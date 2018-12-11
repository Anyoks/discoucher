# == Schema Information
#
# Table name: establishments
#
#  id                    :uuid             not null, primary key
#  name                  :string
#  area                  :string
#  location              :string
#  phone                 :string
#  address               :string
#  logo_file_name        :string
#  logo_content_type     :string
#  logo_file_size        :integer
#  logo_updated_at       :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  book_id               :uuid
#  establishment_type_id :integer
#  description           :text
#  working_hours         :string
#  email                 :string
#  website               :string
#  social_media          :string
#

class Establishment < ApplicationRecord
	has_attached_file :logo, 
					  :path => ':rails_root/public/system/:class/:attachment/:id/:style_:filename',
					  :url => "/system/:class/:attachment/:id/:style_:filename",
					  :styles => { small: "64x64", medium: "100x100", large: "200x200" },
					  :default_url => "/assets/missing.png"
					  # :default_url => "path to default image"
	validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/
	before_save :set_establishment_type

	# belongs_to :register_book
	has_many :vouchers, :dependent => :destroy
	has_many :visits
	has_many :failed_redemptions
	has_many :details
	has_many :books, through: :details
	has_many :register_books, through: :books
	# belongs_to :book
	belongs_to :establishment_type
	has_many :visits
	has_many :failed_redemptions
	has_many :pictures, :dependent => :destroy

	# including elastic search
		# include Elasticsearch::Model
	    # include Elasticsearch::Model::Callbacks
    searchkick #using searchkick gem instead

    # SearchKick 
	def search_data
	  { 
	  	name: name,
	  	type: type,
	    location: location,
	    area: area,
	    phone: phone

	  }
	end

	
	def type
		return self.establishment_type
	end

	def set_establishment_type
		if establishment_type_id.blank?
			self.establishment_type_id = set_default_type
		end
	end

	def pic_urls

		if Rails.env == "development" 
			root_url = "http://localhost:3000"
		else
			root_url = "http://159.89.103.53"
		end

		urls = []
		self.pictures.each do |pic|
			urls << root_url + pic.image.url(:medium)
			# pic.image.url(:medium)
		end	
		return urls	
	end

	# setting the featured image
	# Sjould be random in future. delete this when I acheive it.
	def featured_image
		self.pic_urls.first
	end

	# Incase there are not types in the database and a type has not been set 
	# by the user.

	# all establishments that don't hve types will be assigned a type
	def self.assign_type_to_missing_types
		type = self.set_default_type
		Establishment.where(establishment_type_id: nil).each do |est|
			est.update_attributes(establishment_type_id: "#{type}")
		end	
	end

	def self.hotels
		hotels =  Establishment.where(establishment_type_id: 2)

		return hotels
	end

	def self.restaurants
		 restaurants = Establishment.where(establishment_type_id: 1)

		 return restaurants
	end

	def self.spas_and_salons
		 spas_and_salons = Establishment.where(establishment_type_id: 3)

		 return spas_and_salons
	end

	def self.get_vouchers establishments

		vouchers_collection = []
		establishments.each do |est|
			est.vouchers.each do |voucher|
				vouchers_collection << voucher
			end
		end
		return vouchers_collection
	end

	def pin
		arry_pin    = []
		
		aplphabet  	= ('a'..'z').to_a
		values 		= (1..26).to_a

		hash 		= Hash[*aplphabet.zip(values).flatten]

		# get the first word in the name of the establishment in lowercase
		est_name 	    = self.name.split[0].downcase

		# if the establishment doesn't have a second name, the first name will be the second name
		est_name_last 	=  self.name.split[1].present? ?  self.name.split[1].downcase : est_name

		# itterate through each letter of the first word in the name and get the value for it
		est_name.split('').each do |letter|
			arry_pin << hash[letter]
		end
		# do the same for the second name
		est_name_last.split('').each do |letter|
			arry_pin << hash[letter]
		end


		# join that array to get the pin string of the first 5 letters. Note that the resulting string may contain more than 5 chars.
		pin  = arry_pin[0..4].join

		# Make it a 5 number pin if it's too long.
		if pin.size > 5
			pin = pin[0..4]
		end
		# make it a 5 letter pin
		return pin
	end

protected

	def self.set_default_type
		type = EstablishmentType.find_or_create_by({name: "Restaurant"}).id
		return type
	end

	def set_default_type
		type = EstablishmentType.find_or_create_by({name: "Restaurant"}).id
		return type
	end
end
