class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # Case (1)

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = "Email sent with password reset instructions"
      redirect_to root_path
    else
      flash.now[:danger] = "Account with that email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)          # Case (4)
      session[:user_id] = @user.id
      @user.update_attribute(:lastlogin, Time.now)
      flash[:success] = "Password has been reset."
      redirect_to root_path
    else
      render 'edit'                                     # Case (2)
    end
  end



  private

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def user_params
      params.require(:user).permit(:password)
    end


    def valid_user
      if User.find_by(email: params[:email].downcase) == nil
        redirect_to root_url
      end
    end


    # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
