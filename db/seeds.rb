# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#   
#   ROles seeds
['customer', 'corporate', 'moderator', 'admin'].each do |role|
  Role.find_or_create_by({name: role})
end

require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'bookcodes.csv'))
# display the wall of text
# puts csv_text  
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  #  Put s the hash to be save
  # puts row.to_hash
  # Create a new Obeject 
  book = Book.find_or_create_by( code: "#{row['code']}", year: "#{Time.now.year}" )
  # Save the obeject
  if book
  	puts "#{book.code}, #{book.year} saved"
  else
  	puts "#{book.code}, #{book.year} ERR:: Failed to Save! "
	puts "\n"
	puts "****Error****"
	puts "#{book.errors.messages}"
  end

end 


vouchers_csv_text = File.read(Rails.root.join('lib', 'seeds', 'estvouchers.csv'))
vouchers_csv = CSV.parse(vouchers_csv_text, :headers => true, :encoding => 'ISO-8859-1')
vouchers_csv.each do |row|
		# puts row.to_hash

		establishment = row['establishment']
		location = row['Location']

		voucher1 = row['Voucher1']
		voucher2 = row['Voucher2']
		voucher3 = row['Voucher3']
		description = row['offer']
		condition = row['condition']

		array = []
		array << voucher1 << voucher2 << voucher3

		save_array = array.reject { |e| e.to_s.empty?}

		est = Establishment.find_by(name: "#{establishment}", location: "#{location}")

		if est
			puts "\n"
			puts "DESC => #{description}, COND => #{condition}"
			puts "code1 => #{voucher1}, code2 => #{voucher2}, code3 => #{voucher3} "
			puts "Establishment Found,  #{est.name}"
			puts "\n"

			save_array.size.times do |indexx|
				if Voucher.find_by_code("#{save_array[indexx]}").present?
					puts "VOUCER EXISTS code #{save_array[indexx]}----------Skipping"
				else
					voucher = est.vouchers.find_or_create_by( code: "#{save_array[indexx]}", description: "#{description}", condition: "#{condition}", year: "#{Time.now.year}")
					if voucher
						puts "\n"
						puts "Voucher #{voucher.code} SAVED  for Establishment #{voucher.establishment.name}"
					else
						puts "\n"
						puts "Voucher #{voucher.code} ERR:: Failed to Save! "
						puts "****Error****"
						puts "#{voucher.errors.messages}"
					end
				end
			end	
		else
			puts "\n"
			puts "DESC => #{description}, COND => #{condition}"
			puts "code1 => #{voucher1}, code2 => #{voucher2}, code3 => #{voucher3} "
			puts "Establishment NOT FOUND,  #{establishment}"
			puts "\n"

		end
		# Establishment.first.vouchers.new

		
	end
=begin
	Seeding Establishment details from the csv file
=end
est_csv_text = File.read(Rails.root.join('lib', 'seeds', 'establishments.csv'))
est_csv = CSV.parse(est_csv_text, :headers => true, :encoding => 'ISO-8859-1')

est_csv.each do |row|
	puts row.to_hash
	
	# add establishment type. create it if it does not exist
	name = row['name']
	area = row['area']
	location = row['location']


	establishment_type_id = EstablishmentType.find_or_create_by({name: "#{row['type']}" }).id

	est = Establishment.find_or_create_by( name: "#{name}", area: "#{area}", location: "#{location}", establishment_type_id: "#{establishment_type_id}" )
	
	if est
		puts "#{est.name}, #{est.area}, #{est.location}, #{est.establishment_type.name} } SAVED! "
	else
		puts "#{est.name}, #{est.area}, #{est.location}, #{est.establishment_type.name} } ERR:: Failed to Save! "

		puts "\n"
		puts "****Error****"
		puts "#{est.errors.messages}"
	end
	puts "\n"
end