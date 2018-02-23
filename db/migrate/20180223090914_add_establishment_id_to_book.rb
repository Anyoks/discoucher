class AddEstablishmentIdToBook < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :establishment_id, :uuid
    add_index :books, :establishment_id
    remove_column :establishments, :book_id
  end
end
