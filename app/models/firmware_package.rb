class FirmwarePackage < Termcap2
	self.table_name = "FirmwarePackage"
	has_many :TerminalFirmwarePackages
  	has_many :Terminals, through: :TerminalFirmwarePackage, class_name: 'TerminalFirmwarePackage', foreign_key: 'TerminalId'

	
	def self.options_for_select
	  order(Arel.sql("LOWER(version)")).map { |e| [e.Version, e.Id] }
	end


end