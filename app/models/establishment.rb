# == Schema Information
#
# Table name: establishments
#
#  id                :uuid             not null, primary key
#  name              :string
#  type              :string
#  location          :string
#  phone             :string
#  address           :string
#  logo_file_name    :string
#  logo_content_type :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  book_id           :uuid
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
	has_many :vouchers, :dependent => :destroy
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
			root_url = "http://46.101.137.125"
		end

		urls = []
		self.pictures.each do |pic|
			urls << root_url + pic.image.url(:medium)
			# pic.image.url(:medium)
		end	
		return urls	
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
