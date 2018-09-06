class CreateFavourites < ActiveRecord::Migration[5.1]
  def change
    create_table :favourites, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :voucher_id

      t.timestamps
    end
  end
end
