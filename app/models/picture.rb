class Picture < ApplicationRecord
  

  has_attached_file :image,
     :path => ":rails_root/public/images/:id/:style_:filename",
     :url  => "/images/:id/:style_:filename",
     :styles => { thumb: "200x200", small: "600x600", medium: "800x800", large: "1000x1000" }

   do_not_validate_attachment_file_type :image

   belongs_to :establishment
end
