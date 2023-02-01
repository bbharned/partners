class FirmwarebuildsController < ApplicationController
	before_action :require_admin
	before_action :set_firmwarebuild, only: [:edit, :update]
	

def index
    @firmwarebuilds = Firmwarebuild.all.order("build asc")
end


def new
    @firmwarebuild = Firmwarebuild.new 

end


def edit

end



def update
    if @firmwarebuild.update(firmwarebuild_params)
        flash[:success] = "Firmware build version was successfully updated"
        redirect_to firmwarebuilds_path
    else
        render 'edit'
    end
end




def create
    @firmwarebuild = Firmwarebuild.new(firmwarebuild_params)

    if @firmwarebuild.save
        flash[:success] = "Firmware build version has been created and saved"
        redirect_to firmwarebuilds_path
    else
        render 'new'
    end
end


def destroy
    @firmwarebuild = Firmwarebuild.find(params[:id])
    @firmwarebuild.destroy
    flash[:danger] = "Firmware build version has been deleted"
    redirect_to firmwarebuilds_path
end










private

	def firmwarebuild_params
        params.require(:firmwarebuild).permit(:build)
    end


    def set_firmwarebuild
        @firmwarebuild = Firmwarebuild.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end


end