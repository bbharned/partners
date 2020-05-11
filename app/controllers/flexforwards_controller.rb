class FlexforwardsController < ApplicationController
	before_action :must_login
	before_action :require_admin, only: [:index]
	before_action :set_flex, only: [:edit, :update, :show, :destroy]
	before_action :require_same_user, only: [:edit, :update, :show, :destroy]
    #before_action :calcs, only: [:create, :update]



def index
	@flexforwards = Flexforward.all
	@currencies = Currency.all
end


def new 
	@flex = Flexforward.new
	@currencies = Currency.all

    @flex.sm_exp = Date.today() + 1.year

end


def create

    @flex = Flexforward.new(flex_params)
    @flex.user = current_user

    if @flex.save
        flash[:success] = "Your Flex Forward Calculator has been saved"
        redirect_to flexforward_path(@flex)
    else
        render 'new'
    end
end


def update
    
    
    if @flex.update(flex_params)
        flash[:success] = "Calculator was successfully updated"
        redirect_to flexforward_path(@flex)
    else
        render 'edit'
    end

end


def show

end


def edit

end


def destroy
	@flex.destroy
    flash[:danger] = "The Flex Forward calculator has been deleted"
    redirect_to root_path
end

def saved
	@flexes = Flexforward.where(:user_id => current_user.id)
	@user = current_user
end












private

def must_login
	if !logged_in?
        redirect_to login_path
    end
end


def flex_params
    params.require(:flexforward).permit(:name, :user_id, :currency_id, :mirrored, :red_exchange, :ex_serv_sup, :ex_serv_nosup, :ex_serv_nosup_years, :ex_site_sup, :ex_site_nosup, :ex_site_nosup_years, :ex_simp_sup, :ex_simp_nosup, :ex_simp_nosup_years, :ex_red_sup, :ex_red_nosup, :ex_red_nosup_years, :tr_serv, :tr_pr_serv, :tr_cred_serv, :tr_site, :tr_pr_site, :tr_cred_site, :tr_simp, :tr_pr_simp, :tr_cred_simp, :tr_red, :tr_pr_red, :tr_cred_red, :new_simp, :new_pr_simp, :new_red, :new_pr_red, :total_terms, :tr_pr_total, :tr_cred_total, :total_tr_cost, :total_maint, :sm_exp, :total_quote, :note)
end


def set_flex
    @flex = Flexforward.find(params[:id])
end


def require_admin
    if (logged_in? and !current_user.admin?) || !logged_in? 
        flash[:danger] = "Only admin users can perform that action"
        redirect_to root_path
    end
end


def require_same_user
    if current_user != @flex.user && !current_user.admin
        flash[:danger] = "You are not permitted for that action"
        redirect_to root_path
    end
end


def set_flex
    @flex = Flexforward.find(params[:id])
end





# Flex Forward Calculations
# def findRange(terminalCount)
    
#     if terminalCount == 0..5 
#         terminalRange = 0
#     elsif terminalCount >= 5 && terminalCount < 50 
#         terminalRange = 1
#     elsif terminalCount >= 50 && terminalCount < 100
#         terminalRange = 2
#     elsif terminalCount >= 100 && terminalCount < 250
#         terminalCount = 3
#     elsif terminalCount >= 250 && terminalCount < 500
#         terminalRange = 4
#     elsif terminalCount >= 500
#         terminalRange = 5  
#     end

#     return terminalRange

# end


# def calcs
    
#     vfRedPrices = [3400, 1870, 1700, 1360, 1190, 1020]
#     smrPrices = [400, 220, 200, 160, 140, 120]
#     vfNonRedPrices = [2400, 1320, 1200, 960, 840, 720]

#     @flex.tr_simp = @flex.ex_simp_sup + @flex.ex_simp_nosup
#     @flex.tr_red = @flex.ex_red_sup + @flex.ex_red_nosup

#     @flex.tr_pr_serv = (600 * @flex.currency.rate) * @flex.tr_serv
#     @flex.tr_pr_site = (600 * @flex.currency.rate) * @flex.tr_site

#     @flex.total_terms = @flex.tr_serv + @flex.tr_site + @flex.tr_simp + @flex.tr_red + @flex.new_simp + @flex.new_red

#     #Ranges
#     currentRange = findRange(@flex.total_terms)
#     tradePackRange = findRange(@flex.tr_simp)
#     tradeRPackRange = findRange(@flex.tr_red);
    
# end


end