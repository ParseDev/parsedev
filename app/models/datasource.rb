class Datasource < ApplicationRecord
    belongs_to :company
    has_many :prompts
    has_many :dataqueries
    attr_encrypted :s3_secret_key, key: ENV["ENCRYPTION_KEY"]

    def connection
        # Generate a unique class name based on the database name and host.
        # This assumes that the combination of database_name and host is unique for each connection.
        class_name = "#{database_name}_#{host}".gsub(/[^0-9a-zA-Z]/, '_').camelize
      
        # Define the custom connection class dynamically.
        custom_connection_class = Class.new(ActiveRecord::Base) do
          self.abstract_class = true
      
          def self.establish_custom_connection(datasource)
            db_config_hash = {
              adapter: 'postgresql',
              encoding: 'unicode',
              database: datasource.database_name,
              host: datasource.host,
              port: datasource.port,
              username: datasource.database_username,
              password: datasource.database_password
            }
            establish_connection(db_config_hash)
          end
        end
      
        # Set the class name for the dynamically created class.
        Object.const_set(class_name, custom_connection_class)
      
        # Establish the connection and return the connection object.
        custom_connection_class.establish_custom_connection(self)
        custom_connection_class.connection
      end
    
    def connection2
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
    
        # Use the connection pool to check out connections to the database
        connection_pool.with_connection do |connection|
          # Execute the block of code with the checked-out connection
          yield(connection) if block_given?
        end
      end
end
