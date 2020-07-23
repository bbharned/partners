class FlexforwardsController < ApplicationController
	before_action :must_login
	before_action :require_admin, only: [:index, :totals, :byname, :byuser]
	before_action :set_flex, only: [:edit, :update, :show, :destroy]
	before_action :require_same_user, only: [:edit, :update, :show, :destroy]



def index
	@flexforwards = Flexforward.paginate(page: params[:page], per_page: 25).order("id desc")
	@currencies = Currency.all
end

def totals
    @flexforwards = Flexforward.paginate(page: params[:page], per_page: 25).order("total_quote desc")
end

def byname
    @flexforwards = Flexforward.paginate(page: params[:page], per_page: 25).order("name asc")
end

def byuser
    @flexforwards = Flexforward.paginate(page: params[:page], per_page: 25).order("user_id")
end

def bydate
    @flexforwards = Flexforward.paginate(page: params[:page], per_page: 25).order("created_at desc")
end

def usertotals
    @user = current_user
    @flexes = Flexforward.where(:user_id => @user.id).paginate(page: params[:page], per_page: 10).order("total_quote desc")
    
end

def userbyname
    @flexes = Flexforward.where(:user_id => current_user.id).paginate(page: params[:page], per_page: 10).order("name asc")
    @user = current_user
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
	@flexes = Flexforward.where(:user_id => current_user.id).paginate(page: params[:page], per_page: 10).order("id desc")
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


end