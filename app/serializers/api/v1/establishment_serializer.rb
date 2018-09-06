class  Api::V1::EstablishmentSerializer 
  include FastJsonapi::ObjectSerializer
  # type :establishments

  attribute :name
  attribute :area
  attribute :location

  # has_many :vouchers

  # attribute :est_type do
  # 	@object.type.name
  # end
  # attribute :logo do
  # 	ApplicationController.helpers.asset_url(@object.logo.url(:small))
  # end
  attribute :featured_image do |object|
    object.featured_image.present? ? @object.featured_image : ActionController::Base.helpers.asset_path('discoucher_small.jpg')
  end
  # attribute :pictures do
  #   @object.pic_urls.present? ? @object.pic_urls : [ActionController::Base.helpers.asset_path('discoucher_small.jpg')]
  # end
  # type of est, Rest, spas, hotels
end