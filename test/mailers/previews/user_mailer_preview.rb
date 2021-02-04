class UserMailerPreview < ActionMailer::Preview
  
  def cert_notice
  	UserMailer.with(user: User.first).cert_notice
  end

end