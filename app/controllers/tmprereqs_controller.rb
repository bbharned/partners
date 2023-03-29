class TmprereqsController < ApplicationController
	before_action :require_admin
	before_action :set_tmprereq, only: [:edit, :update]

def index
    @tmprereqs = Tmprereq.all.order("name asc")
end


def new
    @tmprereq = Tmprereq.new 

end


def edit

end



def update
    if @tmprereq.update(tmprereq_params)
        flash[:success] = "ThinManager Matrix Prerequisite was successfully updated"
        redirect_to tmprereqs_path
    else
        render 'edit'
    end
end




def create
    @tmprereq = Tmprereq.new(tmprereq_params)

    if @tmprereq.save
        flash[:success] = "ThinManager Matrix Prerequisite has been created and saved"
        redirect_to tmprereqs_path
    else
        render 'new'
    end
end


def destroy
    @tmprereq = Tmprereq.find(params[:id])
    @tmprereq.destroy
    flash[:danger] = "ThinManager Matrix Prerequisite has been deleted"
    redirect_to tmprereqs_path
end




private

	def tmprereq_params
        params.require(:tmprereq).permit(:name)
    end


    def set_tmprereq
        @tmprereq = Tmprereq.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end