# frozen_string_literal: true

class AddProductToOrder < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :product, foreign_key: true
  end
end
