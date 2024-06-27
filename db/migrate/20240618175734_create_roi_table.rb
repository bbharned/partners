class CreateRoiTable < ActiveRecord::Migration[6.1]
  def change
    create_table :rois do |t|
      #Scenerio
      t.integer :user_id
      t.integer :currency_id
      t.string :name
      t.string :activation_type, default: "Subscription"
      t.string :support_level

      #General
      t.integer :planned_terminals, default: 100
      t.decimal :station_uptime, precision: 10, scale: 2, default: 16.0
      t.decimal :kilowatt_power_cost, precision: 10, scale: 4, default: 0.1319
      t.decimal :downtime_cost_hour, precision: 10, scale: 4, default: 10000.00
      t.integer :projected_years, default: 10
      t.decimal :additional_savings, precision: 10, scale: 2, default: 0.00
      t.text :additional_savings_note

      #Labor
      t.decimal :base_labor_per_year, precision: 10, scale: 2, default: 50000.00
      t.decimal :base_labor_per_hour, precision: 10, scale: 2, default: 24.04
      t.decimal :labor_overhead, precision: 10, scale: 2, default: 52.00
      t.decimal :total_labor_per_year, precision: 10, scale: 2, default: 76000.00
      t.decimal :total_labor_per_hour, precision: 10, scale: 2, default: 36.54

      #PC Stats
      t.decimal :pc_ave_cost, precision: 10, scale: 2, default: 1000.00
      t.decimal :pc_prep_time, precision: 10, scale: 2, default: 4.00
      t.decimal :pc_monthly_maint, precision: 10, scale: 2, default: 1.00
      t.integer :pc_inventory_count, default: 5
      t.decimal :pc_percent_fail_rate, precision: 10, scale: 2, default: 5.00
      t.decimal :pc_watt_power_comsumption, precision: 10, scale: 2, default: 75.00
      t.integer :pc_month_ave_life, default: 36
      t.decimal :pc_ave_replace_time, precision: 10, scale: 2, default: 2.00

      #TC Stats
      t.decimal :tc_ave_cost, precision: 10, scale: 2, default: 500.00
      t.decimal :tc_prep_time, precision: 10, scale: 2, default: 0.00
      t.decimal :tc_monthly_maint, precision: 10, scale: 2, default: 0.50
      t.integer :tc_inventory_count, default: 2
      t.decimal :tc_percent_fail_rate, precision: 10, scale: 2, default: 1.00
      t.decimal :tc_watt_power_comsumption, precision: 10, scale: 2, default: 15.00
      t.integer :tc_month_ave_life, default: 60
      t.decimal :tc_ave_replace_time, precision: 10, scale: 2, default: 0.25

      #RDS Stats
      t.decimal :rds_ave_cost, precision: 10, scale: 2, default: 10000.00
      t.decimal :rds_prep_time, precision: 10, scale: 2, default: 8.00
      t.decimal :rds_monthly_maint, precision: 10, scale: 2, default: 2.00
      t.integer :rds_sessions_number, default: 20
      t.integer :rds_inventory_count, default: 1
      t.decimal :rds_watt_power_comsumption, precision: 10, scale: 2, default: 200.00
      t.integer :rds_month_ave_life, default: 60
      t.decimal :rds_percent_fail_rate, precision: 10, scale: 2, default: 1.00
      t.decimal :rds_uptime, precision: 10, scale: 2, default: 24.0
      t.decimal :rds_ave_replace_time, precision: 10, scale: 2, default: 2.00

      #ThinManager
      t.decimal :thinmanager_cost, precision: 10, scale: 2, default: 0.00
      t.decimal :thinmanager_redundancy, precision: 10, scale: 2, default: 0.00
      t.decimal :thinmanager_maintenance, precision: 10, scale: 2, default: 0.00
      t.decimal :management_time_saved_per_month, precision: 10, scale: 2, default: 0.25

      #results
      t.decimal :result_capcost_pc, precision: 10, scale: 2
      t.decimal :result_capcost_tc_rds, precision: 10, scale: 2
      t.decimal :savings_capcost, precision: 10, scale: 2
      t.decimal :result_prepcost_pc, precision: 10, scale: 2
      t.decimal :result_prepcost_tc_rds, precision: 10, scale: 2
      t.decimal :savings_prepcost, precision: 10, scale: 2
      t.decimal :result_opcost_pc, precision: 10, scale: 2
      t.decimal :result_opcost_tc_rds, precision: 10, scale: 2
      t.decimal :savings_opcost, precision: 10, scale: 2
      t.decimal :result_refreshcost_pc, precision: 10, scale: 2
      t.decimal :result_refreshcost_tc_rds, precision: 10, scale: 2
      t.decimal :savings_refreshcost, precision: 10, scale: 2
      t.decimal :result_total_pc, precision: 10, scale: 2
      t.decimal :result_total_tc_rds, precision: 10, scale: 2
      t.decimal :savings_total, precision: 10, scale: 2

      t.timestamps
    end
  end
end
