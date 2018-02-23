class CreateVisits < ActiveRecord::Migration[5.1]
  def change
    create_table :visits, id: :uuid do |t|

      t.uuid :register_book_id
      t.uuid :user_id
      t.uuid :establishment_id
      t.uuid :voucher_id
      t.timestamps
    end
  end
end
