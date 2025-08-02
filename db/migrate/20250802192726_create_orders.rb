class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :order_number
      t.string :status
      t.decimal :subtotal
      t.decimal :total_amount
      t.integer :billing_address_id
      t.integer :shipping_address_id

      t.timestamps
    end
  end
end
