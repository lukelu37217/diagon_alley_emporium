class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :sku
      t.references :category, null: false, foreign_key: true
      t.decimal :current_price
      t.integer :stock_quantity
      t.boolean :is_active

      t.timestamps
    end
  end
end
