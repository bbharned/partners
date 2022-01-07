class EventsController < ApplicationController
	before_action :require_admin, except: [:index, :show, :register]
	before_action :set_event, only: [:edit, :update, :show, :register]


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
    if current_user
        @registration = EventAttendee.where(:event_id => @event.id, :user_id => current_user.id).first
    end
    @allregistered = EventAttendee.where(:event_id => @event.id)
end


def admin
    @events = Event.all
end



def edit
    @venues = Venue.all

end



def update
    if @event.update(event_params)
        flash[:success] = "Event was successfully updated"
        redirect_to events_path
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
        @register = EventAttendee.new(:event_id => @event.id, :user_id => current_user.id, :lastname => current_user.lastname)
        if @register.save
            flash[:success] = "You have been registered for #{@event.name}"
            redirect_to event_path(@event)
        else
            flash[:danger] = "You appear to already be registered for this event"
            redirect_to event_path(@event)
        end
    else
        flash[:warning] = "You must be logged in to register for events"
        # add path to create account for events
        redirect_to login_path
    end

    
end





private

	def event_params
        params.require(:event).permit(:name, :live, :description, :starttime, :endtime, :cost, :capacity, :event_contact, :event_email, :event_host, :event_phone, :event_image, :private, :virtual, evtcategory_ids: [], venue_ids: [], tag_ids: [])
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