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

class FailedRedemption < ApplicationRecord

	belongs_to :user
	belongs_to :establishment
end
