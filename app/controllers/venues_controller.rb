class VenuesController < ApplicationController
	before_action :require_admin
	before_action :set_venue, only: [:edit, :update, :show]




def index
	@current_user = current_user
	@venues = Venue.all
end



def new
	@venue = Venue.new
end



def edit

end



def create
	@venue = Venue.new(venue_params)

    if @venue.save
        flash[:success] = "New Venue has been created"
        redirect_to venues_path
    else
        render 'new'
    end
end



def update
	if @venue.update(venue_params)
        flash[:success] = "Venue information was successfully updated"
        redirect_to venues_path
    else
        render 'edit'
    end
end



def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy
    flash[:danger] = "Venue has been deleted"
    redirect_to venues_path
end


def show
	@current_user = current_user
    @evtcategories = Evtcategory.all
    @events = EventVenue.where(venue_id: [@venue.id])
end



private

	def venue_params
        params.require(:venue).permit(:name, :street, :city, :state, :zipcode, :url, :image_link, :description)
    end


    def set_venue
        @venue = Venue.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.evt_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end