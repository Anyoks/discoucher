# == Schema Information
#
# Table name: books
#
#  id         :uuid             not null, primary key
#  code       :string
#  year       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  registered :boolean          default(FALSE), not null
#

require 'test_helper'

class BookTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
