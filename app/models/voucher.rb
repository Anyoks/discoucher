# == Schema Information
#
# Table name: vouchers
#
#  id               :uuid             not null, primary key
#  code             :string
#  description      :text
#  condition        :text
#  year             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  establishment_id :uuid
#  redeem_status    :boolean          default(FALSE)
#

class Voucher < ApplicationRecord
	belongs_to :establishment
	has_many :visits, dependent: :destroy
	has_many :favourites, dependent: :destroy
	has_and_belongs_to_many :tags

	# including elastic search
	# include Elasticsearch::Model
 #  	include Elasticsearch::Model::Callbacks
  	searchkick #using searchkick gem instead

  	scope :search_import, -> { includes(:establishment) }
  	scope :search_import, -> { includes(:tags) }

  	# SearchKick 
	def search_data
	  { code: code,
	  	description: description,
	    condition: condition,
	    establishment: establishment.name,
	    tags_name: tags.map(&:name)
	  }
	end

	def self.dup
		v = []
		c = []
		Voucher.all.each do |vouch|

			if vouch.tags.count > 0
				vouch.tags.each do |tag|
					if tag.name != tag.name.downcase

						small_case_tag  = Tag.where(name: "#{tag.name.downcase}")
						if small_case_tag.present?
						# vouch.tags.delete(Tag.find(tag.id))
							if !vouch.tags.where(id: small_case_tag.first.id).first.present?
								vouch.tags << small_case_tag.first
								# puts "yes"
								# vouch.tags.delete(Tag.find(tag.id))
								# v << small_case_tag.first.name
							end
							vouch.tags.delete(Tag.find(tag.id))
							# c << vouch.tags.count
						end
					end
					
				end
			end
		end

		return v, c
	end

	# Check if the voucher is redeemed or not and return true or false
	def redeemed reg_book
		count = check_user_visits_for_voucher reg_book

		if count > 0
			return true
		else
			return false
		end
		
	end

	def check_user_visits_for_voucher(reg_book)
		user = reg_book.user
		# user = User.find("#{user_id}")
		voucher = self

		if user.is_admin?
			return 0
		else
			return user.visits.where( register_book_id: reg_book.id, voucher_id: voucher.id).count
		end
	end

	# Manually redeen a voucher if you have a code.
	def manually_redeem  voucher_code
		# find the voucher
		voucher = Voucher.where(code: voucher_code).first

		# Does that voucher actually exist and is it redeemed already? if yes and no, 
		# redeem it
		if voucher.present? && voucher.redeem_status == false

			# redeem it.
			if voucher.redeem
				"successfully redeemed"
				return true
			else
				return false
			end
		else
			"The voucher does not exist or has already been used"
			return false
		end
	end

	# Voucher redemption process
	def redeem book
		this_book = book
		# first check if the book is registered if so start voucher redemption process
		result_array = self.check_if_book_is_registered this_book.code

		if result_array[0] != false

			#get user details from registred book
			user_id = result_array[0].id
			register_book_id = result_array[1]
			establishment_id = self.establishment.id
			voucher_id = self.id
			# byebug
			#Check visit count for user in this establishement
			count = check_user_visits_in_this_establishment(user_id, voucher_id, register_book_id)
			#create a visit if the count is less than 2

			#this is a bit deficient because the mobile app has to send the bookcode each time. with the user id this
			#should know how many visits a user needs to make.
			if count < 1
				visit_params = make_visit_params(user_id,register_book_id,establishment_id,voucher_id)
				@visit = Visit.new(visit_params)
				if @visit.save!

					logger.debug "Voucher has been successfully redeemed"
					return true
				else
					logger.debug "Error:: something went wrong Creating a new visit"
					return false, "Error, Processing Request code: x00oERRZX5Y"
				end
				#if the visits are more than 2 then the redemption is invalid
			else
				logger.debug "Voucher You cannot redeem more than two vouchers from one book in one establishment"
				#create a failed redemption for user, establishment.
				# byebug
				failed_redemptions = FailedRedemption.new(user_id: "#{user_id}", establishment_id: "#{establishment_id}")
				failed_redemptions.save
				return false, "Voucher code invalid, it has been used multiple times. Kindly try again."
			end
		else
			logger.debug "This Book is not registered"
			# Create failed Reg
			return false, result_array[1]
		end
	end

	# Voucher redemption process VERSION 2
	def redeem_without_book uid
		#uid == email
		user = User.find_by_email("#{uid}")
		#get user details from registred book
		if user.present?
			user_id = user.id
			register_book_ids = user.get_reg_book_ids
			establishment_id = self.establishment.id
			voucher_id = self.id
			# byebug
			#Check visit count for user in this establishement
			count = check_user_visits_in_this_establishment(user_id, voucher_id, register_book_ids)
			
			#check number of times the user is allowed to vist an est (redeem a voucher) based on the books bought
			allowed_visits = user.allowed_visits
			# byebug
			# replace the number 1 with allowed visits
			# note that even users with 0 allowed visits will not be allowed to redeem. They'll get a multiple
			# redemption error.
			if  count < allowed_visits #count < 1
				visit_params = make_visit_params(user_id,register_book_ids,establishment_id,voucher_id)
				@visit = Visit.new(visit_params)
				if @visit.save!

					logger.debug "Voucher has been successfully redeemed"
					return true
				else
					logger.debug "Error:: something went wrong Creating a new visit"
					return false, "Error, Processing Request code: x00oERRZX5Y"
				end
				#if the visits are more than 2 then the redemption is invalid
			else
				logger.debug "Voucher You cannot redeem more than two vouchers from one book in one establishment"
				#create a failed redemption for user, establishment.
				# byebug
				failed_redemptions = FailedRedemption.new(user_id: "#{user_id}", establishment_id: "#{establishment_id}")
				failed_redemptions.save
				return false, "Voucher code invalid, it has been used multiple times. Kindly try again."
			end
		else
			logger.debug "User not found"
			return "No such user"
		end
		
	end

	# attempt manual redemption from an already existing sms
	def redeem_from_sms sms_object
		
	end

	# check if the book is registered.Only books that exist are registered.

	def check_if_book_is_registered book_code
		code = book_code
		registered_book = Book.find_by_code(code).registered?
		# registered_book = self.establishment.register_books.where(book_code: "#{code}").first
		if registered_book.present?
			# establishment.register_books.where(book_code: "#{r.book_code}").first
			logger.debug "This Book is registered"
			
			# return a user and registered book id.
			 registered_book_id = registered_book.id
			 user = registered_book.user
			return user, registered_book_id	
			
		else
			logger.debug "Error :: This Book/Card is  Not registered"
			return false, "Book/Card code not valid, kindly try again."
		end		
	end

	def unredeem
		self.update_attributes(redeem_status: false)
	end

	#register_book_ids is an array  of ids, or an empty array.
	def check_user_visits_in_this_establishment(user_id, voucher_id,register_book_ids)
		user = User.find("#{user_id}")
		voucher = voucher_id

		if user.is_admin?
			return 0
		else
			# deal withe the array.
			# RegisterBook.where(id: [2, 3, 5]) works!
			if register_book_ids.size > 0
				logger.debug "User has paid for at least 1 book"
				return user.visits.where( register_book_id: register_book_ids, voucher_id:"#{voucher_id}").count
			else
				logger.debug "User does not own any book Applying free voucher."
				# get the free book here.
				# see if the user has used the free book before.
				free = RegisterBook.free_book.id
				# byebug
				return user.visits.where( register_book_id: free).count
			end
		end
	end

	private

	# Redeem the voucher by passing the sms object so that the details can be extracted
	def est_voucher_redemption book 
		# first find the book
		
		# book = Book.where(code:"#{self.book_code}").first

		# if book.present?
			# find the voucher
			voucher = book.vouchers.where(code: self.voucher_code).first
			
			if voucher.present?
				
				# pass in the book object, we'll need it because voucher are not unique. they appear in every book
				result = voucher.redeem book
				# byebug
				if result.class != Array
					logger.debug "Successful redemption"
					return true, "This voucher is valid, allow discount."
				else 
					logger.debug "The voucher has already been used"
					# we should have a better error message for this.
					return false, result[1]
				end
			else
				logger.debug "Error:: voucher does not exist for book #{book.code}"
				# add to failed redemption process db (belongs to voucher)
				return false, "Voucher code invalid, kindly try again."
			end	
		# else
			# logger.debug "Book does not exist"
			# return false, "Book/Card code not valid, kindly try again. "
		# end
	end


	def make_visit_params user_id,register_book_ids,establishment_id,voucher_id

		# check if registerbook && voucher_id combination exists, then try anoter 
		# register_book_id && voucher_id combination changing the register_book_id
		# because this combination must be unique. 
		data = []

		if register_book_ids.size > 0
			register_book_ids.each do |register_book_id|
				if Visit.where(register_book_id: register_book_id, voucher_id: voucher_id ).present?
					logger.debug "This Voucher has been used before"
					next
				else
					data << user_id << register_book_id << establishment_id << voucher_id
					break
				end
			end
		else
			# Then this must be a user redeeming their free voucher, give them the free registered book
			register_book_id = RegisterBook.free_book.id
			data << user_id << register_book_id << establishment_id << voucher_id
		end
		
		
		name = ["user_id","register_book_id","establishment_id","voucher_id"] 
		hash = Hash[*name.zip(data).flatten]
		return hash
	end


end
# find the registreed book
# check that the book has not exp
# check if the vouvher exists
# checkif the couvher status is not true
# redeem the voucher by setting the stattus to true
