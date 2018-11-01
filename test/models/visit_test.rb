# == Schema Information
#
# Table name: visits
#
#  id               :uuid             not null, primary key
#  register_book_id :uuid
#  user_id          :uuid
#  establishment_id :uuid
#  voucher_id       :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class VisitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
