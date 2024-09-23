# frozen_string_literal: true

class AddImagesToProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :images, :text
  end
end
