class Dataquery < ApplicationRecord
  belongs_to :user
  belongs_to :datasource
  has_and_belongs_to_many :dataviews, join_table: "dataviews_dataqueries"

  def sanitized_query
    query.gsub(/(sk_live_)[a-zA-Z0-9]+/, '\1***********').strip
  end

  def frame_id
    "result_frame_#{id}"
  end

  def run
    if datasource.datasource_type == "psql" || datasource.datasource_type == "mysql"
      connection = datasource.connection
      output = connection.exec_query(query)
      boxcar = Boxcars::SQL.new
      @result = boxcar.send(:clean_up_output, output)
      return @result
    else
      url = "https://wandering-resonance-1947.fly.dev/execute"

      payload = { code: query }.to_json
      headers = { "Content-Type" => "application/json" }

      response = RestClient.post(url, payload, headers)
      @result = JSON.parse(response.body).fetch("output") || JSON.parse(@response.body).fetch("error")

      return @result
    end
  end
end
