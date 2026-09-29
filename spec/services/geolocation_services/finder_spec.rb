# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GeolocationServices::Finder do
  describe '#call' do
    let(:provider) { instance_double(GeolocationServices::Providers::IpstackProvider) }
    let(:finder) { described_class.new(provider) }

    before do
      allow(provider).to receive(:call)
    end

    it 'delegates the call to the provider' do
      finder.call('208.80.152.2')

      expect(provider).to have_received(:call).with('208.80.152.2')
    end
  end
end
