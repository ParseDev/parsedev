class Company < ApplicationRecord
  has_many :datasources
  has_many :users
end
