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
		fav = user.favourites.new(:user_id => user_id, :voucher_id => voucher_id)
		
		if fav.save
			return successfully_added
		else
			return error_adding_favourite
		end		
	end

	def all
		user = current_api_v1_user
		return invalid_user unless  user

		favs = user.get_favourte_vouchers

		render jsonapi: favs, class: { Voucher: Api::V1::SerializableVoucher }
	end

	protected

	def successfully_added
		render json:{ success: true, message: "Voucher marked as favourite"}, status: :ok
	end

	def error_adding_favourite
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
