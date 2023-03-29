class Tmprereq < ActiveRecord::Base
	has_many :features_tmprereqs
	has_many :features, through: :features_tmprereqs

	validates :name, presence: true, length: { minimum: 3, maximum: 20 }


	# def self.options_for_select
	#   order(Arel.sql("LOWER(name)")).map { |e| [e.name, e.id] }
	# end


end