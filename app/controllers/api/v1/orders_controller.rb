# frozen_string_literal: true

module Api
  module V1
    # app/controllers/api/v1/orders_controller.rb
    class OrdersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user! # Ensure the user is authenticated
      before_action :set_order, only: %i[show edit update destroy generate_pdf] # Load order for specific actions
      before_action :check_authorization

      # Only set products for actions where they're needed
      before_action :set_products, only: %i[new create edit update]

      def index
        @orders = current_user.admin? ? Order.all : current_user.orders
        render json: @orders, status: :ok
      end

      def show
        render json: @order, status: :ok
      end

      def create
        @order = Order.new(order_params)

        if @order.save
          manage_order_products
          update_total_amount
          render json: { message: 'Order was successfully created.', order: @order }, status: :created
        else
          render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def edit
        render json: @order, status: :ok
      end

      def update
        if @order.update(order_params)
          manage_order_products
          update_total_amount
          render json: { message: 'Order was successfully updated.', order: @order }, status: :ok
        else
          render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @order.destroy
          render json: { message: 'Order was successfully destroyed.' }, status: :ok
        else
          render json: { errors: 'Order could not be destroyed' }, status: :unprocessable_entity
        end
      end

      def generate_pdf
        pdf_service = PdfGeneratorService.new(@order)
        pdf_content = pdf_service.generate_pdf
        pdf_filename = "invoice_#{@order.id}.pdf"

        respond_to do |format|
          format.json { render json: { message: 'PDF generated successfully', pdf_filename: pdf_filename }, status: :ok }
          format.pdf do
            send_data pdf_content, filename: pdf_filename, type: 'application/pdf', disposition: 'attachment'
          end
        end
      end

      private

      def set_order
        @order = Order.find(params[:id])
        render json: { error: 'Order not found' }, status: :not_found unless @order
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

      def check_authorization
        if request.headers['Authorization'].present?
          token = request.headers['Authorization'].split(' ').last
          begin
            # Decode the JWT token
            jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' }).first
            # Find the user based on the `sub` field (typically user ID) in the JWT payload
            @current_user = User.find(jwt_payload['sub'])
          rescue JWT::DecodeError, ActiveRecord::RecordNotFound
            # Handle invalid token or user not found
            render json: { error: 'Unauthorized access. Invalid or expired token.' }, status: :unauthorized
          end
        else
          # If the Authorization header is not present
          render json: { error: 'Authorization token is missing.' }, status: :unauthorized
        end
      end

      attr_reader :current_user
    end
  end
end
