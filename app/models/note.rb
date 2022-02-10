class Note < ActiveRecord::Base
	validates :terminal_id, uniqueness: true


end