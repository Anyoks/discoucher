class CreateRegisterBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :register_books, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.string :book_code

      t.uuid :book_id
      t.uuid :user_id

      t.timestamps
    end
    add_index :register_books, :book_id, unique: true
    add_index :register_books, :user_id
  end
end
