require 'rails_helper'

RSpec.describe "Admin::TagsVouchers", type: :request do
  describe "GET /admin_tags_vouchers" do
    it "works! (now write some real specs)" do
      get admin_tags_vouchers_path
      expect(response).to have_http_status(200)
    end
  end
end
