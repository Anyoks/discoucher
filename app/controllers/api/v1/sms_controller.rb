class Api::V1::SmsController < Api::V1::BaseController
	skip_before_action :authenticate_user!
	# skip_before_action :authenticate_admin!
	before_action :ensure_message_param_exists
	# 
	def create
		@sms = Sms.new(sms_params)
		if @sms.extract(params[:message])
		  # return message_recieved# render "api/v1/sms/success.json"# return message_recieved 
		  render json: { success: true }, status: :ok
		  # render json: { success: true }, status: :ok
		else
		  # return message_not_recieved 
		  # render jsonapi: { success: false, errors: 'I cant'}, status: :ok
		  render json: { success: false, error: "Kindly check the message format"}, status: :unprocessable_entity
		end
	end

	protected

	def ensure_message_param_exists 
		ensure_param_exists :message
	end

	def ensure_param_exists(param)
		return unless params[param].blank?
		render json:{ success: false, error: "Missing #{param} parameter"}, status: :unprocessable_entity
	 end

	def sms_params
	  params.permit(:message)
	end
end
