class  Api::V1::EstablishmentResource < JSONAPI::Resource
    attribute :name
  attribute :area
  attribute :location
  attribute :address
  attribute :phone
  attribute :email
  attribute :website
  attribute :social_media

  attribute :featured_image 
  
  def featured_image
    @model.featured_image.present? ? @model.featured_image : ActionController::Base.helpers.asset_path('discoucher_small.jpg')
  end

  def custom_links(options)
    {self: nil}
  end


end