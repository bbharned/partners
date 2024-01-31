class User < ApplicationRecord
	attr_accessor :remember_token, :reset_token
	validates :firstname, presence: true, length: { minimum: 2, maximum: 20 }
    validates :lastname, presence: true, length: { minimum: 2, maximum: 30 }
    validates :company, presence: true, length: { minimum: 3, maximum: 60 }
    validates :password, confirmation: true, :on => :create
    validates :email, confirmation: true, :on => :create
    validates :email_confirmation, presence: true, :on => :create
    validates :password_confirmation, presence: true, :on => :create
    has_many :downloads, dependent: :destroy
    has_many :calculators, dependent: :destroy
    has_many :flexforwards, dependent: :destroy
    has_many :certifications, dependent: :destroy
    has_many :qrcodes, dependent: :destroy
    has_many :wrongs, dependent: :destroy
    has_many :user_quizzes
    has_many :quizzes, through: :user_quizzes, dependent: :destroy
    has_many :event_attendees
    has_many :events, through: :event_attendees, dependent: :destroy
    has_one :user_badge
    has_one :listing, dependent: :destroy
    has_many :demokits, dependent: :destroy
    
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
    validates :email,  presence: true,  length: { maximum: 75 },
                uniqueness: { case_sensitive: false },
                format: { with: VALID_EMAIL_REGEX }
    before_save { self.email = email.downcase }
    has_secure_password

    before_validation :strip_contact_phone


def self.to_csv
      attributes = %w{id active firstname lastname email company prttype certexpire channel continent created_at lastlogin}

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

# Sends cert notification email.
    def send_notice_certification(score, wrongs)
        UserMailer.cert_notice(self, score, wrongs).deliver_now
    end

# Sends download conf emails.
    def send_download_ext_notice
        UserMailer.send_download_ext_notice(self).deliver_now
    end

    def send_download_int_notice
        UserMailer.send_download_int_notice(self).deliver_now
    end

    def send_download_zap
        UserMailer.zap_user_download(self).deliver_now
    end


# Sends cert notification email.
    def send_zap
        UserMailer.zap_zap(self).deliver_now
    end

    def send_cert_conf
        UserMailer.cert_complete(self).deliver_now
    end

    def send_zap_lab_upload
        UserMailer.zap_lab_upload(self).deliver_now
    end

#SI sign up notices
    def send_rau_notice
        UserMailer.rau_notice(self).deliver_now
    end

    def send_signup_notice
        UserMailer.register_notice(self).deliver_now
    end

    def send_user_signup_notice
        UserMailer.partner_register_notice(self).deliver_now
    end

    def send_newuser_zap
        UserMailer.zap_user_signup(self).deliver_now
    end

    def send_lab_upload_notice
        UserMailer.lab_upload_notice(self).deliver_now
    end


#Learning Notices
    def send_learning_register_notice
        UserMailer.learning_register_notice(self).deliver_now
    end

    def send_learning_user_signup_notice
        UserMailer.learning_acct_notice_internal(self).deliver_now
    end

    def send_badge_earned_config(specific, badge)
        UserMailer.badge_earned_config(self, specific, badge).deliver_now
    end

    def send_badge_earned_prod(specific, badge)
        UserMailer.badge_earned_prod(self, specific, badge).deliver_now
    end




#Event Norifications
    def send_account_created_evt
        UserMailer.event_account_creation(self).deliver_now
    end

    def send_acct_create_evt_internal
        UserMailer.event_acct_creation_notice(self).deliver_now
    end

    def send_user_evt_registration(event)
        UserMailer.event_registration_user(self, event).deliver_now
    end

    def send_event_reg_internal_notice(event)
        UserMailer.event_reg_notice(self, event).deliver_now
    end

    def send_event_reg_cancel(event)
        UserMailer.event_cancelation_user(self, event).deliver_now
    end

    def send_event_canceled_internal_notice(event)
        UserMailer.event_reg_cancel(self, event).deliver_now
    end

    def send_event_reminder(event)
        @send_date = event.starttime-48.hours
        UserMailer.event_reminder(self, event).deliver_later!(wait_until: @send_date)
    end

#License Request Notification
    def send_license_notification(license)
        UserMailer.license_notification(self, license).deliver_now
    end

    def send_license_request_confirmation
        UserMailer.license_request_confirmation(self).deliver_now
    end

#Listing Request Notification
    def send_listing_notification(license)
        UserMailer.listing_notification(self, license).deliver_now
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

     def strip_contact_phone
        if self.cell != nil
            self.cell.gsub!(/[^0-9]/, '').to_s
        end
    end

end