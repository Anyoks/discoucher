# == Schema Information
#
# Table name: establishment_types
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#

class EstablishmentType < ApplicationRecord
	has_many :establishments,  :dependent => :destroy
	has_many :vouchers, through: :establishments

	validates_presence_of :name, :description
	
end
