class Company < ActiveRecord::Base
	geocoded_by :address 
	after_validation :geocode
  before_save :find_country_code
  
  def address 
    [street, state, country].compact.join(", ") 
  end

  def address_changed? 
    street_changed?||city_changed?||postal_code_changed?||state_changed?||country_changed?
  end 

  def find_country_code
    if self.country_code == nil && self.latitude != nil && self.longitude != nil
      query = Geocoder.search([self.latitude, self.longitude])
      self.country_code = query.first.country_code
    end
  end


end