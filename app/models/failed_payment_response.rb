class FailedPaymentResponse < ApplicationRecord

	belongs_to :payment_request
end
