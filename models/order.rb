class Order < ActiveRecord::Base
  self.table_name = 'orders'
  belongs_to :user
end
