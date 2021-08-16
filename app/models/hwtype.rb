class Hwtype < ActiveRecord::Base
	has_many :hardwares, dependent: :destroy
	



end