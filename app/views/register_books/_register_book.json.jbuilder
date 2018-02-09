json.extract! register_book, :id, :first_name, :last_name, :phone_number, :email, :book_code, :created_at, :updated_at
json.url register_book_url(register_book, format: :json)
