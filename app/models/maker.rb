class Maker < ActiveRecord::Base
	has_many :hardwares, dependent: :destroy
	validates :name, presence: true, length: { minimum: 5, maximum: 100 }
	




end