class Prompt < ApplicationRecord
  belongs_to :user
  belongs_to :datasource

  def sanitized_code
    if datasource.api_key.present?
      code.gsub(datasource.api_key, "{API_KEY}").lstrip
    else
      return code
    end
  end
end
