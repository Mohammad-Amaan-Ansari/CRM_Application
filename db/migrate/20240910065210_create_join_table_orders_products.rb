# frozen_string_literal: true

# db/migrate/20240910065210_create_join_table_orders_products.rb
class CreateJoinTableOrdersProducts < ActiveRecord::Migration[7.1]
  def change
    create_join_table :orders, :products do |t|
      t.index %i[order_id product_id]
      t.index %i[product_id order_id]
    end
  end
end
