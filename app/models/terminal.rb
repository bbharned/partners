class Terminal < Termcap2
	self.table_name = "Terminals"
	belongs_to :manufacturer, class_name: 'Manufacturer', foreign_key: 'ManufacturerId'


filterrific(
   default_filter_params: { sorted_by: 'model_asc' },
   available_filters: [
     :sorted_by,
     :with_search,
     :with_manufacturer,
     :with_boot_type,
   ],
 )


scope :with_search, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e + '%').gsub(/%+/, '%')
    }

    num_or_conds = 1
    where(
      terms.map { |term|
        "(
        LOWER(terminals.Model) LIKE ? 
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    )
} 


scope :sorted_by, ->(sort_option) {
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^model_/
    order("Model #{direction}")
  when /^created_at_/
    order("terminals.created_at #{direction}")
  else
    raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
  end
}


scope :with_manufacturer, ->(manufacturerIds) {
	Terminal.where(ManufacturerId: manufacturerIds)
}

scope :with_boot_type, ->(typeIds) {
  Terminal.where(TypeId: typeIds)
}

# scope :with_venue, ->(venue_ids) {
#   joins(event_venues: :venue).where(event_venues: {venue_id: venue_ids})
# }


# # filters on 'live' attribute
# scope :with_live, lambda { |flag|
#   return nil  if 0 == flag # checkbox unchecked
#   where(live: true)
# }

# scope :with_live_status, ->(status) {
#     if status == 'Live Events'
#         where("events.live == ?", true)
#     elsif status == 'Draft Events'
#         where("events.live != ?", true)
#     else
#         where.not("events.live == ?", nil)
#     end
# }       

# scope :with_state, ->(date_ref) {
#     if date_ref == 'Upcoming Events'
#         where("events.starttime >= ?", Date.today)
#     elsif date_ref == 'Past Events'
#         where("events.starttime < ?", Date.today)
#     else
#         where.not("events.starttime == ?", nil)
#     end
# }       


  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ["Model a-z", "model_asc"],
      ["Model z-a", "model_desc"],
    ]
  end


end