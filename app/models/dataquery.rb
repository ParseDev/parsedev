include ApplicationHelper

class Dataquery < ApplicationRecord
  belongs_to :user
  has_one :company, through: :user
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
      tunnel = SshGatewayService.new(datasource.host, datasource.port).intiat_connection
      connection = datasource.connection(tunnel[1])
      boxcar = Boxcars::SQLSequel.new
      boxcar.connection = connection
      @result = boxcar.send(:clean_up_output, query)
      tunnel[0].shutdown!
      return @result
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
