class Hardware < ActiveRecord::Base
	belongs_to :maker
	belongs_to :hwstatus
	belongs_to :hwtype
	
	validates :model, presence: true, length: { minimum: 3, maximum: 60 }


end