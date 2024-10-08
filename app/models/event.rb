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
  validates :viewer, format: { with: VALID_EMAIL_REGEX }, :allow_nil => true, :allow_blank => true
  before_save { self.viewer = viewer.downcase }


def formatted_name
  "#{name.truncate(35)} - #{starttime.strftime("%B %d, %Y")}"
end


def self.to_csv
  #attributes = %w{id name description starttime endtime tzid event_host event_contact reg_required capacity live created_at}

  CSV.generate(headers: true) do |csv|
    #csv << attributes
    csv << ["Id"] + ["Event Name"] + ["Event Desciription"] + ["Event Start"] + ["Event End"] + ["Time Zone"] + ["Host Company"] + ["Contact"] + ["Registration Required"] + ["Capacity"] + ["Registered"] + ["Attended"] + ["Past Cert"] + ["Waitlisted"] + ["Canceled"] + ["Live?"] + ["Created At"] 

    all.each do |event|
      registered = event.event_attendees.where.not(canceled: true).where.not(waitlist: true).count
      attended = event.event_attendees.where.not(canceled: true).where.not(waitlist: true).where(checkedin: true).count
      waitlisted = event.event_attendees.where.not(canceled: true).where(waitlist: true).count
      canceled = event.event_attendees.where(canceled: true).count
      certified = event.event_attendees.where(checkedin: true).where(passed: true).count
      #csv << attributes.map{ |attr| event.send(attr) }
      csv << ([event.id] + [event.name] + [event.description] + [event.starttime] + [event.endtime] + [event.tzid] + [event.event_host] + [event.event_contact] + [event.reg_required] + [event.capacity] + [registered] + [attended] + [certified] + [waitlisted] + [canceled] + [event.live] + [event.created_at])
    end
  end
end

filterrific(
   default_filter_params: { sort_this: 'starttime_asc', as_archived: 'Not Archived' },
   available_filters: [
     :sort_this,
     :with_search,
     :with_evtcategory,
     :with_live,
     :with_state,
     :with_live_status,
     :with_tag,
     :with_venue,
     :by_year,
     :as_archived,
   ],
 )


scope :with_search, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e + '%').gsub(/%+/, '%')
    }

    num_or_conds = 8
    where(
      terms.map { |term|
        "(
        LOWER(events.name) LIKE ?
        OR LOWER(events.description) LIKE ?  
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


scope :sort_this, ->(sort_option) {
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^starttime_/
    #order("events.live asc").
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

# scope :as_archived, lambda { |flag|
#   return nil  if 0 == flag # checkbox unchecked
#   where(archive: true)
# }

scope :as_archived, ->(status) {
    if status == 'Archived'
        where(archive: true)
    elsif status == 'Not Archived'
        where.not(archive: true)
    elsif status == 'All'
        where.not(archive: nil)
    end
}  

scope :with_live_status, ->(status) {
    if status == 'Live Events'
        where(live: true)
    elsif status == 'Draft Events'
        where.not(live: true)
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

require 'date'   

scope :by_year, ->(date_ref) {
  
  if date_ref == 2024
    dtb = DateTime.new(2024, 1, 1, 00, 01, 00)
    dte = DateTime.new(2025, 1, 1, 00, 01, 00)
    where("events.starttime >= ?", dtb).where("events.starttime < ?", dte)
  elsif date_ref == 2023
    dtb = DateTime.new(2023, 1, 1, 00, 01, 00)
    dte = DateTime.new(2024, 1, 1, 00, 01, 00)
    where("events.starttime >= ?", dtb).where("events.starttime < ?", dte)
  elsif date_ref == 2022
    dtb = DateTime.new(2022, 1, 1, 00, 01, 00)
    dte = DateTime.new(2023, 1, 1, 00, 01, 00)
    where("events.starttime >= ?", dtb).where("events.starttime < ?", dte)
  elsif date_ref == 2021
    dtb = DateTime.new(2021, 1, 1, 00, 01, 00)
    dte = DateTime.new(2022, 1, 1, 00, 01, 00)
    where("events.starttime >= ?", dtb).where("events.starttime < ?", dte)
  end

} 
     
#if date_ref == '2021'
    #     where('extract(year from starttime ) = ?', date_ref)

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sort_this
    [
      ["Start Time (asc)", "starttime_asc"],
      ["Start Time (desc)", "starttime_desc"],
      ["Newest - Oldest", "created_at_desc"],
      ["Oldest - Newest", "created_at_asc"],
    ]
  end

end