require "rails_helper"

RSpec.describe "Dataqueries", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/dataqueries/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/dataqueries/index"
      expect(response).to have_http_status(:success)
    end
  end
end
