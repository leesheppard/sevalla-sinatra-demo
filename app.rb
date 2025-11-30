require 'sinatra'
require 'json'

require_relative 'config/database'
require_relative 'config/sidekiq'
require_relative 'models/user'
require_relative 'models/order'
require_relative 'workers/export_worker'

get '/' do
  @users = User.all
  erb :index
end

post '/export/my-orders' do
  if request.content_type == 'application/json'
    payload = JSON.parse(request.body.read)
    user_id = payload['user_id']
  else
    user_id = params[:user_id]
  end

  if user_id
    ExportWorker.perform_async('orders', user_id.to_i)
    { status: 'Export queued. Check back shortly for your file.' }.to_json
  else
    status 400
    { status: 'Error: User ID is required' }.to_json
  end
end

post '/export/all-orders' do
  ExportWorker.perform_async('all_orders', nil)
  { status: 'Full orders export queued. This may take a moment.' }.to_json
end

post '/export/users' do
  ExportWorker.perform_async('users', nil)
  { status: 'Users export queued.' }.to_json
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