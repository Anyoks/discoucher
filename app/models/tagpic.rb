# == Schema Information
#
# Table name: tagpics
#
#  id                 :uuid             not null, primary key
#  tag_id             :uuid
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Tagpic < ApplicationRecord

	has_attached_file :image, 
					  :path => ':rails_root/public/system/:class/:attachment/:id/:style_:filename',
					  :url => "/system/:class/:attachment/:id/:style_:filename",
					  :styles => { thumb: "200x200", small: "600x600", medium: "800x800" },
					  :default_url => "missing.png"

	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

	belongs_to :tag
end
