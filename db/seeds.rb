# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
geolocation_seed_data = [
  # Google — 8.8.8.8
  {
    ip: '8.8.8.8',
    country: 'United States',
    region: 'California',
    city: 'Orinda',
    latitude: 37.86330032348633,
    longitude: -122.19094848632813
  },

  # Cisco / OpenDNS — 208.67.222.222
  {
    ip: '208.67.222.222',
    country: 'United States',
    region: 'California',
    city: 'San Jose',
    latitude: 37.330528259277344,
    longitude: -121.83822631835938
  },

  # Quad9 — 2620:fe::fe
  {
    ip: '2620:fe::fe',
    country: 'United States',
    region: 'California',
    city: 'Berkeley',
    latitude: 37.879859924316406,
    longitude: -122.2647705078125
  },

  # Cloudflare — 2606:4700:4700::1111
  {
    ip: '2606:4700:4700::1111',
    country: 'United States',
    region: 'California',
    city: 'San Francisco',
    latitude: 37.775001525878906,
    longitude: -122.41832733154297
  },

  # GitHub — https://github.com → 140.82.113.4
  {
    ip: '140.82.113.4',
    country: 'United States',
    region: 'California',
    city: 'San Francisco',
    latitude: 37.775001525878906,
    longitude: -122.41832733154297
  },

  # Microsoft — microsoft.com → 150.171.110.145
  {
    ip: '150.171.110.145',
    country: 'United States',
    region: 'New York',
    city: 'New York',
    latitude: 40.7589111328125,
    longitude: -73.97901916503906
  }
]

geolocation_seed_data.each do |data|
  Geolocation.find_or_create_by!(ip: data[:ip]) do |geolocation|
    geolocation.assign_attributes(data)
  end
end