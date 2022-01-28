class Answer < ApplicationRecord
	belongs_to :question
	has_many :wrongs
    validates :answer, presence: true, length: { minimum: 1, maximum: 100 }


end