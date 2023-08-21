class Dataview < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  has_and_belongs_to_many :dataqueries, join_table: "dataviews_dataqueries"
  has_many :dataviews_dataqueries
  belongs_to :company
  has_many :mailer_schedulers

  def soft_destroy
    update(deleted_at: Time.now)
  end
end
