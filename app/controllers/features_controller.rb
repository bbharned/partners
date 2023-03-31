class FeaturesController < ApplicationController
	before_action :require_admin, except: [:index, :show]
	before_action :set_feature, only: [:edit, :update, :show]



def index
	#@features = Feature.all.order("name asc")

    @url = request.original_url

    if @url.include? "hardware"
        @bg = 'hardware'
    elsif @url.include? "tmc"
        @bg = 'tmc'
    elsif @url.include? "features"
        @bg = 'features'    
    else
        @bg = 'peripheral'
    end


    @filterrific = initialize_filterrific(
     Feature,
     params[:filterrific],
      select_options: {
        sort_this_feature: Feature.options_for_sort_this_feature,
        with_tmversion: Tmversion.options_for_select,
        with_firmwarebuild: Firmwarebuild.options_for_select,
        greater_tmversion: Tmversion.options_for_select,
        less_tmversion: Tmversion.options_for_select,
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:sort_this_feature, :with_search_feature, :with_tmversion, :with_firmwarebuild, :greater_tmversion, :less_tmversion],
      sanitize_params: true,
   ) or return
   
   @features = @filterrific.find.page(params[:page])

   respond_to do |format|
     format.html
     format.js
   end

   rescue ActiveRecord::RecordNotFound => e
     # There is an issue with the persisted param_set. Reset it.
     puts "Had to reset filterrific params: #{e.message}"
     redirect_to(reset_filterrific_url(format: :html)) && return

end



def new
	@feature = Feature.new
	@tmversions = Tmversion.all.order("version asc")
    @tmprereqs = Tmprereq.all.order("name asc")
	@firmwarebuilds = Firmwarebuild.all.order("build asc")
end



def edit
	@tmversions = Tmversion.all
    @tmprereqs = Tmprereq.all
	@firmwarebuilds = Firmwarebuild.all
end



def show

    @url = request.original_url

    if @url.include? "hardware"
        @bg = 'hardware'
    elsif @url.include? "tmc"
        @bg = 'tmc'
    elsif @url.include? "features"
        @bg = 'features'    
    else
        @bg = 'peripheral'
    end

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
        params.require(:feature).permit(:name, :description, :more_link_label, :more_link, :more_more_link_label, :more_more_link, :more_more_more_link_label, :more_more_more_link, :image_link, tmversion_ids: [], tmprereq_ids: [], firmwarebuild_ids: [])
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