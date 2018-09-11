class Api::V1::SearchController < Api::V1::BaseController
	# before_action :authenticate_api_v1_user!
	respond_to :json
	before_action :ensure_search_query_exists, only: [:vouchers]
	
	def vouchers
		
		elastic_query = {
			fields: [:code, :description, :condition, :establishment],
			order: { _score: :desc },
			page: params[:page],
			per_page: 30
		}
		@results = Voucher.search(params[:query], elastic_query)

		if @results.count == 0
			@results = search_establishments
		end

		render jsonapi: @results, class: { Voucher: Api::V1::SerializableVoucher }
	end

	private

		def search_establishments
			elastic_query = {
				fields: [:name, :type, :location, :area, :phone],
				order: { _score: :desc },
				page: params[:page],
				per_page: 30
			}
			@results = Establishment.search(params[:query], elastic_query)
		end

		def ensure_search_query_exists
			ensure_param_exists :query
		end

		def ensure_param_exists(param)
			return unless params[param].blank?
			render json:{ error: 
						{success: false, message: "Missing #{param} parameter"}
				}, status: :unprocessable_entity
		end
end