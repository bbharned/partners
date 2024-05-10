class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update, :show]
    before_action :require_same_user, only: [:edit, :update, :show]
    before_action :require_admin, only: [:index, :new, :create, :destroy, :company, :type, :active, :inactive, :lastlogin, :distributor, :integrator, :admin, :search, :review, :rauusers, :allsignups, :learnsignups]


def index
    # @sort = [params[:sort]]
    # @users = User.paginate(page: params[:page], per_page: 25).order(@sort)
    # @allusers = User.all


    @filterrific = initialize_filterrific(
     User,
     params[:filterrific],
      select_options: {
        user_sort: User.options_for_user_sort,
        with_channel: ['Rockwell Automation', 'Wonderware', 'Aveva', 'GE', 'Independent'],
        with_prttype: ['Distributor', 'Integrator', 'OEM', 'End User'],
        with_active: ['Active', 'Inactive'],
        with_region: ['North America', 'Latin America', 'EMEA', 'Asia Pacific', 'Unknown'],
        with_cert: ['Active Certified', 'Expired Certified', 'Never Certified'],
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:user_sort, :user_search, :with_channel, :with_prttype, :with_active, :with_region, :with_cert],
      sanitize_params: true,
   ) or return
   @userexport = @filterrific.find
   @users = @filterrific.find.paginate(page: params[:page], per_page: 25)

   respond_to do |format|
     format.html { render "index" }
     format.js
     format.csv { send_data @userexport.to_csv, filename: "ThinManagerPortal_UsersQuery-#{Date.today}.csv" }
   end

   rescue ActiveRecord::RecordNotFound => e
     # There is an issue with the persisted param_set. Reset it.
     puts "Had to reset filterrific params: #{e.message}"
     redirect_to(reset_filterrific_url(format: :html)) && return

end


def si
  if (!logged_in?) 
    @user = User.new
  elsif (logged_in? and current_user.admin?) 
    @user = User.new
  elsif (logged_in? and !current_user.admin?)
    #flash[:warning] = "You have already signed up and have an account"
    redirect_to "/labs"
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



def evt
  @event = Event.find([params[:id]]).first
  @registrations = EventAttendee.where(:event_id => @event.id, :canceled => false, :waitlist => false)

    if @event.capacity != nil && (@event.capacity > @registrations.count)

          if (!logged_in?) 
            @user = User.new
          elsif (logged_in? and current_user.admin?) 
            @user = User.new
          elsif (logged_in? and !current_user.admin?)
            flash[:warning] = "You have already signed up and have an account"
            redirect_to root_path
          end
          @tm = 'Check the option that best describes your relationship to ThinManager'

    elsif  @event.capacity != nil && (@event.capacity <= @registrations.count) #waitlist

        if (!logged_in?) 
            @user = User.new
          elsif (logged_in? and current_user.admin?) 
            @user = User.new
          elsif (logged_in? and !current_user.admin?)
            flash[:warning] = "You have already signed up and have an account"
            redirect_to root_path
          end
          @tm = 'Check the option that best describes your relationship to ThinManager'

    else

        flash[:info] = "This event is currently not accepting registrations."
        redirect_to event_path(@event)

    end

end



def signup
  @user = User.new(user_params)
  @user.needs_review = true
  @user.cert_signup = true
    if @user.save
        session[:user_id] = @user.id
        @user.update_attribute(:lastlogin, Time.now)
        @user.send_signup_notice  #change for production
        @user.send_newuser_zap
        @user.send_user_signup_notice #change for production
        flash[:success] = "Welcome to the ThinManger Portal. Your account has been created. This is the Dashboard. You can start certification by clicking below."
        redirect_to root_path
    else
        render 'si'
    end
end


def signup_rau
  @user = User.new(user_params)
  #@receiver = User.find(1) #remove for production
  @user.needs_review = true
  @user.cert_signup = true
  @user.referred_by = "RAU"
    if @user.save
        session[:user_id] = @user.id
        @user.update_attribute(:lastlogin, Time.now)
        @user.send_rau_notice
        @user.send_newuser_zap 
        @user.send_user_signup_notice #change for production
        #@receiver.send_user_signup_notice #change for production
        flash[:success] = "Welcome to the ThinManger Portal. Your account has been created. This is the Dashboard. You can start certification by clicking below."
        redirect_to root_path
    else
        render 'rau'
    end
end


def signup_evt
  @user = User.new(user_params)
  @event = Event.find([params[:id]]).first
  @registrations = EventAttendee.where(event_id: @event.id).where.not(canceled: true).where.not(waitlist: true)
  #@waitlist = EventAttendee.where(event_id: @event.id).where(canceled: false).where(waitlist: true)
  
  @user.needs_review = true
  @user.event_signup = true
  @user.referred_by = "Events"
    if @user.save
        session[:user_id] = @user.id
        @user.update_attribute(:lastlogin, Time.now)
        @user.send_account_created_evt
        @user.send_acct_create_evt_internal
        @user.send_newuser_zap

        if @registrations.count < @event.capacity
            @register = EventAttendee.new(:event_id => @event.id, :user_id => @user.id, :lastname => @user.lastname)
            
            if @register.save
                # send confirmation emails here
                @user.send_user_evt_registration(@event)
                @user.send_event_reg_internal_notice(@event) 
                @user.send_event_reminder(@event)
                flash[:success] = "Your account has been created, and you have been registered for #{@event.name}."
                redirect_to user_path(@user)

            else

                flash[:danger] = "Your account has been created, but we had a problem registering for #{@event.name}. Please click the Ragister button below to try again."
                redirect_to event_path(@event)

            end

        else

            @register = EventAttendee.new(:event_id => @event.id, :user_id => @user.id, :lastname => @user.lastname, :waitlist => true)

            if @register.save
                # send confirmation emails here
                #@user.send_user_evt_registration(@event) # waitlist email
                #@user.send_event_reg_internal_notice(@event) # internal waitlist email
                #@user.send_event_reminder(@event)
                flash[:success] = "Your account has been created, and you have been added to the waitlist for #{@event.name}."
                redirect_to user_path(@user)

            else

                flash[:danger] = "Your account has been created, but we had a problem adding you to the waitlist for #{@event.name}. Please click the waitlist link below to try again."
                redirect_to event_path(@event)

            end

         end

        
    else
        render :action => "evt", @event.id => params[:id]
    end
end


def learn
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


def learn_signup
  @user = User.new(user_params)
  @user.needs_review = true
  @user.learn_signup = true
  @user.referred_by = "Video Learning"
    if @user.save
        session[:user_id] = @user.id
        @user.update_attribute(:lastlogin, Time.now)
        @user.send_learning_register_notice
        @user.send_newuser_zap
        @user.send_learning_user_signup_notice
        flash[:success] = "Welcome to the ThinManger Portal and the Video Training Course. As you complete each section you will receive a badge and be one step closer to a ThinManager expert!"
        redirect_to learning_path
    else
        render 'learn'
    end
end


def review
  @sort = [params[:sort]]
  @users = User.where(needs_review: true).paginate(page: params[:page], per_page: 25).order(@sort)

  respond_to do |format|
      format.html { render "review" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_NeedsReview-#{Date.today}.csv" }
    end
end


def allsignups
  @sort = [params[:sort]]
  @users = User.where(cert_signup: true).paginate(page: params[:page], per_page: 25).order(@sort)
  

  respond_to do |format|
      format.html { render "allsignups" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_CertSignedUp-#{Date.today}.csv" }
    end
end


def learnsignups
  @sort = [params[:sort]]
  @users = User.where(learn_signup: true).paginate(page: params[:page], per_page: 25).order(@sort)
  

  respond_to do |format|
      format.html { render "learnsignups" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_LearnSignedUp-#{Date.today}.csv" }
    end
end




def search
  @parameter
  if params[:search].blank?
    @parameter = nil
    redirect_to users_path and return
  else
    @parameter = params[:search].downcase
    @users = User.where("lower(firstname||lastname||company||email||channel) LIKE ?", "%#{@parameter}%").order(:lastname)
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
    @alldist = User.where(prttype: "Distributor")
    @allusers = User.all

    respond_to do |format|
      format.html { render "distributor" }
      format.csv { send_data @alldist.to_csv, filename: "PartnerPortal_Distributors-#{Date.today}.csv" }
    end
end

def integrator
    @sort = [params[:sort]]
    @users = User.where(prttype: "Integrator").paginate(page: params[:page], per_page: 25).order(@sort)
    @allsi = User.where(prttype: "Integrator")
    @allusers = User.all

    respond_to do |format|
      format.html { render "integrator" }
      format.csv { send_data @allsi.to_csv, filename: "PartnerPortal_Integrators-#{Date.today}.csv" }
    end
end

def siexpired
    @sort = [params[:sort]]
    @users = User.where.not(certexpire: nil).where("certexpire < ?", Date.today).where(prttype: "Integrator").paginate(page: params[:page], per_page: 25).order(@sort)
    @allforcsv = User.where.not(certexpire: nil).where("certexpire < ?", Date.today).where(prttype: "Integrator")

    respond_to do |format|
      format.html { render "siexpired" }
      format.csv { send_data @allforcsv.to_csv, filename: "PartnerPortal_IntegratorsExpired-#{Date.today}.csv" }
    end
end

def siabouttoexpire
    @sort = [params[:sort]]
    @users = User.where.not(certexpire: nil).where("certexpire >= ?", Date.today).where("certexpire < ?", Date.today+90).where(prttype: "Integrator").paginate(page: params[:page], per_page: 25).order(@sort)
    @allforcsv = User.where.not(certexpire: nil).where("certexpire >= ?", Date.today).where("certexpire < ?", Date.today+90).where(prttype: "Integrator")

    respond_to do |format|
      format.html { render "siabouttoexpire" }
      format.csv { send_data @allforcsv.to_csv, filename: "PartnerPortal_SIsAboutToExpire-#{Date.today}.csv" }
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

def eventusers
    @sort = [params[:sort]]
    @users = User.where(referred_by: "Events").paginate(page: params[:page], per_page: 25).order(@sort)
    @allusers = User.all

    respond_to do |format|
      format.html { render "eventusers" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_Events-#{Date.today}.csv" }
    end
end

def videousers
    @sort = [params[:sort]]
    @users = User.where(referred_by: "Video Learning").paginate(page: params[:page], per_page: 25).order(@sort)
    @allusers = User.all

    respond_to do |format|
      format.html { render "videousers" }
      format.csv { send_data @users.to_csv, filename: "PartnerPortal_Events-#{Date.today}.csv" }
    end
end




def new
    @user = User.new
end



def edit
    
end


def show
     
     @badge = UserBadge.where(user_id: @user.id).take   


     @demokits = Demokit.where(user_id: @user.id)
     @user_certs = Certification.where(user_id: @user.id).order("date_earned desc")   
     @user_flexs = Flexforward.where(user_id: @user.id).limit(10).order("id desc")
     @user_license = License.where(user_id: @user.id).limit(1)
     @listing = Listing.where(user_id: @user.id).first
     @user_registrations = EventAttendee.where(user_id: @user.id).where.not(canceled: true)
     @postal_code = (@user.zip).to_s
     @user_events = []
     if @user_registrations.any?
        @user_registrations.each do |reg|
            @event = Event.find(reg.event_id)
            @user_events.push @event
        end
     end

     
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
        params.require(:user).permit(:firstname, :lastname, :email, :email_confirmation, :notes, :company, :password, :password_confirmation, :continent, :active, :prttype, :silevel, :channel, :certdate, :certexpire, :search, :distributor, :integrator, :end_user, :oem, :needs_review, :hw_admin, :evt_admin, :cell, :carrier, :street, :street2, :city, :state, :zip)
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