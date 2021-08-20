class Hwtype < ActiveRecord::Base
	has_many :hardwares
	has_many :hwstatuses, through: :hardwares
	has_many :makers, through: :hardwares

	validates :name, presence: true, length: { minimum: 3, maximum: 60 }



end