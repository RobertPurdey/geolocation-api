module Api
  class GeolocationsController < ApplicationController
    def create
      target = geolocation_params
      render json: { message: "Geolocation created based on the target: #{target}" }
    end

    private

    def geolocation_params
      params.require(:target)
    end
  end
end