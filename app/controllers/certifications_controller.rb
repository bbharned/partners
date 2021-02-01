class CertificationsController < ApplicationController
	before_action :must_login
	before_action :require_admin, except: [:instruction, :create, :new]
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
@user_certs = Certification.where(user_id: @user.id)

	if @user.prttype != "Integrator" && !@user.admin?
		flash[:warning] = "It looks like you don't need to be certified. If you have questions or think this is incorrect, please contact us at certification@thinmanager.com."
		redirect_to root_path

	elsif !@user_certs.any?

	elsif (@user_certs.any? && (@user_certs.last.date_earned  > Date.today - 364)) || (@user.certexpire > Date.today + 364)
		flash[:warning] = "It looks like you don't need to be certified at this time. Please check back within a year of your expiration date. If you have questions or think this is incorrect, please contact us at certification@thinmanager.com."
		redirect_to root_path

	end

end




def create 

	@answer1 = params[:answer1]
	@answer2 = params[:answer2]
	@answer3 = params[:answer3]
	@answer4 = params[:answer4]
	@answer5 = params[:answer5]
	@answer6 = params[:answer6]
	@answer7 = params[:answer7]
	@answer8 = params[:answer8]
	@answer9 = params[:answer9]
	@answer10 = params[:answer10]

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
	if @questions[4].answer == @answer5
		@score += 1
	end
	if @questions[5].answer == @answer6
		@score += 1
	end
	if @questions[6].answer == @answer7
		@score += 1
	end
	if @questions[7].answer == @answer8
		@score += 1
	end
	if @questions[8].answer == @answer9
		@score += 1
	end
	if @questions[9].answer == @answer10
		@score += 1
	end




	if @score >= 7
		@user = current_user
		@cert = Certification.new(user_id: @user.id, name: "FY21", version: 11.2, date_earned: Date.today, exp_date: Date.today+730)
		@user.certdate = @cert.date_earned
		@user.certexpire = @cert.exp_date
		@old_user_certs = Certification.where(user_id: @user.id)

		
		if @cert.save
			#@current_user.send_notice_certification #sends email to Bryan, Paul and Tom
	        
	        flash[:success] = "CONTRATULATIONS!! You passed the quiz and are now recertified as a ThinManager Systems Integrator for the next two years. 
	        You should notice that your certification expiration date has been updated below and on your profile page. If you need to update your lab license as well, 
	        please contact us at certification@thinmanager.com."
	        if @user.save

	        else
	        	flash[:danger] = "There was a problem updating the expiration date of the new certification on the user profile.  Please contact us."
	        end

	        if @old_user_certs.any?
				@old_user_certs.each do |uc|
					if uc.date_earned != Date.today
						uc.active = false
						if uc.save 
						
						else
							flash[:danger] = "There was a problem updating the old certifications to no longer be active."
						end
					end
				end
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
	#Quiz Questions
	@q1 = "What is a standard color for an apple?"
	@q2 = "What color are bananas?"
	@q3 = "What color are oranges?"
	@q4 = "What color is an eggplant?"
	@q5 = "What color is an eggplant?"
	@q6 = "What color is an eggplant?"
	@q7 = "What color is an eggplant?"
	@q8 = "What color is an eggplant?"
	@q9 = "What color is an eggplant?"
	@q10 = "What color is an eggplant?"
	
	#Quiz Answers
	@a1 = "Red"
	@a2 = "Yellow"
	@a3 = "Orange"
	@a4 = "Purple"
	@a5 = "Purple"
	@a6 = "Purple"
	@a7 = "Purple"
	@a8 = "Purple"
	@a9 = "Purple"
	@a10 = "Purple"

	#Quiz Array of questions
	@questions = [
	     Question.new(@q1, @a1),
	     Question.new(@q2, @a2),
	     Question.new(@q3, @a3),
	     Question.new(@q4, @a4),
	     Question.new(@q5, @a5),
	     Question.new(@q6, @a6),
	     Question.new(@q7, @a7),
	     Question.new(@q8, @a8),
	     Question.new(@q9, @a9),
	     Question.new(@q10, @a10)
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