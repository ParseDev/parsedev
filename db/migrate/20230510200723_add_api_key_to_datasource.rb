class AddApiKeyToDatasource < ActiveRecord::Migration[7.0]
  def change
    add_column :datasources, :api_key, :string
    remove_column :datasources, :stripe_token, :string
    remove_column :datasources, :s3_access_key, :string
    remove_column :datasources, :encrypted_s3_secret_key, :string
    remove_column :datasources, :encrypted_s3_secret_key_iv, :string
  end
end
