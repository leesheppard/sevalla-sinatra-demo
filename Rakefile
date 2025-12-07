require 'sinatra/activerecord/rake'
require_relative './app'

task :load_models do
  Dir["models/**/*.rb"].each { |f| require_relative f }
end

namespace :db do
  desc "Create the database"
  task :create do
    config = ActiveRecord::Base.connection_config
    adapter = config[:adapter]
    database = config[:database]

    case adapter
    when 'postgresql'
      system("createdb #{database}") unless system("psql -lqt | cut -d \\| -f 1 | grep -qw #{database}")
    when 'sqlite3'
      puts "SQLite3 database will be created automatically on first connection"
    else
      puts "DB adapter #{adapter} not supported by db:create task"
    end
  end

  desc "Drop the database"
  task :drop do
    config = ActiveRecord::Base.connection_config
    adapter = config[:adapter]
    database = config[:database]

    case adapter
    when 'postgresql'
      system("dropdb #{database}") if system("psql -lqt | cut -d \\| -f 1 | grep -qw #{database}")
    when 'sqlite3'
      File.delete(database) if File.exist?(database)
    else
      puts "DB adapter #{adapter} not supported by db:drop task"
    end
  end

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::MigrationContext.new('db/migrate', ActiveRecord::SchemaMigration).migrate
  end

  desc "Rollback the last migration"
  task :rollback do
    ActiveRecord::MigrationContext.new('db/migrate', ActiveRecord::SchemaMigration).rollback
  end

  desc "Reset the database (drop, create, migrate, seed)"
  task :reset => [:drop, :create, :migrate, :seed] do
    puts "Database reset complete!"
  end
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
