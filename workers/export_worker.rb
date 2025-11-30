require 'csv'
require 'fileutils'

class ExportWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(export_type, user_id)
    FileUtils.mkdir_p('exports')
    
    case export_type
    when 'orders'
      export_user_orders(user_id)
    when 'all_orders'
      export_all_orders
    when 'users'
      export_all_users
    end
  end

  private

  def export_user_orders(user_id)
    user = User.find(user_id)
    orders = Order.where(user_id: user_id)
    
    filename = "exports/orders_#{user_id}_#{Time.now.to_i}.csv"
    
    CSV.open(filename, 'w') do |csv|
      csv << ['Order ID', 'Amount', 'Status', 'Created At']
      orders.each do |order|
        csv << [order.id, order.amount, order.status, order.created_at]
      end
    end
    
    puts "Export complete: #{filename}"
  end

  def export_all_orders
    filename = "exports/all_orders_#{Time.now.to_i}.csv"
    
    CSV.open(filename, 'w') do |csv|
      csv << ['Order ID', 'User Name', 'Amount', 'Status', 'Created At']
      Order.includes(:user).find_each do |order|
        csv << [order.id, order.user.name, order.amount, order.status, order.created_at]
      end
    end
    
    puts "Export complete: #{filename}"
  end

  def export_all_users
    filename = "exports/users_#{Time.now.to_i}.csv"
    
    CSV.open(filename, 'w') do |csv|
      csv << ['User ID', 'Name', 'Email', 'Created At']
      User.find_each do |user|
        csv << [user.id, user.name, user.email, user.created_at]
      end
    end
    
    puts "Export complete: #{filename}"
  end
end
