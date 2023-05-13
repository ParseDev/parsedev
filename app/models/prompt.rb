class Prompt < ApplicationRecord
  belongs_to :user
  belongs_to :datasource
  store_accessor :requestdetail

  def sanitized_code
    code.gsub(datasource.api_key, "{API_KEY}").lstrip
  end
end
