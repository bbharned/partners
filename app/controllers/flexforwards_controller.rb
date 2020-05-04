class FlexforwardsController < ApplicationController
	before_action :must_login
	before_action :require_admin, only: [:index]



def index
	@flexforwards = Flexforward.all
	@currencies = Currency.all



end


def new 
	@flex = Flexforward.new
	@currencies = Currency.all
	@user = current_user



end


def create
	@flex = Flexforward.new(flex_params)

    if @flex.save
        flash[:success] = "Your Flex Forward Calculator has been saved"
        redirect_to root_path
    else
        render 'new'
    end

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
    params.require(:flexforward).permit(:name)
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