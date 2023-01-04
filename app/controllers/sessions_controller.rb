class SessionsController < ApplicationController

    def new

    end


    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.active && user.authenticate(params[:session][:password])
            session[:user_id] = user.id
            user.update(:lastlogin, Time.now)
            if ((user.street == nil || user.street == "") || (user.city == nil || user.city == "") || (user.cell == nil || user.cell == "") || (user.carrier == nil || user.carrier == "")) && !user.admin?
                flash[:warning] = "Your profile is incomplete. Update your information #{view_context.link_to 'here', edit_user_path(user)}."
            else 
                flash[:success] = "You have successfully logged In"
            end
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