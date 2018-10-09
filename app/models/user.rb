class User < ApplicationRecord
	
	validates :firstname, presence: true, length: { minimum: 1, maximum: 20 }
    validates :lastname, presence: true, length: { minimum: 2, maximum: 30 }
    validates :company, presence: true, length: { minimum: 2, maximum: 30 }
    #validates :password, confirmation: true, :on => :create
    #validates :email, confirmation: true, :on => :create
    #validates :email_confirmation, presence: true, :on => :create
    #validates :password_confirmation, presence: true, :on => :create
   
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
    validates :email,  presence: true,  length: { maximum: 75 },
                uniqueness: { case_sensitive: false },
                format: { with: VALID_EMAIL_REGEX }
    before_save { self.email = email.downcase }
    has_secure_password


end