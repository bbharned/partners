class Maker < ActiveRecord::Base
	has_many :hardwares, dependent: :destroy
	has_many :hwstatuses, through: :hardwares
	has_many :hwtypes, through: :hardwares
	has_many :term_types, through: :hardwares

	validates :name, presence: true, length: { minimum: 2, maximum: 100 }
	


	def self.options_for_select
	  order(Arel.sql("LOWER(name)")).map { |e| [e.name, e.id] }
	end



end