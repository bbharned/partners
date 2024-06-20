class Roi < ActiveRecord::Base
	belongs_to :user
	belongs_to :currency
	#before_save :calcs
	validates :name, presence: true, length: { minimum: 1, maximum: 50 }





end