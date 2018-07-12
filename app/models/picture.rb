class Picture < ApplicationRecord
  

  has_attached_file :image,
     :path => ":rails_root/public/images/:id/:style_:filename",
     :url  => "/images/:id/:style_:filename",
     :styles => { small: "64x64", medium: "100x100", large: "200x200" }

   do_not_validate_attachment_file_type :image

   belongs_to :establishment
end
