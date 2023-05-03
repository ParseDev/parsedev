class Datasource < ApplicationRecord
    belongs_to :company
    has_many :prompts
    has_many :dataqueries
end
