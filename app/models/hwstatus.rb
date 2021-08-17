class Hwstatus < ActiveRecord::Base
	has_many :hardwares
	validates :name, presence: true, length: { minimum: 3, maximum: 60 }



end