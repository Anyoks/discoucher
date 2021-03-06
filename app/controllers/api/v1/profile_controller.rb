class Api::V1::ProfileController < Api::V1::BaseController
	before_action :authenticate_api_v1_user!
	before_action :ensure_voucher_id_exists, only: [:add_favourite]
	def profile
		token = current_api_v1_user.first_name
		render json: { data: [success: true, data: "Wrong message format.", status: "#{token}"]}, status: :ok
		
	end

	def add_favourite
		user = current_api_v1_user
		return invalid_user unless  user
		
		user_id = user.id
		voucher_id = params[:voucher_id]

		check_for_voucher = user.favourites.where(voucher_id: voucher_id).first

		if check_for_voucher.present?
			# remove fav
			if check_for_voucher.destroy
				return successfully_removed
			else
				return error_removing_favourite
			end

		else
			# creat fav
			fav = user.favourites.new(:user_id => user_id, :voucher_id => voucher_id)
			if fav.save
				return successfully_added
			else
				return error_adding_favourite
			end		
		end
		
	end

	# show all favourite vouchers
	def all
		user = current_api_v1_user
		return invalid_user unless  user

		favs =  paginate user.get_favourte_vouchers, per_page: 30

		# render jsonapi: favs, class: { Voucher: Api::V1::SerializableVoucher }

		context = { user: current_api_v1_user}
		@voucher_resources = favs.map { |voucher| Api::V1::VoucherResource.new(voucher, context) }			
		render json: JSONAPI::ResourceSerializer.new(Api::V1::VoucherResource).serialize_to_hash(@voucher_resources)
	end

	def rate
		user = current_api_v1_user
		voucher_id = Voucher.where( code: params[:voucher_code].strip).first.id
		comment    = params[:comment].downcase
		rating     = params[:rating]

		rate 	   = user.reviews.new( comment: comment, voucher_id: voucher_id, rating: rating)

		if rate.save
			return successfully_rated
		else
			return error_rating rate
		end

	end

	def books
		user = current_api_v1_user
		return invalid_user unless  user

		books = user.get_book_codes

		return book_codes books
	end

	def redeemed_offers
		user = current_api_v1_user
		return invalid_user unless  user

		redeemed = paginate user.get_redeemed_offers, per_page: 30

		context = { user: current_api_v1_user}
		@voucher_resources = redeemed.map { |voucher| Api::V1::VoucherResource.new(voucher, context) }

			
		render json: JSONAPI::ResourceSerializer.new(Api::V1::VoucherResource).serialize_to_hash(@voucher_resources)
	end

	# def book_code
	# 	user = current_api_v1_user
	# 	return invalid_user unless  user

	# 	voucher = Voucher.find(params[:voucher_id])


	# 	book_code = voucher.establishment.register_books

	# 	book = Book.find_by_code("236966")

	# 	return book_codes books
	# end

	protected

	def book_codes books
		render json:{ data: [success: true, book_codes: books ]}, status: :ok
	end

	def successfully_rated
		render json:{ success: true, message: "Voucher has been successfully rated"}, status: :ok
	end

	def error_rating rate
		full_messages = ""
		rate.errors.full_messages.each do |err|
			full_messages =  full_messages + err + ','
			logger.debug "ERRR #{err}"
		end
		render json: { success: false, message: full_messages}, status: :unauthorized
	end

	def successfully_added
		render json:{ success: true, message: "Voucher marked as favourite"}, status: :ok
	end

	def successfully_removed
		render json:{ success: true, message: "Voucher removed from favourites"}, status: :ok
	end

	def error_adding_favourite
		render json: { success: false, message: "Error adding favourites"}, status: :unauthorized
	end

	def error_removing_favourite
		render json: { success: false, message: "Error adding favourites"}, status: :unauthorized
	end
	

	def ensure_voucher_id_exists
		ensure_param_exists :voucher_id
	end

	def ensure_param_exists(param)
		return unless params[param].blank?
		render json:{ error: 
					{success: false, message: "Missing #{param} parameter"}
			}, status: :unprocessable_entity
	end

	def invalid_user
		render json: { success: false, message: "Error with your credentials"}, status: :unauthorized
	end
end
