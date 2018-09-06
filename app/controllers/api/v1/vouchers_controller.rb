class Api::V1::VouchersController < Api::V1::BaseController

	before_action :ensure_est_id_exists, only: [:show_for_establishment]

	def all
		@vouchers = Voucher.all.paginate(:page => params[:page], :per_page => 10)
		
		render jsonapi: @vouchers, class: { Voucher: Api::V1::SerializableVoucher }
		# render json: VoucherSerializer.new(@vouchers).serialized_json
	end

	def show_for_establishment
		@vouchers = Voucher.where(establishment_id: params[:establishment_id])

		render jsonapi: @vouchers, class: { Voucher: Api::V1::SerializableVoucher }
	end




	private


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
