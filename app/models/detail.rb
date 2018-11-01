# == Schema Information
#
# Table name: details
#
#  id               :uuid             not null, primary key
#  book_id          :uuid
#  establishment_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Detail < ApplicationRecord
	belongs_to :establishment
	belongs_to :book
end
