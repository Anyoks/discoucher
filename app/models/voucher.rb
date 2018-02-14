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
#

class Voucher < ApplicationRecord
	belongs_to :establishment

	def redeemed?
		if self.redeem_status == true
			"Voucher redeemed!!"
			return true
		else
			"Voucher NOT redeemed"
			return false
		end
		
	end

	def manually_redeem  voucher_code
		voucher = Voucher.where(code: voucher_code).first

		if voucher.present? && voucher.redeem_status == false
			voucher.redeem
			"successfully redeemed"
			# return true
		else
			"The voucher does not exist or has already been used"
			# return false
		end
	end

	def redeem
		# first check if the book is registered
		if self.check_if_book_is_registered
			# check if it's aready redeemed
			
			if self.redeem_status == false
			# change redeemed status
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

	def redeem_from_sms sms_object
		
	end

	# check if the book is registered.Only books that exist are registered.

	def check_if_book_is_registered
		if self.establishment.book.registered?.present?
			"This Book is registered"
			# return true
		else
			return false
		end		
	end
end
# find the registreed book
# check that the book has not exp
# check if the vouvher exists
# checkif the couvher status is not true
# redeem the voucher by setting the stattus to true