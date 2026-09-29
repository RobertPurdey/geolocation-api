require 'net/http'
require 'json'

module GeolocationServices
  module Providers
    class IpstackProvider
      BASE_URL = 'https://api.ipstack.com'

      def initialize(access_key: ENV.fetch('IPSTACK_ACCESS_KEY'))
        @access_key = access_key
      end

      def call(target)
        response = request(target)

        raise IpStackProviderError, "IPstack request failed with with #{response.code}" unless response.code.to_i == 200

        data = JSON.parse(response.body)

        {
          ip: data['ip'],
          country: data['country_name'],
          region: data['region_name'],
          city: data['city'],
          latitude: data['latitude'],
          longitude: data['longitude']
        }
      end

      private

      def request(target)
        uri = URI("#{BASE_URL}/#{target}")
        uri.query = URI.encode_www_form(access_key: @access_key)

        Net::HTTP.get_response(uri)
      end

      class IpStackProviderError < StandardError
      end
    end
  end
end
