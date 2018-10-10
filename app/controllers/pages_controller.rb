class PagesController < ApplicationController
	before_action :must_login, only: [:dashboard]

def dashboard

end


private

def must_login
	if !logged_in?
        redirect_to login_path
    end
end



end