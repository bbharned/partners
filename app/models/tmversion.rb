class Tmversion < ActiveRecord::Base
	has_many :features
	has_many :features, through: :features_tmversions

	validates :version, presence: true, length: { minimum: 3, maximum: 15 }


end