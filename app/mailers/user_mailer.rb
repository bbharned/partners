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
    mail(to: 'certification@thinmanager.com', from: 'ThinManager Portal', subject: 'SI Certification Notice', delivery_method_options: delivery_options)
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
    mail(to: 'lcu069c2@robot.zapier.com', from: 'ThinManager Portal', subject: 'Recertification', delivery_method_options: delivery_options)
  end

  def zap_user_signup(user) 
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'gsf45wh0@robot.zapier.com', from: 'ThinManager Portal', subject: 'new portal user', delivery_method_options: delivery_options)
  end

  def zap_lab_upload(user) 
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: '3y8zssc4@robot.zapier.com', from: 'ThinManager Portal', subject: 'new lab upload', delivery_method_options: delivery_options)
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


  def learning_register_notice(user)
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @user.email, from: 'ThinManager Portal', subject: 'Thank You for Registering for Video Learning in the ThinManager Portal', delivery_method_options: delivery_options)
  end

  def learning_acct_notice_internal(user)
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'certification@thinmanager.com', from: 'ThinManager Portal', subject: 'Video Learning Account Created', delivery_method_options: delivery_options)
  end

  def badge_earned(user, specific, badge)
    @user = user
    @specific = specific
    @badge = badge
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @user.email, from: 'ThinManager Portal', subject: 'ThinManager Video Training... Wow!', delivery_method_options: delivery_options)
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

  def send_download_ext_notice(user)
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @user.email, from: 'ThinManager Portal', subject: 'Thank you for downloading ThinManager', delivery_method_options: delivery_options)
  end

  def send_download_int_notice(user)
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'certification@thinmanager.com', from: 'ThinManager Portal', subject: 'ThinManager Download in the Portal', delivery_method_options: delivery_options)
  end

  
  def zap_user_download(user) 
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'mccu9jlk@robot.zapier.com', from: 'ThinManager Portal', subject: 'portal user download', delivery_method_options: delivery_options)
  end

  def event_reg_notice(user, event) #done
    @user = user
    @event = event
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'events@thinmanager.com', from: 'ThinManager Portal', subject: 'Event Registration', delivery_method_options: delivery_options)
  end

  def event_reg_cancel(user, event) #done
    @user = user
    @event = event
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'events@thinmanager.com', from: 'ThinManager Portal', subject: 'Event Registration Cancellation', delivery_method_options: delivery_options)
  end

  def event_acct_creation_notice(user) #done
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'events@thinmanager.com', from: 'ThinManager Portal', subject: 'Event Account Created', delivery_method_options: delivery_options)
  end


  def event_account_creation(user) 
    @user = user
    #@user = User.find(1)
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @user.email, from: 'ThinManager Portal', subject: 'Thank You for Creating Your Account', delivery_method_options: delivery_options)
  end


  def event_registration_user(user, event)
    @user = user
    @event = event

    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @user.email, from: 'ThinManager Portal', subject: 'You Are Registered!', delivery_method_options: delivery_options)
  end


  def event_cancelation_user(user, event) 
    @user = user
    #@user = User.find(1)
    @event = event
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @user.email, from: 'ThinManager Portal', subject: 'Sorry You Had to Cancel', delivery_method_options: delivery_options)
  end

  def event_reminder(user, event)
    @user = user
    @event = event
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @user.email, from: 'ThinManager Events', subject: 'Upcoming ThinManager Training', delivery_method_options: delivery_options)
  end


  def license_notification(user, license)
    @user = user
    @license = license
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'certification@thinmanager.com', from: 'ThinManager Portal', subject: 'License Request Has Been Received', delivery_method_options: delivery_options)
  end



  def license_request_confirmation(user)
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @user.email, from: 'ThinManager Portal', subject: 'License Request Has Been Received', delivery_method_options: delivery_options)
  end


  def listing_notification(user, listing)
    @user = user
    @listing = listing
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'certification@thinmanager.com', from: 'ThinManager Portal', subject: 'New Web Listing Request Received', delivery_method_options: delivery_options)
  end


end