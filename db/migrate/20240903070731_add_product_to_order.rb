# frozen_string_literal: true

# db/migrate/20240903070731_add_product_to_order.rb
class AddProductToOrder < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :product, foreign_key: true
  end
end
