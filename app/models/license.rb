class License < ApplicationRecord
	belongs_to :user
	validates_uniqueness_of :user_id, :message=>" already has a license in the system. Please email us at certification@thinmanager.com, to explain needed chaanges, extension or renewal."
	validates :license_type, presence: true 
	validates :activation_type, presence: true




def self.to_csv
  attributes = %w{self.user.firstname id activation_type license_type approved created_at}

  CSV.generate(headers: true) do |csv|
    csv << attributes

    all.each do |license|
		csv << [license.user && license.user.firstname] + license.attributes.values_at(*attributes)
		#csv << license.attributes.values_at(license.id + license.activation_type + license.license_type + license.approved + license.user.firstname + license.created_at)
    end
  end
end



filterrific(
   default_filter_params: { license_sorted: 'created_at_desc' },
   available_filters: [
     :license_sorted,
     :license_search,
   ],
 )


scope :license_search, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e + '%').gsub(/%+/, '%')
    }

    num_or_conds = 4
    where(
      terms.map { |term|
        "(
        LOWER(licenses.license_type) LIKE ?
        OR LOWER(licenses.activation_type) LIKE ? 
        OR LOWER(users.firstname) LIKE ? 
        OR LOWER(users.lastname) LIKE ? 
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
      ).joins(:user).references(:user)
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