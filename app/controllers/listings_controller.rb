class ListingsController < ApplicationController
	before_action :require_admin, except: [:new, :create, :show, :integrators, :distributors]
	before_action :set_listing, only: [:edit, :update, :show]


def index
	# @listings = Listing.all.order("lastname desc")
    # @approved = Listing.joins(:user).where('certexpire >= ?', Date.today).where(:active => true)
    # @requested = Listing.where(:active => false)
    # @expired = Listing.joins(:user).where('certexpire < ?', Date.today)

    @filterrific = initialize_filterrific(
     Listing,
     params[:filterrific],
      select_options: {
        listing_sort: Listing.options_for_listing_sort,
        with_status: ['Requested Listings', 'Active Listings', 'Expired Listings'],
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:listing_sort, :listing_search, :with_status],
      sanitize_params: true,
   ) or return
   @listings = @filterrific.find.paginate(page: params[:page], per_page: 20)

   respond_to do |format|
     format.html
     format.js
     format.csv { send_data @listings.to_csv, filename: "ThinManager-Web-Listings_Portal-#{Date.today}.csv" }
   end

   rescue ActiveRecord::RecordNotFound => e
     # There is an issue with the persisted param_set. Reset it.
     puts "Had to reset filterrific params: #{e.message}"
     redirect_to(reset_filterrific_url(format: :html)) && return
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
    	@no_company = Company.where(name: "No Company")
    	@listing.company_id = @no_company.first.id
    end

    if @listing.save
        flash[:success] = "Web Listing has been requested and saved"
        if current_user.admin?
            redirect_to listings_path
        else
            # send email to user that listing request has been received
            # send email to admins that listing has been requested
            current_user.send_listing_notification(@listing)
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



def integrators
    begin
        
        @listings = nil
        @key_parameter
        @search_parameter
        if params[:keyword_search].blank?
          @key_parameter = nil
          #redirect_to listing_integrators_path and return
        else
          @search_parameter = nil
          @key_parameter = params[:keyword_search].downcase 
          @listings = Listing.where(list_type: "Integrator").where(active: true)
                        .joins(:company).joins(:user).where("users.certexpire > ?", Date.today)
                        .where("lower(listings.firstname||listings.lastname||listings.fullname||listings.email||listings.street||listings.street2||listings.city||listings.state||listings.country||listings.country_code||listings.postal_code||listings.keywords||listings.description||companies.name||companies.url||users.silevel||users.channel) LIKE ?", "%#{@key_parameter}%")
                        .paginate(page: params[:page], per_page: 25).order(:lastname)
        end

        if params[:q].blank?
          @search_parameter = nil
          #redirect_to listing_integrators_path and return
        else
          @key_parameter = nil
          @search_parameter = params[:q] 
          @listings = Listing.where(list_type: "Integrator").where(active: true)
                      .joins(:user).where("users.certexpire > ?", Date.today)
                      .near(@search_parameter, 150, min_radius: 40)
                      .paginate(page: params[:page], per_page: 25).order(:lastname)

        end

        respond_to do |format|
          format.html { render "integrators" }
        end

    
    rescue
        
        flash[:danger] = "There was an error with your search. Try being less specific." 
        render 'integrators'

    end
    
end



def distributors
    begin
        
        @listings = nil
        @key_parameter
        @search_parameter
        if params[:keyword_search].blank?
          @key_parameter = nil
        else
          @search_parameter = nil
          @key_parameter = params[:keyword_search].downcase 
          @listings = Listing.where(list_type: "Distributor").where(active: true)
                        .joins(:company).joins(:user)
                        .where("lower(listings.firstname||listings.lastname||listings.fullname||listings.email||listings.street||listings.street2||listings.city||listings.state||listings.country||listings.country_code||listings.postal_code||listings.keywords||listings.description||companies.name||companies.url||users.silevel||users.channel) LIKE ?", "%#{@key_parameter}%")
                        .paginate(page: params[:page], per_page: 25).order(:lastname)
        end

        if params[:q].blank?
          @search_parameter = nil
        else
          @key_parameter = nil
          @search_parameter = params[:q] 
          @listings = Listing.where(list_type: "Distributor").where(active: true)
                      .near(@search_parameter, 150, min_radius: 40)
                      .paginate(page: params[:page], per_page: 25).order(:lastname)

        end

        respond_to do |format|
          format.html { render "distributors" }
        end

    
    rescue
        
        flash[:danger] = "There was an error with your search. Try being less specific." 
        render 'distributors'

    end
end





private

	def listing_params
        params.require(:listing).permit(:firstname, :lastname, :fullname, :phone, :email, :user_id, :company_id, :list_type, :story_path, :street, :street2, :city, :state, :postal_code, :country, :country_code, :latitude, :longitude, :map, :keywords, :description, :priority, :active)
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