class Terminal < Termcap2
  	self.table_name = "Terminals"
    self.primary_key = "Id"
  	belongs_to :Manufacturers, class_name: :Manufacturers, foreign_key: :ManufacturerId
    belongs_to :TerminalType, class_name: :TerminalType, foreign_key: :TypeId
    has_many :FirmwarePackages, through: :TerminalFirmwarePackage, class_name: :TerminalFirmwarePackage, foreign_key: :PackageId
    has_many :TerminalFirmwarePackages



# @terminals = self.all
# @terminals = @terminals.order(:Model)
# @terminalsrev = @terminals.reverse
# @terminalswhen = @terminals.order(:created_at)


filterrific(
   default_filter_params: { },
   available_filters: [
     # :sorted_by,
     :with_search_please,
     :with_manufacturer,
     :with_boot_type,
     :with_firm,
     :with_monitor_count,
     :with_ethernet_count,
   ],
 )



scope :with_search_please, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)

    terms = terms.map { |e|
      #('%' + e + '%').gsub(/%+/, '%')
      ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }

    num_or_conds = 1
    from(Terminal)
    where(
      terms.map { |term|
        "(
            LOWER(Manufacturers.Name) LIKE ?
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    ).includes(:Manufacturers).references('Terminal.ManufacturerId')
} 

# scope :with_search_please, -> (search_string) {
#   return nil  if search_string.blank?
#   terms = search_string.to_s.downcase.split(/\s+/)
#   terms = terms.map { |e|
#       ('%' + e + '%').gsub(/%+/, '%')
#     }
#   Terminal.where("Terminals.Model LIKE ?", terms)
# }


scope :sorted_by, ->(sort_option) {
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^model_/
    order("Model #{direction}")
  # when /^created_at_/
  #   order("created_at #{direction}")
  else
    raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
  end
}


scope :with_manufacturer, ->(manufacturerIds) {
	Terminal.where('ManufacturerId LIKE ?', manufacturerIds)
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