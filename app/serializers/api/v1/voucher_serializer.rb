class  Api::V1::VoucherSerializer 
  include FastJsonapi::ObjectSerializer
  # type :vouchers

  attribute :code
  attribute :description
  attribute :condition
  # attribute :establishment, serializer: Api::V1::EstablishmentSerializer 
  # belongs_to :establishment 

  attribute :books do |object|
    Api::V1::EstablishmentSerializer.new(object.establishment).serialized_json
  end

  
  
  
  private
   def book
       EstablishmentSerializer.new(object.establishments).attributes
   end
  
  # type of est, Rest, spas, hotels
end