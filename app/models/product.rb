# frozen_string_literal: true

# app/models/product.rb
class Product < ApplicationRecord
  has_and_belongs_to_many :orders
  belongs_to :category
  has_many_attached :images

  validates :name, :sku, :size, presence: true
end
