require 'rails_helper'

RSpec.describe "Admin::EstablishmentTypes", type: :request do
  describe "GET /admin_establishment_types" do
    it "works! (now write some real specs)" do
      get admin_establishment_types_path
      expect(response).to have_http_status(200)
    end
  end
end
