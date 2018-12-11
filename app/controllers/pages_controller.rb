class PagesController < ApplicationController
	before_action :must_login, only: [:dashboard, :pricing]
	before_action :can_see_pricing, only: [:pricing]

def dashboard
	
end

def pricing
	@channel = @current_user.channel
end















private

def must_login
	if !logged_in?
        redirect_to login_path
    end
end

def can_see_pricing
	if @current_user.admin? || @current_user.continent == "North America"

	else
		flash[:danger] = "You do not have permission to view this page."
		redirect_to root_path
	end
end




end