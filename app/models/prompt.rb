class Prompt < ApplicationRecord
  belongs_to :user
  belongs_to :datasource

  def sanitized_code
    code.gsub(/(sk_live_)[a-zA-Z0-9]+/, '\1***********').lstrip
  end
end
