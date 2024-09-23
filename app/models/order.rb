# frozen_string_literal: true

class Order < ApplicationRecord
  after_create :set_order_no
  after_save :update_total_amount

  has_and_belongs_to_many :products
  belongs_to :user

  # Removed the product_id validation since the relationship is now many-to-many

  private

  def set_order_no
    update_column(:order_no, id)
  end

  def update_total_amount
    self.total_amount = products.sum(:price)
    save if total_amount_changed?
  end
end
