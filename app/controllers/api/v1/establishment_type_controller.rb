class Api::V1::EstablishmentTypeController < Api::V1::BaseController


	def all
		@est_type = EstablishmentType.all.paginate(:page => params[:page], :per_page => 10)
		
		render jsonapi: @est_type, class: { EstablishmentType: Api::V1::SerializableEstablishmentType }
		
	end
end
