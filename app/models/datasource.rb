class Datasource < ApplicationRecord
  belongs_to :company
  has_many :prompts, dependent: :destroy
  has_many :dataqueries
  encrypts :api_key
  encrypts :database_password

  

  def connection(port)
    # Generate a unique class name based on the database name and host.
    # This assumes that the combination of database_name and host is unique for each connection.
    random = Random.rand(399...79990)
    class_name = "#{database_name}_#{host}_#{random}".gsub(/[^0-9a-zA-Z]/, "_").camelize
      
    
    # Define the custom connection class dynamically.
    custom_connection_class = Class.new(ActiveRecord::Base) do
      self.abstract_class = true
      def self.establish_custom_connection(datasource, port)
        if datasource.host == "localhost"
          connection_port = datasource.port
          connection_host = "#{datasource.host}"
        else
          connection_port = port
          connection_host = '127.0.0.1'
        end
        if datasource.datasource_type == "psql"
          db_config_hash = {
            adapter: "postgresql",
            encoding: "unicode",
            database: datasource.database_name,
            host: connection_host,
            port: connection_port,
            username: datasource.database_username,
            password: datasource.database_password,
          }
          establish_connection(db_config_hash)
        else
          db_config_hash = {
            adapter: "mysql2",
            database: datasource.database_name,
            host: connection_host,
            port: connection_port,
            username: datasource.database_username,
            password: datasource.database_password,
          }
          establish_connection(db_config_hash)
        end
      end
    end

    # Set the class name for the dynamically created class.
    Object.const_set(class_name, custom_connection_class)

    # Establish the connection and return the connection object.
    custom_connection_class.establish_custom_connection(self, port)
    custom_connection_class.connection
  end
end
