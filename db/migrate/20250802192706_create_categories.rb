class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.boolean :is_active
      t.integer :parent_id

      t.timestamps
    end
  end
end
