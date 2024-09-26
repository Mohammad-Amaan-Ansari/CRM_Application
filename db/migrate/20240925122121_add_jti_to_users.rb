# frozen_string_literal: true

# db/migrate/20240925122121_add_jti_to_users.rb
class AddJtiToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :jti, :string
    add_index :users, :jti, unique: true
  end
end
