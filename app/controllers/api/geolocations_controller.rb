module Api
  class GeolocationsController < ApplicationController
    before_action :ensure_unique_geolocation, only: :create
    before_action :set_geolocation, only: [:show, :destroy]

    def create
      target = geolocation_params
      geo_data = ::GeolocationServices::Finder.new(::GeolocationServices::Providers::IpstackProvider.new).call(target)
      geolocation = ::Geolocation.create!(geo_data)

      render json: geolocation, status: :created
    end

    def show
      render json: @found_geolocation, status: :ok
    end

    def destroy
      @found_geolocation.destroy!
      head :no_content
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

    def set_geolocation
      target = geolocation_params
      @found_geolocation = ::Geolocation.find_by(ip: target)
    
      return if @found_geolocation
    
      render json: { error: "Geolocation with the ip: #{target} was not found" }, status: :not_found
    end
  end
end