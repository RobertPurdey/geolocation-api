require 'rails_helper'

RSpec.describe "Geolocations API", type: :request do
  describe "Create a geolocation" do
    let(:finder) { instance_double(GeolocationServices::Finder) }

    before do
      allow(GeolocationServices::Finder).to receive(:new).and_return(finder)
    end

    context "when the target is provided" do
      let(:geolocation) do
        {
          "ip" => "208.80.152.2",
          "country" => "Canada",
          "region" => "British Columbia",
          "city" => "Vancouver",
          "latitude" => 49.28,
          "longitude" => -123.12
        }
      end 

      before do
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

    context "when the geolocation already exists" do
      before do
        Geolocation.create!(
          ip: "208.80.152.2",
          country: "Canada",
          region: "British Columbia",
          city: "Vancouver",
          latitude: 49.28,
          longitude: -123.12
        )
        allow(finder).to receive(:call)
      end
    
      it "returns a conflict error" do
        post api_geolocations_path, params: { target: "208.80.152.2" }
    
        expect(response).to have_http_status(:conflict)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq(
          "Geolocation with the ip: 208.80.152.2 already exists"
        )
      end
    
      it "ignores calling the finder" do
        post api_geolocations_path, params: { target: "208.80.152.2" }
    
        expect(finder).not_to have_received(:call)
      end
    end
  end

  describe "Show a geolocation" do
    context "when the geolocation exists" do
      let!(:geolocation) do
        Geolocation.create!(
          ip: "208.80.152.2",
          country: "Canada",
          region: "British Columbia",
          city: "Vancouver",
          latitude: 49.28,
          longitude: -123.12
        )
      end

      it "returns the geolocation" do
        get api_geolocation_path("208.80.152.2")

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json).to include(
          "ip" => "208.80.152.2",
          "country" => "Canada",
          "region" => "British Columbia",
          "city" => "Vancouver",
          "latitude" => 49.28,
          "longitude" => -123.12
        )
      end
    end

    context "when the geolocation is missing" do
      it "returns not found" do
        get api_geolocation_path("208.80.152.2")

        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq(
          "Geolocation with the ip: 208.80.152.2 was not found"
        )
      end
    end
  end

  describe "Destroy a geolocation" do
    context "when the geolocation exists" do
      let!(:geolocation) do
        Geolocation.create!(
          ip: "208.80.152.2",
          country: "Canada",
          region: "British Columbia",
          city: "Vancouver",
          latitude: 49.28,
          longitude: -123.12
        )
      end

      it "destroys the geolocation" do
        delete api_geolocation_path("208.80.152.2")
        expect(response).to have_http_status(:no_content)

        delete api_geolocation_path("208.80.152.2")
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the geolocation is missing" do
      it "returns not found" do
        delete api_geolocation_path("208.80.152.2")

        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq(
          "Geolocation with the ip: 208.80.152.2 was not found"
        )
      end
    end
  end
end