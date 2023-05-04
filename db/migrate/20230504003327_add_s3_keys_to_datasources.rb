class AddS3KeysToDatasources < ActiveRecord::Migration[7.0]
  def change
    add_column :datasources, :s3_access_key, :string
    add_column :datasources, :encrypted_s3_secret_key, :string
    add_column :datasources, :encrypted_s3_secret_key_iv, :string # Required for attr_encrypted
  end
end
