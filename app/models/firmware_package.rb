class FirmwarePackage < Termcap2
	self.table_name = "FirmwarePackage"
	has_many :TerminalFirmwarePackages
  	has_many :Terminals, through: :TerminalFirmwarePackage, class_name: :TerminalFirmwarePackage, foreign_key: :TerminalId

	@packages = self.all
	@packages = @packages.order(:Version)

	def self.options_for_select
	  @packages.map { |e| [e.Version, e.Id] }
	end


end