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

			if @sms.save
				return true
			else
				return false
			end 
		end

	end


	def sms_params data
		name = ["book_code", "voucher_code", "message"] 
		hash = Hash[*name.zip(data).flatten]
		return hash
	end
end
