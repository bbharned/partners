class License < ApplicationRecord
	belongs_to :user
	validates_uniqueness_of :user_id, :message=>" already has a license in the system. Please email us at certification@thinmanager.com, to explain needed chaanges, extension or renewal."




end