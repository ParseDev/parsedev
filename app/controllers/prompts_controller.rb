class PromptsController < ApplicationController
  def create
    engine = Boxcars::Openai.new(max_tokens: 256)
    
    
    db_config = {
      adapter: 'postgresql',
      encoding: 'unicode',
      database: 'd55iufm1pj5glt',
      host: 'ec2-3-216-167-65.compute-1.amazonaws.com',
      port: 5432,
      username: 'ziabcmpgwumdzw',
      password: 'c773a90ea666421340ca7c9c247aeb72c34d7274c2c18cbdcb8a8bdc40e7cd7c'
    }
    custom_connection = ActiveRecord::Base.establish_connection(db_config)
    
    
    
    sql = Boxcars::SQL.new(engine: engine, connection: custom_connection.connection)

    result = sql.conduct(params[:input_field])
    puts "Result: #{result}}"
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('result_frame', partial: 'result', locals: { result: result }) }
      format.html { redirect_to prompt_path }
    end
  end

  def show
  end
end