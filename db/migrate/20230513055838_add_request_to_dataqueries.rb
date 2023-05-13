class AddRequestToDataqueries < ActiveRecord::Migration[7.0]
  def change
    add_column :dataqueries, :url, :string
    add_column :dataqueries, :request_method, :string
    add_column :dataqueries, :request_header, :json
    add_column :dataqueries, :request_body, :json
  end
end
