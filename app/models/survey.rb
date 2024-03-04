class Survey < ActiveRecord::Base
	has_many :survey_questions, dependent: :destroy
	validates :title, presence: true, length: { minimum:3, maximum: 200 }









end