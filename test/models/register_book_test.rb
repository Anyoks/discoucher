# == Schema Information
#
# Table name: register_books
#
#  id           :uuid             not null, primary key
#  first_name   :string
#  last_name    :string
#  phone_number :string
#  email        :string
#  book_code    :string
#  book_id      :uuid
#  user_id      :uuid
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class RegisterBookTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
