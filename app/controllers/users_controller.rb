class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update, :show]
    before_action :require_same_user, only: [:index, :edit, :update, :show]
    before_action :require_admin, only: [:index, :new, :create, :destroy]


def index
    @users = User.paginate(page: params[:page], per_page: 20).order(:lastname)
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