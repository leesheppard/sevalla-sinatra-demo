require 'sinatra'
require 'json'
require 'sidekiq/api'

require_relative 'config/database'
require_relative 'config/sidekiq'
require_relative 'models/user'
require_relative 'models/order'
require_relative 'workers/export_worker'

begin
  ActiveRecord::Base.connection.execute("SELECT 1")
  puts "[INFO] Database connection established successfully."
rescue => e
  puts "[ERROR] Cannot connect to the database!"
  puts e.message
  exit(1)
end

def redis_available?
  Sidekiq.redis { |conn| conn.ping == "PONG" }
rescue StandardError => e
  puts "Redis connection error: #{e.class} - #{e.message}"
  false
end

get '/' do
  @users = User.all
  erb :index
end

post '/export/my-orders' do
  halt 503, { status: 'Redis unavailable, try again later' }.to_json unless redis_available?

  user_id = if request.content_type == 'application/json'
              begin
                payload = JSON.parse(request.body.read)
                payload['user_id']
              rescue JSON::ParserError
                halt 400, { status: 'Invalid JSON payload' }.to_json
              end
            else
              params[:user_id]
            end

  unless user_id
    halt 400, { status: 'User ID is required' }.to_json
  end

  begin
    ExportWorker.perform_async('orders', user_id.to_i)
    { status: 'Export queued. Check back shortly for your file.' }.to_json
  rescue => e
    halt 500, { status: 'Failed to queue export', error: e.message }.to_json
  end
end

post '/export/all-orders' do
  halt 503, { status: 'Redis unavailable, try again later' }.to_json unless redis_available?

  begin
    ExportWorker.perform_async('all_orders', nil)
    { status: 'Full orders export queued. This may take a moment.' }.to_json
  rescue => e
    halt 500, { status: 'Failed to queue full orders export', error: e.message }.to_json
  end
end

post '/export/users' do
  halt 503, { status: 'Redis unavailable, try again later' }.to_json unless redis_available?

  begin
    ExportWorker.perform_async('users', nil)
    { status: 'Users export queued.' }.to_json
  rescue => e
    halt 500, { status: 'Failed to queue users export', error: e.message }.to_json
  end
end

get '/exports' do
  files = Dir.glob('exports/*.csv').map { |f| File.basename(f) }.sort.reverse
  { files: files }.to_json
end

get '/exports/:filename' do
  filename = params[:filename]
  path = File.join('exports', filename)

  if File.exist?(path) && File.expand_path(path).start_with?(File.expand_path('exports'))
    send_file path, type: 'text/csv'
  else
    status 404
    'File not found'
  end
end
