class  Api::V1::SerializableVoucher1 < JSONAPI::Serializable::Resource
  type :vouchers

  attribute :code
  attribute :description
  attribute :condition
  
  attribute :establishment do
    Api::V1::EstablishmentSerializer.new(@object.establishment).serializable_hash
  end
end