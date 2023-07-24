class UserbadgesController < ApplicationController
	before_action :require_admin

def index
	#@badges = UserBadge.all


	@filterrific = initialize_filterrific(
     UserBadge,
     params[:filterrific],
      select_options: {
        sort_badge: UserBadge.options_for_sort_badge,
        with_badge_type: ['Configuration', 'Productivity', 'Visualization', 'Security', 'Mobility'],
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:sort_badge, :with_badge_search, :with_badge_type],
      sanitize_params: true,
   ) or return
   @badges = @filterrific.find.all

   respond_to do |format|
     format.html
     format.js
     format.csv { send_data @badges.to_csv, filename: "ThinManager-VideoTraining-Badges-#{Date.today}.csv" }
   end

   rescue ActiveRecord::RecordNotFound => e
     # There is an issue with the persisted param_set. Reset it.
     puts "Had to reset filterrific params: #{e.message}"
     redirect_to(reset_filterrific_url(format: :html)) && return
end





private

def user_params
    params.require(:userbadge).permit(:user_id, :configuration, :productivity, :visualization, :security, :mobility)
end

def require_admin
    if (logged_in? and !current_user.admin?) || !logged_in? 
        flash[:danger] = "Only admin users can perform that action"
        redirect_to root_path
    end
end

end