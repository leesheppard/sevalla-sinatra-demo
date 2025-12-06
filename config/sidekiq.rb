require 'sidekiq'

redis_url = if ENV['REDIS_URL']
              ENV['REDIS_URL']
            else
              host = ENV['REDIS_HOST'] || 'localhost'
              port = ENV['REDIS_PORT'] || 6379
              password = ENV['REDIS_PASSWORD']

              if password && !password.empty?
                "redis://:#{password}@#{host}:#{port}/1"
              else
                "redis://#{host}:#{port}/1"
              end
            end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end