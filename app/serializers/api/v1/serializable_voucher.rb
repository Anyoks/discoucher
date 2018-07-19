class  Api::V1::SerializableVoucher < JSONAPI::Serializable::Resource
  type :vouchers

  attribute :code
  attribute :description
  attribute :condition
  attribute :establishment do
  	@object.establishment.name
  end
  # type of est, Rest, spas, hotels
end