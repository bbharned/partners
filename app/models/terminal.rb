class Terminal < Termcap2
  	self.table_name = "Terminals"
    self.primary_key = "Id"
  	belongs_to :Manufacturers, class_name: :Manufacturers, foreign_key: :ManufacturerId
    belongs_to :TerminalType, class_name: :TerminalType, foreign_key: :TypeId
    has_many :TerminalFirmwarePackages, class_name: :TerminalFirmwarePackage, foreign_key: :TerminalId
    has_many :FirmwarePackages, through: :TerminalFirmwarePackages, class_name: :FirmwarePackage, foreign_key: :PackageId
    has_many :Notes, class_name: :Note, foreign_key: :TerminalId
    has_one :termnote, foreign_key: :termcapmodel



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



# scope :with_search_please, ->(search_string) {
#   return nil  if search_string.blank?
#   terms = search_string.to_s.downcase.split(/\s+/)
#   terms = terms.map { |e|
#       #('%' + e + '%').gsub(/%+/, '%')
#       ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
#     }
#   num_or_conds = 6
#   self.where(
#       terms.map { |term|
#         "(
#         LOWER(Terminals.Model) LIKE ?
#         OR LOWER(Terminals.TermcapModel) LIKE ?
#         OR LOWER(Manufacturers.Name) LIKE ?
#         OR LOWER(TerminalType.Type) LIKE ?
#         OR LOWER(Note.Description) LIKE ?
#         OR LOWER(FirmwarePackage.Version) LIKE ?
#         )"
#       }.join(' AND '),
#       *terms.map { |e| [e] * num_or_conds }.flatten
#     )
#     .joins(:Manufacturers).references(:ManufacturerIds)
#     .joins(:TerminalType).references(:TypeIds)
#     .includes(:Notes).references(:TerminalIds)
#     .joins(:FirmwarePackages).references(:TerminalFirmwarePackages)
# }


# scope :with_search_please, ->(search_string) {
  
#   return nil  if search_string.blank?
  
#   searchterm = search_string
#   # .downcase

#   self.where("Model LIKE ?", "#{searchterm}%").or(Terminal.where("Model LIKE ?", "%#{searchterm}%"))

# }


scope :with_search_please, ->(search_string) {
  return none if search_string.blank? # A scope should not return nil

  search_columns = [
    Terminal.arel_table[:Model],
    Terminal.arel_table[:TermcapModel]
    # Manufacturers.arel_table[:Name]
    # TerminalType.arel_table[:Type],
    # Note.arel_table[:Description]
    # FirmwarePackage.arel_table[:Version]
  ]

  terms = search_string.to_s
          .gsub("*","%")
          .split
          .map {|term| "%#{term}%"}

  where(search_columns.map {|c| c.matches_any(terms)}.reduce(:and))
    # .joins(:Manufacturers)
    # .joins(:TerminalType)
    # .left_joins(:Notes)
    # .joins(:FirmwarePackages)
}


# scope :with_note_search, ->(search_string) {
#   return none if search_string.blank? # A scope should not return nil

#   search_columns = [
#     Note.arel_table[:Description]
#   ]

#   terms = search_string.to_s
#           .gsub("*","%")

#   where('Description LIKE ?', "%#{terms}%")
#     .left_joins(:Notes)
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
	self.where(ManufacturerId: manufacturerIds)
}

scope :with_boot_type, ->(typeIds) {
  self.where(TypeId: typeIds)
}

scope :with_firm, ->(firmId) {
  @joins = TerminalFirmwarePackage.where(PackageId: firmId).joins(:FirmwarePackage)
  @terms = []
  if @joins.any?
    @joins.each do |join|
      @terms.push join.TerminalId
    end
  end
  self.where(Id: @terms)
}

scope :with_monitor_count, ->(monitorIds) {
  self.where(MaxMonitors: monitorIds)
}

scope :with_ethernet_count, ->(ethernetIds) {
  self.where(EthernetCount: ethernetIds)
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