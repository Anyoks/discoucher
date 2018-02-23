class Visit < ApplicationRecord
	belongs_to :user
	belongs_to :establishment
	belongs_to :register_book
	belongs_to :vouchers
end
