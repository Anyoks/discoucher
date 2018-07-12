class  Api::V1::SerializableEstablishment < JSONAPI::Serializable::Resource
  type :establishments

  attribute :name
  attribute :area
  attribute :location
  attribute :est_type do
  	@object.type.name
  end
  attribute :logo do
  	@object.logo.url(:small)
  end
  attribute :featured_image do
    @object.pic_urls.first
  end
  attribute :pictures do
    @object.pic_urls
  end
  # type of est, Rest, spas, hotels
end