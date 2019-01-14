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

class Favourite < ApplicationRecord
	belongs_to :user
	belongs_to :voucher
	validates_uniqueness_of :voucher_id, :scope => :user_id # ensure a book doesn't have double establishments
end
