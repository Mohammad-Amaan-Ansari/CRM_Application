module Api
  module V1
		class HomeController < ApplicationController
			before_action :authenticate_user!
			
			def index
				render json:{ message: "you are successfully log in 1"}
			end
		end
	end
end
