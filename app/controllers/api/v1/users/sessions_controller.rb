# frozen_string_literal: true

# app/controllers/api/v1/users/sessions_controller.rb
module Api
  module V1
    module Users
      # app/controllers/api/v1/users/sessions_controller.rb
      class SessionsController < Devise::SessionsController
        skip_before_action :verify_authenticity_token, only: %i[create destroy]
        respond_to :json
        include RackSessionsFix
        # before_action :configure_sign_in_params, only: [:create]

        # GET /resource/sign_in
        # def new
        #   super
        # end

        def create
          user = User.find_for_database_authentication(email: params[:user][:email])
          Rails.logger.debug("User found: #{user.present?}")

          if user&.valid_password?(params[:user][:password])
            # Sign in the user if credentials are valid
            sign_in(user)

            # Generate a JWT token for the signed-in user
            token = current_token(user)

            respond_with_success(user, token)
          else
            Rails.logger.debug('Invalid email or password')
            render json: {
              status: { message: 'Invalid email or password' }
            }, status: :unauthorized
          end
        end

        def destroy
          if request.headers['Authorization'].present?
            jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last,
                                     Rails.application.credentials.devise_jwt_secret_key!).first
            current_user = User.find(jwt_payload['sub'])
          end

          if current_user
            # Sign out the user and end the session
            sign_out(current_user)
            render json: {
              status: { code: 200, message: 'Logged out successfully.' }
            }, status: :ok
          else
            render json: {
              status: { code: 401, message: "Couldn't find an active session." }
            }, status: :unauthorized
          end
        end
        # protected

        # If you have extra params to permit, append them to the sanitizer.
        # def configure_sign_in_params
        #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
        # end
        private

        # Method to generate JWT token
        def current_token(user)
          JWT.encode({ sub: user.id }, Rails.application.credentials.devise_jwt_secret_key!, 'HS256')
        end

        # Response method for successful login
        def respond_with_success(user, token)
          render json: {
            status: { code: 200, message: 'Logged in successfully.' },
            data: {
              id: user.id,
              email: user.email,
              token: token
            }
          }, status: :ok
        end
      end
    end
  end
end
