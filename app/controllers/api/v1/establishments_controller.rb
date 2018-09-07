class Api::V1::EstablishmentsController < Api::V1::BaseController
	# skip_before_action :authenticate_api_v1_user!
	# jsonapi resource:  Api::V1::EstablishmentResource
	before_action :ensure_est_id_exists, only: [:get_est]
	
	def est

		
		@establishments = paginate Establishment.all, per_page: 30
		
		# render jsonapi: @establishments #, class: { Establishment: Api::V1::SerializableEstablishment }
		render jsonapi: @establishments, class: { Establishment: Api::V1::SerializableEstablishment }
		
	end

	# return hotels
	def hotels
		
		@hotels = paginate Establishment.hotels, per_page: 30
		render jsonapi: @hotels, class: { Establishment: Api::V1::SerializableEstablishment }
	end

	# return restaurants
	def restaurants
		@restaurants = paginate Establishment.restaurants, per_page:30

		render jsonapi: @restaurants, class: { Establishment: Api::V1::SerializableEstablishment }
	end

	# return spas and salons
	def spas
		@spas_and_salons = paginate Establishment.spas_and_salons, per_page: 30

		render jsonapi: @spas_and_salons, class: { Establishment: Api::V1::SerializableEstablishment }
	end

	# return an est object on request with ID
	def get_est
		@establishment = Establishment.where(id: params[:establishment_id]).first

		if @establishment.present?
			render jsonapi: @establishment, class: { Establishment: Api::V1::SerializableEstablishment }
		else
			return invalid_est
		end

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

		def invalid_est
	    	render json: { success: false, error: "Cannot find Establishment"}, status: :unauthorized
	  	end
end