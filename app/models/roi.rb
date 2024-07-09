class Roi < ActiveRecord::Base
	belongs_to :user
	belongs_to :currency
	before_validation :sanitize
	before_save :calcs
	validates :name, presence: true, length: { minimum: 1, maximum: 50 }


filterrific(
   default_filter_params: { rois_sort: 'created_at_desc' },
   available_filters: [
     :rois_sort,
     :rois_search,
     :term_count,
     :shows_savings,
   ],
 )


scope :rois_search, lambda { |query|
    return nil  if query.blank?

    terms = query.to_s.downcase.split(/\s+/)

    terms = terms.map { |e|
      ('%' + e + '%').gsub(/%+/, '%')
    }

    num_or_conds = 5
    where(
      terms.map { |term|
        "(
        LOWER(users.company) LIKE ?  
        OR LOWER(users.firstname) LIKE ? 
        OR LOWER(users.lastname) LIKE ?
        OR LOWER(users.firstname || ' ' || users.lastname) LIKE ? 
        OR LOWER(rois.name) LIKE ? 
        )"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    ).includes(:user).references(:users)
} 



scope :rois_sort, ->(sort_option) {
  direction = /desc$/.match?(sort_option) ? "desc" : "asc"
  case sort_option.to_s
  when /^name_/
    order("rois.name #{direction}")
  when /^created_at_/
    order("rois.created_at #{direction}")
  else
    raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
  end
}


scope :term_count, ->(terminals) {
    if terminals == '0 - 100'
        where("rois.planned_terminals <= ?", 100)
    elsif terminals == '101 - 250'
        where("rois.planned_terminals <= ?", 250).where.not("rois.planned_terminals <= ?", 100)
    elsif terminals == '> 250'
        where("rois.planned_terminals > ?", 250)
    else
        where.not("rois.planned_terminals == ?", nil)
    end
}  

scope :shows_savings, ->(option) {
    if option == 'Yes'
        where("rois.savings_total > ?", 0)
    elsif option == 'No'
        where("rois.savings_total <= ?", 0)
    else
        where.not("rois.savings_total == ?", nil)
    end
}  


def self.options_for_listing_sort
	[
	  ["Name (A-Z)", "name_asc"],
	  ["Name (Z-A)", "name_desc"],
	  ["Newest - Oldest", "created_at_desc"],
	  ["Oldest - Newest", "created_at_asc"],
	]
end









private

def sanitize
	# self.thinmanager_cost =  
end


def calcs
######### Capital Costs #########
# PC Calculations
    @pcHardwareCosts = self.planned_terminals * self.pc_ave_cost
    @pcInvCosts = self.pc_ave_cost * self.pc_inventory_count
    self.result_capcost_pc =  @pcHardwareCosts + @pcInvCosts
# TC Calculations
    @tcHardwareCosts = self.planned_terminals * self.tc_ave_cost
    @tcInvCosts = self.tc_ave_cost * self.tc_inventory_count
#RDS Calculations
	if self.planned_terminals % self.rds_sessions_number == 0
		@rdserversneeded = self.planned_terminals / self.rds_sessions_number
	else
		@rdserversneeded = ((self.planned_terminals.to_f/self.rds_sessions_number.to_f).ceil).to_i
	end
	@rdservInvCosts = self.rds_ave_cost * self.rds_inventory_count
	@rdsserverTotalCost = @rdserversneeded * self.rds_ave_cost
#Capital cost totals
	if self.activation_type != "Subscription" #Perpetual License
		self.result_capcost_tc_rds = @tcHardwareCosts + @tcInvCosts + @rdservInvCosts + @rdsserverTotalCost + self.thinmanager_cost + self.thinmanager_redundancy 
	else
		self.result_capcost_tc_rds = @tcHardwareCosts + @tcInvCosts + @rdservInvCosts + @rdsserverTotalCost 
	end
	if self.activation_type != "Subscription" #Perpetual License
		@subscriptionCost = 0
	else
		@subscriptionCost = (self.thinmanager_cost + self.thinmanager_redundancy) * self.projected_years
	end
#Capital Cost Savings
	self.savings_capcost = self.result_capcost_pc - self.result_capcost_tc_rds


############ Wages ###############
self.base_labor_per_hour = self.base_labor_per_year / 52 / 40
self.total_labor_per_year = self.base_labor_per_year * (self.labor_overhead / 100 + 1)
self.total_labor_per_hour = self.total_labor_per_year / 52 / 40


####### Preperation Costs #######
@PCprepCosts = self.planned_terminals * self.pc_prep_time * self.total_labor_per_hour
@PCInventoryPrepCosts = self.pc_inventory_count * self.pc_prep_time * self.total_labor_per_hour
@TCprepCosts = self.planned_terminals * self.tc_prep_time * self.total_labor_per_hour
@TCInventoryPrepCosts = self.tc_prep_time * self.tc_inventory_count * self.total_labor_per_hour
@RDSprepCosts = self.rds_prep_time * self.total_labor_per_hour * @rdserversneeded
@RDSInventoryPrepCosts = self.rds_inventory_count * self.rds_prep_time * self.total_labor_per_hour
self.result_prepcost_pc = @PCprepCosts + @PCInventoryPrepCosts
self.result_prepcost_tc_rds = @TCprepCosts + @TCInventoryPrepCosts + @RDSprepCosts + @RDSInventoryPrepCosts
self.savings_prepcost = self.result_prepcost_pc - self.result_prepcost_tc_rds


####### Operating Costs #######
##PCs##
@pcMaintCosts = self.planned_terminals * (self.pc_monthly_maint * 12) * self.projected_years * self.total_labor_per_hour
@pcFailedUnitCount = self.planned_terminals * (self.pc_percent_fail_rate / 100) * self.projected_years
@pcFailedReplaceCosts = @pcFailedUnitCount * self.pc_ave_cost
@pcFailedUnitPrepLabor = @pcFailedUnitCount * self.pc_prep_time * self.total_labor_per_hour
@pcFailedUnitReplaceLaborCost = @pcFailedUnitCount * self.pc_ave_replace_time * self.total_labor_per_hour
@pcDowntimeCost = @pcFailedUnitCount * self.downtime_cost_hour * self.pc_ave_replace_time
@pcEnergyConsumption = self.planned_terminals * (self.station_uptime * 365 * self.projected_years) * (self.pc_watt_power_comsumption/1000)
@pcEnergyCost = @pcEnergyConsumption * self.kilowatt_power_cost
self.result_opcost_pc = @pcMaintCosts + @pcFailedReplaceCosts + @pcFailedUnitPrepLabor + @pcFailedUnitReplaceLaborCost + @pcDowntimeCost + @pcEnergyCost
##TCs##
@tcMaintCosts = self.planned_terminals * (self.tc_monthly_maint * 12) * self.projected_years * self.total_labor_per_hour
@tcFailedUnitCount = self.planned_terminals * (self.tc_percent_fail_rate / 100) * self.projected_years
@tcFailedReplaceCosts = @tcFailedUnitCount * self.tc_ave_cost
@tcFailedUnitPrepLabor = @tcFailedUnitCount * self.tc_prep_time * self.total_labor_per_hour
@tcFailedUnitReplaceLaborCost = @tcFailedUnitCount * self.tc_ave_replace_time * self.total_labor_per_hour
@tcDowntimeCost = @tcFailedUnitCount * self.downtime_cost_hour * self.tc_ave_replace_time
@tcEnergyConsumption = self.planned_terminals * (self.station_uptime * 365 * self.projected_years) * (self.tc_watt_power_comsumption/1000)
@tcEnergyCost = @tcEnergyConsumption * self.kilowatt_power_cost
##RDSs##
@servMaintCosts = @rdserversneeded * (self.rds_monthly_maint * 12) * self.projected_years * self.total_labor_per_hour
@servFailedUnitCount = @rdserversneeded * (self.rds_percent_fail_rate / 100) * self.projected_years
@servFailedReplaceCosts = @servFailedUnitCount * self.rds_ave_cost
@servFailedUnitPrepLabor = @servFailedUnitCount * self.rds_prep_time * self.total_labor_per_hour
@servFailedUnitReplaceLaborCost = @servFailedUnitCount * self.rds_ave_replace_time * self.total_labor_per_hour
@servDowntimeCost = @servFailedUnitCount * self.downtime_cost_hour * self.rds_ave_replace_time
@servEnergyConsumption = @rdserversneeded * (self.rds_uptime * 365 * self.projected_years) * (self.rds_watt_power_comsumption/1000)
@servEnergyCost = @servEnergyConsumption * self.kilowatt_power_cost
##Software Maintenance & Extras##
if self.activation_type != "Subscription" #Perpetual License
    @softMaintCostTotal = self.thinmanager_maintenance * (self.projected_years-1)
else
    @softMaintCostTotal = 0
end
@tmManagementSavings = self.planned_terminals * (self.management_time_saved_per_month * 12) * self.projected_years * self.total_labor_per_hour
if self.activation_type != "Subscription" #Perpetual License
	self.result_opcost_tc_rds = @tcMaintCosts + @tcFailedReplaceCosts + @tcFailedUnitPrepLabor + @tcFailedUnitReplaceLaborCost + @tcDowntimeCost + @tcEnergyCost + @servMaintCosts + @servFailedReplaceCosts + @servFailedUnitPrepLabor + @servFailedUnitReplaceLaborCost + @servDowntimeCost + @servEnergyCost + @softMaintCostTotal - @tmManagementSavings - self.additional_savings
else
	self.result_opcost_tc_rds = @tcMaintCosts + @tcFailedReplaceCosts + @tcFailedUnitPrepLabor + @tcFailedUnitReplaceLaborCost + @tcDowntimeCost + @tcEnergyCost + @servMaintCosts + @servFailedReplaceCosts + @servFailedUnitPrepLabor + @servFailedUnitReplaceLaborCost + @servDowntimeCost + @servEnergyCost + @softMaintCostTotal - (@tmManagementSavings + self.additional_savings) + ((self.thinmanager_cost + self.thinmanager_redundancy) * self.projected_years)
end
self.savings_opcost = self.result_opcost_pc - self.result_opcost_tc_rds


####### Refresh Costs #######
##PCs##
@numberOfPCrefreshes = (self.projected_years * 12) / self.pc_month_ave_life
@pc_refresh_hardware = (@pcHardwareCosts + @pcInvCosts) * @numberOfPCrefreshes
@pc_refresh_prep = (@PCprepCosts * @numberOfPCrefreshes) + (@PCInventoryPrepCosts * @numberOfPCrefreshes)
##TCs##
@numberOfTCrefreshes = (self.projected_years * 12) / self.tc_month_ave_life
@tc_refresh_hardware = (@tcHardwareCosts + @tcInvCosts) * @numberOfTCrefreshes
@tc_refresh_prep = (@TCprepCosts * @numberOfTCrefreshes) + (@TCInventoryPrepCosts * @numberOfTCrefreshes)
##RDS##
@numberOfRDSrefreshes = (self.projected_years * 12) / self.rds_month_ave_life
@rds_refresh_hardware = (@rdsserverTotalCost + @rdservInvCosts) * @numberOfRDSrefreshes
@rds_refresh_prep = (@RDSprepCosts * @numberOfRDSrefreshes) + (@RDSInventoryPrepCosts * @numberOfRDSrefreshes)
####Totals####
self.result_refreshcost_pc = @pc_refresh_hardware + @pc_refresh_prep
self.result_refreshcost_tc_rds = @tc_refresh_hardware + @tc_refresh_prep + @rds_refresh_hardware + @rds_refresh_prep
self.savings_refreshcost = self.result_refreshcost_pc - self.result_refreshcost_tc_rds


####### Summary #######
self.result_total_pc = self.result_capcost_pc + self.result_prepcost_pc + self.result_opcost_pc + self.result_refreshcost_pc
self.result_total_tc_rds = self.result_capcost_tc_rds + self.result_prepcost_tc_rds + self.result_opcost_tc_rds + self.result_refreshcost_tc_rds
self.savings_total = self.result_total_pc - self.result_total_tc_rds
end





end