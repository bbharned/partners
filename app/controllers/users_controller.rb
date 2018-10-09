class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update, :show]


def index

end



def new
    @user = User.new
end



def edit
    @user = User.find(params[:id])
end


def show

end


def create
    @user = User.new(user_params)

    if @user.save
        session[:user_id] = @user.id
        flash[:success] = "User has been created"
        redirect_to users_path
    else
        render 'new'
    end
end



def update
    if @user.update(user_params)
        flash[:success] = "Account information was successfully updated"
        redirect_to users_path
    else
        render 'edit'
    end
end



def destroy

end



private

	def user_params
        params.require(:user).permit(:firstname, :lastname, :email, :email_confirmation, :company, :password, :password_confirmation, :continent, :active, :prttype, :silevel, :channel)
    end

    def set_user
        @user = User.find(params[:id])
    end

    def require_same_user
        if current_user != @user && !current_user.admin
            flash[:danger] = "You can only edit your own profile information"
            redirect_to dashboard_path
        end
    end

    def require_admin
        if logged_in? and !current_user.admin?
            flash[:danger] = "Only admin users can perform that action"
            redirect_to root_path
        end
    end



end