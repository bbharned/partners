class Hwstatus < ActiveRecord::Base
	has_many :hardwares
	has_many :makers, through: :hardwares
	has_many :hwtypes, through: :hardwares

	validates :name, presence: true, length: { minimum: 3, maximum: 60 }

	def self.options_for_select
	  order(Arel.sql("LOWER(name)")).map { |e| [e.name, e.id] }
	end
	

end