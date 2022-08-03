class AddaddressesController < ApplicationController
	# before_action :require_admin
	before_action :set_addaddress, only: [:edit, :update]




def new
    @company = Company.find(params[:company_id])
    @address = Addaddress.new

end




def edit
    @company = Company.find(params[:company_id])
     
end



def update
    if @address.update(address_params)
        flash[:success] = "Company Address was successfully updated"
        redirect_to company_path(@address.company)
    else
        render 'edit'
    end
end




def create
    @address = Addaddress.new(address_params)
    @address.company_id = params[:company_id]
    @company = Company.find(params[:company_id])

    if @address.save
        flash[:success] = "Company Address has been created and saved"
        redirect_to company_path(@company)
    else
        render 'new'
    end
end


def destroy
    @address = Addaddress.find(params[:id])
    @address.destroy
    flash[:danger] = "Company Address has been deleted"
    redirect_to companies_path
end









private

	def address_params
        params.require(:addaddress).permit(:company_id, :street, :street2, :street3, :city, :state, :postal_code, :country, :country_code, :latitude, :longitude)
    end


    def set_addaddress
        @address = Addaddress.find(params[:id])
    end


	# def require_admin
	#     if (logged_in? and !current_user.admin?) || !logged_in? 
	#         flash[:danger] = "Only admin users can perform that action"
	#         redirect_to root_path
	#     end
	# end

end