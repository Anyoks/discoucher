class  Api::V1::SerializableVoucher < JSONAPI::Serializable::Resource
  type :vouchers

  attribute :code
  attribute :description
  attribute :condition
  # attribute :establishment_id
  # attribute :establishment_name do
  # 	@object.establishment.name
  # end
  # attribute :est_image do
  # 	 @object.establishment.featured_image.present? ? @object.establishment.featured_image : ActionController::Base.helpers.asset_path('discoucher_small.jpg')
  # end
  
  attribute :establishment do
    Api::V1::EstablishmentSerializer.new(@object.establishment).serialized_json
  end
end