class TerminalFirmwarePackage < Termcap2
	self.table_name = "TerminalFirmwarePackage"
	self.primary_key = "Id"
	belongs_to :Terminal, class_name: :Terminal, foreign_key: :TerminalId
    belongs_to :FirmwarePackage, class_name: :FirmwarePackage, foreign_key: :PackageId



end