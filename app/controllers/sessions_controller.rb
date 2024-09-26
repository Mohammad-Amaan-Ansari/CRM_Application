# frozen_string_literal: true

# app/controllers/sessions_controller.rb
class SessionsController < Devise::SessionsController
  # Override the destroy action for Turbo Stream handling
  def destroy
    super do |_resource|
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'You have successfully signed out.' }
        format.turbo_stream { head :no_content } # Turbo Stream format
      end
    end
  end
end
