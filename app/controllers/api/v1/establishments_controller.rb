class Api::V1::EstablishmentsController < Api::V1::BaseController
	skip_before_action :authenticate_api_v1_user!
	# jsonapi resource:  Api::V1::EstablishmentResource
	
	def est

		@establishments = Establishment.all.paginate(:page => params[:page], :per_page => 20)
   
		
		# render jsonapi: @establishments #, class: { Establishment: Api::V1::SerializableEstablishment }
		render jsonapi: @establishments, class: { Establishment: Api::V1::SerializableEstablishment }
		
	end

	# return hotels
	def hotels
		@hotels = Establishment.hotels.paginate(:page => params[:page], :per_page => 20)

		render jsonapi: @hotels, class: { Establishment: Api::V1::SerializableEstablishment }
	end

	# return restaurants
	def restaurants
		@restaurants = Establishment.restaurants.paginate(:page => params[:page], :per_page => 20)

		render jsonapi: @restaurants, class: { Establishment: Api::V1::SerializableEstablishment }
	end

	# return spas and salons
	def spas
		@spas_and_salons = Establishment.spas_and_salons.paginate(:page => params[:page], :per_page => 20)

		render jsonapi: @spas_and_salons, class: { Establishment: Api::V1::SerializableEstablishment }
	end
end