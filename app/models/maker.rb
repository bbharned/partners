class Maker < ActiveRecord::Base
	has_many :hardwares, dependent: :destroy
	has_many :hwstatuses, through: :hardwares
	has_many :hwtypes, through: :hardwares



	validates :name, presence: true, length: { minimum: 2, maximum: 100 }
	

	# @makers = self.all
	# @devices = []
	
	
	# if @makers.any?
	# 	@makers.each do |m|
	# 		if m.hardwares.count > 0
	# 			@devices.push m
	# 		end
	# 	end
	# end
	
	
	# @devices = @devices.sort_by { |m| m.name }

	def self.options_for_select
	  order(Arel.sql("LOWER(name)")).map { |e| [e.name, e.id] }
	  # @devices.map { |e| [e.name, e.id] }
	end

end