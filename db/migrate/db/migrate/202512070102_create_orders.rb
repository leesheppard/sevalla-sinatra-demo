require 'active_record'

class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :product_name, null: false
      t.integer :quantity, default: 1
      t.decimal :price, precision: 10, scale: 2
      t.timestamps
    end
  end
end