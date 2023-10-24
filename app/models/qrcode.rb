class Qrcode < ApplicationRecord
validates :content, presence: true, length: { minimum: 2, maximum: 180 }
belongs_to :user



end