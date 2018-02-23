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
	def redeem
		# first check if the book is registered if so start voucher redemption process
		if self.check_if_book_is_registered

			#get user details from registred book
			#Check visit count for user in this establishement
			#create a visit if the count is less than 2
			#if the visits are more than 2 then the redemption is invalid
			#create a failed redemption for user, establishment.
			
			# check if it's aready redeemed if not redeem it
			
			if self.redeem_status == false
			# change redeemed status to make the voucher redeemed
				if self.update_attributes(redeem_status: true)
					"The voucher has been successfully redeemed"
					return true
				else
					"The voucher has not been redeemed"
					return false
				end
			else
				"This voucher has already been used"
				return false
			end
		else
			"This Book is not registered"
			return false
		end
	end

	# attempt manual redemption from an already existing sms
	def redeem_from_sms sms_object
		
	end

	# check if the book is registered.Only books that exist are registered.

	def check_if_book_is_registered

		if self.establishment.book.registered?.present?
			"This Book is registered"
			# return a user instead
			
			return true
		else
			return false
		end		
	end

	def unredeem
		self.update_attributes(redeem_status: false)
	end
end
# find the registreed book
# check that the book has not exp
# check if the vouvher exists
# checkif the couvher status is not true
# redeem the voucher by setting the stattus to true
