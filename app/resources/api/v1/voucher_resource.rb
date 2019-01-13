class  Api::V1::VoucherResource < JSONAPI::Resource
    attributes :code, :description, :condition, :redeemed
    # belongs_to :establishment

    attribute :establishment 
    

      def establishment
       
        est = Api::V1::EstablishmentResource.new(@model.establishment,{})
        JSONAPI::ResourceSerializer.new(Api::V1::EstablishmentResource).serialize_to_hash(est)
      end

      def redeemed
          if context[:user] == nil
            false
          else
            context[:user].voucher_redeemed @model.id
          end   
      end

      def custom_links(options)
        {self: nil}
      end
  end