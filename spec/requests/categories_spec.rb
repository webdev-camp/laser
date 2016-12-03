require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /categories" do
    it "works!" do
      get categories_path
      expect(response).to have_http_status(200)
    end
  end
end
