class LicensesController < ApplicationController
	before_action :require_admin, except: [:new, :create]
    before_action :set_license, only: [:edit, :update, :show]


def index
	@licenses = License.all
    @approved = License.where(approved: true)
    @requested = License.where(approved: false)
    
end



def new 
    @license = License.new  
    @user = User.find(params[:user_id])

end


def show

end



def edit
    @user = User.find(@license.user_id)
end



def update
    if @license.update(license_params)
        flash[:success] = "License was successfully updated"
        redirect_to licenses_path
    else
        render 'edit'
    end
end




def create
    @license = License.new(license_params)


    if @license.save
        flash[:success] = "Your license request has been submitted, we will be in touch soon."
        redirect_to root_path
    else
        render 'new'
    end
end


def destroy
    
end



private

    def license_params
        params.require(:license).permit(:user_id, :license_type, :activation_type, :product_license, :serial_number, :enddate, :approved, :note)
    end

	def require_admin
        if (logged_in? and !current_user.admin?) || !logged_in? 
            flash[:danger] = "Only admin users can perform that action"
            redirect_to root_path
        end
    end

    def set_license
        @license = License.find(params[:id])
    end

end