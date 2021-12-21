class EventsController < ApplicationController
	before_action :require_admin, except: [:index, :show]
	before_action :set_event, only: [:edit, :update, :show]


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