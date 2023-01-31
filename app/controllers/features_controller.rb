class FeaturesController < ApplicationController


def index

end









private

	def feature_params
        params.require(:feature).permit(:name, :description, tmversion_ids: [], firmwarebuild_ids: [])
    end


    def set_feature
        @feature = Feature.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end