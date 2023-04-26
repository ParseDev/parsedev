class PromptsController < ApplicationController
  before_action :authenticate_user!
  def create
    engine = Boxcars::Openai.new(max_tokens: 256)
    datasource = current_user.company.datasources.first
    
    
    db_config_hash = {
      adapter: 'postgresql',
      encoding: 'unicode',
      database: datasource.database_name,
      host: datasource.host,
      port: datasource.port,
      username: datasource.database_username,
      password: datasource.database_password
    }
    
    
    owner_name = 'ChartGPT'
    env_name = Rails.env
    spec_name = 'primary'
    database_configurations = ActiveRecord::DatabaseConfigurations.new(
      env_name => { spec_name => db_config_hash }
    )
    
    # Retrieve the specific database configuration for the given environment and specification name
    db_config = database_configurations.configs_for(env_name: env_name, name: spec_name)
    
    # Define the connection class, role, and shard
    connection_class = ActiveRecord::Base
    role = :reading
    shard = :default
    
    # Create a PoolConfig object from the database configuration
    pool_config = ActiveRecord::ConnectionAdapters::PoolConfig.new(connection_class, db_config, role, shard)
    
    # Instantiate the ConnectionPool object with the PoolConfig object
    connection_pool = ActiveRecord::ConnectionAdapters::ConnectionPool.new(pool_config)
    
    # You can now use the connection pool to check out connections to the database
    connection = connection_pool.checkout
    # Perform database operations with the connection
    # ...
    # Check the connection back into the pool when done
    connection_pool.checkin(connection)
    
    
    sql = Boxcars::SQL.new(engine: engine, connection: connection)
    
    result = sql.conduct(params[:input_field])
    puts "Result: #{result}}"
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update('result_frame', partial: 'result', locals: { result: result }) }
      format.html { redirect_to prompt_path }
    end
  end
  
  def show
  end
end