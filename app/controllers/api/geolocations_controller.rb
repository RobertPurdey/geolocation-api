module Api
  class GeolocationsController < ApplicationController
    def create
      target = geolocation_params
      geo_data = ::GeolocationServices::Finder.new(::GeolocationServices::Providers::IpstackProvider.new).call(target)
      geolocation = ::Geolocation.create!(geo_data)

      render json: geolocation, status: :created
    end

    private

    def geolocation_params
      params.require(:target)
    end
  end
end