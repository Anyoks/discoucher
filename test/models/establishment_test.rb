# == Schema Information
#
# Table name: establishments
#
#  id                    :uuid             not null, primary key
#  name                  :string
#  area                  :string
#  location              :string
#  phone                 :string
#  address               :string
#  logo_file_name        :string
#  logo_content_type     :string
#  logo_file_size        :integer
#  logo_updated_at       :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  book_id               :uuid
#  establishment_type_id :integer
#  description           :text
#  working_hours         :string
#  email                 :string
#  website               :string
#  social_media          :string
#

require 'test_helper'

class EstablishmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
