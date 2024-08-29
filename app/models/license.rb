class License < ApplicationRecord
	belongs_to :user
	validates_uniqueness_of :user_id, :message=>" already has a license in the system. Please email us at certification@thinmanager.com, to explain needed chaanges, extension or renewal."
	validates :license_type, presence: true 
	validates :activation_type, presence: true




def self.to_csv
  attributes = %w{activation_type license_type approved created_at enddate}

  CSV.generate(headers: true) do |csv|
    csv << ["First Name"] + ["Last Name"] + ["Email"] + ["Company"] + attributes

    all.each do |license|
		csv << ([license.user.firstname] + [license.user.lastname] + [license.user.email] + [license.user.company]) + license.attributes.values_at(*attributes)
    end
  end
end



filterrific(
   default_filter_params: { license_sorted: 'created_at_desc' },
   available_filters: [
     :license_sorted,
     :license_search,
     :with_type,
     :with_approved,
     :with_exp,
   ],
 )


scope :license_search, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e + '%').gsub(/%+/, '%')
    }

    num_or_conds = 8
    where(
      terms.map { |term|
        "(
        LOWER(licenses.license_type) LIKE ?
        OR LOWER(licenses.activation_type) LIKE ? 
        OR LOWER(licenses.note) LIKE ?
        OR LOWER(users.firstname) LIKE ? 
        OR LOWER(users.lastname) LIKE ? 
        OR LOWER(licenses.serial_number) LIKE ?
        OR LOWER(licenses.product_license) LIKE ?
        OR LOWER(users.company) LIKE ?
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
      ).joins(:user).references(:user)
} 




scope :with_type, ->(type) {
    if type == 'TMA'
        where('activation_type == ?', 'TMA')
    elsif type == 'FTA'
        where('activation_type == ?', 'FTA')
    else
        where.not("activation_type == ?", nil)
    end
} 


scope :with_approved, ->(status) {
    if status == 'Approved'
        where(approved: true)
    elsif status == 'Requested'
        where.not(approved: true)
    else
        where.not("licenses.approved == ?", nil)
    end
}          


scope :with_exp, ->(date_ref) {
    if date_ref == 'Active'
        where("licenses.enddate >= ?", Date.today)
    elsif date_ref == 'Expired'
        where("licenses.enddate < ?", Date.today)
    else
        where.not("licenses.enddate == ?", nil)
    end
} 




scope :license_sorted, ->(sort_option) {
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^created_at_/
    order("licenses.created_at #{direction}")
   when /^updated_at_/
    order("licenses.updated_at #{direction}")
  else
    raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
  end
}

# This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_license_sorted
    [
      ["Newest - Oldest", "created_at_desc"],
      ["Oldest - Newest", "created_at_asc"],
    ]
  end



end