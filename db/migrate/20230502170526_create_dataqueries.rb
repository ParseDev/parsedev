class CreateDataqueries < ActiveRecord::Migration[7.0]
  def change
    create_table :dataqueries do |t|
      t.string :name
      t.text :query
      t.integer :datasource_id
      t.integer :user_id

      t.timestamps
    end
  end
end
