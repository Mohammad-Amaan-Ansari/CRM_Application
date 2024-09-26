# frozen_string_literal: true

# db/migrate/20240903063414_create_categories.rb
class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :c_name
      t.string :c_size

      t.timestamps
    end
  end
end
