# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data in development
if Rails.env.development?
  puts "Clearing existing data..."
  OrderItem.destroy_all
  Order.destroy_all
  ShoppingCart.destroy_all
  PriceHistory.destroy_all
  Product.destroy_all
  Category.destroy_all
  Address.destroy_all
  User.destroy_all
  puts "Data cleared!"
end

# Create admin user
puts "Creating admin user..."
admin = User.create!(
  email: 'admin@diagonalley.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Albus',
  last_name: 'Dumbledore',
  phone: '555-123-4567',
  role: 'admin'
)

# Create sample customer
puts "Creating sample customer..."
customer = User.create!(
  email: 'customer@diagonalley.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Harry',
  last_name: 'Potter',
  phone: '555-987-6543',
  role: 'customer'
)

# Create customer address
customer_address = customer.addresses.create!(
  address_type: 'both',
  street_address: '4 Privet Drive',
  city: 'Little Whinging',
  province: 'Surrey',
  postal_code: 'SU1 2AB',
  is_default: true
)

# Create Categories
puts "Creating categories..."
categories = [
  {
    name: 'Wands',
    description: 'Magical wands for every witch and wizard. Each wand is unique and chooses its owner.',
    slug: 'wands'
  },
  {
    name: 'Books',
    description: 'Essential textbooks and reference materials for magical education and research.',
    slug: 'books'
  },
  {
    name: 'Potions',
    description: 'Pre-made potions and ingredients for your magical needs.',
    slug: 'potions'
  },
  {
    name: 'Clothing & Accessories',
    description: 'Magical robes, cloaks, and accessories for the fashionable witch or wizard.',
    slug: 'clothing-accessories'
  },
  {
    name: 'Magical Creatures',
    description: 'Companions and magical creatures for wizarding families.',
    slug: 'magical-creatures'
  }
]

created_categories = {}
categories.each do |cat_data|
  category = Category.create!(cat_data.merge(is_active: true))
  created_categories[category.slug] = category
  puts "Created category: #{category.name}"
end

# Create Products
puts "Creating products..."
products_data = [
  # Wands
  {
    name: 'Elder Wand',
    description: 'The most powerful wand in existence, made from elder wood with a Thestral tail hair core. This legendary wand is known as the "Deathstick" and has passed through many hands throughout history. Extremely rare and powerful.',
    sku: 'WAND-ELDER-001',
    category: created_categories['wands'],
    current_price: 299.99,
    stock_quantity: 1
  },
  {
    name: 'Holly and Phoenix Feather Wand',
    description: 'Eleven inches, nice and supple. Holly wood with phoenix feather core. The phoenix feather came from Fawkes, Dumbledore\'s phoenix. Known for its loyalty to its owner.',
    sku: 'WAND-HOLLY-001',
    category: created_categories['wands'],
    current_price: 79.99,
    stock_quantity: 5
  },
  {
    name: 'Vine and Dragon Heartstring Wand',
    description: 'Ten and three-quarter inches, vine wood with dragon heartstring core. A powerful wand known for its versatility in spell casting.',
    sku: 'WAND-VINE-001',
    category: created_categories['wands'],
    current_price: 84.99,
    stock_quantity: 3
  },
  
  # Books
  {
    name: 'The Standard Book of Spells (Grade 1)',
    description: 'by Miranda Goshawk. Essential first-year textbook covering basic spells every young witch and wizard should know.',
    sku: 'BOOK-SPELLS-001',
    category: created_categories['books'],
    current_price: 24.99,
    stock_quantity: 25
  },
  {
    name: 'Advanced Potion-Making',
    description: 'by Libatius Borage. Comprehensive guide to advanced potion brewing techniques. Required for N.E.W.T.-level Potions class.',
    sku: 'BOOK-POTIONS-001',
    category: created_categories['books'],
    current_price: 39.99,
    stock_quantity: 12
  },
  {
    name: 'Fantastic Beasts and Where to Find Them',
    description: 'by Newt Scamander. The definitive guide to magical creatures from around the world. An essential reference for any aspiring magizoologist.',
    sku: 'BOOK-BEASTS-001',
    category: created_categories['books'],
    current_price: 29.99,
    stock_quantity: 18
  },
  
  # Potions
  {
    name: 'Polyjuice Potion',
    description: 'A complex potion that allows the drinker to assume the appearance of another person. Effects last one hour. Extremely difficult to brew - pre-made for your convenience.',
    sku: 'POTION-POLY-001',
    category: created_categories['potions'],
    current_price: 149.99,
    stock_quantity: 3
  },
  {
    name: 'Felix Felicis (Liquid Luck)',
    description: 'A magical potion that brings the drinker good luck for a period of time. Also known as "Liquid Luck." Use sparingly as prolonged use can cause giddiness and recklessness.',
    sku: 'POTION-FELIX-001',
    category: created_categories['potions'],
    current_price: 299.99,
    stock_quantity: 2
  },
  {
    name: 'Healing Potion',
    description: 'A general-purpose healing potion that accelerates the natural healing process. Effective for minor cuts, bruises, and magical injuries.',
    sku: 'POTION-HEAL-001',
    category: created_categories['potions'],
    current_price: 45.99,
    stock_quantity: 15
  },
  
  # Clothing & Accessories
  {
    name: 'Hogwarts School Robes',
    description: 'Official Hogwarts School robes made from high-quality black fabric. Available in all sizes. House colors sold separately.',
    sku: 'CLOTH-ROBES-001',
    category: created_categories['clothing-accessories'],
    current_price: 89.99,
    stock_quantity: 30
  },
  {
    name: 'Invisibility Cloak',
    description: 'A genuine Invisibility Cloak that renders the wearer completely invisible. One of the three Deathly Hallows. Extremely rare and valuable.',
    sku: 'CLOTH-INVIS-001',
    category: created_categories['clothing-accessories'],
    current_price: 999.99,
    stock_quantity: 1
  },
  {
    name: 'Dragon Hide Gloves',
    description: 'Protective gloves made from genuine dragon hide. Essential for handling dangerous magical creatures and plants. Fire-resistant and durable.',
    sku: 'CLOTH-GLOVES-001',
    category: created_categories['clothing-accessories'],
    current_price: 34.99,
    stock_quantity: 20
  },
  
  # Magical Creatures
  {
    name: 'Snowy Owl',
    description: 'Beautiful snowy owl, perfect for delivering mail and messages. Intelligent, loyal, and capable of finding recipients anywhere in the world.',
    sku: 'CREATURE-OWL-001',
    category: created_categories['magical-creatures'],
    current_price: 199.99,
    stock_quantity: 8
  },
  {
    name: 'Chocolate Frog',
    description: 'Delicious chocolate shaped like a frog with a magical spell that makes it hop. Comes with a collectible Famous Witches and Wizards card.',
    sku: 'CREATURE-FROG-001',
    category: created_categories['magical-creatures'],
    current_price: 4.99,
    stock_quantity: 100
  }
]

created_products = []
products_data.each do |product_data|
  product = Product.create!(product_data.merge(is_active: true))
  created_products << product
  puts "Created product: #{product.name} - $#{product.current_price}"
end

puts "Seeding completed successfully!"
puts "Created:"
puts "- #{Category.count} categories"
puts "- #{Product.count} products"
puts "- 1 admin user (admin@diagonalley.com / password123)"
puts "- 1 customer user (customer@diagonalley.com / password123)"
puts ""
puts "You can now start the Rails server with: rails server"
puts "Admin panel: http://localhost:3000/admin"
