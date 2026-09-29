module GeolocationServices
  class Finder
    def initialize(provider)
      @provider = provider
    end

    delegate :call, to: :@provider
  end
end
