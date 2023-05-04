class PromptsController < ApplicationController
  before_action :authenticate_user!

  def create
    engine = Boxcars::Openai.new(max_tokens: 256)
    datasource = current_user.company.datasources.find(params[:datasource_id])
    connection = datasource.connection

    if datasource.datasource_type == "psql"
      boxcar = Boxcars::SQL.new(engine: engine, connection: connection)
    else
      boxcar = Boxcars::Swagger.new(engine: engine, swagger_url: "https://raw.githubusercontent.com/stripe/openapi/master/openapi/spec3.yaml", context: "API_token: #{datasource.stripe_token}")
    end
    @result = boxcar.conduct(params[:input_field])

    code = @result.added_context.present? ? @result.added_context[:code] : nil
    @prompt = Prompt.create(user: current_user, datasource: datasource, content: params[:input_field], code: @result.added_context[:code])

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.append("result_frame", partial: "result", locals: { result: @result, prompt: @prompt }) }
      format.html { redirect_to prompt_path }
    end
  end

  def show
  end
end
