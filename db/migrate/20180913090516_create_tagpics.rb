class CreateTagpics < ActiveRecord::Migration[5.1]
  def change
    create_table :tagpics, id: :uuid do |t|
      t.uuid :tag_id, index: true
      t.attachment :image
      t.timestamps
    end
  end
end
