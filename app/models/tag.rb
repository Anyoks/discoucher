class Tag < ApplicationRecord


	has_many :tagpics
	has_and_belongs_to_many :vouchers


	def featured_image

		if Rails.env == "development" 
			root_url = "http://localhost:3000"
		else
			root_url = "http://159.89.103.53"
		end


		tagpic = self.tagpics

		if tagpic.present?
			image = root_url + tagpic.first.image.url(:medium)
		else
			image = nil
		end
		
		# image = root_url + tagpic
		return image
	end
end
