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

require 'rails_helper'

RSpec.describe Admin::PaymentResponse, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
