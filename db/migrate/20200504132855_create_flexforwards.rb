class CreateFlexforwards < ActiveRecord::Migration[5.0]
  def change
    create_table :flexforwards do |t|
    	t.integer :user_id
    	t.integer :currency_id
    	t.string :name
    	t.boolean :mirrored, default: :false
    	t.boolean :red_exchange, default: :false
    	
    	t.integer :ex_serv_sup, default: 0
    	t.integer :ex_serv_nosup, default: 0
    	t.integer :ex_serv_nosup_years, default: 0

    	t.integer :ex_site_sup, default: 0
    	t.integer :ex_site_nosup, default: 0
    	t.integer :ex_site_nosup_years, default: 0

    	t.integer :ex_simp_sup, default: 0
    	t.integer :ex_simp_nosup, default: 0
    	t.integer :ex_simp_nosup_years, default: 0

    	t.integer :ex_red_sup, default: 0
    	t.integer :ex_red_nosup, default: 0
    	t.integer :ex_red_nosup_years, default: 0

    	t.integer :tr_serv, default: 0
    	t.decimal :tr_pr_serv, precision: 10, scale: 2, default: 0
    	t.decimal :tr_cred_serv, precision: 10, scale: 2, default: 0

    	t.integer :tr_site, default: 0
    	t.decimal :tr_pr_site, precision: 10, scale: 2, default: 0
    	t.decimal :tr_cred_site, precision: 10, scale: 2, default: 0

    	t.integer :tr_simp, default: 0
    	t.decimal :tr_pr_simp, precision: 10, scale: 2, default: 0
    	t.decimal :tr_cred_simp, precision: 10, scale: 2, default: 0

    	t.integer :tr_red, default: 0
    	t.decimal :tr_pr_red, precision: 10, scale: 2, default: 0
    	t.decimal :tr_cred_red, precision: 10, scale: 2, default: 0

    	t.integer :new_simp, default: 0
    	t.decimal :new_pr_simp, precision: 10, scale: 2, default: 0

    	t.integer :new_red, default: 0
    	t.decimal :new_pr_red, precision: 10, scale: 2, default: 0

    	t.integer :total_terms, default: 0
    	t.decimal :tr_pr_total, precision: 10, scale: 2, default: 0
    	t.decimal :tr_cred_total, precision: 10, scale: 2, default: 0
    	t.decimal :total_tr_cost, precision: 10, scale: 2, default: 0
    	t.decimal :total_maint, precision: 10, scale: 2, default: 0

    	t.date :sm_exp
    	t.decimal :total_quote, precision: 10, scale: 2, default: 0

    	t.text :note



    	t.timestamps
    end
  end
end
