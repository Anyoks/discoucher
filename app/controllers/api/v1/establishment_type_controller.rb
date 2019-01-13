class Api::V1::EstablishmentTypeController < Api::V1::BaseController
	before_action :authenticate_api_v1_user!, only: [:me]


	def all
		@est_type = EstablishmentType.all.paginate(:page => params[:page], :per_page => 10)
		
		render jsonapi: @est_type, class: { EstablishmentType: Api::V1::SerializableEstablishmentType }
		
	end

	def hotel_vouchers
		hotel = EstablishmentType.where(name: "Hotel").first

		hotel_vouchers = paginate hotel.vouchers, per_page: 30

		# render jsonapi: hotel_vouchers, class: { Voucher: Api::V1::SerializableVoucher }

		context = { user: current_api_v1_user}
		@voucher_resources = hotel_vouchers.map { |voucher| Api::V1::VoucherResource.new(voucher, context) }

		render json: JSONAPI::ResourceSerializer.new(Api::V1::VoucherResource).serialize_to_hash(@voucher_resources)

	end

	def spa_vouchers
		hotel = EstablishmentType.where(name: "Spas and Salons").first

		hotel_vouchers = paginate hotel.vouchers, per_page: 30

		render jsonapi: hotel_vouchers, class: { Voucher: Api::V1::SerializableVoucher }

		# context = { user: current_api_v1_user}
		# @voucher_resources = hotel_vouchers.map { |voucher| Api::V1::VoucherResource.new(voucher, context) }

		# render json: JSONAPI::ResourceSerializer.new(Api::V1::VoucherResource).serialize_to_hash(@voucher_resources)
	end

	def restaurant_vouchers
		hotel = EstablishmentType.where( name: "Restaurant").first

		hotel_vouchers = paginate hotel.vouchers, per_page: 30

		# render jsonapi: hotel_vouchers, class: { Voucher: Api::V1::SerializableVoucher }
		context = { user: current_api_v1_user}
		@voucher_resources = hotel_vouchers.map { |voucher| Api::V1::VoucherResource.new(voucher, context) }

		render json: JSONAPI::ResourceSerializer.new(Api::V1::VoucherResource).serialize_to_hash(@voucher_resources)
	end

	def me
		
	end
	
end
