class UserMailerPreview < ActionMailer::Preview
  
  def cert_complete
  	UserMailer.cert_complete
  end

  def cert_notice
  	UserMailer.cert_notice
  end

  def rau_notice
  	UserMailer.rau_notice
  end

  def register_notice
  	UserMailer.register_notice
  end

  def partner_register_notice
  	UserMailer.partner_register_notice
  end

end