# frozen_string_literal: true

# db/migrate/20240910064845_remove_product_id_from_order.rb
class RemoveProductIdFromOrder < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :product_id, :integer
  end
end
