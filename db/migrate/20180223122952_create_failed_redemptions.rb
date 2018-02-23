class CreateFailedRedemptions < ActiveRecord::Migration[5.1]
  def change
    create_table :failed_redemptions, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :establishment_id

      t.timestamps
    end
    add_index :failed_redemptions, :user_id
    add_index :failed_redemptions, :establishment_id
  end
end
