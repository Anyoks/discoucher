class Api::V1::DiscoverController < Api::V1::BaseController

	def tags
		
		@tags =  paginate Tag.all, per_page: 30

		render jsonapi: @tags, class: { Tag: Api::V1::SerializableTag }
	end
end
