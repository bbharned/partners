class Demokit < ActiveRecord::Base
  validates_uniqueness_of :serial_number
  belongs_to :user


def self.to_csv
  attributes = %w{serial_number reason region tmversion esxiversion status firstname lastname email phone company street street2 street3 city state postal_code change_date notes created_at}

  CSV.generate(headers: true) do |csv|
    csv << attributes

    all.each do |kit|
      csv << attributes.map{ |attr| kit.send(attr) }
    end
  end
end	


filterrific(
   default_filter_params: { sort_dk: 'serial_number_asc' },
   available_filters: [
     :sort_dk,
     :with_dk_search,
   ],
 )



scope :with_dk_search, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e + '%').gsub(/%+/, '%')
    }

    num_or_conds = 19
    where(
      terms.map { |term|
        "(
        LOWER(demokits.serial_number) LIKE ?
        OR LOWER(demokits.company) LIKE ?  
        OR LOWER(demokits.status) LIKE ? 
        OR LOWER(demokits.reason) LIKE ? 
        OR LOWER(demokits.region) LIKE ? 
        OR LOWER(demokits.tmversion) LIKE ?
        OR LOWER(demokits.esxiversion) LIKE ?
        OR LOWER(demokits.firstname) LIKE ?
        OR LOWER(demokits.lastname) LIKE ?
        OR LOWER(demokits.firstname + ' ' + demokits.lastname) LIKE ?
        OR LOWER(demokits.email) LIKE ?
        OR LOWER(demokits.city) LIKE ?
        OR LOWER(demokits.state) LIKE ?
        OR LOWER(demokits.street) LIKE ?
        OR LOWER(demokits.street2) LIKE ?
        OR LOWER(demokits.street3) LIKE ?
        OR LOWER(demokits.postal_code) LIKE ?
        OR LOWER(demokits.phone) LIKE ?
        OR LOWER(demokits.notes) LIKE ?
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    )
} 


scope :sort_dk, ->(sort_option) {
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^serial_number_/
    #order("events.live asc").
    order("demokits.serial_number #{direction}")
  when /^created_at_/
    order("demokits.created_at #{direction}")
  else
    raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
  end
}	


def self.options_for_sort_dk
    [
      ["Serial Number (asc)", "serial_number_asc"],
      ["Serial Number (desc)", "serial_number_desc"],
      ["Newest - Oldest", "created_at_desc"],
      ["Oldest - Newest", "created_at_asc"],
    ]
  end


end