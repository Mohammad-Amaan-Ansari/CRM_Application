# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  before_create :initialize_jti

  after_initialize :set_default_role, if: :new_record?
  has_many :orders

  enum role: { customer: 'customer', salesperson: 'salesperson', admin: 'admin' }

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true

  private

  def set_default_role
    self.role ||= :customer
  end

  def initialize_jti
    self.jti ||= SecureRandom.uuid
  end
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
