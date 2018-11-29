class Api::V1::PayController < Api::V1::BaseController
	# before_action :authenticate_api_v1_user!
	before_action :ensure_req_id_exists, only: [:check_status]
	# include PaymentModules::Mpesa

	require "#{Rails.root}/mpesa.rb"


	# phone number and amount
	def mobile
		phone_number = params[:phone_number]
		description  = params[:description]
		amount		 = 1 #params[:amount]  # change this to 2000/- when system is ready.
		uid 	     = params[:uid]#params[:user_id]

		user_id		 = User.where(email: uid).first.id

		mpesa 				= Mpesa.new( phone_number, amount, description)
		request 			= mpesa.request_mpesa_api

		# byebug
		json 				= JSON.parse(request.body)
		# byebug

		if json["errorMessage"]
			return server_error json["errorMessage"]
		else
			payment_req 					=  PaymentRequest.new
			payment_req.MerchantRequestID	= json["MerchantRequestID"]
			payment_req.CheckoutRequestID	= json["CheckoutRequestID"]
			payment_req.ResponseCode		= json["ResponseCode"]
			payment_req.ResponseDescription	= json["ResponseDescription"]
			payment_req.CustomerMessage		= json["CustomerMessage"]
			payment_req.user_id				= user_id
			payment_req.save

			if payment_req.ResponseCode == "0"
				return successful_request json["CustomerMessage"], json["CheckoutRequestID"]
			else
				return failed_request json["CustomerMessage"]
			end
		end
		
	end

	def from_mpesa

		# {"Body"=>{"stkCallback"=>{"MerchantRequestID"=>"32420-650798-1", 
		# 	"CheckoutRequestID"=>"ws_CO_DMZ_91536166_09102018190034360", 
		# 	"ResultCode"=>0, "ResultDesc"=>"The service request is processed successfully.", 
		# 	"CallbackMetadata"=>{"Item"=>[{"Name"=>"Amount", "Value"=>1.0}, 
		# 		{"Name"=>"MpesaReceiptNumber", "Value"=>"MJ905N5336"}, {"Name"=>"Balance"},
		# 		{"Name"=>"TransactionDate", "Value"=>20181009190043}, {"Name"=>"PhoneNumber", 
		# 			"Value"=>254711430817}]
		# 			}
		# 		}
		# 	}
		# }
		 
		response = request.POST

		checkoutRequestID 	= response["Body"]["stkCallback"]["CheckoutRequestID"]

		payment_req 		= PaymentRequest.where(CheckoutRequestID: checkoutRequestID).first


		if response["Body"]["stkCallback"]["CallbackMetadata"]

			payment_response  	= payment_req.build_payment_response

			payment_response.MerchantRequestID 	= response["Body"]["stkCallback"]["MerchantRequestID"]
			payment_response.CheckoutRequestID 	= response["Body"]["stkCallback"]["CheckoutRequestID"]
			payment_response.ResultCode		 	= response["Body"]["stkCallback"]["ResultCode"]
			payment_response.ResultDescription	= response["Body"]["stkCallback"]["ResultDesc"]

			payment_response.Amount 			= response["Body"]["stkCallback"]["CallbackMetadata"]["Item"][0]["Value"]
			payment_response.MpesaReceiptNumber = response["Body"]["stkCallback"]["CallbackMetadata"]["Item"][1]["Value"]
			payment_response.Balance 			= response["Body"]["stkCallback"]["CallbackMetadata"]["Item"][2]["Value"]
			payment_response.TransactionDate	= get_time_from response["Body"]["stkCallback"]["CallbackMetadata"]["Item"][3]["Value"]
			payment_response.PhoneNumber		= response["Body"]["stkCallback"]["CallbackMetadata"]["Item"][4]["Value"]

			payment_response.save
			
			@book_assingment =  payment_response.create_registered_book_for_payed_user
			byebug
			return successful_payment "test"
		else

			failed_payment_response 					= payment_req.build_failed_payment_response

			failed_payment_response.MerchantRequestID 	= response["Body"]["stkCallback"]["MerchantRequestID"]
			failed_payment_response.CheckoutRequestID 	= response["Body"]["stkCallback"]["CheckoutRequestID"]
			failed_payment_response.ResultCode		 	= response["Body"]["stkCallback"]["ResultCode"]
			failed_payment_response.ResultDescription	= response["Body"]["stkCallback"]["ResultDesc"]

			failed_payment_response.save

			return failed_payment "test"
		end
		
	end

	def check_book_assingment
		val = @book_assingment
		return book_assingment_status val
	end
	

	def check_status
		# send payment_req_id//CheckoutRequestID to check status
		
		checkout_req_id = params[:checkout_req_id]
		
		payment_request = PaymentRequest.where(CheckoutRequestID: checkout_req_id).first

		if payment_request.present?
			if payment_request.payment_response.present?
				return successful_payment "Payment was successful"
			elsif payment_request.failed_payment_response.present?
				message = payment_request.failed_payment_response.ResultDescription
				return failed_payment message
			else
				# payment does not exist
				return failed_payment "Payment does not exist"
			end 
		else
			return failed_request "Invalid checkout_req_id"
		end
		
	end




	private

		def get_time_from string
			time_array  = string.to_s.chars.map(&:to_i)

			year 	= time_array[0..3].join("")
			month	= time_array[4..5].join("")
			day 	= time_array[6..7].join("")
			hour 	= time_array[8..9].join("")
			min 	= time_array[10..11].join("")
			sec 	= time_array[12..13].join("")

			time = Time.new(year,month,day,hour,min,sec)

			return time
		end

		def book_assingment_status val
			if @book_assingment
				render json:{ success: true, message: "#{@book_assingment}"}, status: :ok
			else
				render json:{ success: false, error: "#{@book_assingment}"}, status: :unprocessable_entity
			end
		end

		def successful_request customerMessage, checkoutRequestID
			render json:{ success: true, message: "#{customerMessage}", checkout_req_id: "#{checkoutRequestID}"}, status: :ok
		end

		def failed_request customerMessage
			render json:{ success: false, error: "#{customerMessage}"}, status: :unprocessable_entity
		end

		def server_error customerMessage
			render json:{ success: false, error: "#{customerMessage}"}, status: :unprocessable_entity
		end

		def successful_payment message
			render json:{ success: true, message: "#{message}"}, status: :ok
		end

		def failed_payment message
			render json:{ success: false, error: "#{message}"}, status: :unprocessable_entity
		end

		def ensure_est_id_exists
			ensure_param_exists :establishment_id
		end

		def ensure_req_id_exists
			ensure_param_exists :checkout_req_id
		end

		def ensure_param_exists(param)
			return unless params[param].blank?
			render json:{ error: 
						{success: false, message: "Missing #{param} parameter"}
				}, status: :unprocessable_entity
		end
end