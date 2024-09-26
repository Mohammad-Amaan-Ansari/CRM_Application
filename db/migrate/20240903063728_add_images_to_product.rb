# frozen_string_literal: true

# db/migrate/20240903063728_add_images_to_product.rb
class AddImagesToProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :images, :text
  end
end
