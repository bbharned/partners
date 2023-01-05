class Note < Termcap2
	self.table_name = "Note"
	self.primary_key = "Id"
	belongs_to :Terminal, class_name: :Terminal, foreign_key: :TerminalId



end