class Manufacturers < Termcap2
	self.table_name = "Manufacturers"
	self.primary_key = "Id"
	has_many :Terminals, class_name: :Terminal, foreign_key: :ManufacturerId


	@manufacturers = self.all
	@terms = []
	if @manufacturers.any?
		@manufacturers.each do |m|
			if m.Terminals.count > 0
				@terms.push m
			end
		end
	end
	
	@terms = @terms.sort_by { |m| m.Name }
	
	def self.options_for_select
	  @terms.map { |e| [e.Name, e.Id] }
	end

end