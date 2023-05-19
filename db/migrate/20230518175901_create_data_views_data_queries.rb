class CreateDataViewsDataQueries < ActiveRecord::Migration[7.0]
  def change
    create_table :dataviews_dataqueries do |t|
      t.references :dataview, null: false, foreign_key: true
      t.references :dataquery, null: false, foreign_key: true

      t.timestamps
    end
  end
end
