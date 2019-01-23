class Review < ApplicationRecord
    validates_uniqueness_of :voucher_id, :scope => :user_id
    belongs_to :user
    belongs_to :voucher
end
