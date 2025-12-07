require 'active_record'
require 'uri'

def database_config
  if ENV['DATABASE_URL'] && !ENV['DATABASE_URL'].empty?
    uri = URI.parse(ENV['DATABASE_URL'])
    {
      adapter:  'postgresql',
      host:     uri.host,
      port:     uri.port || 5432,
      database: uri.path[1..-1],
      username: uri.user,
      password: uri.password,
      encoding: 'utf8'
    }
  else
    {
      adapter:  'postgresql',
      host:     ENV['DATABASE_HOST'] || 'localhost',
      port:     ENV['DATABASE_PORT'] || 5432,
      database: ENV['DATABASE'] || 'sinatra_exports_dev',
      username: ENV['DATABASE_USER'] || 'postgres',
      password: ENV['DATABASE_PASSWORD'] || '',
      encoding: 'utf8'
    }
  end
end

ActiveRecord::Base.establish_connection(database_config)
