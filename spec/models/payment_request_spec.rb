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

require 'rails_helper'

RSpec.describe Admin::PaymentRequest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
