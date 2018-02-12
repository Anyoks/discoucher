# == Schema Information
#
# Table name: vouchers
#
#  id               :uuid             not null, primary key
#  code             :string
#  description      :text
#  condition        :text
#  year             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  establishment_id :uuid
#

class Voucher < ApplicationRecord
	belongs_to :establishment
end
