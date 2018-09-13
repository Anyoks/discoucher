class Tagpic < ApplicationRecord

	has_attached_file :image, 
					  :path => ':rails_root/public/system/:class/:attachment/:id/:style_:filename',
					  :url => "/system/:class/:attachment/:id/:style_:filename",
					  :styles => { small: "64x64", medium: "100x100", large: "200x200" },
					  :default_url => "/assets/missing.png"

	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

	belongs_to :tag
end
