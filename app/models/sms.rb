# == Schema Information
#
# Table name: sms
#
#  id           :uuid             not null, primary key
#  message      :string
#  voucher_code :string
#  book_code    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :boolean
#  phone_number :string
#

class Sms < ApplicationRecord


# Extract relevant info from the message and save it. This method also catches errors in the SMS
	def process_text
		# remove any spaces and new line characters from the message
		text_message = self.message.gsub(/[[:space:]]/, '')
		# set up variables to use 
		# update model with the new message
		# 
		# self.message = text_message

		phone_number = self.phone_number

		

		if check_regex_text text_message #self.check_regex
		# split at the star and discard empty string
			raw_data = text_message.split('*')

			raw_data.reject!{ |c| c.empty?}

			# Catch any errors in the message early.
			if text_message.empty? &&  raw_data.size !=2
				# log the erronous message
				failed_message = FailedMessage.new(:message => "#{self.message}", :phone_number => "#{phone_number}")
				failed_message.save
				logger.debug "this message #{self.message} does not match regex "

				return false, "Error with the Text message format"
				# byebug
			else
				# process the ext and extract relevant data
				
				book_code = raw_data[0].squish
				# ge the voucher code
				voucher_code = raw_data[1].split('#')
				# voucher_code = voucher_code[0]
				
				# save the data in am array
				params_arr = []
				params_arr << book_code << voucher_code[0].squish << self.message << phone_number

				# Prepare parameters to save to Database
				save_params = sms_params params_arr

				# save the sms at this point
				@sms = Sms.new(save_params)
				@sms.save
				return @sms
			end

		else
			failed_message = FailedMessage.new(:message => "#{text_message}", :phone_number => "#{phone_number}")
			failed_message.save
			return false, "Error with the Text message format"
		end
	end

	def check_regex 
		regex = /[*]\S+[*]\S+[#]/
		# remove white spaces and new lines from the message
		# text_message = text_message.gsub(/[[:space:]]/, '') 
		if regex.match(self.message).nil? 
			logger.debug "this message #{self.message} does not match regex "
			return false 
		else
			logger.debug "This message #{self.message} matches"
			return true
		end
	end
	
	def check_regex_text text
		regex = /[*]\S+[*]\S+[#]/
		# remove white spaces and new lines from the message
		text_message = text
		if regex.match(text_message).nil? 
			logger.debug "this message #{self.message} does not match regex "
			return false 
		else
			logger.debug "This message #{self.message} matches"
			return true
		end
	end
	

	def attempt_redeem
		redeem_from_sms = self.sms_voucher_redemption

		if redeem_from_sms[0] == true
			self.update_attributes(status: true)
			logger.debug "Success:: #{redeem_from_sms[1]}"
			return true, redeem_from_sms[1]
		else
			self.update_attributes(status: false)
			logger.debug "Error redeeming code:: #{redeem_from_sms[1]}"
			return false, redeem_from_sms[1]
		end
	end

protected
	# Redeem the voucher by passing the sms object so that the details can be extracted
	def sms_voucher_redemption 
		# first find the book
		
		book = Book.where(code:"#{self.book_code}").first

		if book.present?
			# find the voucher
			voucher = book.vouchers.where(code: self.voucher_code).first
			
			if voucher.present?
				
				result = voucher.redeem
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
				logger.debug "Error:: voucher does not exist for book #{book.code}"
				# add to failed redemption process db (belongs to voucher)
				return false, "Voucher code invalid, kindly try again."
			end	
		else
			logger.debug "Book does not exist"
			return false, "Book/Card code not valid, kindly try again. "
		end
	end

	# FOrm the sms parameters
	def sms_params data
		name = ["book_code", "voucher_code", "message", "phone_number"] 
		hash = Hash[*name.zip(data).flatten]
		return hash
	end
end
