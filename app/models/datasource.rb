class Datasource < ApplicationRecord
    belongs_to :company
    has_many :prompts
    has_many :dataqueries
    attr_encrypted :s3_secret_key, key: ENV["ENCRYPTION_KEY"]

    def connection
        db_config_hash = {
            adapter: 'postgresql',
            encoding: 'unicode',
            database: database_name,
            host: host,
            port: port,
            username: database_username,
            password: database_password
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
          
          return connection
    end
end
