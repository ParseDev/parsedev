class RenameTypeColumnInDatasources < ActiveRecord::Migration[7.0]
  def change
    rename_column :datasources, :type, :datasource_type
  end
end
