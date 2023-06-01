class AddDeletedAtToDataquery < ActiveRecord::Migration[7.0]
  def change
    add_column :dataqueries, :deleted_at, :datetime
  end
end
