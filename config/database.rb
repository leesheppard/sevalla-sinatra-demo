require 'active_record'

db_config = {
  adapter: 'postgresql',
  database: ENV['DATABASE_URL'] || 'sinatra_exports_dev',
  user: ENV['DATABASE_USER'] || '',
  password: ENV['DATABASE_PASSWORD'] || '',
  host: ENV['DATABASE_HOST'] || 'localhost',
  port: ENV['DATABASE_PORT'] || 5432
}

ActiveRecord::Base.establish_connection(db_config)

unless ActiveRecord::Base.connection.table_exists?(:users)
  ActiveRecord::Base.connection.create_table(:users) do |t|
    t.string :name
    t.string :email
    t.timestamps
  end
end

unless ActiveRecord::Base.connection.table_exists?(:orders)
  ActiveRecord::Base.connection.create_table(:orders) do |t|
    t.integer :user_id
    t.decimal :amount
    t.string :status
    t.timestamps
  end
end