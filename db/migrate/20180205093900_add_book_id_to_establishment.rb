class AddBookIdToEstablishment < ActiveRecord::Migration[5.1]
  def change

  	if Book.first.present?
  		book = Book.first
  	else
  		book = Book.new(code: '1231312', year:'2018')
  	end
  	
    add_column :establishments, :book_id, :uuid, default: book.id
    add_index :establishments, :book_id
  end
end
