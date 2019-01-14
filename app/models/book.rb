# == Schema Information
#
# Table name: books
#
#  id         :uuid             not null, primary key
#  code       :string
#  year       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  registered :boolean          default(FALSE), not null
#

class Book < ApplicationRecord
	has_one  :register_book
	has_many :details, dependent: :destroy
	has_many :establishments, through: :details
	has_many :vouchers, through: :establishments

	# including elastic search
	# include Elasticsearch::Model
    #  	include Elasticsearch::Model::Callbacks

  	searchkick #using searchkick gem instead

    # SearchKick 
	def search_data
	  { 
	  	code: code
	  }
	end

	def registered?
		if self.register_book
			return self.register_book
		else
			return false
		end
	end

	def registered_already?
		if self.register_book.present?
			return true
		else
			return false
		end
	end

	def book_code
		"#{self.code}"
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

	def self.get_unregistered_book_for_mobile_user
		
		book = Book.where(registered: false).first

		if book
			return book
		else
			return false
		end
		
	end

	# the ree book, owned by dennorina@gmail.com, used for the one free voucher.
	def self.free_book
		book = Book.where(code:"DISCOUCHERFREEBOOK").first
		return book
	end
	
end
