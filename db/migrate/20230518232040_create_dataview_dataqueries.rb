class CreateDataviewDataqueries < ActiveRecord::Migration[7.0]
  def change
    create_table :dataview_dataqueries do |t|
      t.integer :height
      t.integer :width
      t.integer :x_position
      t.integer :y_position
      t.references :dataview, null: false, foreign_key: true
      t.references :dataquery, null: false, foreign_key: true

      t.timestamps
    end
  end
end
