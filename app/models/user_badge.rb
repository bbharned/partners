class UserBadge < ActiveRecord::Base
	belongs_to :user




filterrific(
   default_filter_params: { sort_badge: 'created_at_asc' },
   available_filters: [
     :sort_badge,
     :with_badge_search,
     :with_badge_type,
   ],
 )



 scope :with_badge_search, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e + '%').gsub(/%+/, '%')
    }

    num_or_conds = 8
    where(
      terms.map { |term|
        "(
        LOWER(users.company) LIKE ?   
        OR LOWER(users.firstname) LIKE ? 
        OR LOWER(users.lastname) LIKE ?
        OR LOWER(users.email) LIKE ? 
        OR LOWER(users.prttype) LIKE ?
        OR LOWER(users.channel) LIKE ?
        OR LOWER(users.city) LIKE ?
        OR LOWER(users.state) LIKE ?
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    ).includes(:user).references(:users)
} 



scope :sort_badge, ->(sort_option) {
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^created_at_/
    order("created_at #{direction}")
  else
    raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
  end
}



scope :with_badge_type, ->(type) {
	if type == 'Configuration'
	    where(configuration: true)
	elsif type == 'Productivity'
	    where(productivity: true)
	elsif type == 'Visualization'
	    where(visualization: true)
	elsif type == 'Security'
	    where(security: true)
	elsif type == 'Mobility'
	    where(mobility: true)
	end
} 




def self.options_for_sort_badge
    [
      ["Newest - Oldest", "created_at_desc"],
      ["Oldest - Newest", "created_at_asc"],
    ]
end



end