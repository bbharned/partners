class UserMailerPreview < ActionMailer::Preview
  
  def cert_complete
    @user = User.find(1)
  	UserMailer.cert_complete(@user)
  end

  def cert_notice
    @user = User.find(4)
    @score = 8
    @wrongs = [2,4]
  	UserMailer.cert_notice(@user, @score, @wrongs)
  end

  def rau_notice
    @user = User.find(19)
  	UserMailer.rau_notice(@user)
  end

  def register_notice
    @user = User.find(20)
  	UserMailer.register_notice(@user)
  end

  def partner_register_notice
    @user = User.find(20)
  	UserMailer.partner_register_notice(@user)
  end

  def lab_upload_notice
    @user = User.find(20)
    UserMailer.lab_upload_notice(@user)
  end

  def zap_zap
    @user = User.find(4)
    UserMailer.zap_zap(@user)
  end

  def zap_user_signup
    @user = User.find(15)
    UserMailer.zap_user_signup(@user)
  end

  def zap_lab_upload
    @user = User.find(15)
    UserMailer.zap_lab_upload(@user)
  end

  def event_reg_notice
    @user = User.find(1)
    @event = Event.find(9)
    UserMailer.event_reg_notice(@user, @event)
  end

  def event_reg_cancel
    @user = User.find(1)
    @event = Event.find(9)
    UserMailer.event_reg_cancel(@user, @event)
  end

  def event_account_creation
    @user = User.find(15)
    UserMailer.event_account_creation(@user)
  end

  def event_acct_creation_notice
    @user = User.find(15)
    UserMailer.event_acct_creation_notice(@user)
  end

  def event_registration_user
    @user = User.find(1)
    @event = Event.find(9)
    UserMailer.event_registration_user(@user, @event)
  end


  def event_cancelation_user
    @user = User.find(1)
    @event = Event.find(9)
    UserMailer.event_cancelation_user(@user, @event)
  end



end