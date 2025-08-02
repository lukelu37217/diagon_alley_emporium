class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address_type
      t.string :street_address
      t.string :city
      t.string :province
      t.string :postal_code

      t.timestamps
    end
  end
end
