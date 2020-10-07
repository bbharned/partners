class CertificationsController < ApplicationController
	before_action :must_login
	before_action :require_admin, except: [:instruction, :create, :new]
	#skip_before_action :require_admin, only: [:new_cert]
	before_action :set_cert, only: [:edit, :update, :show, :destroy]
	before_action :make_quiz, only: [:new, :create]


def index
	@certifications = Certification.paginate(page: params[:page], per_page: 25).order("id desc")
	#@current_user.send_notice_certification
end



def instruction

end





def new

@certification = Certification.new


end




def create 

	@answer1 = params[:answer1]

	if @answer1 == "Red"
		flash[:success] = "You got it right! The answer was #{@answer1}"
    else
		flash[:danger] = "Did you really thing an apple is #{@answer1}?... Really?"
	end

	redirect_to root_path

end






def update
    
    
    if @cert.update(cert_params)
        flash[:success] = "Certification was successfully updated"
        redirect_to certifications_path
    else
        render 'edit'
    end

end


def show

end


def edit

end


def destroy
	@cert.destroy
    flash[:danger] = "The SI Certification has been deleted"
    redirect_to certifications_path
end



private

def must_login
	if !logged_in?
	    redirect_to login_path
	end
end

def cert_params
    params.require(:certification).permit(:user_id, :name, :version, :active, :date_earned, :exp_date)
end


def set_cert
    @cert = Certification.find(params[:id])
end

def make_quiz
@q1 = "What is a standard color for an apple?"
@q2 = "What color are bananas?"
@a1 = "Red"
@a2 = "Yellow"

@questions = [
     Question.new(@p1, @a1),
     Question.new(@p2, @a2)
]
end


def require_admin
    if (logged_in? and !current_user.admin?) || !logged_in? 
        flash[:danger] = "Only admin users can perform that action"
        redirect_to root_path
    end
end


end