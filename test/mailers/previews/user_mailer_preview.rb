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

end