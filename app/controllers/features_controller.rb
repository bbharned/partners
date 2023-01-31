class FeaturesController < ApplicationController
	before_action :require_admin, except: [:index, :show]
	before_action :set_feature, only: [:edit, :update, :show]



def index
	@features = Feature.all
end



def new
	@feature = Feature.new
	@tmversions = Tmversion.all
	@firmwarebuilds = Firmwarebuild.all
end



def edit
	@tmversions = Tmversion.all
	@firmwarebuilds = Firmwarebuild.all
end



def show

end



def create
    @feature = Feature.new(feature_params)

    if @feature.save
        flash[:success] = "ThinManager feature for Matrix has been saved"
        redirect_to features_path
    else
        render 'new'
    end
end



def update
    if @feature.update(feature_params)
        flash[:success] = "Feature was successfully updated"
        redirect_to features_path
    else
        render 'edit'
    end
end



def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy
    flash[:danger] = "Feature has been deleted"
    redirect_to features_path
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