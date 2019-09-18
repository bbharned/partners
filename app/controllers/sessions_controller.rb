class SessionsController < ApplicationController

    def new

    end


    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.active && user.authenticate(params[:session][:password])
            session[:user_id] = user.id
            user.update_attribute(:lastlogin, Time.now)
            flash[:success] = "You have successfully logged In"
            redirect_to root_path
        else
            flash.now[:danger] = "There was something wrong with your log in information"
            render 'new'
        end
    end


    def destroy
        session[:user_id] = nil
        flash[:success] = "you are successfully logged out"
        redirect_to root_path
    end

end