class Sms < ApplicationRecord


	def extract text
		text_message = text
		raw_data = text.split('*')
		raw_data.reject!{ |c| c.empty?}

		if text_message.empty? ||  raw_data.size !=2
			return false
		else
			# process the ext and extract relevant data
			
			book_code = raw_data[0].squish
			# ge the voucher code
			voucher_code = raw_data[1].split('#')
			# voucher_code = voucher_code[0]
			
			# save the data in am array
			params_arr = []
			params_arr << book_code << voucher_code[0].squish << text_message

			# Prepare parameters to save to Database
			save_params = sms_params params_arr
			

			@sms = Sms.new(save_params)

			# IF the message is saved, the params are fine, if not there was an error with the 
			# Message parametes. Most likely with the structure (*xxxx*yyyyy#)
			if @sms.save
				# try to redeem the voucher
				redeem_from_sms = sms_voucher_redemption @sms

				#if redemption is successful retuen true, If not the voucher has been used
				if redeem_from_sms
					"Successful sms voucher redemption"
					return true
				else
					"The voucher has already been used"
					return false
				end
			else
				"Error with Message parameters"
				return false
			end 
		end

	end


	# Redeem the voucher by passing the sms object so that the details can be extracted
	def sms_voucher_redemption object
		sms = object
		# find the voucher
		voucher = Voucher.where(code: object.voucher_code).first

		if voucher.present?
			# byebug
			if voucher.redeem
				"Successful redemption"
				return true
			else 
				"The voucher has already been used"
				return false
			end
		else
			"Failed sms redemption Process, voucher does not exist"
			# add to failed redemption process db (belongs to voucher)
			return false
		end
		
	end

	# FOrm the sms parameters
	def sms_params data
		name = ["book_code", "voucher_code", "message"] 
		hash = Hash[*name.zip(data).flatten]
		return hash
	end
end
