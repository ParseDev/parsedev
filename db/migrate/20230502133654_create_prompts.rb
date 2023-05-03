class CreatePrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :prompts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :datasource, null: false, foreign_key: true
      t.text :content
      t.text :code

      t.timestamps
    end
  end
end
