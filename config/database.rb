require 'active_record'

if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  db_config = {
    adapter: 'postgresql',
    database: 'sinatra_exports_dev',
    user: ENV['DATABASE_USER'] || '',
    password: ENV['DATABASE_PASSWORD'] || '',
    host: ENV['DATABASE_HOST'] || 'localhost',
    port: ENV['DATABASE_PORT'] || 5432
  }
  ActiveRecord::Base.establish_connection(db_config)
end