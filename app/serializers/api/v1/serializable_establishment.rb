class SerializableEstablishments < JSONAPI::Serializable::Resource
  type :establishments

  # attribute :first_name
  # attribute :last_name
  # attribute :age
  attribute :created_at
  attribute :updated_at
end