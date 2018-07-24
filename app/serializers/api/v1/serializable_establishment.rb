class  Api::V1::SerializableEstablishment < JSONAPI::Serializable::Resource
  type :establishments

  attribute :name
  attribute :area
  attribute :location
  attribute :est_type do
  	@object.type.name
  end
  attribute :logo do
  	ApplicationController.helpers.asset_url(@object.logo.url(:small))
  end
  attribute :featured_image do
    if @object.pic_urls.present?
      @object.pic_urls.first
    else
      ActionController::Base.helpers.asset_path('discoucher_small.jpg')
    end
  end
  attribute :pictures do
    if @object.pic_urls.present?
      @object.pic_urls.first
    else
      ActionController::Base.helpers.asset_path('discoucher_small.jpg')
    end
  end
  # type of est, Rest, spas, hotels
end