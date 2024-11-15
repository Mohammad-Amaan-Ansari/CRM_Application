# frozen_string_literal: true

module Api
  module V1
    # app/controllers/products_controller.rb
    class ProductsController < ApplicationController
      before_action :set_category, only: %i[index show new create edit update destroy]
      skip_before_action :verify_authenticity_token, only: %i[remove_image prices create update destroy]
      load_and_authorize_resource # CanCanCan will handle loading and authorization
      before_action :authenticate_user! # Ensure the user is authenticated (adjust for API if needed)
      before_action :set_product, only: %i[show update destroy]
      # skip_load_and_authorize_resource only: :show # Disable CanCanCan for the show action

      def all_products
        @products = Product.all
        render json: @products, status: :ok
      end

      def index
        @products = @category.products
        render json: @products, status: :ok
      end

      def show
        @product = @category.products.find(params[:id])
        render json: @product, status: :ok
      end

      def new
        render json: { error: 'This action is not available for API.' }, status: :unprocessable_entity
      end

      def create
        @product = @category.products.new(product_params)
        if @product.save
          render json: @product, status: :created, location: [@category, @product]
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def edit
        render json: { error: 'This action is not available for API.' }, status: :unprocessable_entity
      end

      def update
        @product = @category.products.find(params[:id])
        if @product.update(product_params)
          render json: @product, status: :ok
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @product = @category.products.find(params[:id])
        @product.destroy
        render json: { message: 'Product was successfully destroyed.' }, status: :ok
      end

      def remove_image
        @image = ActiveStorage::Attachment.find(params[:attachment_id]) # Find the image using attachment_id
        @image.purge_later
        render json: { message: 'Image was successfully removed.' }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Couldn't find ActiveStorage::Attachment with 'id'=#{params[:attachment_id]}" }, status: :not_found
      end

      def prices
        product_ids = params[:product_ids]
        products = Product.where(id: product_ids)
        # Check if products were found
        if products.empty?
          render json: { message: 'No products found with the given IDs', prices: [] }, status: :not_found
          return
        end
        prices = products.map { |product| [product.id, product.price] } # include ID with price
        render json: { prices: prices }, status: :ok
      end

      private

      def set_category
        @category = Category.find(params[:category_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message, status: 'failed' }
      end

      def set_product
        @product = @category.products.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { message: "Product not found: #{e.message}" }, status: :not_found
      end

      def product_params
        params.require(:product).permit(:name, :sku, :size, :price, :mrp, :selling_price, images: [])
      end
    end
  end
end
