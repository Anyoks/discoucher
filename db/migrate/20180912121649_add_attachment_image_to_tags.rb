class AddAttachmentImageToTags < ActiveRecord::Migration[5.1]
  def self.up
    change_table :tags do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :tags, :image
  end
end
