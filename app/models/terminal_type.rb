class TerminalType < Termcap2
	self.table_name = "TerminalType"
	
	@types = self.all
	@types = @types.order(:Type)

	def self.options_for_select
      @types.map { |e| [e.Type, e.Id] }
    end

end