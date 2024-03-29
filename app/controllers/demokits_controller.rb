class DemokitsController < ApplicationController
	before_action :require_admin, except: :show
    before_action :set_viewers, only: :show
	before_action :set_demokit, only: [:edit, :update, :show]


def index
	
    # @demokits = Demokit.order("serial_number asc").paginate(page: params[:page], per_page: 25) 


    @filterrific = initialize_filterrific(
     Demokit,
     params[:filterrific],
      select_options: {
        sort_dk: Demokit.options_for_sort_dk,
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:sort_dk, :with_dk_search],
      sanitize_params: true,
   ) or return
   @demokits = @filterrific.find.all.order("serial_number asc")

   respond_to do |format|
     format.html
     format.js
     format.csv { send_data @demokits.to_csv, filename: "ThinManager-Demokit-Search-#{Date.today}.csv" }
   end

   rescue ActiveRecord::RecordNotFound => e
     # There is an issue with the persisted param_set. Reset it.
     puts "Had to reset filterrific params: #{e.message}"
     redirect_to(reset_filterrific_url(format: :html)) && return
end



def new
	@demokit = Demokit.new
    if params[:user_id]
        @user = User.find(params[:user_id])
        @demokit.user_id = @user.id
    else
        @user = nil
    end
end



def edit
    if @demokit.user_id != nil
        @user = User.find(@demokit.user_id)
    else 
        @user = nil
    end
end



def show

end



def update
    #@demokit.user = User.find(params[:user_id])
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
        params.require(:demokit).permit(:user_id, :serial_number, :reason, :region, :tmversion, :esxiversion, :status, :change_date, :notes)
    end


    def set_demokit
        @demokit = Demokit.find(params[:id])
    end

    def set_viewers
        @demokit = Demokit.find(params[:id])
        if @demokit.user_id != nil
            @user = User.find(@demokit.user_id)
        end
        
        if @user && (logged_in? && !current_user.admin? && @user.id != current_user.id)
            flash[:danger] = "Sorry, you can't view that page"
            redirect_to root_path
        elsif !@user && !current_user.admin?
            flash[:danger] = "Sorry, you can't view that page"
            redirect_to root_path
        end
    end


	def require_admin
	    if (logged_in? and !current_user.admin?) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end