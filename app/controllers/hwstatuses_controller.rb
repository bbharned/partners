class HwstatusesController < ApplicationController
	before_action :require_admin
	before_action :set_status, only: [:edit, :update, :show]


def index
	@sort = [params[:sort]]
    @statuses = Hwstatus.all.order(@sort)
end



def new
    @status = Hwstatus.new 

end

def show

end



def edit

end



def update
    if @status.update(status_params)
        flash[:success] = "Hardware status was successfully updated"
        redirect_to hwstatuses_path
    else
        render 'edit'
    end
end




def create
    @status = Hwstatus.new(status_params)

    if @status.save
        flash[:success] = "Hardware status has been created and saved"
        redirect_to hwstatuses_path
    else
        render 'new'
    end
end


def destroy
    @status = Hwstatus.find(params[:id])
    @status.destroy
    flash[:danger] = "Hardware status has been deleted"
    redirect_to hwstatuses_path
end









private

	def status_params
        params.require(:hwstatus).permit(:name)
    end


    def set_status
        @status = Hwstatus.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.hw_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end





end