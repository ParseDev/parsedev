class AddLastExecutionToMailerScheduler < ActiveRecord::Migration[7.0]
  def change
    add_column :mailer_schedulers, :last_execution, :datetime
  end
end
