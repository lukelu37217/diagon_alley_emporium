FactoryBot.define do
  factory :category do
    name { "Magical Items" }
    description { "Various magical items for wizards and witches" }
  end

  factory :product do
    name { "Magic Wand" }
    description { "A powerful magic wand made from holly wood" }
    sku { "MW-001" }
    current_price { 29.99 }
    stock_quantity { 10 }
    is_active { true }
    association :category
  end

  factory :user do
    first_name { "Harry" }
    last_name { "Potter" }
    email { "harry@hogwarts.edu" }
    password { "password123" }
    phone_number { "555-0123" }
    role { "customer" }
  end

  factory :admin_user, parent: :user do
    email { "admin@diagonalley.com" }
    role { "admin" }
  end

  factory :order do
    total_amount { 59.98 }
    status { "pending" }
    shipping_address { "4 Privet Drive, Little Whinging" }
    billing_address { "4 Privet Drive, Little Whinging" }
    payment_method { "credit_card" }
    association :user
  end

  factory :order_item do
    quantity { 2 }
    price { 29.99 }
    association :product
    association :order
  end

  factory :shopping_cart do
    quantity { 1 }
    association :user
    association :product
  end
end
