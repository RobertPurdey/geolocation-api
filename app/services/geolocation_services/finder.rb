module GeolocationServices
  class Finder
    def initialize(provider)
      @provider = provider
    end

    def call(target)
      @provider.call(target)
    end
  end
end

