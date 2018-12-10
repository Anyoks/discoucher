class Api::V1::RedeemController < Api::V1::BaseController
	before_action :authenticate_api_v1_user!
	before_action :ensure_voucher_params_exists, :ensure_pin_param_exists
	# 
	def voucher

		user = current_api_v1_user
		return invalid_user unless  user


		voucher_code = params[:voucher_code]
		# book_code  	 = params[:book_code]
		# uid			 = params[:uid]
		est_pin 	 = params[:est_pin]

		# user 		 = User.find_by_email(params[:uid])


		# find the book and see if it is regeistered
		
		# book 		= Book.find_by_code(book_code)
		

		# return invalid_book unless book

		voucher 	= Voucher.find_by_code(voucher_code)

		# return invalid_voucher unless voucher

		# check est pin before redeemption
		pin_check	= est_pin == voucher.establishment.pin

		if pin_check

			redeem 		= user.est_voucher_redemption_v2(voucher)

			if redeem[0]
				render json:{ success: true, message: "#{redeem[1]}"}, status: :ok
			else
				render json:{ success: false, error: "#{redeem[1]}"}, status: :unprocessable_entity
			end
		else
			return invalid_pin
		end	
	end

	protected

	def ensure_voucher_params_exists
		ensure_param_exists :voucher_code
	end

	def ensure_book_params_exists
		ensure_param_exists :book_code
	end

	def ensure_uid_params_exists
		ensure_param_exists :uid
	end

	def ensure_message_param_exists 
		ensure_param_exists :message
	end

	def ensure_pin_param_exists 
		ensure_param_exists :est_pin
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
	
	def invalid_user
		render json: { success: false, message: "Error with your credentials"}, status: :unauthorized
	end
	def invalid_book
		render json: { success: false, message: "Error Book not found with that id"}, status: :unauthorized
	end

	def invalid_voucher
		render json: { success: false, message: "Error voucher not found"}, status: :unauthorized
	end

	def invalid_pin
		render json: { success: false, message: "Wrong establishment pin"}, status: :unauthorized
	end
end
