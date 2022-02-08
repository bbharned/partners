class Manufacturers < Termcap2
	self.table_name = "Manufacturers"
	has_many :terminals, class_name: 'Terminal'
	
	

end