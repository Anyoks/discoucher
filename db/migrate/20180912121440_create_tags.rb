class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags, id: :uuid do |t|
      t.string :name
      # t.uuid :voucher_id, foreign_key: true

      t.timestamps
    end
  end
end
