class Firmwarebuild < ActiveRecord::Base
	has_many :features_firmwarebuilds
	has_many :features, through: :features_firmwarebuilds

	validates :build, presence: true, length: { minimum: 1, maximum: 25 }


	def self.options_for_select
	  order(Arel.sql("LOWER(build)")).map { |e| [e.build, e.id] }
	end


end