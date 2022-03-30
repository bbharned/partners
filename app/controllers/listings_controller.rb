class ListingsController < ApplicationController
	before_action :require_admin, except: [:new, :create, :show]
	before_action :set_listing, only: [:edit, :update, :show]


def index
	@listings = Listing.all
end


def new
	@listing = Listing.new(:user_id => params[:user_id], :firstname => params[:firstname])
	@companies = Company.all.order(:name)
end


def show

end



def edit
	@companies = Company.all.order(:name)
end



def update
    if @listing.update(listing_params)
        flash[:success] = "Listing was successfully updated"
        redirect_to listings_path
    else
        render 'edit'
    end
end




def create
    @listing = Listing.new(listing_params)

    if @listing.save
        flash[:success] = "Listing has been created and saved"
        redirect_to listings_path
    else
        render 'new'
    end
end


def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    flash[:danger] = "Listing has been deleted"
    redirect_to listings_path
end







private

	def listing_params
        params.require(:listing).permit(:firstname, :lastname, :phone, :email, :user_id, :company_id, :list_type, :story_path, :street, :street2, :city, :state, :postal_code, :country, :country_code, :latitude, :longitude, :map, :keywords, :description, :priority, :active)
    end


    def set_listing
        @listing = Listing.find(params[:id])
    end


	def require_admin
	    if (logged_in? and !current_user.admin?) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end