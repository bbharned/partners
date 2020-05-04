class Currency < ApplicationRecord
	validates :name, presence: true, length: { minimum: 1, maximum: 25 }
	validates :symbol, presence: true
	validates :rate, presence: true
	has_many :flexforwards





end