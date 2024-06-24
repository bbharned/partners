class Roi < ActiveRecord::Base
	belongs_to :user
	belongs_to :currency
	before_save :calcs
	validates :name, presence: true, length: { minimum: 1, maximum: 50 }






private




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



#self.savings_opcost = self.result_opcost_pc - self.result_opcost_tc_rds



end











end