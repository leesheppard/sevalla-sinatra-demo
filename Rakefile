require 'sinatra/activerecord/rake'
require_relative './app'

task :load_models do
  Dir["models/**/*.rb"].each { |f| require_relative f }
end

task :seed => :load_models do
  puts "Seeding database..."

  Order.delete_all
  User.delete_all

  users = [
    User.create(name: 'Alice Smith', email: 'alice@example.com'),
    User.create(name: 'Bob Jones', email: 'bob@example.com'),
    User.create(name: 'Carol White', email: 'carol@example.com'),
    User.create(name: 'David Brown', email: 'david@example.com'),
    User.create(name: 'Emma Davis', email: 'emma@example.com')
  ]

  users.each do |user|
    rand(3..8).times do
      Order.create(
        user_id: user.id,
        amount: rand(20..500).round(2),
        status: ['pending', 'completed', 'cancelled'].sample
      )
    end
  end

  puts "✓ Created #{User.count} users"
  puts "✓ Created #{Order.count} orders"
  puts "Seeding complete!"
end
