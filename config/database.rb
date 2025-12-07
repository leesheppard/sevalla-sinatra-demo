require 'active_record'

if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  db_config = {
    adapter: 'postgresql',
    database: ENV['DATABASE'] || 'sinatra_exports_dev',
    username: ENV['DATABASE_USER'] || 'postgres',
    password: ENV['DATABASE_PASSWORD'] || nil,
    host: ENV['DATABASE_HOST'] || 'localhost',
    port: (ENV['DATABASE_PORT'] || 5432).to_i
  }

  ActiveRecord::Base.establish_connection(db_config)
  puts "Connected to #{ActiveRecord::Base.connection_config[:database]} on #{ActiveRecord::Base.connection_config[:host]}"
end
