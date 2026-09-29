# frozen_string_literal: true

class Geolocation < ApplicationRecord
  validates :ip, :country, :region, :city, :latitude, :longitude, presence: true
end
