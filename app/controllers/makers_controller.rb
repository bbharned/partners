class MakersController < ApplicationController
	before_action :require_admin
	before_action :set_maker, only: [:edit, :update, :show]


def index
	@sort = [params[:sort]]
    @makers = Maker.paginate(page: params[:page], per_page: 25).order(@sort)
end



def new
    @maker = Maker.new 

end

def show

end



def edit

end



def update
    if @maker.update(maker_params)
        flash[:success] = "Hardware Company was successfully updated"
        redirect_to makers_path
    else
        render 'edit'
    end
end




def create
    @maker = Maker.new(maker_params)

    if @maker.save
        flash[:success] = "Hardware company has been created and saved"
        redirect_to makers_path
    else
        render 'new'
    end
end


def destroy
    @maker = Maker.find(params[:id])
    @maker.destroy
    flash[:danger] = "Hardware Company has been deleted"
    redirect_to makers_path
end









private

	def maker_params
        params.require(:maker).permit(:name, :logo_path, :url, :description)
    end


    def set_maker
        @maker = Maker.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.hw_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end