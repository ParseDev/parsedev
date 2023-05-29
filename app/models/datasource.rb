class Datasource < ApplicationRecord
  belongs_to :company
  has_many :prompts, dependent: :destroy
  has_many :dataqueries
  encrypts :api_key
  encrypts :database_password
  before_create :create_dataview

  def connection(port)
    # Generate a unique class name based on the database name and host.
    # This assumes that the combination of database_name and host is unique for each connection.
    random = Random.rand(399...79990)
    class_name = "#{database_name}_#{host}_#{random}".gsub(/[^0-9a-zA-Z]/, "_").camelize

    # Define the custom connection class dynamically.
    custom_connection_class = Class.new(ActiveRecord::Base) do
      self.abstract_class = true
      def self.establish_custom_connection(datasource, port)
        if datasource.datasource_type == "psql"
          db_config_hash = {
            adapter: "postgresql",
            encoding: "unicode",
            database: datasource.database_name,
            host: "127.0.0.1",
            port: port,
            username: datasource.database_username,
            password: datasource.database_password,
          }
          establish_connection(db_config_hash)
        else
          db_config_hash = {
            adapter: "mysql2",
            database: datasource.database_name,
            host: "127.0.0.1",
            port: port,
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

  def create_dataview
    return unless datasource_type == "psql" || datasource_type == "mysql"
    ssh_gateway = Net::SSH::Gateway.new("#{ENV["BASTION_SERVER_IP_1"]}", nil, {
      user: "#{ENV["BASTION_USER"]}",
      port: 22,
      password: "#{ENV["BASTION_PASSWORD"]}",
    })
    ssh_port = ssh_gateway.open("#{host}", port)
    engine = Boxcars::Openai.new(max_tokens: 512)
    # Create a new dataview.
    dataview = Dataview.create(name: "Home", company_id: company_id)
    # TODO using ssh tunnel
    connection = self.connection(ssh_port)
    response = engine.run("You are a data analyst and you are given a list of tables: #{connection.tables}      Based on that write a series of 5 questions to ask the database that a CEO would like to s
      ee on a daily basis\n      Format it as an array of string\n      Example: [' How many new subscripti
      ons were added today?', 'What is the current balance of all transactions made by our users?']\n
      Just return the code")
    questions = response.gsub(/[\[\]\n']/, "").split(",").map(&:strip)
    questions.each do |question|
      boxcar = Boxcars::SQL.new(engine: engine, connection: connection)
      result = boxcar.conduct(question)
      code = result.try(:added_context).present? ? result.added_context[:code] : nil
      if code.present?
        dataview.dataqueries.create(name: question, query: code, user: company.users.first, datasource: self)
      end
    end

    ssh_gateway.shutdown!
  end
end
