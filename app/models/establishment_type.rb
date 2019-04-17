# == Schema Information
#
# Table name: establishment_types
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#

class EstablishmentType < ApplicationRecord
	has_many :establishments,  :dependent => :destroy
	has_many :vouchers, through: :establishments

	validates_presence_of :name, :description
	before_save :down_case_name


	def activate_deactivate_est_availablity

		if self.available
			# make unavailble
			if self.description == nil
				self.update_attributes(available: false, description: '.')
				logger.debug "Establishment Type unavailable"
				return true
			else
				self.update_attributes(available: false)
				logger.debug "Establishment Type unavailable"
				return true
			end
		else
			# make available
			if self.description == nil
				self.update_attributes(available: true, description: '.')
				logger.debug "Establishment Type available"
				return true
			else
				self.update_attributes(available: true)
				logger.debug "Establishment Type available"
				return true
			end
			
		end
	end

	def self.available_types
		names = []
		EstablishmentType.where(available: true).each do  |type|
			names << type.name
		end

		return names
	end

	def self.downall
		EstablishmentType.all.each do |est|
			est.update_attributes(name: est.name.downcase)
		end
	end

	private

	def down_case_name
		self.name.downcase!
	end

	
	
end
