class User < ApplicationRecord
	attr_accessor :remember_token, :reset_token
	validates :firstname, presence: true, length: { minimum: 1, maximum: 20 }
    validates :lastname, presence: true, length: { minimum: 1, maximum: 30 }
    validates :company, presence: true, length: { minimum: 2, maximum: 60 }
    validates :password, confirmation: true, :on => :create
    validates :email, confirmation: true, :on => :create
    validates :email_confirmation, presence: true, :on => :create
    validates :password_confirmation, presence: true, :on => :create
    has_many :downloads
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
    validates :email,  presence: true,  length: { maximum: 75 },
                uniqueness: { case_sensitive: false },
                format: { with: VALID_EMAIL_REGEX }
    before_save { self.email = email.downcase }
    has_secure_password


def self.to_csv
      attributes = %w{id active firstname lastname email company prttype channel continent created_at lastlogin}

      CSV.generate(headers: true) do |csv|
        csv << attributes

        all.each do |user|
          csv << attributes.map{ |attr| user.send(attr) }
        end
      end
end


# Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

# Sends password reset email.
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

# Returns the hash digest of the given string.
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # Remembers a user in the database for use in persistent sessions.
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end


private

# Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end