class Qrcode < ApplicationRecord
validates :content, presence: true, length: { minimum: 2, maximum: 60 }
belongs_to :user



end