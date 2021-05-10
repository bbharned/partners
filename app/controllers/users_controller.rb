class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update, :show]
    before_action :require_same_user, only: [:edit, :update, :show]
    before_action :require_admin, only: [:index, :new, :create, :destroy, :company, :type, :active, :inactive, :lastlogin, :distributor, :integrator, :admin, :search, :review, :rauusers]


def index
    @sort = [params[:sort]]
    @users = User.paginate(page: params[:page], per_page: 25).order(@sort)
    @allusers = User.all

    respond_to do |format|
      format.html { render "index" }
      format.csv { send_data @allusers.to_csv, filename: "PartnerPortal_AllUsers-#{Date.today}.csv" }
    end
end


def si
  if (!logged_in?) 
    @user = User.new
  elsif (logged_in? and current_user.admin?) 
    @user = User.new
  elsif (logged_in? and !current_user.admin?)
    flash[:warning] = "You have already signed up and have an account"
    redirect_to root_path
  end
  @tm = 'Check the option that best describes your relationship to ThinManager'
end


def rau
  if (!logged_in?) 
    @user = User.new
  elsif (logged_in? and current_user.admin?) 
    @user = User.new
  elsif (logged_in? and !current_user.admin?)
    flash[:warning] = "You have already signed up and have an account"
    redirect_to root_path
  end
  @tm = 'Check the option that best describes your relationship to ThinManager'
end



def signup
  @user = User.new(user_params)
  #@receiver = User.find(1) #remove for production
  @user.needs_review = true
    if @user.save
        session[:user_id] = @user.id
        @user.update_attribute(:lastlogin, Time.now)
        @user.send_signup_notice  #change for production
        @user.send_user_signup_notice #change for production
        flash[:success] = "Your account has been created, Welcome!"
        redirect_to root_path
    else
        render 'si'
    end
end


def signup_rau
  @user = User.new(user_params)
  #@receiver = User.find(1) #remove for production
  @user.needs_review = true
  @user.referred_by = "RAU"
    if @user.save
        session[:user_id] = @user.id
        @user.update_attribute(:lastlogin, Time.now)
        @user.send_rau_notice 
        @user.send_user_signup_notice #change for production
        #@receiver.send_user_signup_notice #change for production
        flash[:success] = "Your account has been created, Welcome!"
        redirect_to root_path
    else
        render 'si'
    end
end



def review
  @sort = [params[:sort]]
  @users = User.where(needs_review: true).paginate(page: params[:page], per_page: 25).order(@sort)

end


# def upload_file
#     @user = current_user
#     @file = params[:cert_lab]

#     flash[:success] = "Your file is #{:cert_lab}"
#     redirect_to root_path
# end



def search
  if params[:search].blank?
    redirect_to users_path and return
  else
    @parameter = params[:search].downcase
    #@sort = [params[:sort]]
    @users = User.where("lower(firstname || lastname || company || email) LIKE ?", "%#{@parameter}%").paginate(page: params[:page], per_page: 25)#.order(@sort)
  end

  respond_to do |format|
      format.html { render "search" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_SearchedUsers-#{Date.today}.csv" }
  end
end

def company
    @users = User.paginate(page: params[:page], per_page: 25).order(:company)
    @allusers = User.all

    respond_to do |format|
      format.html { render "company" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_AllUsers-#{Date.today}.csv" }
    end
end

def type
    @users = User.paginate(page: params[:page], per_page: 25).order(:prttype)
    @allusers = User.all

    respond_to do |format|
      format.html { render "type" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_AllUsers-#{Date.today}.csv" }
    end
end

def active
    @sort = [params[:sort]]
    @users = User.where.not(active: false).paginate(page: params[:page], per_page: 25).order(@sort)
    @allusers = User.all

    respond_to do |format|
      format.html { render "active" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_ActiveUsers-#{Date.today}.csv" }
    end
end

def inactive
    @sort = [params[:sort]]
    @users = User.where(active: false).paginate(page: params[:page], per_page: 25).order(@sort)
    @allusers = User.all

    respond_to do |format|
      format.html { render "inactive" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_InactiveUsers-#{Date.today}.csv" }
    end
end

def lastlogin
    @sort = [params[:sort]]
    @loggedin_before = User.where.not(lastlogin: nil)
    @users = @loggedin_before.paginate(page: params[:page], per_page: 25).order(@sort)
    @allusers = User.all

    respond_to do |format|
      format.html { render "lastlogin" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_loginHistory-#{Date.today}.csv" }
    end
end

def distributor
    @sort = [params[:sort]]
    @users = User.where(prttype: "Distributor").paginate(page: params[:page], per_page: 25).order(@sort)
    @allusers = User.all

    respond_to do |format|
      format.html { render "distributor" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_Distributors-#{Date.today}.csv" }
    end
end

def integrator
    @sort = [params[:sort]]
    @users = User.where(prttype: "Integrator").paginate(page: params[:page], per_page: 25).order(@sort)
    @allusers = User.all

    respond_to do |format|
      format.html { render "integrator" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_Integrators-#{Date.today}.csv" }
    end
end

def admin
    @sort = [params[:sort]]
    @users = User.where(admin: true).paginate(page: params[:page], per_page: 25).order(@sort)
    @allusers = User.all

    respond_to do |format|
      format.html { render "admin" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_Admins-#{Date.today}.csv" }
    end
end

def rauusers
    @sort = [params[:sort]]
    @users = User.where(referred_by: "RAU").paginate(page: params[:page], per_page: 25).order(@sort)
    @allusers = User.all

    respond_to do |format|
      format.html { render "rauusers" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_RAU-#{Date.today}.csv" }
    end
end




def new
    @user = User.new
end



def edit
    
end


def show
     @user_certs = Certification.where(user_id: @user.id).order("date_earned desc")   

     # def send_cert_conf(user)  # --->  <a onClick="<%= @user.send_cert_conf() %>"></a>
     #    user.send_cert_conf
     # end
end

def send_cert_conf(user)
    user.send_cert_conf
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
    #redirect_to users_path
    redirect_back(fallback_location:"/")
end



private

	def user_params
        params.require(:user).permit(:firstname, :lastname, :email, :email_confirmation, :company, :password, :password_confirmation, :continent, :active, :prttype, :silevel, :channel, :certdate, :certexpire, :search, :distributor, :integrator, :end_user, :oem, :needs_review)
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