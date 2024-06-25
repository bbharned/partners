class RoisController < ApplicationController
	before_action :must_login
	before_action :require_admin, only: :index
	before_action :set_roi, only: [:edit, :update, :show, :destroy]
	before_action :require_same_user, only: [:edit, :update, :show, :destroy]


def index
	@rois = Roi.all
end



def new
	@roi = Roi.new()
	@currencies = Currency.all
end


def create

    @roi = Roi.new(roi_params)
    @roi.user = current_user
    

    if @roi.save
        flash[:success] = "Your Return On Investment Calculations have been created and saved"
        redirect_to roi_path(@roi)
    else
        render 'new'
    end
end


def update
    
    
    if @roi.update(roi_params)
        flash[:success] = "Your ROI Calculator was successfully updated"
        redirect_to roi_path(@roi)
    else
        render 'edit'
    end

end


def show
    @tcMaintCosts = @roi.planned_terminals * (@roi.tc_monthly_maint * 12) * @roi.projected_years * @roi.total_labor_per_hour
end


def edit

end


def destroy
	@roi.destroy
    flash[:danger] = "The ROI calculator has been deleted"
    #redirect_to root_path
    redirect_back(fallback_location:"/")
end

























private

def must_login
	if !logged_in?
        redirect_to login_path
    end
end


def roi_params
    params.require(:roi).permit(:name, :user_id, :currency_id, :activation_type, :support_level, :planned_terminals, 
    	:station_uptime, :kilowatt_power_cost, :downtime_cost_hour, :projected_years, :additional_savings, :additional_savings_note, 
    	:base_labor_per_year, :base_labor_per_hour, :labor_overhead, :total_labor_per_year, :total_labor_per_hour, :pc_ave_cost, 
    	:pc_prep_time, :pc_monthly_maint, :pc_inventory_count, :pc_percent_fail_rate, :pc_watt_power_comsumption, :pc_month_ave_life, 
    	:pc_ave_replace_time, :tc_ave_cost, :tc_prep_time, :tc_monthly_maint, :tc_inventory_count, :tc_percent_fail_rate, 
    	:tc_watt_power_comsumption, :tc_month_ave_life, :tc_ave_replace_time, :rds_ave_cost, :rds_prep_time, :rds_monthly_maint, 
    	:rds_sessions_number, :rds_inventory_count, :rds_watt_power_comsumption, :rds_month_ave_life, :rds_percent_fail_rate, 
    	:rds_uptime, :rds_ave_replace_time, :thinmanager_cost, :thinmanager_redundancy, :thinmanager_maintenance, :management_time_saved_per_month, 
    	:result_capcost_pc, :result_capcost_tc_rds, :savings_capcost, :result_prepcost_pc, :result_prepcost_tc_rds, :savings_prepcost, 
    	:result_opcost_pc, :result_opcost_tc_rds, :savings_opcost, :result_refreshcost_pc, :result_refreshcost_tc_rds, :savings_refreshcost, 
    	:result_total_pc, :result_total_tc_rds, :savings_total)
end


def set_roi
    @roi = Roi.find(params[:id])
end


def require_admin
    if (logged_in? and !current_user.admin?) || !logged_in? 
        flash[:danger] = "Only admin users can perform that action"
        redirect_to root_path
    end
end


def require_same_user
    if current_user != @roi.user && !current_user.admin
        flash[:danger] = "You are not permitted for that action"
        redirect_to root_path
    end
end


end