# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_category, only: %i[index show new create edit update destroy]
  skip_before_action :verify_authenticity_token, only: [:prices]
  load_and_authorize_resource # CanCanCan will handle loading and authorization
  def all_products
    @products = Product.all
  end

  def index
    @category = Category.find(params[:category_id])
    @products = @category.products
  end

  def show
    @product = @category.products.find(params[:id])
  end

  def new
    @product = @category.products.new
  end

  def create
    @product = @category.products.new(product_params)
    if @product.save
      redirect_to [@category, @product], notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def edit
    @product = @category.products.find(params[:id]) # Find the existing product
  end

  def update
    @product = @category.products.find(params[:id]) # Find the existing product
    if @product.update(product_params) # Update the product with the new attributes
      redirect_to [@category, @product], notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product = @category.products.find(params[:id]) # Find the existing product
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  def remove_image
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge_later
    redirect_to(fallback_location: request.referer)
  end

  def prices
    product_ids = params[:product_ids]
    products = Product.where(id: product_ids)
    prices = products.map(&:price)

    render json: { prices: prices }
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  def product_params
    params.require(:product).permit(:name, :sku, :size, :price, :mrp, :selling_price, images: [])
  end
end
