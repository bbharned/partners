class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update, :show]
    before_action :require_same_user, only: [:edit, :update, :show]
    before_action :require_admin, only: [:index, :new, :create, :destroy, :company, :type, :active, :inactive, :lastlogin, :distributor, :integrator, :admin]


def index
    @users = User.paginate(page: params[:page], per_page: 25).order(:lastname)
    @allusers = User.all

    respond_to do |format|
      format.html { render "index" }
      format.csv { send_data @allusers.to_csv, filename: "All_Partners-#{Date.today}.csv" }
    end
end

def company
    @users = User.paginate(page: params[:page], per_page: 25).order(:company)
    @allusers = User.all

    respond_to do |format|
      format.html { render "company" }
      format.csv { send_data @allusers.to_csv, filename: "All_Partners-#{Date.today}.csv" }
    end
end

def type
    @users = User.paginate(page: params[:page], per_page: 25).order(:prttype)
    @allusers = User.all

    respond_to do |format|
      format.html { render "type" }
      format.csv { send_data @allusers.to_csv, filename: "All_Partners-#{Date.today}.csv" }
    end
end

def active
    @users = User.where.not(active: false).paginate(page: params[:page], per_page: 25).order(:lastname)
    @allusers = User.all

    respond_to do |format|
      format.html { render "active" }
      format.csv { send_data @allusers.to_csv, filename: "All_Partners-#{Date.today}.csv" }
    end
end

def inactive
    @users = User.where(active: false).paginate(page: params[:page], per_page: 25).order(:lastname)
    @allusers = User.all

    respond_to do |format|
      format.html { render "inactive" }
      format.csv { send_data @allusers.to_csv, filename: "All_Partners-#{Date.today}.csv" }
    end
end

def lastlogin
    @loggedin_before = User.where.not(lastlogin: nil)
    @users = @loggedin_before.paginate(page: params[:page], per_page: 25).order("lastlogin desc")
    @allusers = User.all

    respond_to do |format|
      format.html { render "lastlogin" }
      format.csv { send_data @allusers.to_csv, filename: "All_Partners-#{Date.today}.csv" }
    end
end

def distributor
    @users = User.where(prttype: "Distributor").paginate(page: params[:page], per_page: 25).order(:lastname)
    @allusers = User.all

    respond_to do |format|
      format.html { render "distributor" }
      format.csv { send_data @allusers.to_csv, filename: "All_Partners-#{Date.today}.csv" }
    end
end

def integrator
    @users = User.where(prttype: "Integrator").paginate(page: params[:page], per_page: 25).order(:lastname)
    @allusers = User.all

    respond_to do |format|
      format.html { render "integrator" }
      format.csv { send_data @allusers.to_csv, filename: "All_Partners-#{Date.today}.csv" }
    end
end

def admin
    @users = User.where(admin: true).paginate(page: params[:page], per_page: 25).order(:lastname)
    @allusers = User.all

    respond_to do |format|
      format.html { render "admin" }
      format.csv { send_data @users.to_csv, filename: "Portal_Integrator_Partners-#{Date.today}.csv" }
    end
end




def new
    @user = User.new
end



def edit
    
end


def show
        
end


def create
    @user = User.new(user_params)

    if @user.save
        flash[:success] = "User has been created"
        redirect_to users_path
    else
        render 'new'
    end
end



def update
    if @user.update(user_params)
        flash[:success] = "Account information was successfully updated"
        redirect_to user_path(@user)
    else
        render 'edit'
    end
end



def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "User and user info has been deleted"
    redirect_to users_path
end



private

	def user_params
        params.require(:user).permit(:firstname, :lastname, :email, :email_confirmation, :company, :password, :password_confirmation, :continent, :active, :prttype, :silevel, :channel, :certdate, :certexpire)
    end

    def set_user
        @user = User.find(params[:id])
    end

    def require_same_user
        if current_user != @user && !current_user.admin
            flash[:danger] = "You are not permitted for that action"
            redirect_to root_path
        end
    end

    def require_admin
        if (logged_in? and !current_user.admin?) || !logged_in? 
            flash[:danger] = "Only admin users can perform that action"
            redirect_to root_path
        end
    end



end