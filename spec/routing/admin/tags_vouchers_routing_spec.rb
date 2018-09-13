require "rails_helper"

RSpec.describe Admin::TagsVouchersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/tags_vouchers").to route_to("admin/tags_vouchers#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/tags_vouchers/new").to route_to("admin/tags_vouchers#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/tags_vouchers/1").to route_to("admin/tags_vouchers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/tags_vouchers/1/edit").to route_to("admin/tags_vouchers#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/admin/tags_vouchers").to route_to("admin/tags_vouchers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/tags_vouchers/1").to route_to("admin/tags_vouchers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/tags_vouchers/1").to route_to("admin/tags_vouchers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/tags_vouchers/1").to route_to("admin/tags_vouchers#destroy", :id => "1")
    end
  end
end
