class Company < ApplicationRecord
  has_many :datasources
  has_many :users
  has_many :dataviews
  has_many :dataqueries, through: :users

  def dataqueries
    users.map(&:dataqueries).flatten
  end
end
