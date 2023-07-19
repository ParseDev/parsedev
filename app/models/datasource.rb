class Datasource < ApplicationRecord
  belongs_to :company
  has_many :prompts, dependent: :destroy
  has_many :dataqueries
  encrypts :api_key
  encrypts :database_password
  default_scope { where(deleted_at: nil) }

  def connection(port)
    if host == "localhost" || ENV["SSH_TUNNEL_ENABLED"] == "false"
      connection_port = self.port
      connection_host = "#{host}"
    elsif ENV["SSH_TUNNEL_ENABLED"] == "true"
      connection_port = port
      connection_host = "127.0.0.1"
    end
    if datasource_type == "psql"
      db_config_hash = {
        adapter: "postgresql",
        encoding: "unicode",
        database: database_name,
        host: connection_host,
        port: connection_port,
        username: database_username,
        password: database_password,
      }
    else
      db_config_hash = {
        adapter: "mysql2",
        database: database_name,
        host: connection_host,
        port: connection_port,
        username: database_username,
        password: database_password,
      }
    end
    return Sequel.connect(db_config_hash)
  end

  def create_dataview
    return unless datasource_type == "psql" || datasource_type == "mysql"

    tunnel = SshGatewayService.new(datasource.host, datasource.port).intiat_connection

    # Create a new dataview.
    dataview = Dataview.create(name: "Home", company_id: company_id)
    # TODO using ssh tunnel
    connection = self.connection(tunnel[1])
    if connection.tables.count > 30
      engine = Boxcars::Openai.new(max_tokens: 512, model: "gpt-4")
    else
      engine = Boxcars::Openai.new(max_tokens: 512)
    end

    response = engine.run("You are a data analyst and you are given a list of tables: #{connection.tables}      Based on that write a series of 5 questions to ask the database that a CEO would like to s
      ee on a daily basis\n      Format it as an array of string\n      Example: [' How many new subscripti
      ons were added today?', 'What is the current balance of all transactions made by our users?']\n
      Just return the code")
    questions = response.gsub(/[\[\]\n']/, "").split(",").map(&:strip)
    questions.each do |question|
      boxcar = Boxcars::SQLSequel.new(engine: engine, connection: connection)
      result = boxcar.conduct(question)
      code = result.dig(:answer).try(:added_context).present? ? result.dig(:answer).added_context[:code] : nil
      if code.present?
        dataview.dataqueries.create(name: question, query: code, user: company.users.first, datasource: self)
      end
    end

    tunnel[0].shutdown!
  end

  def soft_destroy
    update(deleted_at: Time.now)
  end
end
