class Survey < ActiveRecord::Base
	has_many :survey_questions, dependent: :destroy
	validates :title, presence: true, length: { minimum:3, maximum: 200 }





## filterrific ##

filterrific(
   default_filter_params: { survey_sort: 'created_at_desc' },
   available_filters: [
     :survey_sort,
     :survey_search
   ],
 )


scope :survey_search, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e + '%').gsub(/%+/, '%')
    }

    num_or_conds = 1
    where(
      terms.map { |term|
        "(
        LOWER(surveys.title) LIKE ?
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
      )
} 


scope :survey_sort, ->(sort_option) {
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^created_at_/
    order("surveys.created_at #{direction}")
  when /^title_/
    order("surveys.title #{direction}")
  else
    raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
  end
}

# scope :with_channel, ->(channels) {
#   where(channel: [*channels])
# }

# scope :with_prttype, ->(prttypes) {
#   where(prttype: [*prttypes])
# }

# scope :with_active, ->(status) {
#     if status == "Active"
#         where(active: true)
#     elsif status == "Inactive"
#         where(active: false)
#     end
# } 

# scope :with_region, ->(region) {
#     if region == "North America"
#         where(continent: "NA")
#     elsif region == "Latin America"
#         where(continent: "LA")
#     elsif region == "EMEA"
#         where(continent: "EMEA")
#     elsif region == "Asia Pacific"
#         where(continent: "AP")
#     elsif region == "Unknown"
#         where(continent: "")
#     end
# } 

# scope :with_cert, ->(cert) {
#     if cert == "Active Certified"
#         where("users.certexpire >= ?", Date.today)
#     elsif cert == "Expired Certified"
#         where("users.certexpire < ?", Date.today)
#     elsif cert == "Never Certified"
#         where(certdate: nil)
#     end
# } 

def self.options_for_survey_sort
    [
      ["Newest - Oldest", "created_at_desc"],
      ["Oldest - Newest", "created_at_asc"],
      ["Title A-Z", "title_asc"],
      ["Title Z-A", "title_desc"],
    ]
end

## end Filterrific ##



end