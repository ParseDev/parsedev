class Datasource < ApplicationRecord
    belongs_to :company
    has_many :prompts
end
