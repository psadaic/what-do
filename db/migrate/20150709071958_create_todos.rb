class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :uid
      t.text :text
      t.integer :status

      t.timestamps null: false
    end
  end
end
