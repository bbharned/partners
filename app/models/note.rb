class Note < Termcap2
	self.table_name = "Note"
	belongs_to :Terminal, class_name: :Terminal, foreign_key: :TerminalId



end