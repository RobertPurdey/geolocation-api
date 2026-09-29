# frozen_string_literal: true

require 'ipaddr'
require 'uri'
require 'resolv'

module Api
  class GeolocationsController < ApplicationController
    INVALID_TARGET_MESSAGE = 'Target must be a valid IP address or URL'

    rescue_from InvalidTargetError, with: :handle_invalid_target

    before_action :authenticate
    before_action :ensure_unique_geolocation, only: :create
    before_action :set_geolocation, only: %i[show destroy]

    def show
      render json: @found_geolocation, status: :ok
    end

    def create
      geo_data = ::GeolocationServices::Finder.new(::GeolocationServices::Providers::IpstackProvider.new).call(target_ip)
      geolocation = ::Geolocation.create!(geo_data)

      render json: geolocation, status: :created
    end

    def destroy
      @found_geolocation.destroy!
      head :no_content
    end

    private

    def geolocation_params
      params.require(:target)
    end

    def target_ip
      target = geolocation_params

      return target if valid_ip?(target)

      uri = URI.parse(target)
      raise InvalidTargetError, INVALID_TARGET_MESSAGE unless uri.host

      Resolv.getaddress(uri.host)
    rescue URI::InvalidURIError
      raise InvalidTargetError, INVALID_TARGET_MESSAGE
    end

    def valid_ip?(target)
      IPAddr.new(target)
      true
    rescue IPAddr::InvalidAddressError
      false
    end

    def ensure_unique_geolocation
      ip = target_ip
      return unless ::Geolocation.exists?(ip: ip)

      render json: { error: "Geolocation with the ip: #{ip} already exists" }, status: :conflict
    end

    def set_geolocation
      ip = target_ip
      @found_geolocation = ::Geolocation.find_by(ip: ip)

      return if @found_geolocation

      render json: { error: "Geolocation with the ip: #{ip} was not found" }, status: :not_found
    end

    def handle_invalid_target(error)
      render json: { error: error.message }, status: :bad_request
    end
  end
end
