class Hardware < ActiveRecord::Base
	belongs_to :maker
	belongs_to :hwstatus
	belongs_to :hwtype
	



end