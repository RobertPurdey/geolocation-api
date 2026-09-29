class AddUniqueIndextToGeolocationsIp < ActiveRecord::Migration[8.1]
  def change
    add_index :geolocations, :ip, unique: true
  end
end
