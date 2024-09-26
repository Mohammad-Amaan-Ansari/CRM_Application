# frozen_string_literal: true

# app/controllers/api/v1/users/registrations_controller.rb
module Api
  module V1
    module Users
      # This controller handles user registration actions such as creating new user accounts.
      class RegistrationsController < Devise::RegistrationsController
        skip_before_action :verify_authenticity_token, only: [:create]
        respond_to :json
        include RackSessionsFix
        # before_action :configure_sign_up_params, only: [:create]
        # before_action :configure_account_update_params, only: [:update]

        # GET /resource/sign_up
        # def new
        #   super
        # end
        def create
          user = User.new(sign_up_params)

          if user.save
            token = current_token(user) # Generate JWT token for the newly created user
            render json: {
              status: { code: 200, message: 'Signed up successfully.' },
              data: {
                id: user.id,
                email: user.email,
                token: token
              }
            }, status: :ok
          else
            render json: {
              status: { message: "User couldn't be created successfully. #{user.errors.full_messages.to_sentence}" }
            }, status: :unprocessable_entity
          end
        end
        # GET /resource/edit
        # def edit
        #   super
        # end

        # PUT /resource
        # def update
        #   super
        # end

        # DELETE /resource
        # def destroy
        #   super
        # end

        # GET /resource/cancel
        # Forces the session data which is usually expired after sign
        # in to be expired now. This is useful if the user wants to
        # cancel oauth signing in/up in the middle of the process,
        # removing all OAuth session data.
        # def cancel
        #   super
        # end

        # protected

        # If you have extra params to permit, append them to the sanitizer.
        # def configure_sign_up_params
        #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
        # end

        # If you have extra params to permit, append them to the sanitizer.
        # def configure_account_update_params
        #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
        # end

        # The path used after sign up.
        # def after_sign_up_path_for(resource)
        #   super(resource)
        # end

        # The path used after sign up for inactive accounts.
        # def after_inactive_sign_up_path_for(resource)
        #   super(resource)
        # end
        private

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end

        # Generate JWT token
        def current_token(user)
          JWT.encode({ sub: user.id }, Rails.application.credentials.devise_jwt_secret_key!, 'HS256')
        end
      end
    end
  end
end
