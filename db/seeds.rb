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

require 'csv'

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


# vouchers_csv_text = File.read(Rails.root.join('lib', 'seeds', 'estvouchers.csv'))
# vouchers_csv = CSV.parse(vouchers_csv_text, :headers => true, :encoding => 'ISO-8859-1')
# vouchers_csv.each do |row|
# 		# puts row.to_hash

# 		establishment = row['establishment']
# 		location = row['Location']

# 		voucher1 = row['Voucher1']
# 		voucher2 = row['Voucher2']
# 		voucher3 = row['Voucher3']
# 		description = row['offer']
# 		condition = row['condition']

# 		array = []
# 		array << voucher1 << voucher2 << voucher3

# 		save_array = array.reject { |e| e.to_s.empty?}

# 		est = Establishment.find_by(name: "#{establishment}", location: "#{location}")

# 		if est
# 			puts "\n"
# 			puts "DESC => #{description}, COND => #{condition}"
# 			puts "code1 => #{voucher1}, code2 => #{voucher2}, code3 => #{voucher3} "
# 			puts "Establishment Found,  #{est.name}"
# 			puts "\n"

# 			save_array.size.times do |indexx|
# 				if Voucher.find_by_code("#{save_array[indexx]}").present?
# 					puts "VOUCER EXISTS code #{save_array[indexx]}----------Skipping"
# 				else
# 					voucher = est.vouchers.find_or_create_by( code: "#{save_array[indexx]}", description: "#{description}", condition: "#{condition}", year: "#{Time.now.year}")
# 					if voucher
# 						puts "\n"
# 						puts "Voucher #{voucher.code} SAVED  for Establishment #{voucher.establishment.name}"
# 					else
# 						puts "\n"
# 						puts "Voucher #{voucher.code} ERR:: Failed to Save! "
# 						puts "****Error****"
# 						puts "#{voucher.errors.messages}"
# 					end
# 				end
# 			end	
# 		else
# 			puts "\n"
# 			puts "DESC => #{description}, COND => #{condition}"
# 			puts "code1 => #{voucher1}, code2 => #{voucher2}, code3 => #{voucher3} "
# 			puts "Establishment NOT FOUND,  #{establishment}"
# 			puts "\n"

# 		end
# 		# Establishment.first.vouchers.new

		
# 	end
# =begin
# 	Seeding Establishment details from the csv file
# =end
# est_csv_text = File.read(Rails.root.join('lib', 'seeds', 'establishments.csv'))
# est_csv = CSV.parse(est_csv_text, :headers => true, :encoding => 'ISO-8859-1')

# est_csv.each do |row|
# 	puts row.to_hash
	
# 	# add establishment type. create it if it does not exist
# 	name = row['name']
# 	area = row['area']
# 	location = row['location']


# 	establishment_type_id = EstablishmentType.find_or_create_by({name: "#{row['type']}" }).id



# 	# check if the establishment is present
# 	if Establishment.find_by( name: "#{name}", area: "#{area}", location: "#{location}", establishment_type_id: "#{establishment_type_id}" ).present?
# 		puts "ESTALISHMENT EXISTS code #{name}----------Skipping"
# 	else

# 		est = Establishment.find_or_create_by( name: "#{name}", area: "#{area}", location: "#{location}", establishment_type_id: "#{establishment_type_id}" )
		
# 		if est
# 			puts "#{est.name}, #{est.area}, #{est.location}, #{est.establishment_type.name} } SAVED! "
# 		else
# 			puts "#{est.name}, #{est.area}, #{est.location}, #{est.establishment_type.name} } ERR:: Failed to Save! "

# 			puts "\n"
# 			puts "****Error****"
# 			puts "#{est.errors.messages}"
# 		end
# 	end
# 	puts "\n"
# end

=begin
	Seeding Voucher tag details from the csv file
=end

tags_csv_text = File.read(Rails.root.join('lib', 'seeds', 'tagsvouchers.csv'))
tags_csv = CSV.parse(tags_csv_text, :headers => true, :encoding => 'ISO-8859-1')

tags_csv.each do |row|
	# puts row.to_hash
	
	# add establishment type. create it if it does not exist
	voucher_code = row['Voucher Code']
	tags = row['Tags']
	# get indivitual tag names
	tag_names = tags.split(',')
	tag_names = tag_names.reject { |e| e.to_s.empty?}

	# remove spaces from tag names
	tag_names.each do |tag|
		tag.gsub!(/[[:space:]]/, '')
	end

	# puts "#{voucher_code} => TAGS::  #{tag_names}"

	# find the voucher  by code
	voucher_for_tag = Voucher.find_by(code: "#{voucher_code}")

	if voucher_for_tag
		puts "Voucher Found #{voucher_for_tag.code}"

		tag_names.size.times do |tag_index|

			tag = Tag.find_by(name: "#{tag_names[tag_index]}")

			if tag.present?
				# check if voucher is associated with the tag
				if voucher_for_tag.tags.where(name: "#{tag_names[tag_index]}").first.present?
					puts "SKIPPING:: Voucher Tag Found #{voucher_for_tag.code} <===> #{tag_names[tag_index]}"
				else
					puts "TAGGING:: #{voucher_for_tag.code} <===> #{tag.name}"
					# associate voucher with tag
					voucher_for_tag.tags << tag
					
				end
			else
				puts "ADDING NEW TAG:: #{voucher_for_tag.code} <===> #{tag_names[tag_index]}"
				# create a new tag & associate it with the voucher
				tag = Tag.create!(name: "#{tag_names[tag_index]}")
				voucher_for_tag.tags << tag
			end
		end
	else
		puts "\n"
		puts "Voucher NOT Found #{voucher_code}"
	end

end