# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Geolocations API', type: :request do
  def auth_headers
    { 'Authorization' => "Bearer #{ENV.fetch('API_KEY')}" }
  end

  shared_examples 'an invalid target' do
    it 'returns a bad request' do
      request

      expect(response).to have_http_status(:bad_request)

      json = response.parsed_body
      expect(json['error']).to eq('Target must be a valid IP address or URL')
    end
  end

  describe 'Authentication' do
    let(:invalid_headers) do
      { 'Authorization' => 'Bearer invalid-key' }
    end

    it 'rejects create requests with an invalid API key' do
      post api_geolocations_path,
           params: { target: '208.80.152.2' },
           headers: invalid_headers

      expect(response).to have_http_status(:unauthorized)
    end

    it 'rejects show requests with an invalid API key' do
      get api_geolocations_path,
          params: { target: '208.80.152.2' },
          headers: invalid_headers

      expect(response).to have_http_status(:unauthorized)
    end

    it 'rejects destroy requests with an invalid API key' do
      delete api_geolocations_path,
             params: { target: '208.80.152.2' },
             headers: invalid_headers

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'Create a geolocation' do
    let(:finder) { instance_double(GeolocationServices::Finder) }

    before do
      allow(GeolocationServices::Finder).to receive(:new).and_return(finder)
    end

    context 'when the target is provided' do
      let(:geolocation) do
        {
          'ip' => '208.80.152.2',
          'country' => 'Canada',
          'region' => 'British Columbia',
          'city' => 'Vancouver',
          'latitude' => 49.28,
          'longitude' => -123.12
        }
      end

      before do
        allow(finder).to receive(:call).with('208.80.152.2').and_return(geolocation)
      end

      it 'creates a geolocation based on the target' do
        post api_geolocations_path, params: { target: '208.80.152.2' }, headers: auth_headers

        expect(response).to have_http_status(:created)

        json = response.parsed_body
        expect(json).to include(geolocation)
      end
    end

    context 'when the target is a URL' do
      let(:geolocation) do
        {
          'ip' => '142.250.72.196',
          'country' => 'United States',
          'region' => 'California',
          'city' => 'Mountain View',
          'latitude' => 37.4056,
          'longitude' => -122.0775
        }
      end

      before do
        allow(Resolv).to receive(:getaddress).with('www.google.com').and_return('142.250.72.196')
        allow(finder).to receive(:call).with('142.250.72.196').and_return(geolocation)
      end

      it 'creates a geolocation based on the URL' do
        post api_geolocations_path, params: { target: 'https://www.google.com' }, headers: auth_headers

        expect(response).to have_http_status(:created)

        json = response.parsed_body
        expect(json).to include(geolocation)
      end
    end

    context 'when the target is omitted' do
      it 'returns a bad request error' do
        post api_geolocations_path, headers: auth_headers

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when the geolocation already exists' do
      before do
        Geolocation.create!(
          ip: '208.80.152.2',
          country: 'Canada',
          region: 'British Columbia',
          city: 'Vancouver',
          latitude: 49.28,
          longitude: -123.12
        )
        allow(finder).to receive(:call)
      end

      it 'returns a conflict error' do
        post api_geolocations_path, params: { target: '208.80.152.2' }, headers: auth_headers

        expect(response).to have_http_status(:conflict)

        json = response.parsed_body
        expect(json['error']).to eq(
          'Geolocation with the ip: 208.80.152.2 already exists'
        )
      end

      it 'ignores calling the finder' do
        post api_geolocations_path, params: { target: '208.80.152.2' }, headers: auth_headers

        expect(finder).not_to have_received(:call)
      end
    end

    context 'when the target is an invalid IP address' do
      let(:request) do
        post api_geolocations_path, params: { target: '208.80.152.999' }, headers: auth_headers
      end

      include_examples 'an invalid target'
    end

    context 'when the target is an invalid URL' do
      let(:request) do
        post api_geolocations_path, params: { target: 'https://[' }, headers: auth_headers
      end

      include_examples 'an invalid target'
    end
  end

  describe 'Show a geolocation' do
    context 'when the geolocation exists' do
      let(:geolocation) do
        {
          'ip' => '208.80.152.2',
          'country' => 'Canada',
          'region' => 'British Columbia',
          'city' => 'Vancouver',
          'latitude' => 49.28,
          'longitude' => -123.12
        }
      end

      let!(:geolocation_record) do
        Geolocation.create!(geolocation)
      end

      context 'when the target is an IP address' do
        it 'returns the geolocation' do
          get api_geolocations_path, params: { target: '208.80.152.2' }, headers: auth_headers

          expect(response).to have_http_status(:ok)

          json = response.parsed_body
          expect(json).to include(geolocation)
        end
      end

      context 'when the target is a URL' do
        before do
          allow(Resolv).to receive(:getaddress).with('www.google.com').and_return('208.80.152.2')
        end

        it 'returns the geolocation' do
          get api_geolocations_path, params: { target: 'https://www.google.com' }, headers: auth_headers

          expect(response).to have_http_status(:ok)

          json = response.parsed_body
          expect(json).to include(geolocation)
        end
      end
    end

    context 'when the geolocation is missing' do
      it 'returns not found' do
        get api_geolocations_path, params: { target: '208.80.152.2' }, headers: auth_headers

        expect(response).to have_http_status(:not_found)

        json = response.parsed_body
        expect(json['error']).to eq(
          'Geolocation with the ip: 208.80.152.2 was not found'
        )
      end
    end

    context 'when the target is an invalid IP address' do
      let(:request) do
        get api_geolocations_path, params: { target: '208.80.152.999' }, headers: auth_headers
      end

      include_examples 'an invalid target'
    end

    context 'when the target is an invalid URL' do
      let(:request) do
        get api_geolocations_path, params: { target: 'https://[' }, headers: auth_headers
      end

      include_examples 'an invalid target'
    end
  end

  describe 'Destroy a geolocation' do
    context 'when the geolocation exists' do
      let!(:geolocation) do
        Geolocation.create!(
          ip: '208.80.152.2',
          country: 'Canada',
          region: 'British Columbia',
          city: 'Vancouver',
          latitude: 49.28,
          longitude: -123.12
        )
      end

      it 'destroys the geolocation' do
        delete api_geolocations_path, params: { target: '208.80.152.2' }, headers: auth_headers
        expect(response).to have_http_status(:no_content)

        delete api_geolocations_path, params: { target: '208.80.152.2' }, headers: auth_headers
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the geolocation is missing' do
      it 'returns not found' do
        delete api_geolocations_path, params: { target: '208.80.152.2' }, headers: auth_headers

        expect(response).to have_http_status(:not_found)

        json = response.parsed_body
        expect(json['error']).to eq(
          'Geolocation with the ip: 208.80.152.2 was not found'
        )
      end
    end

    context 'when the target is an invalid IP address' do
      let(:request) do
        delete api_geolocations_path, params: { target: '208.80.152.999' }, headers: auth_headers
      end

      include_examples 'an invalid target'
    end

    context 'when the target is an invalid URL' do
      let(:request) do
        delete api_geolocations_path, params: { target: 'https://[' }, headers: auth_headers
      end

      include_examples 'an invalid target'
    end
  end
end
