class Api::V1::BaseController < ActionController::API
	 respond_to :json
	 before_action :configure_permitted_parameters, if: :devise_controller?
	include DeviseTokenAuth::Concerns::SetUserByToken
	# skip_before_action :verify_authenticity_token
 	# before_action :authenticate_api_v1_user!
	
	rescue_from ActionController::ParameterMissing do
		api_error(status: 400, errors: 'Invalid parameters')
	end

	rescue_from ActiveRecord::RecordNotFound do
		api_error(status: 404, errors: 'Resource not found!')
	end

	# rescue_from UnauthenticatedError do
	# 	unauthenticated!
	# end

protected 

	def unauthenticated!
      unless Rails.env.production? || Rails.env.test?
        Rails.logger.warn { "Unauthenticated user not granted access" }
      end

      api_error(status: 401, errors: 'Not Authenticated')
    end


	def api_error(status: 500, errors: [])
      puts errors.full_messages if errors.respond_to?(:full_messages)

      render json: Api::V1::ErrorSerializer.new(status, errors).as_json,
        status: status
    end

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :password, :password_confirmation , :phone_number]) 
    end
end
