# == Schema Information
#
# Table name: vouchers
#
#  id          :uuid             not null, primary key
#  code        :string
#  description :text
#  condition   :text
#  year        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class VoucherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
