class Api::V1::EstablishmentTypeController < Api::V1::BaseController


	def all
		@est_type = EstablishmentType.all.paginate(:page => params[:page], :per_page => 10)
		
		render jsonapi: @est_type, class: { EstablishmentType: Api::V1::SerializableEstablishmentType }
		
	end

	def hotel_vouchers
		hotel = EstablishmentType.where(name: "Hotel").first

		hotel_vouchers = paginate hotel.vouchers, per_page: 30

		render jsonapi: hotel_vouchers, class: { Voucher: Api::V1::SerializableVoucher }

	end

	def spa_vouchers
		hotel = EstablishmentType.where(name: "Spas and Salons").first

		hotel_vouchers = paginate hotel.vouchers, per_page: 30

		render jsonapi: hotel_vouchers, class: { Voucher: Api::V1::SerializableVoucher }
	end

	def restaurant_vouchers
		hotel = EstablishmentType.where( name: "Restaurant").first

		hotel_vouchers = paginate hotel.vouchers, per_page: 30

		render jsonapi: hotel_vouchers, class: { Voucher: Api::V1::SerializableVoucher }
	end
end
