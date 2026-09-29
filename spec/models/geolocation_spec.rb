require 'rails_helper'

RSpec.describe Geolocation, type: :model do
  let(:geolocation) do
    Geolocation.new(
      ip: '134.201.250.155',
      country: 'United States',
      region: 'California',
      city: 'Los Angeles',
      latitude: 34.0655,
      longitude: -118.2405
    )
  end

  describe 'validations' do
    context 'when all required fields are present' do
      it 'is valid' do
        expect(geolocation).to be_valid
      end
    end

    context 'when the ip is missing' do
      it 'is invalid' do
        geolocation.ip = nil

        expect(geolocation).not_to be_valid
      end
    end

    context 'when the country is missing' do
      it 'is invalid' do
        geolocation.country = nil

        expect(geolocation).not_to be_valid
      end
    end

    context 'when the region is missing' do
      it 'is invalid' do
        geolocation.region = nil

        expect(geolocation).not_to be_valid
      end
    end

    context 'when the city is missing' do
      it 'is invalid' do
        geolocation.city = nil

        expect(geolocation).not_to be_valid
      end
    end

    context 'when the latitude is missing' do
      it 'is invalid' do
        geolocation.latitude = nil

        expect(geolocation).not_to be_valid
      end
    end

    context 'when the longitude is missing' do
      it 'is invalid' do
        geolocation.longitude = nil

        expect(geolocation).not_to be_valid
      end
    end
  end
end
