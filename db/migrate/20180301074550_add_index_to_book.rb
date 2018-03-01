class AddIndexToBook < ActiveRecord::Migration[5.1]
  def change
    add_index :books, :code,                unique: true
  end
end
