class Api::V1::EstablishmentTypeController < Api::V1::BaseController
	before_action :authenticate_api_v1_user!, only: [:me]
	before_action :ensure_voucher_params_exists, only:[:type]


	def all
		@est_type = EstablishmentType.all.paginate(:page => params[:page], :per_page => 10)
		
		render jsonapi: @est_type, class: { EstablishmentType: Api::V1::SerializableEstablishmentType }
		
	end

	def available_types
		@types = EstablishmentType.where(available: true)

		# return render_data @types
		render jsonapi: @types, class: { EstablishmentType: Api::V1::SerializableEstablishmentType }
	end

	def type

		est_type = EstablishmentType.where(name: params[:name]).first

			# byebug
		type_vouchers = paginate est_type.vouchers.order("RANDOM()"), per_page: 30

		# render jsonapi: hotel_vouchers, class: { Voucher: Api::V1::SerializableVoucher }

		context = { user: current_api_v1_user}
		@voucher_resources = type_vouchers.map { |voucher| Api::V1::VoucherResource.new(voucher, context) }

		render json: JSONAPI::ResourceSerializer.new(Api::V1::VoucherResource).serialize_to_hash(@voucher_resources)
	end

	def hotel_vouchers
		hotel = EstablishmentType.where(name: "hotels").first

		hotel_vouchers = paginate hotel.vouchers.order("RANDOM()"), per_page: 30

		# render jsonapi: hotel_vouchers, class: { Voucher: Api::V1::SerializableVoucher }

		context = { user: current_api_v1_user}
		@voucher_resources = hotel_vouchers.map { |voucher| Api::V1::VoucherResource.new(voucher, context) }

		render json: JSONAPI::ResourceSerializer.new(Api::V1::VoucherResource).serialize_to_hash(@voucher_resources)

	end

	def spa_vouchers
		hotel = EstablishmentType.where(name: "spas and salons").first

		hotel_vouchers = paginate hotel.vouchers.order("RANDOM()"), per_page: 30

		# render jsonapi: hotel_vouchers, class: { Voucher: Api::V1::SerializableVoucher }

		context = { user: current_api_v1_user}
		@voucher_resources = hotel_vouchers.map { |voucher| Api::V1::VoucherResource.new(voucher, context) }

		render json: JSONAPI::ResourceSerializer.new(Api::V1::VoucherResource).serialize_to_hash(@voucher_resources)
	end

	def restaurant_vouchers
		hotel = EstablishmentType.where( name: "restaurants").first

		hotel_vouchers = paginate hotel.vouchers.order("RANDOM()"), per_page: 30

		# render jsonapi: hotel_vouchers, class: { Voucher: Api::V1::SerializableVoucher }
		context = { user: current_api_v1_user}
		@voucher_resources = hotel_vouchers.map { |voucher| Api::V1::VoucherResource.new(voucher, context) }

		render json: JSONAPI::ResourceSerializer.new(Api::V1::VoucherResource).serialize_to_hash(@voucher_resources)
	end

	def me
		
	end

	private

	def render_data array
		render json: { data: array }
	end

	def ensure_voucher_params_exists
		ensure_param_exists :name
	end

	def ensure_param_exists(param)
		return unless params[param].blank?
		render json:{ error: 
					{success: false, message: "Missing #{param} parameter"}
			}, status: :unprocessable_entity
	end

	
end
