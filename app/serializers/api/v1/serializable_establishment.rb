class Api::V1::SerializableEstablishment < JSONAPI::Serializable::Resource
	type :establishments

  	attribute :name
  	attribute :location
  	attribute :logo

end
