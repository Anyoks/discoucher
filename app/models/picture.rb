class Picture < ApplicationRecord
  belongs_to :establishment

  has_attached_file :image,
     :path => ":rails_root/public/images/:id/:filename",
     :url  => "/images/:id/:filename",
     :styles => { small: "64x64", medium: "100x100", large: "200x200" }

   do_not_validate_attachment_file_type :image
end
