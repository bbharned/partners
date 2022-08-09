class DemokitsController < ApplicationController
	before_action :require_admin
	before_action :set_demokit, only: [:edit, :update, :show]


def index
	@demokits = Demokit.all
end



def new
	@demokit = Demokit.new
end



def edit

end



def show

end



def update
    if @demokit.update(demokit_params)
        flash[:success] = "Demo kit was successfully updated"
        redirect_to demokits_path
    else
        render 'edit'
    end
end




def create
    @demokit = Demokit.new(demokit_params)

    if @demokit.save
        flash[:success] = "Demo kit has been created and saved"
        redirect_to demokits_path
    else
        render 'new'
    end
end


def destroy
    @demokit = Demokit.find(params[:id])
    @demokit.destroy
    flash[:danger] = "Demo kit has been deleted"
    redirect_to demokits_path
end




private

	def demokit_params
        params.require(:demokit).permit(:serial_number, :reason, :region, :tmversion, :esxiversion, :status, :firstname, :lastname, :email, :company, :street, :street2, :street3, :city, :state, :postal_code, :phone, :change_date, :notes)
    end


    def set_demokit
        @demokit = Demokit.find(params[:id])
    end


	def require_admin
	    if (logged_in? and !current_user.admin?) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end