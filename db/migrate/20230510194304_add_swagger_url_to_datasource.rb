class AddSwaggerUrlToDatasource < ActiveRecord::Migration[7.0]
  def change
    add_column :datasources, :swagger_url, :string
  end
end
