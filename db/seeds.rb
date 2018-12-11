# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#   
#   ROles seeds
# ['customer', 'corporate', 'moderator', 'admin'].each do |role|
# 	if Role.find_by_name("role").present?
# 		puts "ROLE EXISTS #{role}----------Skipping"
# 	else
#  		Role.find_or_create_by({name: role})
#  	end
# end

#create an Admin book for free voucher redemption. no User owns this book
Book.where(code: "DISCOUCHERFREEBOOK").first_or_create do |book|
	book.year = "2030"
	book.save

	#build registerbook
	book.build_register_book do |reg|
		reg.first_name    = "Dennis"
		reg.last_name     = "Orina"
		reg.book_code     = book.code
		reg.email         = "dennorina@gmail.com"
		reg.phone_number  = "0711430817"
		reg.user_id       = Admin.where(email: "dennorina@gmail.com").first.id
		reg.book_id       = book.id

		reg.save
	end
end

###############################################################################################################
######################                                         ################################################
######################  INSERT BOOK DETAILS INTO THE DATABASE  ################################################
######################                                         ################################################
###############################################################################################################
###############################################################################################################

# csv_text = File.read(Rails.root.join('lib', 'seeds', 'bookcodes.csv'))
# # display the wall of text
# # puts csv_text  
# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
# csv.each do |row|
#   #  Put s the hash to be save
#   # puts row.to_hash
  
#   # check if the book exists
#   if Book.find_by(code: "#{row['code']}", year: "#{Time.now.year}")
#   	puts "BOOK EXISTS code #{row['code']}----------Skipping"
#   else
# 	  # Create a new Obeject 
# 	  book = Book.find_or_create_by( code: "#{row['code']}", year: "#{Time.now.year}" )
# 	  # Save the obeject
# 	  if book
# 	  	puts "#{book.code}, #{book.year} saved"
# 	  else
# 	  	puts "#{book.code}, #{book.year} ERR:: Failed to Save! "
# 		puts "\n"
# 		puts "****Error****"
# 		puts "#{book.errors.messages}"
# 	  end
#   end
# end 


###############################################################################################################
##########################                                                  ###################################
##########################  INSERT ESTABLISHMENT DEATILS INTO THE DATABASE  ###################################
##########################                                                  ###################################
###############################################################################################################
###############################################################################################################


# est_csv_text 	= File.read(Rails.root.join('lib', 'seeds', 'establishmentdetails.csv'))
# est_csv 		= CSV.parse(est_csv_text, :headers => true, :encoding => 'ISO-8859-1')

# est_csv.each do |row|
# 	puts row.to_hash
	
# 	# add establishment type. create it if it does not exist
# 	name 				= row['Establishment']
# 	type 				= row['Type']
# 	area 				= row['Area']
# 	location 			= row['Location']
# 	address 			= row['Address']
# 	phone 				= row['Phone']
# 	description 		= row['Description']
# 	working_hours 		= row['Opening hours']
# 	email 				= row['Email']
# 	website 			= row['Website']
# 	social_media 		= row['Social media']

# 	# puts "#{name} => [ #{type}]"

# 	establishment_type_id = EstablishmentType.where({name: "#{type}" }).first_or_create.id



# 	# check if the establishment is present
# 	est = Establishment.where( name: "#{name}", location: "#{location}")
# 	if est.present?
# 		count = est.count
# 		# if more thatn one loop through and update details
# 		if count > 1
# 			puts "\n"
# 			puts "00000Found #{count} establishments, looping ... ! "
# 			est.each do |establishment|
# 				establishment.establishment_type_id = establishment_type_id
# 				establishment.area 					= area
# 				establishment.phone 				= phone
# 				establishment.description 			= description
# 				establishment.working_hours 		= working_hours
# 				establishment.email 				= email
# 				establishment.website				= website
# 				establishment.social_media			= social_media
# 				establishment.address 				= address
# 				establishment.save!
# 				# puts "#{est.attributes } SAVED! "
# 				puts "\n"
# 			end

# 		else
# 			puts "\n"
# 			puts "AAAAFound 1 establishments... ! "
# 			puts "\n"
# 			est = est.first
# 			est.establishment_type_id 	= establishment_type_id
# 			est.phone 					= phone
# 			est.area 					= area
# 			est.description 			= description
# 			est.working_hours 			= working_hours
# 			est.email 					= email
# 			est.website					= website
# 			est.social_media			= social_media
# 			est.address 				= address
# 			est.save!
# 			# puts "#{est.attributes } SAVED!"
# 			puts "\n"
# 		end
# 		# if not update
# 		# puts "ESTALISHMENT EXISTS: #{name}----------Skipping"
# 	else 
# 		puts "Creating  new establishment... ! "
# 		est = Establishment.new

# 		est.name 					= name
# 		est.location 				= location
# 		est.establishment_type_id 	= establishment_type_id
# 		est.area 					= area
# 		est.description 			= description
# 		est.working_hours 			= working_hours
# 		est.email 					= email
# 		est.website					= website
# 		est.social_media			= social_media
# 		est.address 		 		= address
# 		est.phone 					= phone
# 		# puts "#{est.attributes} "
# 		est.save!
# 	end
# 	puts "\n"
# end



###############################################################################################################
##############################                                                     ############################
##############################  CREATE VOUCHERS AND ADD TO RELATED ESTABLISHMENTS  ############################
##############################                                                     ############################
###############################################################################################################
###############################################################################################################



# vouchers_csv_text 		= File.read(Rails.root.join('lib', 'seeds', 'vouchers.csv'))
# vouchers_csv 			= CSV.parse(vouchers_csv_text, :headers => true, :encoding => 'ISO-8859-1')

# vouchers_csv.each do |row|
# 	# puts row.to_hash

# 	establishment 	= row['Establishment']
# 	location 		= row['Location']
# 	voucher_code 	= row['Voucher code']
# 	description 	= row['description']
# 	condition 		= row['Condition']


# 	est = Establishment.find_by(name: "#{establishment}", location: "#{location}")

# 	if est
# 		puts "\n"
# 		puts "Establishment Found,  #{est.name}"
# 		puts "Voucher code => #{voucher_code} "
# 		puts "Details => #{description}, COND => #{condition}"
# 		puts "\n"

		
# 		if Voucher.find_by_code("#{voucher_code}").present?
# 			puts "VOUCER EXISTS code #{voucher_code}----------Skipping"
# 		else
# 			voucher = est.vouchers.where( code: "#{voucher_code}").first_or_create do |vouch|

# 				vouch.description 	= description
# 				vouch.condition 	= condition
# 				vouch.year 			= Time.now.year
# 				vouch.save
# 			end
# 		end
# 	else
# 		puts "\n"
# 		puts "Establishment NOT FOUND,  #{establishment}"
# 		# puts "DESC => #{description}, COND => #{condition}"
# 		puts "code => #{voucher_code} "
# 		puts "\n"

# 	end
# end



###############################################################################################################
##########################                                                     ################################
##########################  CREATE TAGS FOR VOUCHERS THAT ARE IN THE DATABASE  ################################
##########################                                                     ################################
###############################################################################################################
###############################################################################################################


# tags_csv_text = File.read(Rails.root.join('lib', 'seeds', 'missingtags.csv'))
# tags_csv = CSV.parse(tags_csv_text, :headers => true, :encoding => 'ISO-8859-1')

# tags_csv.each do |row|
# 	# puts row.to_hash
	
# 	# add establishment type. create it if it does not exist
# 	voucher_code = row['Voucher code']
# 	tags = row['Tags']
# 	# get indivitual tag names
# 	tag_names = tags.split(',')
# 	tag_names = tag_names.reject { |e| e.to_s.blank?}

# 	# make everything lower case
# 	tag_names.map(&:downcase!)
# 	tag_names.map(&:strip!)
# 	# remove spaces from tag names
# 	# tag_names.each do |tag|
# 	# 	tag.gsub!(/[[:space:]]/, '')
# 	# end

# 	# puts "#{voucher_code} => TAGS::  #{tag_names}"

# 	# find the voucher  by code
# 	voucher_for_tag = Voucher.find_by(code: "#{voucher_code}")

# 	if voucher_for_tag
# 		puts "Voucher Found #{voucher_for_tag.code}"

# 		tag_names.size.times do |tag_index|

# 			tag = Tag.find_by(name: "#{tag_names[tag_index]}")

# 			if tag.present?
# 				# check if voucher is associated with the tag
# 				if voucher_for_tag.tags.where(name: "#{tag_names[tag_index]}").first.present?
# 					puts "SKIPPING:: Voucher Tag Found #{voucher_for_tag.code} <===> #{tag_names[tag_index]}"
# 				else
# 					puts "TAGGING:: #{voucher_for_tag.code} <===> #{tag.name}"
# 					# associate voucher with tag
# 					voucher_for_tag.tags << tag
					
# 				end
# 			else
# 				puts "ADDING NEW TAG:: #{voucher_for_tag.code} <===> #{tag_names[tag_index]}"
# 				# create a new tag & associate it with the voucher
# 				tag = Tag.create!(name: "#{tag_names[tag_index]}")
# 				voucher_for_tag.tags << tag
# 			end
# 		end
# 	else
# 		puts "\n"
# 		puts "Voucher NOT Found #{voucher_code}"
# 	end

# end


# 
###############################################################################################################
###############################                          ######################################################
############################### Uploading Images to tags ######################################################
###############################                          ######################################################
###############################################################################################################
###############################################################################################################
#


# change DIr to the seed images Directory


# Dir.chdir(Rails.root.join("app/assets/images/seed"))

# #collect all the images



# @images = Dir.glob("*.jpg")

# @images.each do |img|


# 	image = img
# 	image_name = img.split('.')
# 	image_name = image_name[0]
# 	first_word = image_name.split[0]
# 	last_word = image_name.split[1]
# 	third_word = image_name.split[3]

# 	array = []
# 	array << first_word << last_word << third_word

# 	array.reject! { |e| e.to_s.empty?}

	
# 	tag = Tag.where('lower(name) = ?', image_name.downcase)

# 	if tag.present?
# 		file = File.open(image)
# 		if tag.count > 1
# 			puts "Found #{tag.count} tags"
# 			tag.each do |tg|
				
# 				unless tg.tagpics.where(image_file_name: "#{File.basename(file)}").present?
# 					puts "No similar image found on tag..."
					
# 					puts "Uploading: #{File.basename(file)} to tag: #{tg.name}"
# 					# tg.tagpics.create(image: file)
# 				end
# 				puts "Image already Present..."
				
# 			end
# 		else
# 			puts "Found a Tag"

# 			unless tag.first.tagpics.where(image_file_name: "#{File.basename(file)}").present?
# 				puts "No similar image found on tag..."
				
# 				puts "Uploading: #{File.basename(file)} to tag: #{tag.name}"
# 				# tag.first.tagpics.create(image: file)
# 			end
# 		end
# 	else
# 		puts "Tag not found with name ::: #{tag.name}"
# 	end


	####array names

	## array.each do |name|
	## 	tag = Tag.where('lower(name) = ?', name.downcase)
#
	## 	if tag.present?
	## 		file = File.open(image)
	## 		if tag.count > 1
	## 			puts "Found #{tag.count} tags"
	## 			tag.each do |tg|
	#				
	## 				unless tg.tagpics.where(image_file_name: "#{File.basename(file)}").present?
	## 					puts "No similar image found on tag..."
	#					
	## 					puts "Uploading: #{File.basename(file)} to tag: #{tg.name}"
	## 					# tg.tagpics.create(image: file)
	## 				end
	#				
	## 			end
	## 		else
	## 			puts "Found a Tag"
#
	## 			unless tag.first.tagpics.where(image_file_name: "#{File.basename(file)}").present?
	## 				puts "No similar image found on tag..."
	#				
	## 				puts "Uploading: #{File.basename(file)} to tag: #{name}"
	## 				# tag.first.tagpics.create(image: file)
	## 			end
	## 		end
	## 	else
	## 		puts "Tag not found with name ::: #{name}"
	## 	end
	## end


# end
