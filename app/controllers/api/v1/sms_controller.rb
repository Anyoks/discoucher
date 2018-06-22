class Api::V1::SmsController < Api::V1::BaseController
	# skip_before_action :authenticate_user!
	# skip_before_action :authenticate_admin!
	# before_action :ensure_message_param_exists
	# 
	def create
		@sms = Sms.new(sms_params)
		# process and save the SMS
		# 
		
		@processed_text = @sms.process_text
		# byebug

		if @processed_text.class != Array 
			# attempt redeem, the result is an array with true/false + the error or success message
			@redeemed_status = @processed_text.attempt_redeem

			if @redeemed_status[0] == true 
				
				# render json: { success: true, message: "#{@redeemed_status[1]}", phone_number: "#{@sms.phone_number}" }, status: :ok
				render json: { sms: [success: true, message: "#{@redeemed_status[1]}", phone_number: "#{@sms.phone_number}"]}, status: :ok
				

			else
				# render json: { success: false, error: "#{@redeemed_status[1]}",  phone_number: "#{@sms.phone_number}"}, status: :unprocessable_entity
				render json: { sms: [success: false, message: "#{@redeemed_status[1]}", phone_number: "#{@sms.phone_number}"]}, status: :ok
			end

		else
			
			# render json: { success: false, error: "#{@processed_text[1]}", phone_number: "#{@sms.phone_number}"}, status: :unprocessable_entity
			render json: { sms: [success: false, message: "Wrong message format. Please ensure the message has  the format *BOOKCODE*VOUCHERCODE# and try again ", phone_number: "#{@sms.phone_number}"]}, status: :ok
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

	 def generate_json_sucess_sms_to_be_sent
	 	phone = @sms.phone_number
	 	# build json

	 end

	def sms_params
	  params.permit(:phone_number,:message)
	end
	# def fix
	# 	name = ["message", "phone_number"] 
	# 	data = []
	# 	data << params[:message] << params[:sender]
	# 	params = Hash[*name.zip(data).flatten]	
	# 	return params	
	# end
end
