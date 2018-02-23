# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  first_name             :string
#  last_name              :string
#  phone_number           :string
#  role_id                :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  belongs_to :role
  before_validation :set_default_role
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  
  before_create :set_default_role
  has_many :register_books

  has_many :visits

def is_admin?
		if self.role.nil?
			false
		elsif self.role.name == "admin"
			true
		else
			false
		end
	end
# protected
	# Making all users' role to be registered as they sign up.
	def set_default_role
		self.role ||= Role.find_by_name('customer') 
	end

	def make_corporate
		self.update_attributes :role_id => 2		# self.role ||= Role.find_by_name('moderator') 
	end

	def make_admin
		self.update_attributes :role_id => 4
	end

	def make_customer
		self.update_attributes :role_id => 1
	end

	def show_admins
		User.where(:role_id => 4 )
	end

	def is_admin?
		if self.role.nil?
			false
		elsif self.role.name == "admin"
			true
		else
			false
		end
	end

	def is_customer?
		if self.role.nil?
			false
		elsif self.role.name == "customer"
			true
		else
			false
		end
	end


end

