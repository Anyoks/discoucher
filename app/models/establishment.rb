# == Schema Information
#
# Table name: establishments
#
#  id                :uuid             not null, primary key
#  name              :string
#  type              :string
#  location          :string
#  phone             :string
#  address           :string
#  logo_file_name    :string
#  logo_content_type :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Establishment < ApplicationRecord
	has_attached_file :logo, styles: { small: "64x64", med: "100x100", large: "200x200" }
end
