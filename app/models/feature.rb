class Feature < ActiveRecord::Base
  has_many :features_firmwarebuilds
  has_many :firmwarebuilds, through: :features_firmwarebuilds
  has_many :features_tmversions
  has_many :tmversions, through: :features_tmversions
  validates :name, presence: true, length: { minimum:3, maximum: 100 }




end