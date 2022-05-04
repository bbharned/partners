class Termnote < ActiveRecord::Base
	validates :termcapmodel, uniqueness: true


end