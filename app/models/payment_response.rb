# == Schema Information
#
# Table name: payment_responses
#
#  id                 :uuid             not null, primary key
#  MerchantRequestID  :string
#  CheckoutRequestID  :string
#  ResultCode         :string
#  ResultDescription  :string
#  Amount             :string
#  MpesaReceiptNumber :string
#  Balance            :string
#  TransactionDate    :datetime
#  PhoneNumber        :string
#  payment_request_id :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  book_code          :string           default("test"), not null
#

class PaymentResponse < ApplicationRecord

	belongs_to :payment_request
	after_commit :create_registered_book_for_payed_user, on: :create
	# after_commit :add_book_code, on: :update



	def user
		self.payment_request.user
	end


	private

	def create_registered_book_for_payed_user
		user = self.user

		if self.Amount.to_f > 0
			reg 	= user.register_book_for_paying_mobile_user

			if reg == false
				logger.debug "Error creating registered Book for user"
				return false
			else
				t = self.update_columns(book_code: reg.book_code)
				return true
			end
		else
			logger.debug "Not enough money"
			return false
		end		
	end

	def add_book_code
		self.update_attributes(book_code: reg.book_code)
	end
end
