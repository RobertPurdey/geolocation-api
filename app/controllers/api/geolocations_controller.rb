module Api
  class GeolocationsController < ApplicationController
    def create
      render json: { message: "Geolocation created" }
    end
  end
end