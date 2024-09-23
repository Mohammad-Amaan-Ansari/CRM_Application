# frozen_string_literal: true

class CreateJoinTableOrdersProducts < ActiveRecord::Migration[7.1]
  def change
    create_join_table :orders, :products do |t|
      t.index %i[order_id product_id]
      t.index %i[product_id order_id]
    end
  end
end
