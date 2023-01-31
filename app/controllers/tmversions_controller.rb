class TmversionsController < ApplicationController
	before_action :require_admin
	before_action :set_tmversion, only: [:edit, :update]

def index

end


def new
    @tmversion = Tmversion.new 

end


def edit

end



def update
    if @tmversion.update(tmversion_params)
        flash[:success] = "ThinManager Matrix Version was successfully updated"
        redirect_to tmversions_path
    else
        render 'edit'
    end
end




def create
    @tmversion = Tmversion.new(tmversion_params)

    if @tmversion.save
        flash[:success] = "ThinManager Matrix Version has been created and saved"
        redirect_to tmversions_path
    else
        render 'new'
    end
end


def destroy
    @tmversion = Tmversion.find(params[:id])
    @tmversion.destroy
    flash[:danger] = "ThinManager Matrix version has been deleted"
    redirect_to tmversions_path
end




private

	def tmversion_params
        params.require(:tmversion).permit(:version)
    end


    def set_tmversion
        @tmversion = Tmversion.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end