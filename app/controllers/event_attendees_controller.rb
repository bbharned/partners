class EventAttendeesController < ApplicationController
  before_action :set_phones, only: [:sendit]

  	def checkin
      if (logged_in? && current_user.admin?) || (logged_in? && current_user.evt_admin?)
        @event = Event.find(params[:id])
        @users = User.all.order(:lastname)
        @attendees = EventAttendee.where(event_id: @event.id, :canceled => false).order(:lastname)
      else
        @event = Event.find(params[:id])
        flash[:danger] = "Only admins can perform that action"
        redirect_to event_path(@event)
      end
    end


    def attended
    	@attendee = EventAttendee.where(event_id: params[:event_id], user_id: params[:user_id])
      @attendee.first.toggle!(:checkedin)
      redirect_to checkin_path(params[:event_id])
    end

    def sms 
      if (logged_in? && current_user.admin?) || (logged_in? && current_user.evt_admin?)
        @event = Event.find(params[:id])
        @attendees = EventAttendee.where(event_id: @event.id).where.not(:canceled => true)
        @evt_users = []
        @attendees.each do |u|
          @user = User.find(u.user_id)
          @evt_users.push @user
        end
        #@evt_users = User.where(id: @attendees.user_ids)
        # @phones = []
        # @evt_users.each do |role|
        #   if role.cell != nil && role.cell != ""
        #     @phones.push role.cell
        #   end
        # end
      else
        @event = Event.find(params[:id])
        flash[:danger] = "Only admins can perform that action"
        redirect_to event_path(@event)
      end
    end

    def sendit
      
      @message = params[:message][:sms_message]
      @subject = params[:message][:sms_subject]
      @event = Event.find(params[:id])
      @attendees = EventAttendee.where(event_id: @event.id).where.not(canceled: true)
      @evt_users = []
      @attendees.each do |u|
        @user = User.find(u.user_id)
        @evt_users.push @user
      end
      if @evt_users.any? 
        @evt_users.each do |attendee|
          if (attendee.cell != nil && attendee.cell != "") && (attendee.carrier != nil && attendee.carrier != "")
            send_sms(attendee.cell, @subject, attendee.carrier, @message)
          end
        end
      end
      flash[:success] = "Your SMS messages were sent"
      redirect_to event_path(@event)
      
    end


    def destroy
      @registration = EventAttendee.find(params[:reg])
      @event = Event.find(@registration.event_id)
      @registration.destroy
      # send confirmation email of registration deleted?
      flash[:danger] = "Registration has been deleted"
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
        @evt_users = User.where(id: @attendees.ids)
        #@evt_users = Attendee.where(id: @attendees.ids)
        @phones = []
        @evt_users.each do |role|
          if (role.cell != nil && role.cell != "") && (role.carrier != nil && role.carrier != "")
            @phones.push role.cell
          end
        end
    end
      

end