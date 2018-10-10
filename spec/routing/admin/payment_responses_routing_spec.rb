require "rails_helper"

RSpec.describe Admin::PaymentResponsesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/payment_responses").to route_to("admin/payment_responses#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/payment_responses/new").to route_to("admin/payment_responses#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/payment_responses/1").to route_to("admin/payment_responses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/payment_responses/1/edit").to route_to("admin/payment_responses#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/admin/payment_responses").to route_to("admin/payment_responses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/payment_responses/1").to route_to("admin/payment_responses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/payment_responses/1").to route_to("admin/payment_responses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/payment_responses/1").to route_to("admin/payment_responses#destroy", :id => "1")
    end
  end
end
