class TerminalType < Termcap2
	self.table_name = "TerminalType"
	self.primary_key = "Id"
	has_many :Terminals, class_name: :Terminal, foreign_key: :TypeId
	
	@types = self.all
	@types = @types.order(:Type)

	def self.options_for_select
      @types.map { |e| [e.Type, e.Id] }
    end

end