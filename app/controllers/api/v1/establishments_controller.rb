class Api::V1::EstablishmentsController < Api::V1::BaseController
	before_action :authenticate_api_v1_user!
	jsonapi resource:  Api::V1::EstablishmentResource
	
	def est

		@establishments = Establishment.all.paginate(:page => params[:page], :per_page => 20)
   
		
		# render jsonapi: @establishments #, class: { Establishment: Api::V1::SerializableEstablishment }
		render_jsonapi @establishments, class: { Establishment: Api::V1::SerializableEstablishment }
		
	end
end