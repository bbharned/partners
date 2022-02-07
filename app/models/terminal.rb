class Terminal < Termcap2
	self.table_name = "Terminals"
	belongs_to :Manufacturer, class_name: 'Manufacturer', foreign_key: 'ManufacturerId'
  has_many :FirmwarePackages, through: :TerminalFirmwarePackage, class_name: 'TerminalFirmwarePackage', foreign_key: 'PackageId'
  has_many :TerminalFirmwarePackages


filterrific(
   default_filter_params: { sorted_by: 'model_asc' },
   available_filters: [
     :sorted_by,
     :with_search,
     :with_manufacturer,
     :with_boot_type,
     :with_firm,
     :with_monitor_count,
     :with_ethernet_count,
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
    order("terminals.Model #{direction}")
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

scope :with_firm, ->(firmId) {
  @joins = TerminalFirmwarePackage.where(PackageId: firmId).joins(:FirmwarePackage)
  @terms = []
  if @joins.any?
    @joins.each do |join|
      @terms.push join.TerminalId
    end
  end
  #Terminal.where(Id: @joins.TerminalIds).includes(:TerminalFirmwarePackage)#.joins(:FirmwarePackage)
  Terminal.where(Id: @terms)
}

scope :with_monitor_count, ->(monitorIds) {
  Terminal.where(MaxMonitors: monitorIds)
}

scope :with_ethernet_count, ->(ethernetIds) {
  Terminal.where(EthernetCount: ethernetIds)
}


  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ["Model a-z", "model_asc"],
      ["Model z-a", "model_desc"],
    ]
  end


end