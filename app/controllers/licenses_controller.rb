class LicensesController < ApplicationController
	before_action :require_admin, except: [:new, :create, :show]
    before_action :set_license, only: [:edit, :update, :show]
    before_action :require_same_user, only: [:show]


def index
	# @licenses = License.all
    # @approved = License.where(approved: true).order("created_at desc")
    # @requested = License.where(approved: false).order("created_at desc")


    @filterrific = initialize_filterrific(
     License,
     params[:filterrific],
      select_options: {
        license_sorted: License.options_for_license_sorted,
        with_type: ['TMA', 'FTA'],
        with_approved: ['Requested', 'Approved'],
        with_exp: ['Active', 'Expired'],
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:license_sorted, :license_search, :with_type, :with_approved, :with_exp],
      sanitize_params: true,
   ) or return
   @licenses = @filterrific.find.paginate(page: params[:page], per_page: 20)

   respond_to do |format|
     format.html
     format.js
     format.csv { send_data @licenses.to_csv, filename: "ThinManager-Portal_Licenses-#{Date.today}.csv" }
   end

   rescue ActiveRecord::RecordNotFound => e
     # There is an issue with the persisted param_set. Reset it.
     puts "Had to reset filterrific params: #{e.message}"
     redirect_to(reset_filterrific_url(format: :html)) && return
    
end



def new 
    @license = License.new  
    @user = User.find(params[:user_id])
    if ((@user.street == nil || @user.street == "") || (@user.city == nil || @user.city == "") || (@user.cell == nil || @user.cell == "")) && !@user.admin?
        if !flash[:danger]
            flash.now[:warning] = "Address and Phone number are needed for FTA License requests.  You may 
            enter that #{view_context.link_to 'here', edit_user_path(@user)} and return to complete your license request."      
        end
    end
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

    if @license.activation_type == "FTA" && ((@user.street == nil || @user.street == "") || (@user.city == nil || @user.city == "") || (@user.cell == nil || @user.cell == "")) && !@user.admin?
        flash[:danger] = "We could not process you FTA License request, your Address and Phone Number are needed.  You may 
        enter that #{view_context.link_to 'here', edit_user_path(@user)} and return to complete your license request."
        #render 'edit', params: {user_id: @user.id}
        redirect_to new_license_path(user_id: @user.id)
    else
        if @license.save
            if !current_user.admin?
                # Send internal email of license request nptification here unless admin created.
                @user.send_license_notification(@license)
                @user.send_license_request_confirmation
            end
            flash[:success] = "Your license request has been submitted."
            redirect_to root_path
        else
            render 'edit', params: {user_id: @user.id}
        end
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