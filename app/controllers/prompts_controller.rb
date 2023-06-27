class PromptsController < ApplicationController
  before_action :authenticate_user!

  def create
    datasource = current_user.company.datasources.find(params[:datasource_id])
    if datasource.datasource_type == "psql" || datasource.datasource_type == "mysql"
      tunnel = SshGatewayService.new(datasource.host, datasource.port).intiat_connection
      connection = datasource.connection(tunnel[1])
      if connection.tables.count > 30
        engine = Boxcars::Openai.new(max_tokens: 512, model: "gpt-4")
      else
        engine = Boxcars::Openai.new(max_tokens: 512)
      end

      boxcar = Boxcars::SQLSequel.new(engine: engine, connection: connection)
      @result = boxcar.conduct(params[:input_field])
      tunnel[0].shutdown!
    else
      engine = Boxcars::Openai.new(max_tokens: 512)
      boxcar = Boxcars::Swagger.new(engine: engine, swagger_url: datasource.swagger_url, context: "TOKEN: #{datasource.api_key}")
      @result = boxcar.conduct(params[:input_field])
    end

    code = @result.try(:added_context).present? ? @result.added_context[:code] : nil

    @prompt = Prompt.create(user: current_user, datasource: datasource, content: params[:input_field], code: code)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.append("result_frame", partial: "result", locals: { result: @result, prompt: @prompt }) }
      format.html { redirect_to prompt_path }
    end
  end

  def show
  end
end
