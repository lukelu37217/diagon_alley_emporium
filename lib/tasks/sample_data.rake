namespace :db do
  desc "Seed the database with sample data"
  task seed_sample_data: :environment do
    puts "Creating sample categories..."
    
    categories = [
      { name: "Textbooks", description: "Academic magical textbooks and references" },
      { name: "Potions", description: "Magical potions and ingredients" },
      { name: "Quidditch", description: "Equipment for the wizarding sport" },
      { name: "Dark Arts", description: "Items related to dark magic (educational only)" }
    ]
    
    categories.each do |cat_data|
      Category.find_or_create_by(name: cat_data[:name]) do |category|
        category.description = cat_data[:description]
      end
    end
    
    puts "Sample data seeded successfully!"
  end
  
  desc "Create admin user"
  task create_admin: :environment do
    admin = User.find_or_create_by(email: 'admin@diagonalley.com') do |user|
      user.first_name = 'Store'
      user.last_name = 'Administrator'
      user.password = 'password123'
      user.role = 'admin'
      user.phone_number = '555-0100'
    end
    
    puts "Admin user created: #{admin.email}"
  end
end
