# == Schema Information
#
# Table name: pictures
#
#  id                 :uuid             not null, primary key
#  description        :string
#  image              :string
#  establishment_id   :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
