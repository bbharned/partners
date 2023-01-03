class Manufacturers < Termcap2
	self.table_name = "Manufacturers"
	self.primary_key = "Id"
	has_many :terminals, class_name: :Terminal


	@manufacturers = self.all
	@manufacturers = @manufacturers.order(:Name)
	
	def self.options_for_select
	  @manufacturers.map { |e| [e.Name, e.Id] }
	end

end