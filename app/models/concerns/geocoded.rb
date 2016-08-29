module Concerns
  module Geocoded
    def self.included(base)
      base.after_validation :execute_geocoding
    end

    private

    def execute_geocoding
      return if confirmation_ip_address.blank?
      result = Geocoder.search(confirmation_ip_address.to_s).first
      return unless result
      self.lng = result.longitude
      self.lat = result.latitude
      self.country = result.country
      self.city = result.city
    rescue
      nil
    end
  end
end
