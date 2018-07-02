class CreatePictures < ActiveRecord::Migration[5.1]
  def change
    create_table :pictures, id: :uuid do |t|
      t.string :description
      t.string :image
      t.uuid :establishment_id, foreign_key: true

      t.timestamps
    end
  end
end
