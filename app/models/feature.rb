class Feature < ActiveRecord::Base
  has_many :features_firmwarebuilds
  has_many :firmwarebuilds, through: :features_firmwarebuilds
  has_many :features_tmversions
  has_many :tmversions, through: :features_tmversions
  validates :name, presence: true, length: { minimum:3, maximum: 100 }




filterrific(
   default_filter_params: { sort_this_feature: 'name_asc' },
   available_filters: [
     :sort_this_feature,
     :with_search_feature,
     :with_tmversion,
     :with_firmwarebuild,
   ],
 )



scope :with_search_feature, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e + '%').gsub(/%+/, '%')
    }

    num_or_conds = 4
    where(
      terms.map { |term|
        "(
        LOWER(features.name) LIKE ?
        OR LOWER(features.description) LIKE ?  
        OR LOWER(tmversions.version) LIKE ?
        OR LOWER(firmwarebuilds.build) LIKE ? 
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    ).includes(:tmversions).references(:tmversions)
    .includes(:firmwarebuilds).references(:firmwarebuilds)
} 


scope :sort_this_feature, ->(sort_option) {
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^name_/
    #order("events.live asc").
    order("features.name #{direction}")
  when /^created_at_/
    order("features.tmversions #{direction}")
  else
    raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
  end
}


scope :with_tmversion, ->(tmversion_ids) {
  joins(features_tmversions: :tmversion).where(features_tmversions: {tmversion_id: tmversion_ids})
}

scope :with_firmwarebuild, ->(firmwarebuild_ids) {
  joins(features_firmwarebuilds: :firmwarebuild).where(features_firmwarebuilds: {firmwarebuild_id: firmwarebuild_ids})
}

# This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sort_this_feature
    [
      ["Name (asc)", "name_asc"],
      ["name (desc)", "name_desc"],
    ]
  end

end