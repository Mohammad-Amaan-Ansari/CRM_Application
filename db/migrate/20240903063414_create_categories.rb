# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :c_name
      t.string :c_size

      t.timestamps
    end
  end
end
