class EventsController < ApplicationController
	before_action :require_admin, except: [:index, :show, :register, :reg_cancel, :hosted]
	before_action :set_event, only: [:edit, :update, :show, :register], except: [:destroy_reg]
    before_action :require_host, only: :hosted


def index
	@sort = [params[:sort]]
    @events = Event.paginate(page: params[:page], per_page: 25).order(@sort)
    @evtcategories = Evtcategory.where(private: false)
end



def new
    if params[:name] != nil
        @name = "#{params[:name]} (copy)"
    else
        @name = ""
    end
    
    @event = Event.new(:name => @name, :description => params[:description], :starttime => params[:starttime], :endtime => params[:endtime], :cost => params[:cost], :capacity => params[:capacity], :event_contact => params[:event_contact], :event_email => params[:event_email], :event_host => params[:event_host], :event_phone => params[:event_phone], :event_image => params[:event_image], :tzid => params[:tzid], :private => params[:private], :virtual => params[:virtual], :viewer => params[:viewer])
    @venues = Venue.all

end

def show

    require 'icalendar/tzinfo'

    # if statement for iCal
    if @event.starttime != nil && @event.starttime != "" && @event.endtime != nil && @event.endtime != ""

        @ical = Icalendar::Calendar.new
        @zones = TZInfo::Timezone.all_identifiers

      @tzid = @event.tzid 
      #@tzid = "Africa/Accra"
      @tz = TZInfo::Timezone.get(@tzid)

      # new icalendar event 
        event = Icalendar::Event.new

      # event start date
        event.dtstart = Icalendar::Values::DateTime.new @event.starttime, 'tzid' => @tzid

      # event end date
        event.dtend = Icalendar::Values::DateTime.new @event.endtime, 'tzid' => @tzid

      # event organizer
        event.organizer = Icalendar::Values::CalAddress.new("mailto:" + @event.event_email)

      # event created date
        event.created = DateTime.now

      # event location
        if @event.venues.any?
          event.location =  @event.venues[0].name
        end

      # if there's an external link e.g, google meet
        if @event.evt_link != "" && @event.evt_link != nil
            event.uid = event.url = @event.evt_link
        end


      # event title
        event.summary = @event.name


      # event description
        event.description = @event.description


      # attach the configured event to icalendar class
        @ical.add_event(event)

        @ical.publish
        @cal_string = @ical.to_ical

    end
    # end if    
    
    if (current_user == nil && !@event.live) || (current_user != nil && !current_user.admin? && !current_user.evt_admin && !@event.live)
        flash[:warning] = "You can not view this event."
        redirect_to events_path
    elsif (current_user == nil && @event.starttime < Date.today) || (current_user != nil && !current_user.admin? && !current_user.evt_admin && @event.starttime < Date.today && @event.viewer != current_user.email)
        flash[:warning] = "You can not view this event."
        redirect_to events_path

    else
        
        @full = false
        if current_user
            @registration = EventAttendee.where(:event_id => @event.id, :user_id => current_user.id).where.not(canceled: true).first
        end

        if @registration != nil && @registration.waitlist == true
            @iswaitlisted = true
        else
            @iswaitlisted = false
        end
        
        @allregistered = EventAttendee.where(:event_id => @event.id).where.not(:canceled => true).where.not(:waitlist => true)
        if ((@allregistered.any? && @allregistered.count >= @event.capacity) || (!@allregistered.any? && @event.capacity == 0))
            @full = true
        end

        if @event.capacity != nil && @event.capacity != ""
            if @event.capacity > 0
                @spotsleft = @event.capacity - @allregistered.count
            else
                @spotsleft = 0
            end
        else
            @spotsleft = 0
        end

        @canceled = EventAttendee.where(:event_id => @event.id).where(:canceled => true)
        @waitlist = EventAttendee.where(event_id: @event.id).where.not(canceled: true).where.not(waitlist: false).order(:updated_at)

        @evtusers = []
        if @allregistered.any?
            @allregistered.each do |u|
                if !u.canceled
                    @evtusers.push u.user_id
                end
            end
        end

        @waitlisters = []
        if @waitlist.any?
            @waitlist.each do |w|
                if !w.canceled
                    @waitlisters.push w.user_id
                end
            end
        end

        @passedcert = []
        if @allregistered.any?
            @allregistered.each do |w|
                if w.passed
                    @passedcert.push w.user_id
                end
            end
        end
        
        @allusers = User.where(id: @evtusers)
        @waitlistusers = User.where(id: @waitlisters)
        @passedcertusers = User.where(id: @passedcert)

        respond_to do |format|
            format.html { render "show" }
            #format.csv { send_data @allusers.to_csv, filename: "Registration_#{@event.name}-#{@event.starttime}.csv" }
            #format.csv { send_data @waitlist.to_csv, filename: "Waitlist_#{@event.name}-#{@event.starttime}.csv" }
            format.csv do 
                if (params[:format_data] == 'registered')
                  send_data @allusers.to_csv, filename: "Registration_#{@event.name}-#{@event.starttime}.csv"
                elsif (params[:format_data] == 'waitlist')
                  send_data @waitlistusers.to_csv, filename: "Waitlist_#{@event.name}-#{@event.starttime}.csv" 
                elsif (params[:format_data] == 'passed')
                  send_data @passedcertusers.to_csv, filename: "Certified From_#{@event.name}-#{@event.starttime}.csv"  
                end
              end
            format.ics { send_data @cal_string, filename: "#{@event.name}.ics"}
        end
    end
    
end


def fill_event
    
    @event = Event.find(params[:id])
    @registered = EventAttendee.where(event_id: @event.id).where.not(canceled: true).where.not(waitlist: true)
    @spots = @event.capacity - @registered.count
    @waitlist = EventAttendee.where(event_id: @event.id).where.not(canceled: true).where.not(waitlist: false).order(:updated_at)
    @wcount = @waitlist.count
    
    if @waitlist.count >= @spots
        @waitlist.each_slice(@spots) do | wl |
            wl.each do |u| 
                @user = u.user
                u.toggle!(:waitlist)
                # send Waitlist emails
                @user.send_user_evt_registration(@event)
            end
        end
        flash[:success] = "Filled #{@spots} spots"
    elsif @waitlist.count < @spots
        @waitlist.each do |w|
            @user = w.user
            w.toggle!(:waitlist)
            # send Waitlist emails
            @user.send_user_evt_registration(@event)
        end
        flash[:success] = "Filled #{@wcount} spots"
    end

    redirect_to event_path(@event)

end


def waitlist_check(event)
    @capacity = event.capacity
    @registered = EventAttendee.where(event_id: event.id).where.not(canceled: true).where.not(waitlist: true)
    if @registered.count < @capacity
        @waitlist = EventAttendee.where(event_id: event.id).where.not(canceled: true).where.not(waitlist: false).order(:updated_at)
        if @waitlist.any?
            @change = @waitlist.first
            @user = @change.user
            @change.waitlist = false
            if @change.save
                # send emails to change user for coming off the waitlist
                @user.send_user_evt_registration(event)
                @user.send_event_reg_waitlist_auto_internal_notice(event)
            else
                puts "registration from waitlist didnt change"
            end
        end 
        return
    end
end

def passed
    @attendee = EventAttendee.where(event_id: params[:event_id], user_id: params[:user_id])
    @attendee.first.toggle!(:passed)
    redirect_to checkin_path(params[:event_id])
end

def reg_cancel
    @event = Event.find(params[:id])
    @attendee = EventAttendee.where(event_id: @event.id, user_id: params[:user_id]).first
    @user = User.find(@attendee.user_id)
    @allregistered = EventAttendee.where(event_id: @event).where.not(canceled: true).where.not(waitlist: true)
    @waitlist = EventAttendee.where(event_id: @event.id).where.not(canceled: true).where.not(waitlist: false)
    
    if @attendee.canceled == true && (@allregistered.count >= @event.capacity) # re-enrolling but at capacity

        # flash[:danger] = "This event has reached capacity"
        # redirect_to event_path(@event)
        @attendee.toggle!(:canceled)
        @attendee.waitlist = true
        if @attendee.save
            # send email of waitlisted user
            @user.send_user_evt_waitlist(@event) # waitlisted user email - external
            @user.send_event_reg_waitlist_internal_notice(@event) # waitlisted user - internal notification
            flash[:success] = "Since the event is full, you have been moved to the waitlist for #{@event.name}"
            redirect_to user_path(@user)
        else
            flash[:danger] = "Something didnt quite work correctly"
            redirect_to user_path(@user)
        end
        

    elsif @attendee.canceled == true && (@allregistered.count < @event.capacity) # re-enrolling still room

        
        @attendee.toggle!(:canceled)
        @attendee.waitlist = false
        if @attendee.save
            @user.send_user_evt_registration(@event)
            @user.send_event_reg_internal_notice(@event)
            flash[:success] = "You have been registered for #{@event.name}"
            redirect_to user_path(@user)
        else
            flash[:danger] = "Something didnt quite work correctly"
            redirect_to user_path(@user)
        end
        

    else
        #was enrolled and now canceling
        
        @attendee.toggle!(:canceled)
        @attendee.waitlist = false
        if @attendee.save
            #email notices
            @user.send_event_reg_cancel(@event)
            @user.send_event_canceled_internal_notice(@event)
            flash[:success] = "Your Registration change request has completed."
            self.waitlist_check(@event)
            redirect_to event_path(@event)
        else
            flash[:danger] = "Something didnt quite work correectly"
            redirect_to event_path(@event)
        end

    end

    
end



def admin

    @filterrific = initialize_filterrific(
     Event,
     params[:filterrific],
      select_options: {
        sort_this: Event.options_for_sort_this,
        with_evtcategory: Evtcategory.options_for_select,
        with_tag: Tag.options_for_select,
        with_venue: Venue.options_for_select,
        with_state: ['Upcoming Events', 'Past Events'],
        with_live_status: ['Live Events', 'Draft Events'],
        by_year: ['2024', '2023', '2022', '2021'],
        as_archived: ['Not Archived', 'Archived', 'All'],
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:sort_this, :with_search, :with_evtcategory, :with_live, :with_state, :with_live_status, :with_tag, :with_venue, :by_year, :as_archived],
      sanitize_params: true,
   ) or return
   @events = @filterrific.find.paginate(page: params[:page], per_page: 10)

   respond_to do |format|
     format.html
     format.js
   end

   rescue ActiveRecord::RecordNotFound => e
     # There is an issue with the persisted param_set. Reset it.
     puts "Had to reset filterrific params: #{e.message}"
     redirect_to(reset_filterrific_url(format: :html)) && return
    
    
end



def edit
    @venues = Venue.all

end



def update
    if @event.update(event_params)
        flash[:success] = "Event was successfully updated"
        redirect_to event_path(@event)
    else
        render 'edit'
    end
end




def create
    @event = Event.new(event_params)

    if @event.save
        flash[:success] = "Event has been created and saved"
        redirect_to event_admin_path
    else
        render 'new'
    end
end


def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:danger] = "Event has been deleted"
    redirect_to events_path
end



def register
    if current_user && @event.reg_required
        @user = User.find(params[:user_id])
        @registration = EventAttendee.where(event_id: @event.id).where(user_id: current_user.id) 
        @totalregs = EventAttendee.where(event_id: @event.id).where.not(canceled: true).where.not(waitlist: true)  
        if @registration.count == 0

            if @totalregs.count < @event.capacity

                @register = EventAttendee.new(:event_id => @event.id, :user_id => current_user.id, :lastname => current_user.lastname)
                if @register.save
                    # send confirmation emails here
                    current_user.send_user_evt_registration(@event)
                    current_user.send_event_reg_internal_notice(@event) 
                    current_user.send_event_reminder(@event)
                    flash[:success] = "You have been registered for #{@event.name}"
                    redirect_to user_path(current_user)
                else
                    flash[:danger] = "You appear to already be registered for this event"
                    redirect_to user_path(current_user)
                end
            
            else

                # add waitlist logic here
                @register = EventAttendee.new(:event_id => @event.id, :user_id => current_user.id, :lastname => current_user.lastname, :waitlist => true)
                
                if @register.save
                    # send waitlist emails here
                    @user.send_user_evt_waitlist(@event) # waitlisted user email - external
                    @user.send_event_reg_waitlist_internal_notice(@event) # waitlisted user - internal notification
                    flash[:success] = "You have been added to the waitlist for #{@event.name}"
                    redirect_to user_path(current_user)
                else
                    flash[:danger] = "You appear to already be registered or on the waitlist for this event"
                    redirect_to user_path(current_user)
                end

                # flash[:danger] = "This event has reached capacity"
                # redirect_to event_path(@event)

            end
        
        else

            if @totalregs.count < @event.capacity

                @registration.first.toggle!(:canceled)
                @user.send_user_evt_registration(@event)
                @user.send_event_reg_internal_notice(@event)
                @user.send_event_reminder(@event)
                flash[:success] = "You have been registered for #{@event.name}"
                redirect_to user_path(current_user)

            else

                # add waitlist logic here
                @registration.first.toggle!(:canceled)
                @registration.first.toggle!(:waitlist)
                # send waitlist emails
                @user.send_user_evt_waitlist(@event) # waitlisted user email - external
                @user.send_event_reg_waitlist_internal_notice(@event) # waitlisted user - internal notification
                flash[:success] = "You have been added to the waitlist for #{@event.name}"
                redirect_to user_path(current_user)

            end

        end

    elsif !current_user && @event.reg_required
        flash[:warning] = "You must have an account and be logged in to register for events. Please create your account"
        redirect_to evt_path(@event) 
    else
        redirect_to event_path(@event)
    end

    
end



def hosted

end




private

	def event_params
        params.require(:event).permit(:name, :live, :archive, :description, :starttime, :endtime, :cost, :capacity, :event_contact, :event_email, :event_host, :event_phone, :event_image, :private, :virtual, :viewer, :evt_link, :reg_required, :tzid, :survey_id, evtcategory_ids: [], venue_ids: [], tag_ids: [])
    end


    def set_event
        @event = Event.find(params[:id])
    end

    def require_host
        if logged_in? and has_events.count < 1
            flash[:danger] = "You are not permitted to view that page. You are not the host of any events."
            redirect_to root_path
        end
    end


	def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.evt_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end