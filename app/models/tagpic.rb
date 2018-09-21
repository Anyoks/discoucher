class Tagpic < ApplicationRecord

	has_attached_file :image, 
					  :path => ':rails_root/public/system/:class/:attachment/:id/:style_:filename',
					  :url => "/system/:class/:attachment/:id/:style_:filename",
					  :styles => { thumb: "200x200", small: "600x600", medium: "800x800" },
					  :default_url => "missing.png"

	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

	belongs_to :tag
end
