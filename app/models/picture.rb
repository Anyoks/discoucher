# == Schema Information
#
# Table name: pictures
#
#  id                 :uuid             not null, primary key
#  description        :string
#  image              :string
#  establishment_id   :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Picture < ApplicationRecord
  

  has_attached_file :image,
     :path => ":rails_root/public/images/:id/:style_:filename",
     :url  => "/images/:id/:style_:filename",
     :styles => { thumb: "200x200", small: "600x600", medium: "800x800", large: "1000x1000" }

   do_not_validate_attachment_file_type :image

   belongs_to :establishment
end
