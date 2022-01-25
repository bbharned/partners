class EventsController < ApplicationController
	before_action :require_admin, except: [:index, :show, :register, :reg_cancel]
	before_action :set_event, only: [:edit, :update, :show, :register], except: [:destroy_reg]


def index
	@sort = [params[:sort]]
    @events = Event.paginate(page: params[:page], per_page: 25).order(@sort)
    @evtcategories = Evtcategory.all
end



def new
    @event = Event.new
    @venues = Venue.all

end

def show
    
    if (current_user == nil && !@event.live) || (current_user != nil && !current_user.admin? && !current_user.evt_admin && !@event.live)
        flash[:warning] = "You can not view this event."
        redirect_to events_path
    elsif (current_user == nil && @event.starttime < Date.today) || (current_user != nil && !current_user.admin? && !current_user.evt_admin && @event.starttime < Date.today)
        flash[:warning] = "You can not view this event."
        redirect_to events_path
    else
        
        @full = false
        if logged_in?
            @registration = EventAttendee.where(:event_id => @event.id, :user_id => current_user.id, :canceled => false).first
        end
        
        @allregistered = EventAttendee.where(:event_id => @event.id).where.not(:canceled => true)
        if @allregistered.any? && @allregistered.count >= @event.capacity
            @full = true
        end

        @canceled = EventAttendee.where(:event_id => @event.id).where(:canceled => true)

        @evtusers = []
        if @allregistered.any?
            @allregistered.each do |u|
                @evtusers.push u.user_id
            end
        end
        
        @allusers = User.where(id: @evtusers)


        respond_to do |format|
            format.html { render "show" }
            format.csv { send_data @allusers.to_csv, filename: "Registration_#{@event.name}-#{Date.today}.csv" }
        end
    end
    
end


def reg_cancel
    @event = params[:id]
    @attendee = EventAttendee.where(event_id: @event, user_id: params[:user_id])
    @attendee.first.toggle!(:canceled)
    flash[:success] = "Registration changed"
    redirect_to event_path(@event)
    #redirect_back
end



def admin

    @filterrific = initialize_filterrific(
     Event,
     params[:filterrific],
      select_options: {
        sorted_by: Event.options_for_sorted_by,
        with_evtcategory: Evtcategory.options_for_select,
        with_tag: Tag.options_for_select,
        with_venue: Venue.options_for_select,
        with_state: ['Upcoming Events', 'Past Events'],
        with_live_status: ['Live Events', 'Draft Events'],
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:sorted_by, :with_search, :with_evtcategory, :with_live, :with_state, :with_live_status, :with_tag, :with_venue],
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
        redirect_to events_path
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
    if current_user
        @registration = EventAttendee.where(:event_id => @event.id, :user_id => current_user.id)
        if @registration == nil

            @register = EventAttendee.new(:event_id => @event.id, :user_id => current_user.id, :lastname => current_user.lastname)
            if @register.save
                # send confirmation emails here 
                flash[:success] = "You have been registered for #{@event.name}"
                redirect_to user_path(current_user)
            else
                flash[:danger] = "You appear to already be registered for this event"
                redirect_to user_path(current_user)
            end
        
        else

            @registration.first.toggle!(:canceled)
            flash[:success] = "You have been registered for #{@event.name}"
            redirect_to user_path(current_user)

        end

    else
        flash[:warning] = "You must have an account and be logged in to register for events. Please create your account"
        redirect_to evt_path(@event)
    end

    
end





private

	def event_params
        params.require(:event).permit(:name, :live, :description, :starttime, :endtime, :cost, :capacity, :event_contact, :event_email, :event_host, :event_phone, :event_image, :private, :virtual, :viewer, evtcategory_ids: [], venue_ids: [], tag_ids: [])
    end


    def set_event
        @event = Event.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.evt_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end