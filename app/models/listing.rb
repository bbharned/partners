class Listing < ActiveRecord::Base
	geocoded_by :where_is
	after_validation :geocode
  before_save :find_country_code
  belongs_to :company
  validates_uniqueness_of :user_id

  
  def where_is 
    if self.state != nil && self.state != ""
      [street, state, country].compact.join(", ")
    else
      [street, city, country].compact.join(", ")
    end
  end

  def find_country_code
    if self.country_code == nil && self.latitude != nil && self.longitude != nil
      query = Geocoder.search([self.latitude, self.longitude])
      self.country_code = query.first.country_code
      self.postal_code = query.first.postal_code
    end
  end





  private

  # def address_changed? 
  #   street_changed?||city_changed?||postal_code_changed?||state_changed?||country_changed?
  # end 


end