class DownloadsController < ApplicationController
	before_action :require_admin


def index
	@user = current_user
	@downloads = Download.order("created_at desc").paginate(page: params[:page], per_page: 25) 

	
end









private

def download_params
        params.require(:download).permit(:user_id)
    end

	def require_admin
        if (logged_in? and !current_user.admin?) || !logged_in? 
            flash[:danger] = "Only admin users can perform that action"
            redirect_to root_path
        end
    end

end