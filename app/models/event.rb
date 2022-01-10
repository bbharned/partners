class Event < ActiveRecord::Base
	has_many :event_categories
    has_many :evtcategories, through: :event_categories
    has_many :event_venues
    has_many :venues, through: :event_venues
    has_many :event_tags
    has_many :tags, through: :event_tags
    has_many :event_attendees, :dependent => :destroy
    has_many :users, through: :event_attendees
    validates :name, presence: true, length: { minimum:3, maximum: 100 }
    


filterrific(
   default_filter_params: { sorted_by: 'starttime_desc' },
   available_filters: [
     :sorted_by,
     :with_search,
     :with_evtcategory,
     #:with_created_at_gte
   ]
 )


scope :with_search, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e + '%').gsub(/%+/, '%')
    }

    num_or_conds = 9
    where(
      terms.map { |term|
        "(
        LOWER(events.name) LIKE ? 
        OR LOWER(events.description) LIKE ? 
        OR LOWER(events.capacity) LIKE ? 
        OR LOWER(events.event_contact) LIKE ? 
        OR LOWER(events.event_email) LIKE ? 
        OR LOWER(events.event_host) LIKE ? 
        OR LOWER(tags.name) LIKE ?
        OR LOWER(evtcategories.name) LIKE ?
        OR LOWER(venues.name) LIKE ?
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    ).includes(:venues).references(:venues)
    .includes(:evtcategories).references(:evtcategories)
    .includes(:tags).references(:tags)
} 


scope :sorted_by, ->(sort_option) {
  # Sorts hardware by sort_key
  # extract the sort direction from the param value.
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^starttime_/
    order("events.starttime #{direction}")
  when /^created_at_/
    # Simple sort on the created_at column.
    # Make sure to include the table name to avoid ambiguous column names.
    # Joining on other tables is quite common in Filterrific, and almost
    # every ActiveRecord table has a 'created_at' column.
    order("events.created_at #{direction}")
  # when /^tag_/
  #   # Simple sort on the name colums
  #   order("LOWER(events.tags) #{direction}")
  # when /^evtcategory_name_/
  #   # This sorts by a hardware's maker name, so we need to include
  #   # the maker.
  #   order("LOWER(events.evtcategories) #{direction}").includes(:evtcategory).references(:event_categories)
  else
    raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
  end
}


# scope :with_evtcategory_id, ->(evtcategory_ids) {
#     # Filters event with any of the given hardware type_ids
#     where(evtcategory_id: [*evtcategory_ids])
# }

# scope :with_evtcategory_id, -> {
#   where(
#     "EXISTS (SELECT * from evtcategories WHERE events.id = event_categories.event_id)",
#   )
# }

scope :with_evtcategory, ->(evtcategory_ids) {
  where(evtcategories: [*evtcategory_ids])
}


# scope :with_maker_id, ->(maker_ids) {
#     # Filters hardware with any of the given maker_ids
#     where(maker_id: [*maker_ids])
# }

# scope :with_hwstatus_id, ->(hwstatus_ids) {
#     # Filters hardware with any of the given status_ids
#     where(hwstatus_id: [*hwstatus_ids])
# }

# scope :with_min_firmware, ->(firmware_vs) {
#     # Filters hardware with any of the given firmwares_ids
#     where("hardwares.min_firmware >= ?", (firmware_vs))
# }

# scope :with_max_firmware, ->(firmware_versions) {
#     # @firmware = firmware_versions.to_f
#     # Filters hardware with any of the given firmwares_ids
#     where("hardwares.max_firmware <= ?", (firmware_versions))
#     #.where.not("hardwares.max_firmware == ?", "#{nil}")
# }


# filters on 'boot type' attribute
# scope :with_boot, ->(terminal_types) {
#   where(terminal_type: [*terminal_types])
# }

#scope :with_created_at_gte, ->(ref_date) {
    #where("hardwares.created_at >= ?", ref_date)
#}


  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ["Start Time", "starttime_desc"],
      ["Newest - Oldest", "created_at_desc"],
      ["Oldest - Newest", "created_at_asc"],
    ]
  end

end