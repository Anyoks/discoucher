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

# csv_text = File.read(Rails.root.join('lib', 'seeds', 'bookcodes.csv'))
# # display the wall of text
# # puts csv_text  
# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
# csv.each do |row|
#   #  Put s the hash to be save
#   # puts row.to_hash
#   # Create a new Obeject 
#   book = Book.new
#   book.code = row['code']
#   book.year = Time.now.year
#   # Save the obeject
#   book.save
#   puts "#{book.code}, #{book.year} saved"
# end


vouchers_csv_text = File.read(Rails.root.join('lib', 'seeds', 'vouchers.csv'))
# display the wall of text
# puts csv_text  
# Create an establishment
Establishment.new(name: 'Default', location: 'default')
vouchers_csv = CSV.parse(vouchers_csv_text, :headers => true, :encoding => 'ISO-8859-1')
vouchers_csv.each do |row|
	Voucher.find_or_create_by(code: "#{row['code'}"]) do |v|
		# Put s the hash to be save
		# puts row.to_hash
		# Create a new Obeject 
		voucher = Voucher.new
		voucher.code = row['code']
		voucher.description = row['description']
		voucher.condition = row['condition']
		voucher.year = Time.now.year
		# Save the obeject
		# voucher.save
		# voucher.find_or_create_by(:code => "#{voucher.code}")
	end
   
  puts "#{voucher.code}, #{voucher.year} saved"
end

User.find_or_create_by(first_name: 'Scarlett') do |user|
  user.last_name = 'Johansson'
end


