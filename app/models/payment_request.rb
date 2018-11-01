# == Schema Information
#
# Table name: payment_requests
#
#  id                  :uuid             not null, primary key
#  MerchantRequestID   :string
#  CheckoutRequestID   :string
#  ResponseCode        :string
#  ResponseDescription :string
#  CustomerMessage     :string
#  user_id             :uuid
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class PaymentRequest < ApplicationRecord

	belongs_to :user
	has_one :payment_response
	has_one :failed_payment_response
end
