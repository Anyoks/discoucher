class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews, id: :uuid do |t|
      t.text :comment
      t.float :rating
      t.uuid :user_id, foreign_key: true
      t.uuid :voucher_id, foreign_key: true

      t.timestamps
    end

    add_index :reviews, :user_id
    add_index :reviews, :voucher_id
  end
end
