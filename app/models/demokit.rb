class Demokit < ActiveRecord::Base
  validates_uniqueness_of :serial_number
  belongs_to :user, optional: true


def self.to_csv
  
  attributes = %w{serial_number user_id user.firstname user.lastname user.email user.company reason region tmversion esxiversion status change_date notes created_at}

  # CSV.generate(headers: true, write_nil_value: nil, write_empty_value: "") do |csv|
  #   csv << attributes

  #   all.each do |kit|
  #     csv << attributes.map{ |attr| kit.send(attr) }
  #   end

  # end

  CSV.generate(write_headers: true, write_nil_value: nil, headers: attributes) do |csv|
    method_chains = attributes.map { |a| a.split('.') }

    find_each do |user|
      csv << method_chains.map do |chain| 
        chain.reduce(user) { |obj, method_name| obj = obj.try(method_name.to_sym) }
      end
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

    num_or_conds = 18
    where(
      terms.map { |term|
        "(
        LOWER(CAST(demokits.serial_number AS VARCHAR)) LIKE ?
        OR LOWER(users.company) LIKE ?  
        OR LOWER(demokits.status) LIKE ? 
        OR LOWER(demokits.reason) LIKE ? 
        OR LOWER(demokits.region) LIKE ? 
        OR LOWER(demokits.tmversion) LIKE ?
        OR LOWER(demokits.esxiversion) LIKE ?
        OR LOWER(demokits.notes) LIKE ?
        OR LOWER(users.firstname) LIKE ?
        OR LOWER(users.lastname) LIKE ?
        OR LOWER(users.firstname || ' ' || users.lastname) LIKE ?
        OR LOWER(users.email) LIKE ?
        OR LOWER(users.city) LIKE ?
        OR LOWER(users.state) LIKE ?
        OR LOWER(users.street) LIKE ?
        OR LOWER(users.street2) LIKE ?
        OR LOWER(CAST(users.zip AS VARCHAR)) LIKE ?
        OR LOWER(users.cell) LIKE ?
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    ).includes(:user).references(:users)
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