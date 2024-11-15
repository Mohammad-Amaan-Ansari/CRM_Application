# frozen_string_literal: true

# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found # for api response
  include CanCan::ControllerAdditions

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
  end

  private

  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end
