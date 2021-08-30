class Hardware < ActiveRecord::Base
	belongs_to :maker
	belongs_to :hwstatus
	belongs_to :hwtype
	
	validates :model, presence: true, length: { minimum: 3, maximum: 60 }



filterrific(
   default_filter_params: { sorted_by: 'priority_asc' },
   available_filters: [
     :sorted_by,
     :with_search,
     :with_maker_id,
     :with_hwtype_id,
     :with_hwstatus_id,
     :with_min_firmware,
     :with_max_firmware
     #:with_created_at_gte
   ]
 )


scope :with_search, lambda { |query|
    return nil  if query.blank?

    terms = query.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e + '%').gsub(/%+/, '%')
    }

    num_or_conds = 12
    where(
      terms.map { |term|
        "(
        LOWER(hardwares.terminal_type) LIKE ? 
        OR LOWER(hardwares.model) LIKE ? 
        OR LOWER(hardwares.note) LIKE ? 
        OR LOWER(hardwares.hardware_gpu_id) LIKE ? 
        OR LOWER(hardwares.cpu) LIKE ? 
        OR LOWER(hardwares.touch_interface) LIKE ? 
        OR LOWER(hardwares.network_card) LIKE ? 
        OR LOWER(hardwares.pci_network_id) LIKE ? 
        OR LOWER(hardwares.video_chipset) LIKE ?
        OR LOWER(makers.name) LIKE ?
        OR LOWER(hwstatuses.name) LIKE ?
        OR LOWER(hwtypes.name) LIKE ?
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    ).includes(:maker).references(:makers)
    .includes(:hwstatus).references(:hwstatuses)
    .includes(:hwtype).references(:hwtypes)
} 


scope :sorted_by, ->(sort_option) {
  # Sorts hardware by sort_key
  # extract the sort direction from the param value.
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^priority_/
    order("hardwares.priority #{direction}")
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
    order("LOWER(makers.name) #{direction}").includes(:maker).references(:maker)
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

scope :with_min_firmware, ->(firmware_vs) {
    # @firmware = firmware_vs.to_f  
    # Filters hardware with any of the given firmwares_ids
    where("hardwares.min_firmware >= ?", (firmware_vs)).where.not("hardwares.min_firmware == ?", "")
}

scope :with_max_firmware, ->(firmware_versions) {
    # @firmware = firmware_versions.to_f
    # Filters hardware with any of the given firmwares_ids
    where("hardwares.max_firmware <= ?", (firmware_versions)).where.not("hardwares.max_firmware == ?", "")
}


#scope :with_created_at_gte, ->(ref_date) {
    #where("hardwares.created_at >= ?", ref_date)
#}


  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ["Relevance", "priority_asc"],
      ["Brand (a-z)", "maker_name_asc"],
      ["Hardware Model (a-z)", "model_asc"],
      # ["Newest - Oldest", "created_at_desc"],
      # ["Oldest - Newest", "created_at_asc"],
    ]
  end


end