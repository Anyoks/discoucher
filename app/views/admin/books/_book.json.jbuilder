json.extract! book, :id, :code, :year, :created_at, :updated_at
json.url book_url(book, format: :json)
