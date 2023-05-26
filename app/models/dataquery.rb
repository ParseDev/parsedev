include ApplicationHelper
require 'net/ssh/gateway'

class Dataquery < ApplicationRecord
  belongs_to :user
  belongs_to :datasource
  has_and_belongs_to_many :dataviews, join_table: "dataviews_dataqueries"
  before_save :format_query

  def sanitized_query
    if self.datasource.api_key.present?
      return query.gsub(self.datasource.api_key, "*" * self.datasource.api_key.length).strip
    end
    return query.strip
  end

  def format_query
    if valid_ruby_code?(self.query)
      self.query = Rubyfmt.format(self.query)
    end
  end

  def frame_id
    "result_frame_#{id}"
  end
  
  def run
    
    if datasource.datasource_type == "psql" || datasource.datasource_type == "mysql"
      gateway = Net::SSH::Gateway.new("#{ENV['BASTION_SERVER_IP_1']}", nil, {
        user: "#{ENV['BASTION_USER']}",
        port: 22,
        password: "#{ENV['BASTION_PASSWORD']}"
      })
      port = gateway.open("#{datasource.host}", datasource.port)
      connection = datasource.connection(port)
      output = connection.exec_query(query)
      boxcar = Boxcars::SQL.new
      @result = boxcar.send(:clean_up_output, output)
      return @result
      gateway.shutdown!
    else
      url = "https://morpheus.parse.dev/execute"

      payload = { code: query }.to_json
      headers = { "Content-Type" => "application/json" }

      response = RestClient.post(url, payload, headers)
      @result = JSON.parse(response.body).fetch("output") || JSON.parse(@response.body).fetch("error")

      return @result
    end
  end
end
