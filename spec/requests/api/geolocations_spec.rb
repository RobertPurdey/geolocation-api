require 'rails_helper'

RSpec.describe "Geolocations API", type: :request do
  describe "Create a geolocation" do
    it "creates a geolocation" do
      post api_geolocations_path
      
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Geolocation created")
    end
  end
end