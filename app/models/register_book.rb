class RegisterBook < ApplicationRecord
	belongs_to :book
	belongs_to :user
 
 # "Blessed are they that do His commandments that they may have right to the tree of life"
	
# confirm the book being registered exists and add book id to the book before saving

	def find_book_by_code 
		book = Book.find_by_code self.book_code

		if book.nil?
			"Book does not Exist!"
			return false
		elsif RegisterBook.find_by_book_code self.book_code
			"Book already registered"
			return false 
		else
			"Book Registration successfully"
			if create_user_for_the_book
				self.user_id = @user.id
				self.book_id = book.id
				return true
			else
				return false
			end
		end
	end


#  " Prepare ye the way of the Lord..."
# NOw lets create a user for the book, this will be used for mobile app logins in the future
	def create_user_for_the_book
		user = User.find_by_email self.email
		if user.nil?
			create_user
		else
			"User Exists!"
			return false
		end
	end

	def create_user
		@user = User.new( first_name: "#{self.first_name}", last_name: "#{self.last_name}",
					 email: "#{self.email}", phone_number: "#{self.phone_number}",
					 password: "#{self.book_code}", password_confirmation: "#{self.book_code}")
		if @user.save!
			# byebug
			# return true
			"User Has been crated!"
			return @user.id
		else
			
			# return false
			"Error creating user"
			return false
		end
	end
end
