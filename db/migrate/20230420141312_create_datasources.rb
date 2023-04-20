class CreateDatasources < ActiveRecord::Migration[7.0]
  def change
    create_table :datasources do |t|
      t.string :name
      t.string :description
      t.string :type
      t.string :host
      t.string :port
      t.string :database_name
      t.string :database_username
      t.string :database_password
      t.references :company

      t.timestamps
    end
  end
end
