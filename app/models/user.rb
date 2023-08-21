class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company
  attr_accessor :company_name
  has_many :prompts
  has_many :dataqueries
  has_many :mailer_schedulers
  after_create :start_mixmax_sequence

  PROD_MIXMAX_URL = "https://gateway.mixmax.com/ir/63bf6924ac6c3dcd4f32c4af/sWsS0c13eiBw7Yd2v"
  DEV_MIXMAX_URL = ""

  def start_mixmax_sequence
    url = Rails.env.production? ? PROD_MIXMAX_URL : DEV_MIXMAX_URL

    headers = {
      "Content-Type" => "application/json",
    }
    payload = { email: email }
    response = HTTParty.post(url, headers: headers, body: payload.to_json)

    if response.code == 200
      puts "Request successful!"
      puts response.body
    else
      puts "Request failed with status code #{response.code}"
      puts response.body
    end
  end
end
