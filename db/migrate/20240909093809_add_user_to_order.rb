# frozen_string_literal: true

# db/migrate/20240909093809_add_user_to_order.rb
class AddUserToOrder < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :user, foreign_key: true
  end
end
