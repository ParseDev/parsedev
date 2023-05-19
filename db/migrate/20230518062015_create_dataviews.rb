class CreateDataviews < ActiveRecord::Migration[7.0]
  def change
    create_table :dataviews do |t|
      t.string :name
      t.integer :company_id

      t.timestamps
    end
  end
end
