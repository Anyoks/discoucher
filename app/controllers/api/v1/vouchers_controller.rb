class Api::V1::VouchersController < Api::V1::BaseController
	before_action :authenticate_api_v1_user!, only: [:me]
	before_action :ensure_est_id_exists, only: [:show_for_establishment]

	def all
		
		# in future when a user logs in, we should check if they have paid for a book then show them their vouchers
		# and not all vouchers
		@vouchers = paginate Voucher.all, per_page: 30

		
		
		render jsonapi: @vouchers, class: { Voucher: Api::V1::SerializableVoucher }
		# render json: VoucherSerializer.new(@vouchers).serialized_json
	end

	def show_for_establishment
		@vouchers = Voucher.where(establishment_id: params[:establishment_id])

		render jsonapi: @vouchers, class: { Voucher: Api::V1::SerializableVoucher }
	end

	def me
		user = current_api_v1_user
		return invalid_user unless  user

		
		
	end




	private

		def invalid_user
			render json: { success: false, message: "Error with your credentials"}, status: :unauthorized
		end

		def ensure_est_id_exists
			ensure_param_exists :establishment_id
		end

		def ensure_param_exists(param)
			return unless params[param].blank?
			render json:{ error: 
						{success: false, message: "Missing #{param} parameter"}
				}, status: :unprocessable_entity
		end
end
