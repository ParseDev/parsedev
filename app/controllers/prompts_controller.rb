require 'net/ssh/gateway'
class PromptsController < ApplicationController
  before_action :authenticate_user!

  def create
    engine = Boxcars::Openai.new(max_tokens: 512)
    datasource = current_user.company.datasources.find(params[:datasource_id])
    if datasource.datasource_type == "psql" || datasource.datasource_type == "mysql"
      ssh_gateway = Net::SSH::Gateway.new("#{ENV['BASTION_SERVER_IP_1']}", nil, {
        user: "#{ENV['BASTION_USER']}",
        port: 22,
        password: "#{ENV['BASTION_PASSWORD']}"
      })
      bastion_port = ssh_gateway.open("#{datasource.host}", datasource.port)
      connection = datasource.connection(bastion_port)
      boxcar = Boxcars::SQL.new(engine: engine, connection: connection)
      @result = boxcar.conduct(params[:input_field])
      ssh_gateway.shutdown!
    else
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
