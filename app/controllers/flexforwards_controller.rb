class FlexforwardsController < ApplicationController
	before_action :must_login
	before_action :require_admin, only: [:index]



def index
	@flexforwards = Flexforward.all
	@currencies = Currency.all


end


def new 

end


def show

end


def edit

end


def delete

end




private

def must_login
	if !logged_in?
        redirect_to login_path
    end
end

def flex_params
    #params.require(:currency).permit(:name, :symbol, :rate)
end

def require_admin
    if (logged_in? and !current_user.admin?) || !logged_in? 
        flash[:danger] = "Only admin users can perform that action"
        redirect_to root_path
    end
end

def set_flex
    @flex = Flexforward.find(params[:id])
end


end