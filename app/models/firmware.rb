class Firmware < ActiveRecord::Base
	validates :version, presence: true, length: { minimum: 1, maximum: 20 }


	def self.options_for_select
	  order(:version).map { |e| [e.version, e.version] }
	end

end