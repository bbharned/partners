class HwtypesController < ApplicationController
	before_action :require_admin
	before_action :set_type, only: [:edit, :update, :show]


def index
	@sort = [params[:sort]]
    @types = Hwtype.all.order(@sort)
end



def new
    @type = Hwtype.new 

end

def show

end



def edit

end



def update
    if @type.update(type_params)
        flash[:success] = "Hardware type was successfully updated"
        redirect_to hwtypes_path
    else
        render 'edit'
    end
end




def create
    @type = Hwtype.new(type_params)

    if @type.save
        flash[:success] = "Hardware type has been created and saved"
        redirect_to hwtypes_path
    else
        render 'new'
    end
end


def destroy
    @type = Hwtype.find(params[:id])
    @type.destroy
    flash[:danger] = "Hardware type has been deleted"
    redirect_to hwtypes_path
end









private

	def type_params
        params.require(:hwtype).permit(:name)
    end


    def set_type
        @type = Hwtype.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.hw_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end