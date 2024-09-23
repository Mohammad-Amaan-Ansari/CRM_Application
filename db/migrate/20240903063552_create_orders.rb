# frozen_string_literal: true

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
