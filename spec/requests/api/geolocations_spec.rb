require 'rails_helper'

RSpec.describe "Geolocations API", type: :request do
  describe "Create a geolocation" do
    context "when the target is provided" do
      let(:geolocation) do
        {
          "ip" => "208.80.152.2",
          "country" => "Canada",
          "region" => "British Columbia",
          "city" => "Vancouver",
          "latitude" => 49.28,
          "longitude" => -123.12 }
      end 
      
      let(:finder) { instance_double(GeolocationServices::Finder) }
        
      before do
        allow(GeolocationServices::Finder).to receive(:new).and_return(finder)
        allow(finder).to receive(:call).with("208.80.152.2").and_return(geolocation)
      end

      it "creates a geolocation based on the target" do
        post api_geolocations_path, params: { target: "208.80.152.2"}
        
        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json).to include(geolocation)
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