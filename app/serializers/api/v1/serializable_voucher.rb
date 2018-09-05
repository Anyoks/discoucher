class  Api::V1::SerializableVoucher < JSONAPI::Serializable::Resource
  type :vouchers

  attribute :code
  attribute :description
  attribute :condition
  attribute :establishment do
  	@object.establishment.name
  end
  attribute :est_image do
  	 @object.establishment.featured_image.present? ? @object.establishment.featured_image : ActionController::Base.helpers.asset_path('discoucher_small.jpg')
  end
  # type of est, Rest, spas, hotels
end