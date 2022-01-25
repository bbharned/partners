class Event < ActiveRecord::Base
  has_many :event_categories, :dependent => :destroy
  has_many :evtcategories, through: :event_categories
  has_many :event_venues, :dependent => :destroy
  has_many :venues, through: :event_venues
  has_many :event_tags
  has_many :tags, through: :event_tags
  has_many :event_attendees, :dependent => :destroy
  has_many :users, through: :event_attendees
  validates :name, presence: true, length: { minimum:3, maximum: 100 }
    

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :viewer, format: { with: VALID_EMAIL_REGEX }
  before_save { self.viewer = viewer.downcase }


def self.to_csv
  attributes = %w{id active firstname lastname email company prttype channel continent created_at lastlogin}

  CSV.generate(headers: true) do |csv|
    csv << attributes

    all.each do |user|
      csv << attributes.map{ |attr| user.send(attr) }
    end
  end
end

filterrific(
   default_filter_params: { sorted_by: 'created_at_desc' },
   available_filters: [
     :sorted_by,
     :with_search,
     :with_evtcategory,
     :with_live,
     :with_state,
     :with_live_status,
     :with_tag,
     :with_venue,
   ],
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
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^starttime_/
    order("events.starttime #{direction}")
  when /^created_at_/
    order("events.created_at #{direction}")
  else
    raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
  end
}


scope :with_evtcategory, ->(evtcategory_ids) {
  joins(event_categories: :evtcategory).where(event_categories: {evtcategory_id: evtcategory_ids})
}

scope :with_tag, ->(tag_ids) {
  joins(event_tags: :tag).where(event_tags: {tag_id: tag_ids})
}

scope :with_venue, ->(venue_ids) {
  joins(event_venues: :venue).where(event_venues: {venue_id: venue_ids})
}


# filters on 'live' attribute
scope :with_live, lambda { |flag|
  return nil  if 0 == flag # checkbox unchecked
  where(live: true)
}

scope :with_live_status, ->(status) {
    if status == 'Live Events'
        where("events.live == ?", true)
    elsif status == 'Draft Events'
        where("events.live != ?", true)
    else
        where.not("events.live == ?", nil)
    end
}       

scope :with_state, ->(date_ref) {
    if date_ref == 'Upcoming Events'
        where("events.starttime >= ?", Date.today)
    elsif date_ref == 'Past Events'
        where("events.starttime < ?", Date.today)
    else
        where.not("events.starttime == ?", nil)
    end
}       


  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ["Start Time", "starttime_asc"],
      ["Newest - Oldest", "created_at_desc"],
      ["Oldest - Newest", "created_at_asc"],
    ]
  end

end