# frozen_string_literal: true

# app/controllers/customers_controller.rb
class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: %i[index new create] # Ensure only admin can access these actions

  def index
    @customers = User.where(role: 'customer')
  end

  def new
    @customer = User.new
  end

  def create
    @customer = User.new(customer_params)
    @customer.role = 'customer' # Set the role to customer
    if @customer.save
      redirect_to customers_path, notice: 'Customer was successfully created.'
    else
      render :new
    end
  end

  private

  def customer_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def authorize_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user.role == 'admin'
  end
end
