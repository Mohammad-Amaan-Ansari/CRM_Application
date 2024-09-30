# frozen_string_literal: true

# app/serializers/order_serializer.rb
class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_no, :total_amount, :invoice
  has_many :products
end
