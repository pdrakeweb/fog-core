module Fog
  module Identity
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      unless providers.include?(provider)
        raise ArgumentError, "#{provider} has no identity service"
      end

      require "fog/#{provider}/identity"
      begin
        Fog::Identity.const_get(Fog.providers[provider])
      rescue
        Fog.const_get(Fog.providers[provider])::Identity
      end.new(attributes)
    end

    def self.providers
      Fog.services[:identity]
    end
  end
end
