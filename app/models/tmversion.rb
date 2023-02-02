class Tmversion < ActiveRecord::Base
	has_many :features_tmversions
	has_many :features, through: :features_tmversions

	validates :version, presence: true, length: { minimum: 3, maximum: 15 }


	def self.options_for_select
	  order(Arel.sql("LOWER(version)")).map { |e| [e.version, e.id] }
	end


end