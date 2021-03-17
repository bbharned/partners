class UserMailerPreview < ActionMailer::Preview
  
  def cert_complete
  	UserMailer.cert_complete
  end

  def cert_notice
  	UserMailer.cert_notice
  end

end