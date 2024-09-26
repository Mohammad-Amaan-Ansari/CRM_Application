# frozen_string_literal: true

# db/migrate/20240903064113_add_category_to_product.rb
class AddCategoryToProduct < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :category, foreign_key: true
  end
end
