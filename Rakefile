require "active_record"
require "activerecord-rake"
require_relative "config/database"

namespace :db do
  task :load_app do
    Dir["models/**/*.rb"].each { |f| require_relative f }
  end
end

Rake::Task["db:migrate"].enhance(["db:load_app"]) if Rake::Task.task_defined?("db:migrate")
Rake::Task["db:seed"].enhance(["db:load_app"]) rescue nil

task :seed do
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
