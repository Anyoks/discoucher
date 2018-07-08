class AddAttachmentImageToPictures < ActiveRecord::Migration[5.1]
  def change
    change_table :pictures do |t|
      t.attachment :image
    end
  end
end
