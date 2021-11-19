class VenuesController < ApplicationController
	before_action :require_admin
	before_action :set_type, only: [:edit, :update, :show]




def index
	@venues = Venue.all
end








private

	def venue_params
        params.require(:venue).permit(:name, :street, :city, :state, :zipcode, :url)
    end


    def set_type
        @venue = Venue.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.evt_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end