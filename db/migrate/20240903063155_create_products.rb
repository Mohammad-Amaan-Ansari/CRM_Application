# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.string :size
      t.decimal :price
      t.decimal :mrp
      t.decimal :selling_price

      t.timestamps
    end
  end
end
