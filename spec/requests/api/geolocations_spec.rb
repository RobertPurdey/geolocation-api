require 'rails_helper'

RSpec.describe "Geolocations API", type: :request do
  describe "Create a geolocation" do
    context "when the target is provided" do
      it "creates a geolocation based on the target" do
        post api_geolocations_path, params: { target: "208.80.152.2"}
        
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Geolocation created based on the target: 208.80.152.2")
      end
    end

    context "when the target is omitted" do
      it "returns a bad request error" do
        post api_geolocations_path

        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end