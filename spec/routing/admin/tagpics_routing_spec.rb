require "rails_helper"

RSpec.describe Admin::TagpicsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/tagpics").to route_to("admin/tagpics#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/tagpics/new").to route_to("admin/tagpics#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/tagpics/1").to route_to("admin/tagpics#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/tagpics/1/edit").to route_to("admin/tagpics#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/admin/tagpics").to route_to("admin/tagpics#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/tagpics/1").to route_to("admin/tagpics#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/tagpics/1").to route_to("admin/tagpics#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/tagpics/1").to route_to("admin/tagpics#destroy", :id => "1")
    end
  end
end
