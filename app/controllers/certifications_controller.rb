class CertificationsController < ApplicationController
	before_action :must_login
	before_action :require_admin, except: [:instruction, :create, :new]
	#skip_before_action :require_admin, only: [:new_cert]
	before_action :set_cert, only: [:edit, :update, :show, :destroy]
	before_action :make_quiz, only: [:new, :create]


def index
	@certifications = Certification.paginate(page: params[:page], per_page: 25).order("id desc")
end



def instruction

end





def new

@certification = Certification.new
@user = current_user

end




def create 

	@answer1 = params[:answer1]
	@answer2 = params[:answer2]
	@answer3 = params[:answer3]
	@answer4 = params[:answer4]

	@score = 0

	if @questions[0].answer == @answer1
		@score += 1
	end
	if @questions[1].answer == @answer2
		@score += 1
	end
	if @questions[2].answer == @answer3
		@score += 1
	end
	if @questions[3].answer == @answer4
		@score += 1
	end


	# @questions.each do |question|
 #          answer = gets.chomp()
 #          if answer == question.answer
 #               score += 1
 #          end
 #    end



	if @score >= 3
		@user = current_user
		@cert = Certification.new(user_id: @user.id, name: "FY21", version: 11.2, date_earned: Date.today, exp_date: Date.today+730)
		#@user.certdate = Date.today
		#@user.certexpire = Date.today + 730

		if @cert.save
			#@current_user.send_notice_certification
	        flash[:success] = "CONTRATULATIONS!! You passed the test with a score of #{@score} out of #{@count}"
	        if @user.save

	        else
	        	flash[:danger] = "There was a problem updating the expiration date of the new certification on the user profile.  Please #{link_to 'contact us', 'mailt:certification@thinmanager.com'}"
	        end
	    end

		
	else #didn't pass.

		flash[:danger] = "That didn't go so well did it? You only got #{@score} right out of #{@count}"
	
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
	@q3 = "What color are oranges?"
	@q4 = "What color is an eggplant?"
	@a1 = "Red"
	@a2 = "Yellow"
	@a3 = "Orange"
	@a4 = "Purple"

	@questions = [
	     Question.new(@q1, @a1),
	     Question.new(@q2, @a2),
	     Question.new(@q3, @a3),
	     Question.new(@q4, @a4)
	]

	@count = @questions.count
end


def require_admin
    if (logged_in? and !current_user.admin?) || !logged_in? 
        flash[:danger] = "Only admin users can perform that action"
        redirect_to root_path
    end
end


end