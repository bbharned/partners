class Certification < ApplicationRecord
	belongs_to :user
	validates :name, presence: true, length: { minimum: 1, maximum: 50 }
	validates :version, presence: true













private





end