# == Schema Information
#
# Table name: tags
#
#  id                 :uuid             not null, primary key
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Tag < ApplicationRecord


	has_many :tagpics, dependent: :destroy
	has_and_belongs_to_many :vouchers
	before_save { |tag| tag.name = tag.name.downcase }

	searchkick

	def search_data
	  { 
	  	name: name
	  }
	end


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

	def self.get_vouchers tags

		vouchers_collection = []
		tags.each do |tag|
			tag.vouchers.each do |voucher|
				vouchers_collection << voucher
			end
		end
		return vouchers_collection
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
