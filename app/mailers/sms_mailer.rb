class SMSMailer < ApplicationMailer
default from: 'ThinManager'

def sms_mailer(number, subject, carrier, message)
	  @carrier = carrier
    @phone = number
    @subject = subject
    @message = message
    
    if carrier == "at&t"
    	@cellco = "@txt.att.net" # possibly @mms.att.net
    
    elsif carrier == "verizon"
    	@cellco = "@vzwpix.com"
    
    elsif carrier == "boost"
    	@cellco = "@myboostmobile.com"
    
    elsif carrier == "cricket"
    	@cellco = "@sms.mycricket.com" # possibly @mms.cricketwireless.net
    
    elsif carrier == "metropcs"
    	@cellco = "@mymetropcs.com"
    
    elsif carrier == "sprint"
    	@cellco = "@messaging.sprintpcs.com" # possibly @pm.sprint.com
    
    elsif carrier == "t-mobile"
    	@cellco = "@tmomail.net"

    end


	delivery_options = { address: 'smtp.gmail.com',
                         port: 587,
                         user_name: ENV["MAIL_USERNAME"],
                         password: ENV["MAIL_PASSWORD"],
                         authentication: 'plain',
                         enable_starttls_auto: true
                          }
    mail(to: @phone + @cellco, from: "ThinManager Events", subject: @subject, delivery_method_options: delivery_options)
  end


  

  end