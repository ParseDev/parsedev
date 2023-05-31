class Contact < ApplicationRecord
  after_create :send_admin_email
  SUPPORT_OPTIONS = ["MySQL", "PostgreSQL", "MongoDB", "SQLite", "Snowflake", "Redshift", "BigQuery", "Other"]
  EMPLOYEE_RANGES = ["less than 5",
                     "5-20",
                     "20-100",
                     "100-500",
                     "500-2000",
                     "2000+"]

  def send_admin_email
    @contact = self
    ContactMailer.new_contact_email(self).deliver_now
  end
end
