# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_initialize :set_default_role, if: :new_record?
  has_many :orders

  enum role: { customer: 'customer', salesperson: 'salesperson', admin: 'admin' }

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true

  def set_default_role
    self.role ||= :customer
  end

  # def admin?
  #   role == 'admin'
  # end

  # def customer?
  #   role == 'customer'
  # end

  # def salesperson?
  #   role == 'salesperson'
  # end
end
