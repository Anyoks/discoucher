# == Schema Information
#
# Table name: failed_payment_responses
#
#  id                 :uuid             not null, primary key
#  MerchantRequestID  :string
#  CheckoutRequestID  :string
#  ResultCode         :string
#  ResultDescription  :string
#  payment_request_id :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe FailedPaymentResponse, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
