class Hardware < ActiveRecord::Base
	belongs_to :maker
	belongs_to :hwstatus
	belongs_to :hwtype
	
	validates :model, presence: true, length: { minimum: 3, maximum: 60 }


filterrific(
   default_filter_params: { sorted_by: 'created_at_asc' },
   available_filters: [
     :sorted_by,
     :search_query,
     :with_maker_id,
     :with_hwtype_id,
     :with_hwstatus_id
     #:with_created_at_gte
   ]
 )


scope :search_query, ->(query) {
  # Filters hardware by search query
  # Matches using LIKE, automatically appends '%' to each term.
  # LIKE is case INsensitive with MySQL, however it is case
  # sensitive with PostGreSQL. To make it work in both worlds,
  # we downcase everything.
  return nil  if query.blank?

  # condition query, parse into individual keywords
  terms = query.downcase.split(/\s+/)

  # replace "*" with "%" for wildcard searches,
  # append '%', remove duplicate '%'s
  terms = terms.map { |e|
    #(e.tr("*", "%") + "%").gsub(/%+/, "%")
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }
  # configure number of OR conditions for provision
  # of interpolation arguments. Adjust this if you
  # change the number of OR conditions.
  num_or_conds = 3
  where(
    terms.map { |_term|
      "(LOWER(hardwares.model) LIKE ? OR LOWER(hardwares.min_firmware) LIKE ? OR LOWER(hardwares.max_firmware) LIKE ?)"
    }.join(" AND "),
    *terms.map { |e| [e] * num_or_conds }.flatten,
  )
}


scope :sorted_by, ->(sort_option) {
  # Sorts hardware by sort_key
  # extract the sort direction from the param value.
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^created_at_/
    # Simple sort on the created_at column.
    # Make sure to include the table name to avoid ambiguous column names.
    # Joining on other tables is quite common in Filterrific, and almost
    # every ActiveRecord table has a 'created_at' column.
    order("hardwares.created_at #{direction}")
  when /^model_/
    # Simple sort on the name colums
    order("LOWER(hardwares.model) #{direction}")
  when /^maker_name_/
    # This sorts by a hardware's maker name, so we need to include
    # the maker.
    order("LOWER(hardwares.model) #{direction}").includes(:maker).references(:maker)
  when /^hwtype_name_/
    # This sorts by a hardware's maker type, so we need to include
    # the type.
    order("LOWER(hardwares.hwtype) #{direction}").includes(:hwtype).references(:hwtype)
  else
    raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
  end
}


scope :with_hwtype_id, ->(hwtype_ids) {
    # Filters hardware with any of the given hardware type_ids
    where(hwtype_id: [*hwtype_ids])
}


scope :with_maker_id, ->(maker_ids) {
    # Filters hardware with any of the given maker_ids
   	where(maker_id: [*maker_ids])
}

scope :with_hwstatus_id, ->(hwstatus_ids) {
    # Filters hardware with any of the given status_ids
    where(hwstatus_id: [*hwstatus_ids])
}


#scope :with_created_at_gte, ->(ref_date) {
    #where("hardwares.created_at >= ?", ref_date)
#}


  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ["Hardware Model (a-z)", "model_asc"],
      ["Newest - Oldest", "created_at_desc"],
      ["Oldest - Newest", "created_at_asc"],
      ["Brand (a-z)", "maker_name_asc"],
    ]
  end


end