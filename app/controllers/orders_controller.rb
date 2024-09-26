# frozen_string_literal: true

# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user! # Ensure the user is authenticated
  load_and_authorize_resource # CanCanCan will handle loading and authorization
  before_action :set_order, only: %i[show edit update destroy generate_pdf] # Load order for specific actions
  before_action :set_products, only: %i[new edit create update] # Fetch all products for selection

  def index
    @orders = current_user.admin? ? Order.all : current_user.orders
  end

  def show
    @products = @order.products # Fetch associated products
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      manage_order_products
      update_total_amount
      redirect_to orders_path, notice: 'Order was successfully created.'
    else
      render :new
    end
  end

  def edit
    # @order is already set by before_action
  end

  def update
    if @order.update(order_params)
      manage_order_products
      update_total_amount
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.'
  end

  def generate_pdf
    pdf_service = PdfGeneratorService.new(@order)
    pdf_content = pdf_service.generate_pdf
    pdf_filename = "invoice_#{@order.id}.pdf"

    respond_to do |format|
      format.pdf do
        send_data pdf_content, filename: pdf_filename, type: 'application/pdf', disposition: 'attachment'
      end
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_products
    @products = Product.all # Fetch all products for selection
  end

  def order_params
    params.require(:order).permit(:order_no, :total_amount, :invoice, :user_id, product_ids: [])
  end

  def manage_order_products
    selected_products = Product.where(id: params[:order][:product_ids])
    existing_product_ids = @order.product_ids

    # Remove products that are no longer selected
    products_to_remove = @order.products.where.not(id: selected_products.pluck(:id))
    @order.products.delete(products_to_remove) unless products_to_remove.empty?

    # Add only new products
    new_product_ids = selected_products.pluck(:id) - existing_product_ids
    @order.products << Product.where(id: new_product_ids) unless new_product_ids.empty?
  end

  def update_total_amount
    @order.update(total_amount: @order.products.sum(&:price))
  end
end
