class EventAttendeesController < ApplicationController
  before_action :set_phones, only: [:sendit]
  before_action :require_admin

  	def checkin
      if (logged_in? && current_user.admin?) || (logged_in? && current_user.evt_admin?)
        @event = Event.find(params[:id])
        @users = User.all.order(:lastname)
        @attendees = EventAttendee.where(event_id: @event.id, :canceled => false, :waitlist => false).order(:lastname)
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



    def new
      @eventattendee = EventAttendee.new(:user_id => params[:user_id])
      @user = User.find(params[:user_id])
      @registrations = EventAttendee.where(:user_id => @user.id)
      @events = Event.where.not(:starttime => nil).where("starttime >= ? AND live = ?", Date.today, true)

    end



    def create
      @user = User.find(params['/eventattendees/new'][:user_id])
      @event = Event.find(params['/eventattendees/new'][:event_id])
      @eventattendee = EventAttendee.new(:user_id => @user.id, :lastname => @user.lastname, :event_id => @event.id)
      

      @registrations = EventAttendee.where(event_id: @event.id).where(user_id: @user.id)
      @totalregs = EventAttendee.where(event_id: @event.id).where.not(canceled: true)
      if @registrations.count == 0

          if @totalregs.count < @event.capacity

              if @eventattendee.save
                  # send confirmation emails here
                  @user.send_user_evt_registration(@event) #Email to User Registered
                  #@user.send_event_reg_internal_notice(@event) #internal Notification 
                  
                  flash[:success] = "User Registration has been saved and notification has been emailed for #{@event.name}."
                  redirect_to user_path(@user)
              else
                  flash[:danger] = "This user is already registered for this event"
                  redirect_to user_path(@user)
              end
          
          else #waitlist

              @eventattendee.waitlist = true
              # waitlist logic here, has account, never registered previously
              
              if @eventattendee.save
                  # send waitlist confirmation email to user
                  #@user.send_user_evt_registration(@event) #Email to User Registered
                  flash[:success] = "Waitlist addition has been saved and notification has been emailed for #{@event.name}."
                  redirect_to user_path(@user)
              else
                  flash[:danger] = "This user may already be registered for this event"
                  redirect_to user_path(@user)
              end


          end
      
      else

          if @totalregs.count < @event.capacity

              if @registrations.first.canceled == true 
                @registrations.first.toggle!(:canceled)
                @user.send_user_evt_registration(@event) #Email to User Registered
                flash[:success] = "User Registration has been saved and notification has been emailed for #{@event.name}."
                redirect_to user_path(@user)
              else
                flash[:danger] = "User is already registered for #{@event.name}."
                redirect_to user_path(@user)
              end

          else #waitlist

              if @registrations.first.canceled == true 
                @registrations.first.toggle!(:canceled)
                @registrations.first.toggle!(:waitlist)
                # send waitlist confirmation email to user
                flash[:success] = "User Registration has been updated and waitlist notification has been emailed for #{@event.name}."
                redirect_to user_path(@user)
              else
                flash[:danger] = "This user may already be registered for this event"
                redirect_to user_path(@user)
              end

          end

      end

      # render 'new', params: {user_id: @user.id}
     
    end



    private 

    # def send_blowio(message, number)
    #   blowerio = RestClient::Resource.new(ENV['BLOWERIO_URL'])
    #   blowerio['/messages'].post :to => number, :message => message
    # end

    def ea_params
        params.require(:eventattendee).permit(:user_id, :event_id, :lastname, :checked_in, :canceled, :waitlist)
    end

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


    def require_admin
      if (logged_in? and (!current_user.admin? && !current_user.evt_admin?)) || !logged_in? 
          flash[:danger] = "Only admin users can perform that action"
          redirect_to root_path
      end
  end
      

end