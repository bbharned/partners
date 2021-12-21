class EventAttendeesController < ApplicationController
  before_action :set_phones, only: [:sendit]

  	def checkin
      if (logged_in? && current_user.admin?) || (logged_in? && current_user.evtadmin?)
        @event = Event.find(params[:id])
        @users = Attendee.all.order(:lastname)
        @attendees = EventAttendee.where(event_id: @event.id).order(:lastname)
      else
        flash[:danger] = "Only admins can perform that action"
        redirect_to events_path
      end
    end


    def attended
    	@attendee = EventAttendee.where(event_id: params[:event_id], attendee_id: params[:attendee_id])
      @attendee.first.toggle!(:checkedin)
      redirect_to checkin_path(params[:event_id])
    end

    def sms 
      if (logged_in? && current_user.admin?) || (logged_in? && current_user.evtadmin?)
        @event = Event.find(params[:id])
        @attendees = EventAttendee.where(event_id: @event.id).order(:lastname)
        @evt_users = Attendee.where(id: @attendees.ids)
        @phones = []
        @evt_users.each do |role|
          if role.phone != nil && role.phone != ""
            @phones.push role.phone
          end
        end
      else
        flash[:danger] = "Only admins can perform that action"
        redirect_to events_path
      end
    end

    def sendit
      
      @message = params[:message][:sms_message]
      @subject = params[:message][:sms_subject]
      @event = Event.find(params[:id])
      
      @evt_users.where.not(carrier: "").each do |attendee|
        if (attendee.phone != nil || attendee.phone != "") && attendee.carrier != nil
          send_sms(attendee.phone, @subject, attendee.carrier, @message)
        end
      end

      flash[:success] = "Your SMS messages were sent"
      redirect_to event_path(@event)
      
    end



    private 

    # def send_blowio(message, number)
    #   blowerio = RestClient::Resource.new(ENV['BLOWERIO_URL'])
    #   blowerio['/messages'].post :to => number, :message => message
    # end

    def send_sms(number, subject, carrier, message)
      SMSMailer.sms_mailer(number, subject, carrier, message).deliver_now
    end

    def set_phones
        @event = Event.find(params[:id])
        @attendees = EventAttendee.where(event_id: @event.id).order(:lastname)
        @evt_users = Attendee.where(id: @attendees.ids)
        @evt_users = Attendee.where(id: @attendees.ids)
        @phones = []
        @evt_users.each do |role|
          if role.phone != nil && role.phone != ""
            @phones.push role.phone
          end
        end
    end
      

end