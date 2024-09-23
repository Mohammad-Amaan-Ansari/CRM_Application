# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :products

  validates :c_name, :c_size, presence: true
end
# def serial_number
#   "PLN-%.3d" % id
# end
