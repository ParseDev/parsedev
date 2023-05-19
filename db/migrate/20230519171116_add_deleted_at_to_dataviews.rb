class AddDeletedAtToDataviews < ActiveRecord::Migration[7.0]
  def change
    add_column :dataviews, :deleted_at, :datetime
  end
end
