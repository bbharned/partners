class Manufacturer < Termcap2
	self.table_name = "Manufacturers"
	has_many :terminals, class_name: 'Terminal'
	
	def self.options_for_select
      order("Name asc").map { |e| [e.Name, e.Id] }
    end

end