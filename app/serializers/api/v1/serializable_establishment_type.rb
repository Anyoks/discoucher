class  Api::V1::SerializableEstablishmentType < JSONAPI::Serializable::Resource
  type :establishment_type
  # include: ['establishment']

  
  attribute :category do
      @object.name
  end

  

 
end