class RoisController < ApplicationController
	before_action :must_login
	before_action :require_admin, only: :index
	before_action :set_roi, only: [:edit, :update, :show, :destroy]
	before_action :require_same_user, only: [:edit, :update, :show, :destroy]


def index
	#@rois = Roi.paginate(page: params[:page], per_page: 15).order("id desc")

    @filterrific = initialize_filterrific(
     Roi,
     params[:filterrific],
      select_options: {
        rois_sort: Roi.options_for_listing_sort
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:rois_sort, :rois_search],
      sanitize_params: true,
   ) or return
   @rois = @filterrific.find.paginate(page: params[:page], per_page: 15)

   respond_to do |format|
     format.html
     format.js
     #format.csv { send_data @listings.to_csv, filename: "ThinManager-Web-Listings_Portal-#{Date.today}.csv" }
   end

   rescue ActiveRecord::RecordNotFound => e
     # There is an issue with the persisted param_set. Reset it.
     puts "Had to reset filterrific params: #{e.message}"
     redirect_to(reset_filterrific_url(format: :html)) && return
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
    if @roi.planned_terminals % @roi.rds_sessions_number == 0
        @rdserversneeded = @roi.planned_terminals / @roi.rds_sessions_number
    else
        @rdserversneeded = ((@roi.planned_terminals.to_f/@roi.rds_sessions_number.to_f).ceil).to_i
    end 

    # Capital Costs
        @pcHardwareCosts = @roi.planned_terminals * @roi.pc_ave_cost
        @pcInventoryCosts = @roi.pc_inventory_count * @roi.pc_ave_cost
        @tcHardwareCosts = @roi.planned_terminals * @roi.tc_ave_cost
        @tcInventoryCosts = @roi.tc_inventory_count * @roi.tc_ave_cost
        @rdsHardwareCosts =  @rdserversneeded * @roi.rds_ave_cost
        @rdsInventoryCosts = @roi.rds_inventory_count * @roi.rds_ave_cost

    #Prep Costs
        @pcPrepCosts = @roi.planned_terminals * @roi.pc_prep_time * @roi.total_labor_per_hour
        @pcInvPrepCosts = @roi.pc_inventory_count * @roi.pc_prep_time * @roi.total_labor_per_hour
        @tcPrepCosts = @roi.planned_terminals * @roi.tc_prep_time * @roi.total_labor_per_hour
        @tcInvPrepCosts = @roi.tc_inventory_count * @roi.tc_prep_time * @roi.total_labor_per_hour
        @rdsPrepCosts = @rdserversneeded * @roi.rds_prep_time * @roi.total_labor_per_hour
        @rdsInvPrepCosts = @roi.rds_inventory_count * @roi.rds_prep_time * @roi.total_labor_per_hour

    #Operating Costs
        @pcMaintCosts = @roi.planned_terminals * (@roi.pc_monthly_maint * 12) * @roi.projected_years * @roi.total_labor_per_hour
        @pcFailUnitCount = @roi.planned_terminals * (@roi.pc_percent_fail_rate/100) * @roi.projected_years
        @pcFailedCost = @pcFailUnitCount * @roi.pc_ave_cost
        @pcFailedPrepCost = @pcFailUnitCount * @roi.pc_prep_time * @roi.total_labor_per_hour
        @pcFailedReplaceCost = @pcFailUnitCount * @roi.pc_ave_replace_time * @roi.total_labor_per_hour
        @pcDowntimeCost = @pcFailUnitCount * @roi.pc_ave_replace_time * @roi.downtime_cost_hour
        @pcEnergyUse = @roi.planned_terminals * (@roi.station_uptime*365*@roi.projected_years) * (@roi.pc_watt_power_comsumption/1000)
        @pcEnergyCost = @pcEnergyUse * @roi.kilowatt_power_cost
        #TCs#
        @tcMaintCosts = @roi.planned_terminals * (@roi.tc_monthly_maint * 12) * @roi.projected_years * @roi.total_labor_per_hour
        @tcFailUnitCount = @roi.planned_terminals * (@roi.tc_percent_fail_rate/100) * @roi.projected_years
        @tcFailedCost = @tcFailUnitCount * @roi.tc_ave_cost
        @tcFailedPrepCost = @tcFailUnitCount * @roi.tc_prep_time * @roi.total_labor_per_hour
        @tcFailedReplaceCost = @tcFailUnitCount * @roi.tc_ave_replace_time * @roi.total_labor_per_hour
        @tcDowntimeCost = @tcFailUnitCount * @roi.tc_ave_replace_time * @roi.downtime_cost_hour
        @tcEnergyUse = @roi.planned_terminals * (@roi.station_uptime*365*@roi.projected_years) * (@roi.tc_watt_power_comsumption/1000)
        @tcEnergyCost = @tcEnergyUse * @roi.kilowatt_power_cost
        #RDS#   
        @rdsMaintCosts = @rdserversneeded * (@roi.rds_monthly_maint * 12) * @roi.projected_years * @roi.total_labor_per_hour
        @rdsFailUnitCount = @rdserversneeded * (@roi.rds_percent_fail_rate/100) * @roi.projected_years
        @rdsFailedCost = @rdsFailUnitCount * @roi.rds_ave_cost
        @rdsFailedPrepCost = @rdsFailUnitCount * @roi.rds_prep_time * @roi.total_labor_per_hour
        @rdsFailedReplaceCost = @rdsFailUnitCount * @roi.rds_ave_replace_time * @roi.total_labor_per_hour
        @rdsDowntimeCost = @rdsFailUnitCount * @roi.rds_ave_replace_time * @roi.downtime_cost_hour
        @rdsEnergyUse = @rdserversneeded * (@roi.rds_uptime*365*@roi.projected_years) * (@roi.rds_watt_power_comsumption/1000)
        @rdsEnergyCost = @rdsEnergyUse * @roi.kilowatt_power_cost
        #Additional#
        @tmSubscription = (@roi.thinmanager_cost + @roi.thinmanager_redundancy) * @roi.projected_years
        @managementSavings = @roi.planned_terminals * (@roi.management_time_saved_per_month*12*@roi.projected_years) * @roi.total_labor_per_hour

    #Refresh Costs
        #PC#
        @numberOfPCrefreshes = (@roi.projected_years * 12) / @roi.pc_month_ave_life
        @pc_refresh_hardware = (@pcHardwareCosts + @pcInventoryCosts) * @numberOfPCrefreshes
        @pc_refresh_prep = (@pcPrepCosts * @numberOfPCrefreshes) + (@pcInvPrepCosts * @numberOfPCrefreshes)
        #TC#
        @numberOfTCrefreshes = (@roi.projected_years * 12) / @roi.tc_month_ave_life
        @tc_refresh_hardware = (@tcHardwareCosts + @tcInventoryCosts) * @numberOfTCrefreshes
        @tc_refresh_prep = (@tcPrepCosts * @numberOfTCrefreshes) + (@tcInvPrepCosts * @numberOfTCrefreshes)
        #RDS#
        @numberOfRDSrefreshes = (@roi.projected_years * 12) / @roi.rds_month_ave_life
        @rds_refresh_hardware = (@rdsHardwareCosts + @rdsInventoryCosts) * @numberOfRDSrefreshes
        @rds_refresh_prep = (@rdsPrepCosts * @numberOfRDSrefreshes) + (@rdsInvPrepCosts * @numberOfRDSrefreshes)

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