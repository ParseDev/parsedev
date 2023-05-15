class Dataquery < ApplicationRecord
  belongs_to :user
  belongs_to :datasource

  def sanitized_query
    query.gsub(/(sk_live_)[a-zA-Z0-9]+/, '\1***********').strip
  end

  def run
    if datasource.datasource_type == "psql"
      connection = datasource.connection
      output = connection.exec_query(query)
      boxcar = Boxcars::SQL.new
      @result = boxcar.send(:clean_up_output, output)
      return @result
    else
      repl = Boxcars::RubyREPL.new
      @result = repl.send(:run, query)
      return @result
    end
  end
end
