require 'rails_helper'

RSpec.describe "Dataviews", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/dataview/show"
      expect(response).to have_http_status(:success)
    end
  end

end
