class AddDimensionsToDataviewsDataqueries < ActiveRecord::Migration[7.0]
  def change
    add_column :dataviews_dataqueries, :height, :integer
    add_column :dataviews_dataqueries, :width, :integer
    add_column :dataviews_dataqueries, :x_position, :integer
    add_column :dataviews_dataqueries, :y_position, :integer
  end
end
