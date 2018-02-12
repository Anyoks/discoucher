# == Schema Information
#
# Table name: books
#
#  id         :uuid             not null, primary key
#  code       :string
#  year       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Book < ApplicationRecord
	has_many :establishments, dependent: :destroy
	has_one  :register_book
	has_many :vouchers, through: :establishments


	def registered?
		if self.register_book
			return self.register_book
		else
			return false
		end
	end
end
