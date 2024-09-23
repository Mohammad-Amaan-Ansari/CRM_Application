# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!   # Ensure the user is authenticated
  load_and_authorize_resource         # CanCanCan will handle loading and authorization

  def index
    @orders = if current_user.admin?
                Order.all
              else
                current_user.orders
              end
  end

  def show
    @order = Order.find(params[:id])
    @products = @order.products # Fetch associated products
  end

  def new
    @order = Order.new
    @products = Product.all # Fetch all products for selection
  end

  def create
    # Admin can select a customer (user) for the order
    @order = Order.new(order_params)

    if @order.save
      selected_products = Product.where(id: params[:order][:product_ids])
      existing_product_ids = @order.product_ids

      # Add only new products
      new_product_ids = selected_products.pluck(:id) - existing_product_ids
      @order.products << Product.where(id: new_product_ids) unless new_product_ids.empty?

      # Calculate and update the total amount
      @order.update(total_amount: @order.products.sum(&:price))

      redirect_to orders_path, notice: 'Order was successfully created.'
    else
      @products = Product.all
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
    @products = Product.all # Fetch all products for selection
  end

  def update
    @order = Order.find(params[:id])

    if @order.update(order_params)
      selected_products = Product.where(id: params[:order][:product_ids])
      existing_product_ids = @order.product_ids

      # Remove products that are no longer selected
      products_to_remove = @order.products.where.not(id: selected_products.pluck(:id))
      @order.products.delete(products_to_remove) unless products_to_remove.empty?

      # Add only new products
      new_product_ids = selected_products.pluck(:id) - existing_product_ids
      @order.products << Product.where(id: new_product_ids) unless new_product_ids.empty?

      # Calculate and update the total amount
      @order.update(total_amount: @order.products.sum(&:price))

      redirect_to @order, notice: 'Order was successfully updated.'
    else
      @products = Product.all
      render :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.'
  end

  def generate_pdf
    order = Order.find(params[:id])
    pdf_service = PdfGeneratorService.new(order)
    pdf_content = pdf_service.generate_pdf
    pdf_filename = "invoice_#{order.id}.pdf"

    respond_to do |format|
      format.pdf do
        send_data pdf_content, filename: pdf_filename, type: 'application/pdf', disposition: 'attachment'
      end
    end
  end

  private

  def order_params
    params.require(:order).permit(:order_no, :total_amount, :invoice, :user_id, product_ids: [])
  end
end
