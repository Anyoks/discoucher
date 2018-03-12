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
#  book_id           :uuid
#

class Establishment < ApplicationRecord
	has_attached_file :logo, 
					  :path => ':rails_root/public/system/:class/:attachment/:id/:style_:filename',
					  :url => "/system/:class/:attachment/:id/:style_:filename",
					  :styles => { small: "64x64", medium: "100x100", large: "200x200" },
					  :default_url => "/assets/missing.png"
					  # :default_url => "path to default image"
	validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

	# belongs_to :register_book
	has_many :vouchers, :dependent => :destroy
	has_many :visits
	has_many :failed_redemptions
	has_many :details
	has_many :books, through: :details
	has_many :register_books, through: :books
	# belongs_to :book
	belongs_to :establishment_type
	has_many :vouchers, :dependent => :destroy
	has_many :visits
	has_many :failed_redemptions

	def type
		return self.establishment_type
	end
end
