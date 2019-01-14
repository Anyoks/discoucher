class AddIndexToUserId < ActiveRecord::Migration[5.1]
  def change

    add_index :favourites, :user_id
    add_index :favourites, :voucher_id
  end
end
