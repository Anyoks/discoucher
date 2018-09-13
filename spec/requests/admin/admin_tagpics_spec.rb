require 'rails_helper'

RSpec.describe "Admin::Tagpics", type: :request do
  describe "GET /admin_tagpics" do
    it "works! (now write some real specs)" do
      get admin_tagpics_path
      expect(response).to have_http_status(200)
    end
  end
end
