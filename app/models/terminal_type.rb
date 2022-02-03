class TerminalType < Termcap2
	self.table_name = "TerminalType"
	

	def self.options_for_select
      order(Arel.sql("LOWER(type)")).map { |e| [e.Type, e.id] }
    end

end