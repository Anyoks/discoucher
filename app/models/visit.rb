# == Schema Information
#
# Table name: visits
#
#  id               :uuid             not null, primary key
#  register_book_id :uuid
#  user_id          :uuid
#  establishment_id :uuid
#  voucher_id       :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Visit < ApplicationRecord
	belongs_to :user
	belongs_to :establishment
	belongs_to :register_book
	belongs_to :voucher


	def self.visited_establishments
		visited_establishments = []
		Visit.all.each do |visit|
			visited_establishments << visit.establishment_id
		end
		return visited_establishments		
	end

	def self.not_visited_establishments
		establishment_ids = Visit.visited_establishments
		return Establishment.where("id NOT IN (?)", establishment_ids).count

	end

	def self.number_of_visited_establishments
		Visit.visited_establishments.size
	end
end
