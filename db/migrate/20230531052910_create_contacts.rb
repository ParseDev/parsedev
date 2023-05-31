class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :email
      t.string :company_name
      t.string :number_of_employees
      t.string :database_support

      t.timestamps
    end
  end
end
