class PaymentRequest < ApplicationRecord

	belongs_to :user
	has_one :payment_response
	has_one :failed_payment_response
end
