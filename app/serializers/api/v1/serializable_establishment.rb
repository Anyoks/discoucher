class  Api::V1::SerializableEstablishment < JSONAPI::Serializable::Resource
  type :establishments

  attribute :name
  attribute :area
  attribute :location
  attribute :logo do
  	@object.logo.url(:small)
  end
  # type of est, Rest, spas, hotels
end