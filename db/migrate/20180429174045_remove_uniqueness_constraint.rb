class RemoveUniquenessConstraint < ActiveRecord::Migration[5.1]
  def change
  	change_column :register_books, :email, :string, unique: false
  end
end
