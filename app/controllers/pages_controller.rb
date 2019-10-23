class PagesController < ApplicationController
	before_action :must_login, only: [:dashboard, :pricing, :documents, :vflex]
	before_action :can_see_pricing, only: [:pricing]

def new_dl
	@download = Download.new(user_id: current_user.id)

    if @download.save
        
        flash[:success] = "Your Download should have iniated. If you have issues, please contact us."
        redirect_to root_path
    else
        flash[:danger] = "There seems to have been a problem with the download. Feel free to contact us."
        redirect_to root_path
    end
end

def new_calc
    @calculator = Calculator.new(user_id: current_user.id)

    if @calculator.save
        
        flash[:success] = "Your ROI Calculator download should have iniated. If you have issues, please contact us."
        redirect_to root_path
    else
        flash[:danger] = "There seems to have been a problem with the download. Feel free to contact us."
        redirect_to root_path
    end
end

def dashboard
	@user = current_user
	respond_to do |format| 
      format.html { render "dashboard" } 
    end
     
    # @download = Download.new(user_id: current_user.id)
    # if @download.save
    #     flash[:success] = "success"
    #     redirect_to root_path
    # else
    #     flash[:danger] = "Didn't work"
    #     redirect_to root_path
    # end
end 


def pricing
	@channel = @current_user.channel
	respond_to do |format| 
      format.html { render "pricing" } 
    end 
end


def documents
	respond_to do |format| 
      format.html { render "documents" } 
    end 
end


def vflex
	@user = @current_user
	respond_to do |format| 
      format.html { render "vflex" } 
    end 
end









private

def must_login
	if !logged_in?
        redirect_to login_path
    end
end

def can_see_pricing
	if @current_user.admin? || @current_user.continent == "North America"

	else
		flash[:danger] = "You do not have permission to view this page."
		redirect_to root_path
	end
end




end