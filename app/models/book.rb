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
	has_one  :register_book
	has_many :details
	has_many :establishments, through: :details
	has_many :vouchers, through: :establishments

	# including elastic search
	include Elasticsearch::Model
  	include Elasticsearch::Model::Callbacks

	def registered?
		if self.register_book
			return self.register_book
		else
			return false
		end
	end

	def self.is_registered book_code
		# check if the book is retistered aand return the registered book
		book = RegisterBook.where(book_code: "#{book_code}").first
		if book.nil?
			p "THis book is not registered"
			return false
		else
			"The book is registered"
			return book
		end
	end
end
