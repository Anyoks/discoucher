class Api::V1::DiscoverController < Api::V1::BaseController

	def tags
		
		@tag = []

		Tagpic.all.each do |tagpic| 
			if tagpic.tag.present?
			 	@tag << tagpic.tag 
			end
		end


		@tags =  paginate @tag , per_page: 30
		
		render jsonapi: @tags, class: { Tag: Api::V1::SerializableTag }
	end
end
