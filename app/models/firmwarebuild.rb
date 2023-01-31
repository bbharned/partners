class Firmwarebuild < ActiveRecord::Base
	has_many :features
	has_many :features, through: :features_firmwarebuilds

	validates :build, presence: true, length: { minimum: 3, maximum: 25 }


end