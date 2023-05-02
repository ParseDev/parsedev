class Prompt < ApplicationRecord
  belongs_to :user
  belongs_to :datasource
end
