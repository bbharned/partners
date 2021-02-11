class UserMailer < ApplicationMailer
    default from: 'ThinManager Partners Portal'
 
  def password_reset(user)
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: 'bharned@thinmanager.com',
                         password: password,
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @user.email, from: 'ThinManager Partner Portal', subject: 'Password Reset', delivery_method_options: delivery_options)
  end



  def cert_notice(user, score, wrongs) #remove (user) for preview
    #@user = User.find(15) #for preview at http://localhost:3000/rails/mailers/user_mailer/cert_notice
    @score = score
    @user = user
    @wrongs = wrongs
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: 'bharned@thinmanager.com',
                         password: password,
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'bbharned@gmail.com', from: 'ThinManager Partner Portal', subject: 'SI Certification Notice', delivery_method_options: delivery_options)
  end


  def zap_zap(user) #remove (user) for preview
    #@user = User.find(15) #for preview at http://localhost:3000/rails/mailers/user_mailer/cert_notice
    @user = user
    delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: 'bharned@thinmanager.com',
                         password: password,
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: 'y2odhwtw@robot.zapier.com', from: 'ThinManager Partner Portal', subject: 'Recertification', delivery_method_options: delivery_options)
  end


  
private
    def password
      password = "Corv3tt3"
    end


end