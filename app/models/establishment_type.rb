class EstablishmentType < ApplicationRecord
	has_many :establishments

	def self.options_for_select
	  EstablishmentType.all.map {|e| [e.name, e.id]}
	end
end