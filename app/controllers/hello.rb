require 'active_record'

# Define the database configuration
db_config_hash = {
    adapter: 'postgresql',
    encoding: 'unicode',
    database: datasource.database_name,
    host: datasource.host,
    port: datasource.port,
    username: datasource.database_username,
    password: datasource.database_password
  }

# Define the owner name, environment name, and specification name
owner_name = 'MyApp'
env_name = 'development'
spec_name = 'primary'

# Create an ActiveRecord::DatabaseConfigurations object
database_configurations = ActiveRecord::DatabaseConfigurations.new(
  env_name => { spec_name => db_config_hash }
)

# Retrieve the specific database configuration for the given environment and specification name
db_config = database_configurations.configs_for(env_name: env_name, name: spec_name)

# Create a PoolConfig object from the database configuration
pool_config = ActiveRecord::ConnectionAdapters::PoolConfig.new(owner_name, env_name, spec_name, db_config)

# Instantiate the ConnectionPool object with the PoolConfig object
connection_pool = ActiveRecord::ConnectionAdapters::ConnectionPool.new(pool_config)

# You can now use the connection pool to check out connections to the database
connection = connection_pool.checkout
# Perform database operations with the connection
# ...
# Check the connection back into the pool when done
connection_pool.checkin(connection)
