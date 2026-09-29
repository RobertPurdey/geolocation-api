module Api
  class GeolocationsController < ApplicationController
    def create
      target = geolocation_params
      geolocation = ::GeolocationServices::Finder.new(::GeolocationServices::Providers::IpstackProvider.new).call(target)

      render json: geolocation
    end

    private

    def geolocation_params
      params.require(:target)
    end
  end
end