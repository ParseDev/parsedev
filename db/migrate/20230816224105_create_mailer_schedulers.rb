class CreateMailerSchedulers < ActiveRecord::Migration[7.0]
  def change
    create_table :mailer_schedulers do |t|
      t.string :name
      t.references :dataview, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :send_time
      t.string :recipient

      t.timestamps
    end
  end
end
