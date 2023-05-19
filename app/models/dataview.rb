class Dataview < ApplicationRecord
  has_and_belongs_to_many :dataqueries, join_table: "dataviews_dataqueries"
  has_many :dataviews_dataqueries
  belongs_to :company
end
