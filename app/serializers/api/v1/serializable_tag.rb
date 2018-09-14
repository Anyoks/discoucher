class  Api::V1::SerializableTag < JSONAPI::Serializable::Resource
  type :tags

  attribute :name
  
  attribute :image do
    @object.featured_image.present? ? @object.featured_image : ActionController::Base.helpers.asset_path('discoucher_small.jpg')
  end

  attribute :search_freq do
    0
  end
end