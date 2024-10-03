# frozen_string_literal: true

# app/serializers/product_serializer.rb
class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :sku, :price
end
