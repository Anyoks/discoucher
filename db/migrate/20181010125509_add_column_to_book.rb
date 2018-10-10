class AddColumnToBook < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :registered, :boolean, null: false, default: false
  end
end
