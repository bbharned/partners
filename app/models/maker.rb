class Maker < ActiveRecord::Base
	has_many :hardwares, dependent: :destroy
	has_many :hwstatuses, through: :hardwares
	has_many :hwtypes, through: :hardwares

	validates :name, presence: true, length: { minimum: 5, maximum: 100 }
	


	def self.options_for_select
	  order("LOWER(name)").map { |e| [e.name, e.id] }
	end



end