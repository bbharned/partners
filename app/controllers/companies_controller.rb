class CompaniesController < ApplicationController
	before_action :require_admin, except: [:show]
	before_action :set_company, only: [:edit, :update, :show]


def index
	@sort = [params[:sort]]
    @companies = Maker.paginate(page: params[:page], per_page: 25).order(@sort)
end



def new
    @company = Company.new 

end

def show

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