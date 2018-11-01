# == Schema Information
#
# Table name: failed_redemptions
#
#  id               :uuid             not null, primary key
#  user_id          :uuid
#  establishment_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class FailedRedemptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
