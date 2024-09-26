# frozen_string_literal: true

# db/migrate/20240903063552_create_orders.rb
class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :order_no
      t.decimal :total_amount
      t.string :invoice

      t.timestamps
    end
  end
end
