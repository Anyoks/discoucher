class CreateDetailsTable < ActiveRecord::Migration[5.1]
   def change
    create_table :details, id: :uuid do |t|

      t.uuid :book_id
      t.uuid :establishment_id
      t.timestamps
    end
    add_index :details, :book_id
    add_index :details, :establishment_id
  end
end
