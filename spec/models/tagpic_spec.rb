# == Schema Information
#
# Table name: tagpics
#
#  id                 :uuid             not null, primary key
#  tag_id             :uuid
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe Tagpic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
