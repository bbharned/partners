class Termnote < ActiveRecord::Base
	validates :termcapmodel, uniqueness: true
	belongs_to :Terminal


end