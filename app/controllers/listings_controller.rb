class ListingsController < ApplicationController
	before_action :require_admin, except: [:new, :create, :show]
	before_action :set_listing, only: [:edit, :update, :show]


def index
	@listings = Listing.all.order("lastname desc")
    @approved = Listing.joins(:user).where('certexpire >= ?', Date.today).where(:active => true)
    @requested = Listing.where(:active => false)
    # @expired = []
    # @approved.each do |u|
    #     if u.user.certexpire < Date.today
    #         @expired.push u
    #     end
    # end
    @expired = Listing.joins(:user).where('certexpire < ?', Date.today)
end


def new

	@listing = Listing.new(:user_id => params[:user_id], :firstname => params[:firstname], :lastname => params[:lastname], :email => params[:email], 
		:phone => params[:cell], :street => params[:street], :street2 => params[:street2], :city => params[:city], :postal_code => params[:postal_code], 
        :list_type => params[:list_type], :state => params[:state_code]
    )
    
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
    if @listing.company == nil
    	@no_company = Company.where(name: "No Company (Don't Delete)")
    	@listing.company_id = @no_company.first.id
    end
    #@listings.user_id = @listing.user_id.to_i
    if @listing.save
        flash[:success] = "Web Listing has been requested and saved"
        if current_user.admin?
        	redirect_to listings_path
        else
        	redirect_to root_path
        end
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