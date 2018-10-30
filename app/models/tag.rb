class Tag < ApplicationRecord


	has_many :tagpics
	has_and_belongs_to_many :vouchers
	before_save { |tag| tag.name = tag.name.downcase }


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


	def self.dup
		tagS = []
		tags  = []
		codes = []
		regex = /[[:upper:]]/
		Tag.all.each do |tag|
		  small_tag_name = tag.name.downcase
		  capital_tag_name = tag.name.titlecase

		  # search
		  small = Tag.where(name: "#{small_tag_name}")
		  caps = Tag.where(name: "#{capital_tag_name}")
		  
		  if small.count >= 1 && caps.count >=1


		  	# if small.count > caps.count

		  	# elsif caps.count > small.count

		  	# end
		  			
		  	# 

		  	tagS << caps.first.vouchers.count
		  	
		  	tags << small.first.vouchers.count
		  	
		  end
		end

		return tags, tagS
	end
end
