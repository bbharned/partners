class UserMailer < ApplicationMailer
    default from: 'ThinManager Partners Portal'
 
  def password_reset(user)
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @user.email, from: 'ThinManager Partner Portal', subject: 'Password Reset', delivery_method_options: delivery_options)
  end

  # for preview at http://localhost:3000/rails/mailers/user_mailer/


  def cert_notice(user, score, wrongs) #remove (user, score, wrongs) for preview
    # @user = User.find(15) 
    # @score = 8
    # @wromgs = [2,4]
    @score = score
    @user = user
    @wrongs = wrongs
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'certification@thinmanager.com', from: 'ThinManager Partner Portal', subject: 'SI Certification Notice', delivery_method_options: delivery_options)
  end


  def zap_zap(user) #remove (user) for preview
    #@user = User.find(15) 
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'lcu069c2@robot.zapier.com', from: 'ThinManager Partner Portal', subject: 'Recertification', delivery_method_options: delivery_options)
  end


  def cert_complete(user) #remove (user) for preview
    # @user = User.find(15) #make user for production
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @user.email, from: 'ThinManager Partner Portal', subject: 'Congratulations on Recertification', delivery_method_options: delivery_options)
  end
  

  def rau_notice(user)
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'certification@thinmanager.com', from: 'ThinManager Portal', subject: 'ThinManager Portal Registration - RAU', delivery_method_options: delivery_options)
  end


  def register_notice(user)
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'certification@thinmanager.com', from: 'ThinManager Portal', subject: 'ThinManager Portal Registration', delivery_method_options: delivery_options)
  end


  def partner_register_notice(user)
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @user.email, from: 'ThinManager Portal', subject: 'Thank You for Registering for the ThinManager Portal', delivery_method_options: delivery_options)
  end

  def lab_upload_notice(user)
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'certification@thinmanager.com', from: 'ThinManager Portal', subject: 'ThinManager Lab Uploaded for certification', delivery_method_options: delivery_options)
  end








end