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
	has_many :visits
	has_many :favourites
	has_and_belongs_to_many :tags

	# including elastic search
	# include Elasticsearch::Model
 #  	include Elasticsearch::Model::Callbacks
  	searchkick #using searchkick gem instead

  	scope :search_import, -> { includes(:establishment) }

  	# SearchKick 
	def search_data
	  { code: code,
	  	description: description,
	    condition: condition,
	    establishment: establishment.name,
	  }
	end

	# Check if the voucher is redeemed or not and return true or false
	def redeemed?
		if self.redeem_status == true
			"Voucher redeemed!!"
			return true
		else
			"Voucher NOT redeemed"
			return false
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
			count = check_user_visits_in_this_establishment(user_id, voucher_id)
			#create a visit if the count is less than 2
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

	# attempt manual redemption from an already existing sms
	def redeem_from_sms sms_object
		
	end

	# check if the book is registered.Only books that exist are registered.

	def check_if_book_is_registered book_code
		code = book_code
		registered_book = self.establishment.register_books.where(book_code: "#{code}").first
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

	def check_user_visits_in_this_establishment user_id, voucher_id
		user = User.find("#{user_id}")
		voucher = voucher_id

		if user.is_admin?
			return 0
		else
			return user.visits.where(voucher_id:"#{voucher_id}").count
		end
	end

	def make_visit_params user_id,register_book_id,establishment_id,voucher_id
		data = []
		data << user_id << register_book_id << establishment_id << voucher_id
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
