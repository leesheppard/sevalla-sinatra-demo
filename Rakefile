require 'active_record'
require 'sinatra/activerecord/rake'
require_relative './app'
require 'active_record/tasks/database_tasks'

db_config = if ENV['DATABASE_URL']
              ENV['DATABASE_URL']
            else
              {
                'adapter'  => 'postgresql',
                'database' => ENV['DATABASE'] || 'sinatra_exports_dev',
                'username' => ENV['DATABASE_USER'] || '',
                'password' => ENV['DATABASE_PASSWORD'] || '',
                'host'     => ENV['DATABASE_HOST'] || 'localhost',
                'port'     => ENV['DATABASE_PORT'] || 5432
              }
            end

ActiveRecord::Base.establish_connection(db_config)

ActiveRecord::Tasks::DatabaseTasks.database_configuration = {
  (ENV['RACK_ENV'] || 'development') => db_config
}
ActiveRecord::Tasks::DatabaseTasks.env = ENV['RACK_ENV'] || 'development'
ActiveRecord::Tasks::DatabaseTasks.db_dir = 'db'
ActiveRecord::Tasks::DatabaseTasks.migrations_paths = ['db/migrate']

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

namespace :db do
  desc "Reset the database (drop, create, migrate, seed)"
  task :reset do
    ActiveRecord::Tasks::DatabaseTasks.drop_current
    ActiveRecord::Tasks::DatabaseTasks.create_current
    Rake::Task['db:migrate'].invoke
    Rake::Task[:seed].invoke
    puts "Database reset complete!"
  end
end
