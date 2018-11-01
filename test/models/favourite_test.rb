# == Schema Information
#
# Table name: favourites
#
#  id         :uuid             not null, primary key
#  user_id    :uuid
#  voucher_id :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class FavouriteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
