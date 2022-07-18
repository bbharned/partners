class UserMailerPreview < ActionMailer::Preview

  # for preview at http://localhost:3000/rails/mailers/user_mailer/
  
  def certification_complete_external
    @user = User.find(1)
  	UserMailer.cert_complete(@user)
  end

  def certification_notice_internal
    @user = User.find(4)
    @score = 8
    @wrongs = [2,4]
  	UserMailer.cert_notice(@user, @score, @wrongs)
  end

  def certification_rau_signup_notice_internal
    @user = User.find(19)
  	UserMailer.rau_notice(@user)
  end

  def certification_signup_notice_internal
    @user = User.find(20)
  	UserMailer.register_notice(@user)
  end

  def certification_acct_confirmation_external
    @user = User.find(20)
  	UserMailer.partner_register_notice(@user)
  end

  def certification_lab_upload_notice_internal
    @user = User.find(20)
    UserMailer.lab_upload_notice(@user)
  end

  def zapier_zap_recertification
    @user = User.find(4)
    UserMailer.zap_zap(@user)
  end

  def zapier_new_user_acct
    @user = User.find(15)
    UserMailer.zap_user_signup(@user)
  end

  def zapier_certification_lab_upload
    @user = User.find(15)
    UserMailer.zap_lab_upload(@user)
  end

  def event_reg_notice_internal
    @user = User.find(1)
    @event = Event.find(9)
    UserMailer.event_reg_notice(@user, @event)
  end

  def event_reg_cancel_internal
    @user = User.find(1)
    @event = Event.find(9)
    UserMailer.event_reg_cancel(@user, @event)
  end

  def event_account_creation_external
    @user = User.find(15)
    UserMailer.event_account_creation(@user)
  end

  def event_acct_creation_notice_internal
    @user = User.find(15)
    UserMailer.event_acct_creation_notice(@user)
  end

  def event_registration_user_external
    @user = User.find(1)
    @event = Event.find(9)
    UserMailer.event_registration_user(@user, @event)
  end

  def event_reminder
    @user = User.find(1)
    @event = Event.find(10)
    UserMailer.event_reminder(@user, @event)
  end


  def event_cancelation_user_external
    @user = User.find(1)
    @event = Event.find(9)
    UserMailer.event_cancelation_user(@user, @event)
  end

  def license_request_internal
    @user = User.find(3)
    @license = License.find(1)
    UserMailer.license_notification(@user, @license)
  end

  def listing_request_internal
    @user = User.find(3)
    @listing = Listing.find(2)
    UserMailer.listing_notification(@user, @listing)
  end

  def download_ext_notice
    @user = User.find(3)
    UserMailer.send_download_ext_notice(@user)
  end

  def download_int_notice
    @user = User.find(3)
    UserMailer.send_download_int_notice(@user)
  end

  def download_zap
    @user = User.find(3)
    UserMailer.zap_user_download(@user)
  end



end