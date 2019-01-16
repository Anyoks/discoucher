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
#  provider               :string           default(""), not null
#  uid                    :string           default(""), not null
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  tokens                 :json
#

class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
		  :recoverable, :rememberable, :trackable, :validatable,
		  :omniauthable, password_length: 4..128 #,:confirmable,
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	
  
	

  belongs_to :role
  before_validation :set_default_role
  

  # reduced password length to four to accomdate users using their bank cards as book codes
  before_create :set_default_role
  has_many :register_books, dependent: :destroy

  has_many :visits, dependent: :destroy
  has_many :failed_redemptions, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :payment_requests, dependent: :destroy
  has_many :payment_responses, through: :payment_requests
  has_many :failed_payment_responses, through: :payment_requests
  has_many :vouchers, through: :register_books

  # including elastic search
	# include Elasticsearch::Model
	# include Elasticsearch::Model::Callbacks
	searchkick

	# SearchKick 
	def search_data
		{ 
			first_name: first_name,
			last_name: last_name,
			email: email,
			phone_number: phone_number,
		}
	end

		# // return whether a user has valid vouchers or not.
	def as_json(options={})
		super(options).merge({vouchers: "#{self.voucher_status}"})
	end

	# get total user vouchers
	def total_vouchers
		vouchers = 0
		self.register_books.each do |reg_book|
			vouchers +=reg_book.vouchers.count
		end

		return vouchers
	end
	
	#  does this user have vouchers to redeem?
	def voucher_status
		if self.register_books.count > 0
			if self.visits.count < self.total_vouchers
				return 'valid'
			else
				return 'depleted'
			end	
		else
			if self.visits.count > 0
				return 'none'
			else
				return 'free'
			end
		end
	end

	# checks if this voucher is redeemed by this user
	def voucher_redeemed(id)
		 if self.visits.where(voucher_id: id).present?
			return "true"
		 else
			"false"
		 end
	end

	def is_favourite_voucher(id)
		if self.favourites.where(voucher_id: id).present?
			"true"
		else
			"false"
		end
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

	def name
		return self.first_name
	end

	def vouchers

		vouchers = []
		if self.register_books.present?
			self.register_books.each do |reg|

				vouchers << reg.book.vouchers
				
			end
		else
		end

		return vouchers
	end

	#how many times a user is able to redeem one unique voucher depending on the number of books they have

	def allowed_visits #per voucher
		#registered books
		bought_books = self.register_books.count
		# one voucher == one visit : it can only be redeemed once.
		# each book has two unique vouchers that can be redeemed in one establishment.
		# allowed visits = bought_books.count
		# so a user without any bought book has 0 allowed visits.
		if self.is_admin?
			return 10000
		elsif bought_books == 0
			# None paying users are allowed only one visit.
			return 1
		else
			return bought_books
		end
	end

	def paid
		if self.register_books.count > 0
			return true
		else
			return false
		end
	end
	

	def get_favourte_vouchers
		array = []
		self.favourites.each do |favourite|
			array << favourite.voucher
		end

		return array
	end

	# get the ids for this users's registered (bought books)

	def get_reg_book_ids
		book_codes = self.get_book_codes
		reg_book_ids = []

		unless self.register_books.nil?
			book_codes.each do |code|
				reg_book_ids << RegisterBook.where(book_code: code).first.id
			end
		end

		return reg_book_ids
	end
	

	def get_book_codes

		book_codes = []
		
		unless self.register_books.nil?
			self.register_books.each do |register_book|
				book_codes << register_book.code
			end
		end
		

		return book_codes
	end

	def register_book_for_paying_mobile_user

		book 			= Book.get_unregistered_book_for_mobile_user
		# byebug
		# (:first_name, :last_name, :phone_number, :email, :book_code)
		register_book 	= RegisterBook.new(:first_name => self.first_name, :last_name => self.last_name, :phone_number => self.phone_number, :email => self.email , :book_code => book.code)
		
		reg 			= register_book.find_book_by_code
		# byebug
		return reg	
	end

	
	def est_voucher_redemption_v2 voucher
		
		# book_codes = self.get_book_codes

		# make sure this book belongs to this user.
		# if book_codes.include? book.code


			# pass in the book object, we'll need it because voucher are not unique. they appear in every book
			result = voucher.redeem_without_book self.email
			# byebug
			if result.class != Array
				logger.debug "Successful redemption"
				return true, "This voucher is valid, allow discount.", self.voucher_status
			else 
				logger.debug "The voucher has already been used"
				# we should have a better error message for this.
				return false, result[1]
			end
		# else
		# 	return false, "You don't own this book"
		# end
	end


	# this will be deprecated
	def est_voucher_redemption(book,voucher)
		
		book_codes = self.get_book_codes

		# make sure this book belongs to this user.
		if book_codes.include? book.code


			# pass in the book object, we'll need it because voucher are not unique. they appear in every book
			result = voucher.redeem book
			# byebug
			if result.class != Array
				logger.debug "Successful redemption"
				return true, "This voucher is valid, allow discount."
			else 
				logger.debug "The voucher has already been used"
				# we should have a better error message for this.
				return false, result[1]
			end
		else
			return false, "You don't own this book"
		end
	end
end

