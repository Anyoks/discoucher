class Api::V1::ProfileController < Api::V1::ApplicationController
	before_action :authenticate_api_v1_user!
	def profile
		token = current_api_v1_user.first_name
		render json: { data: [success: true, data: "Wrong message format.", status: "#{token}"]}, status: :ok
		
	end
end
