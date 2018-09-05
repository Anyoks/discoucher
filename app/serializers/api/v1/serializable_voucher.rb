class  Api::V1::SerializableVoucher < JSONAPI::Serializable::Resource
  type :vouchers

  attribute :code
  attribute :establishment_id
  attribute :establishment_name do
    @object.establishment.name
  end
  attribute :establishment_type do
    @object.establishment.establishment_type.name
  end
  attribute :description
  attribute :condition
  
  attribute :est_image do
  	 @object.establishment.featured_image.present? ? @object.establishment.featured_image : ActionController::Base.helpers.asset_path('discoucher_small.jpg')
  end
  # type of est, Rest, spas, hotels
end