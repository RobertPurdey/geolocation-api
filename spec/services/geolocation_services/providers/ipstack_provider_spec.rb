# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GeolocationServices::Providers::IpstackProvider do
  describe '#call' do
    let(:provider) { described_class.new(access_key: 'test-key') }

    context 'when IPstack returns a successful response' do
      let(:response) do
        instance_double(
          Net::HTTPResponse,
          code: '200',
          body: {
            ip: '208.80.152.2',
            country_name: 'Canada',
            region_name: 'British Columbia',
            city: 'Vancouver',
            latitude: 49.28,
            longitude: -123.12
          }.to_json
        )
      end

      before do
        allow(Net::HTTP).to receive(:get_response).and_return(response)
      end

      it 'returns the geolocation data' do
        expect(provider.call('208.80.152.2')).to eq(
          ip: '208.80.152.2',
          country: 'Canada',
          region: 'British Columbia',
          city: 'Vancouver',
          latitude: 49.28,
          longitude: -123.12
        )
      end
    end

    context 'when IPstack returns an unsuccessful response' do
      let(:response) do
        instance_double(Net::HTTPResponse, code: '500')
      end

      before do
        allow(Net::HTTP).to receive(:get_response).and_return(response)
      end

      it 'raises an error' do
        expect { provider.call('208.80.152.2') }
          .to raise_error(described_class::IpStackProviderError, 'IPstack request failed with 500')
      end
    end
  end
end
