class AddStripeTokenToDataSource < ActiveRecord::Migration[7.0]
  def change
    add_column :datasources, :stripe_token, :string
  end
end
