class Api::V1::SearchController < Api::V1::BaseController
	# require 'will_paginate/array'
	# before_action :authenticate_api_v1_user!
	respond_to :json
	before_action :ensure_search_query_exists, only: [:vouchers]
	
	def vouchers
		
		elastic_query = {
			fields: [:code, :description, :condition, :establishment, :tags],
			order: { _score: :desc },
			page: params[:page],
			per_page: 30
		}
		

		@raw_results = Voucher.search(params[:query])#, elastic_query)
		# byebug
		
		# if @raw_results.count == 0
			# @un_paginated_results = search_establishments
			# @results = paginate search_establishments, per_page: 30
		# else
			@results = paginate @raw_results.results, per_page: 30
		# end

		# byebug 
		render jsonapi: @results, class: { Voucher: Api::V1::SerializableVoucher }
	end

	private

		# def search_establishments
		# 	elastic_query = {
		# 		fields: [:name, :type, :location, :area, :phone],
		# 		order: { _score: :desc },
		# 		page: params[:page],
		# 		per_page: 30
		# 	}
		# 	@raw = Establishment.search(params[:query], elastic_query)
		# 	@results = Establishment.get_vouchers @raw
		# end

		# def search_tags
		# 	elastic_query = {
		# 		fields: [:name],
		# 		order: { _score: :desc },
		# 		page: params[:page],
		# 		per_page: 30
		# 	}

		# 	@raw = Tag.search(params[:query], elastic_query)
		# 	@results = Tag.get_vouchers @raw
		# end

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
