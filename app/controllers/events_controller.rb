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
    
    @event = Event.new(:name => @name, :description => params[:description], :starttime => params[:starttime], :endtime => params[:endtime], :cost => params[:cost], :capacity => params[:capacity], :event_contact => params[:event_contact], :event_email => params[:event_email], :event_host => params[:event_host], :event_phone => params[:event_phone], :event_image => params[:event_image], :private => params[:private], :virtual => params[:virtual], :viewer => params[:viewer])
    @venues = Venue.all

end

def show

    require 'icalendar'

# if statement for iCal
if @event.starttime != nil && @event.starttime != "" && @event.endtime != nil && @event.endtime != ""

    @ical = Icalendar::Calendar.new

    @ical.event do |e|
      e.dtstart     = Icalendar::Values::DateTime.new(@event.starttime)
      e.dtend       = Icalendar::Values::DateTime.new(@event.endtime)
      e.summary     = @event.name
      e.description = @event.description
      if @event.venues.any?
          e.location = @event.venues[0].name
      end
      if @event.event_host != ""
          e.organizer = @event.event_host
      end
      if @event.evt_link != "" && @event.evt_link != nil
        e.url = @event.evt_link
      end
      
      @ical.timezone do |t|
      t.tzid = "America/New_York"

      t.daylight do |d|
        d.tzoffsetfrom = "-0500"
        d.tzoffsetto   = "-0600"
        d.tzname       = "EDT"
        d.dtstart      = "19700308T020000"
        d.rrule        = "FREQ=YEARLY;BYMONTH=3;BYDAY=2SU"
      end

      t.standard do |s|
        s.tzoffsetfrom = "-0400"
        s.tzoffsetto   = "-0500"
        s.tzname       = "EST"
        s.dtstart      = "19701101T020000"
        s.rrule        = "FREQ=YEARLY;BYMONTH=11;BYDAY=1SU"
      end
    end

      e.ip_class = "PRIVATE"
    end

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
        if logged_in?
            @registration = EventAttendee.where(:event_id => @event.id, :user_id => current_user.id, :canceled => false).first
        end
        
        @allregistered = EventAttendee.where(:event_id => @event.id).where.not(:canceled => true)
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

        @evtusers = []
        if @allregistered.any?
            @allregistered.each do |u|
                if !u.canceled
                    @evtusers.push u.user_id
                end
            end
        end
        
        @allusers = User.where(id: @evtusers)


        respond_to do |format|
            format.html { render "show" }
            format.csv { send_data @allusers.to_csv, filename: "Registration_#{@event.name}-#{@event.starttime}.csv" }
            format.ics { send_data @cal_string, filename: "#{@event.name}.ics"}
        end
    end
    
end


def reg_cancel
    @event = Event.find(params[:id])
    @attendee = EventAttendee.where(event_id: @event.id, user_id: params[:user_id]).first
    @user = User.find(@attendee.user_id)
    @allregistered = EventAttendee.where(event_id: @event, canceled: false)
    #@e = Event.find(@event.to_i)
    
    if @attendee.canceled? && (@allregistered.count >= @event.capacity)

        flash[:danger] = "This event has reached capacity"
        redirect_to event_path(@event)

    elsif @attendee.canceled? && (@allregistered.count < @event.capacity)

        #@user = User.find(@attendee.first.user_id)
        @attendee.toggle!(:canceled)
        @user.send_user_evt_registration(@event)
        @user.send_event_reg_internal_notice(@event)
        flash[:success] = "You have been registered for #{@event.name}"
        redirect_to user_path(@user)

    else

        
        @attendee.toggle!(:canceled)
        #email notices
        @user.send_event_reg_cancel(@event)
        @user.send_event_canceled_internal_notice(@event)
        
        flash[:success] = "Registration changed"
        redirect_to event_path(@event)

    end

    # @attendee.first.toggle!(:canceled)
    # flash[:success] = "Registration changed"
    # redirect_to event_path(@event)
    
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
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:sort_this, :with_search, :with_evtcategory, :with_live, :with_state, :with_live_status, :with_tag, :with_venue],
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
        @registration = EventAttendee.where(:event_id => @event.id, :user_id => current_user.id)
        @totalregs = EventAttendee.where(:event_id => @event.id, :canceled => false)
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

                flash[:danger] = "This event has reached capacity"
                redirect_to event_path(@event)

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

                flash[:danger] = "This event has reached capacity"
                redirect_to event_path(@event)

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
        params.require(:event).permit(:name, :live, :description, :starttime, :endtime, :cost, :capacity, :event_contact, :event_email, :event_host, :event_phone, :event_image, :private, :virtual, :viewer, :evt_link, :reg_required, :survey_id, evtcategory_ids: [], venue_ids: [], tag_ids: [])
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