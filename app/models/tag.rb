class Tag < ApplicationRecord


	has_many :tagpics
	has_and_belongs_to_many :vouchers
end
