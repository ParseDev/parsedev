class PromptsController < ApplicationController
  before_action :authenticate_user!

  def create
    engine = Boxcars::Openai.new(max_tokens: 256)
    datasource = current_user.company.datasources.find(params[:datasource_id])
    if datasource.datasource_type == "psql"
      connection = datasource.connection
      boxcar = Boxcars::SQL.new(engine: engine, connection: connection)
    else
      boxcar = Boxcars::Swagger.new(engine: engine, swagger_url: datasource.swagger_url, context: "API_token: #{datasource.api_key}")
    end
    @result = boxcar.conduct(params[:input_field])

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
