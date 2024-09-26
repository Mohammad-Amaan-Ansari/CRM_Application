# frozen_string_literal: true

module Api
  module V1
    # app/controllers/api/v1/home_controller.rb
    class HomeController < ApplicationController
      before_action :authenticate_user!

      def index
        render json: { message: 'you are successfully log in 1' }
      end
    end
  end
end
