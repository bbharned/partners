class Listing < ActiveRecord::Base
	geocoded_by :where_is
	after_validation :geocode
  before_save :find_country_code
  before_save :get_fullname
  belongs_to :company
  belongs_to :user

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

  def get_fullname
    self.fullname = self.firstname + " " + self.lastname
  end


  def self.to_csv
      attributes = %w{id active firstname lastname email user_id company_id list_type created_at}

      CSV.generate(headers: true) do |csv|
        csv << attributes

        all.each do |listing|
          csv << attributes.map{ |attr| listing.send(attr) }
        end
      end
  end


  filterrific(
   default_filter_params: { listing_sort: 'created_at_asc' },
   available_filters: [
     :listing_sort,
     :listing_search,
     :with_status,
   ],
 )


scope :listing_search, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e + '%').gsub(/%+/, '%')
    }

    num_or_conds = 21
    where(
      terms.map { |term|
        "(
        LOWER(listings.firstname) LIKE ?
        OR LOWER(listings.description) LIKE ?  
        OR LOWER(listings.lastname) LIKE ?
        OR LOWER(listings.fullname) LIKE ? 
        OR LOWER(listings.email) LIKE ? 
        OR LOWER(listings.street) LIKE ? 
        OR LOWER(listings.street2) LIKE ?
        OR LOWER(listings.city) LIKE ?
        OR LOWER(listings.state) LIKE ?
        OR LOWER(listings.keywords) LIKE ?
        OR LOWER(listings.country) LIKE ?
        OR LOWER(listings.country_code) LIKE ?
        OR LOWER(listings.postal_code) LIKE ?
        OR LOWER(listings.list_type) LIKE ?
        OR LOWER(companies.name) LIKE ?
        OR LOWER(companies.url) LIKE ?
        OR LOWER(companies.country) LIKE ?
        OR LOWER(companies.country_code) LIKE ?
        OR LOWER(companies.description) LIKE ?
        OR LOWER(users.silevel) LIKE ?
        OR LOWER(users.channel) LIKE ?
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
      ).joins(:company).references(:company)
      .joins(:user).references(:user)
} 


scope :listing_sort, ->(sort_option) {
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^lastname_/
    order("listings.lastname #{direction}")
  when /^created_at_/
    order("listings.created_at #{direction}")
  else
    raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
  end
}

scope :with_status, ->(status) {
    if status == 'Active Listings'
        Listing.joins(:user).where('certexpire >= ?', Date.today).where(active: true)
    elsif status == 'Requested Listings'
        where.not(active: true)
    elsif status == 'Expired Listings'
        Listing.joins(:user).where('certexpire < ?', Date.today)
    end
}   



  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_listing_sort
    [
      ["Last Name (A-Z)", "lastname_asc"],
      ["Last Name (Z-A)", "lastname_desc"],
      ["Newest - Oldest", "created_at_desc"],
    ]
  end


  


end