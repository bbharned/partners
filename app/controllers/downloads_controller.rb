class DownloadsController < ApplicationController
	before_action :require_admin


def index
	@user = current_user
	@downloads = Download.paginate(page: params[:page], per_page: 25).order(:created_at)
end








private

	def require_admin
        if (logged_in? and !current_user.admin?) || !logged_in? 
            flash[:danger] = "Only admin users can perform that action"
            redirect_to root_path
        end
    end

end