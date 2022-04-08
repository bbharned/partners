class CompaniesController < ApplicationController
	before_action :require_admin, except: [:show]
	before_action :set_company, only: [:edit, :update, :show]


def index
	#@sort = [params[:sort]]
    @companies = Company.paginate(page: params[:page], per_page: 12).order(:name)
end


def search
  @parameter
  if params[:search].blank?
    @parameter = nil
    redirect_to companies_path and return
  else
    @parameter = params[:search].downcase
    @companies = Company.where('lower(name) LIKE :search OR lower(country) LIKE :search OR lower(country_code) LIKE :search OR lower(street) LIKE :search OR lower(city) LIKE :search OR lower(state) LIKE :search OR lower(main_prt_type) LIKE :search', 
        search: "%#{@parameter}%").paginate(page: params[:page], per_page: 25).order(:name)
  end

  respond_to do |format|
      format.html { render "search" }
      # format.csv { send_data @users.to_csv, filename: "PartnerPortal_SearchedUsers-#{Date.today}.csv" }
  end
end


def new
    @company = Company.new 

end

def show
    @listings = []
    @all = Listing.where(company_id: @company.id)
    @all.each do |l|
        if l.user.certexpire == nil || l.user.certexpire == ""
            @listings.push l
        elsif l.user.certexpire != nil && l.user.certexpire != "" && l.user.certexpire >= Date.today
            @listings.push l
        end
    end

    
end



def edit

end



def update
    if @company.update(company_params)
        flash[:success] = "Company was successfully updated"
        redirect_to companies_path
    else
        render 'edit'
    end
end




def create
    @company = Company.new(company_params)

    if @company.save
        flash[:success] = "Company has been created and saved"
        redirect_to companies_path
    else
        render 'new'
    end
end


def destroy
    @company = Company.find(params[:id])
    @no_company = Company.where(name: "No Company").first
    @listings = Listing.where(company_id: @company.id)
    @listings.each do |l|
        l.company_id = @no_company.id
        l.active = false
        l.save
    end
    @company.destroy
    flash[:danger] = "Company has been deleted"
    redirect_to companies_path
end









private

	def company_params
        params.require(:company).permit(:name, :url, :phone, :email, :logo_path, :story_path, :street, :street2, :city, :state, :postal_code, :country, :country_code, :latitude, :longitude, :map, :main_prt_type, :description)
    end


    def set_company
        @company = Company.find(params[:id])
    end


	def require_admin
	    if (logged_in? and !current_user.admin?) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end