module Api
  class GeolocationsController < ApplicationController
    before_action :ensure_unique_geolocation, only: :create

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

    def ensure_unique_geolocation
      target = geolocation_params
      return unless ::Geolocation.exists?(ip: target)
    
      render json: { error: "Geolocation with the ip: #{target} already exists" }, status: :conflict
    end
  end
end