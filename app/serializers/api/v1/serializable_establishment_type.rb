class  Api::V1::SerializableEstablishmentType < JSONAPI::Serializable::Resource
  type :establishment_type
  
   
  attribute :category do
      @object.name
  end
  attribute :description
  attribute :available
 
end