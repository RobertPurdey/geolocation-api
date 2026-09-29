# frozen_string_literal: true

class CreateGeolocations < ActiveRecord::Migration[8.1]
  def change
    create_table :geolocations do |t|
      t.string :ip, null: false
      t.string :country, null: false
      t.string :region, null: false
      t.string :city, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.timestamps
    end
  end
end
