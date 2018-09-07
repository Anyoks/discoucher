class EstablishmentType < ApplicationRecord
	has_many :establishments
	has_many :vouchers, through: :establishments
end