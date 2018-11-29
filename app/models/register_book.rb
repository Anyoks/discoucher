# == Schema Information
#
# Table name: register_books
#
#  id           :uuid             not null, primary key
#  first_name   :string
#  last_name    :string
#  phone_number :string
#  email        :string
#  book_code    :string
#  book_id      :uuid
#  user_id      :uuid
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class RegisterBook < ApplicationRecord
	belongs_to :book
	belongs_to :user
	has_many :vouchers, through: :book
	has_many :visits
	has_many :establishments, through: :book
	after_commit :mark_book_as_registered, on: :create
 
 # "Blessed are they that do His commandments that they may have right to the tree of life"
	
# confirm the book being registered exists and add book id to the book before saving

	def find_book_by_code 
		@book = Book.find_by_code self.book_code
		# byebug
		if @book.nil?
			logger.debug "Book does not Exist!"
			return false
		elsif RegisterBook.find_by_book_code self.book_code
			logger.debug "Book already registered"
			return false 
		else
			logger.debug "Book Registration successfully"
			regbook = create_user_for_the_book
			if regbook

				# byebug
				if self.book_id.blank?
					self.book_id = @book.id
					# self.update_attributes(book_id: @book.id)
				elsif self.user_id.blank?
					self.user_id = @user.id 

				end

				return regbook
			else
				return false
			end
		end
	end

	def code
		self.book_code
	end

	def self.make_registered_books_true

		RegisterBook.all.each do |regBook|
			regBook.book.update_attributes(registered: true)
		end
		
	end

	def vouchers
		return self.book.vouchers
	end




protected
#  " Prepare ye the way of the Lord..."
#  
# NOw lets create a user for the book, this will be used for mobile app logins in the future
	def create_user_for_the_book
		
		user = User.find_by_email self.email
		if user.nil?
			create_user
		else
			"User Exists!"
			
			# create  new register book for the user
			registeredBook = create_register_book_for_existing_user user
			logger.debug "Created a book"
			return registeredBook
		end
	end

	def create_register_book_for_existing_user existinguser
		user = existinguser
		regBook = user.register_books.new
		regBook.first_name = user.first_name
		regBook.last_name = user.last_name
		regBook.phone_number = user.phone_number
		regBook.email = user.email
		regBook.book_code = self.book_code
		regBook.book_id = @book.id

		if regBook.save!
			logger.debug "Created another Reg book for this user"
			return regBook
		else
			logger.debug "FAILED to create another Reg book for this user"
			return false
		end
	end

	def create_user
		user = User.new( first_name: "#{self.first_name}", last_name: "#{self.last_name}",
					 email: "#{self.email}", phone_number: "#{self.phone_number}",
					 password: "#{self.book_code}", password_confirmation: "#{self.book_code}", uid: "#{self.email}",
					 provider: "email")
		# byebug
		if user.save!
			# byebug
			# return true
			"User Has been crated!"
			registeredBook = create_register_book_for_existing_user user
			logger.debug "Created a book"
			return registeredBook
		else
			
			# return false
			"Error creating user"
			return false
		end
	end

	# Mark a reistered book as registered true each time a book registration is done.
	def mark_book_as_registered
		book = self.book
		book.update_attributes(registered: true)
		logger.debug "Marked book as registered"
	end
end
