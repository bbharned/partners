class LicensesController < ApplicationController
	before_action :require_admin, except: [:new, :create, :show]
    before_action :set_license, only: [:edit, :update, :show]
    before_action :require_same_user, only: [:show]


def index
	@licenses = License.all
    @approved = License.where(approved: true).order("created_at desc")
    @requested = License.where(approved: false).order("created_at desc")
    
end



def new 
    @license = License.new  
    @user = User.find(params[:user_id])

end


def show
    @user = User.find(@license.user_id)
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
    @user = User.find(@license.user_id)

    if @license.save
        if !current_user.admin?
            # Send internal email of license request nptification here unless admin created.
            @user.send_license_notification(@license)
        end
        flash[:success] = "Your license request has been submitted. To process your license we will need you to enter your business address and details in your profile. Update this information #{view_context.link_to 'here', edit_user_path(@user)}."
        redirect_to root_path
    else
        render 'edit', params: {user_id: @user.id}
    end
end


def destroy
    @license = License.find(params[:id])
    @license.destroy
    flash[:danger] = "ThinManager license has been deleted. This is only from the Portal, not the licensing database."
    redirect_to licenses_path
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

    def require_same_user
        if current_user != @license.user && !current_user.admin
            flash[:danger] = "You are not permitted for that action"
            redirect_to root_path
        end
    end

    

end