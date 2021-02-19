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

	@wrongs = []
	@score = 0

	if @questions[0].answer == @answer1
		@score += 1
	else 
		@wrongs.append(1)
	end
	
	if @questions[1].answer == @answer2
		@score += 1
	else
		@wrongs.append(2)
	end
	
	if @questions[2].answer == @answer3
		@score += 1
	else
		@wrongs.append(3)
	end
	
	if @questions[3].answer == @answer4
		@score += 1
	else
		@wrongs.append(4)
	end

	if @questions[4].answer == @answer5
		@score += 1
	else
		@wrongs.append(5)
	end

	if @questions[5].answer == @answer6
		@score += 1
	else
		@wrongs.append(6)
	end

	if @questions[6].answer == @answer7
		@score += 1
	else
		@wrongs.append(7)
	end

	if @questions[7].answer == @answer8
		@score += 1
	else
		@wrongs.append(8)
	end

	if @questions[8].answer == @answer9
		@score += 1
	else
		@wrongs.append(9)
	end

	if @questions[9].answer == @answer10
		@score += 1
	else
		@wrongs.append(10)
	end




	if @score >= 7
		@user = current_user
		@cert = Certification.new(user_id: @user.id, name: "FY21", version: 12.0, date_earned: Date.today, exp_date: Date.today+730)
		@user.certdate = @cert.date_earned
		@user.certexpire = @cert.exp_date
		@old_user_certs = Certification.where(user_id: @user.id)

		
		if @cert.save
			
	        flash[:success] = "CONTRATULATIONS!! You passed the quiz and are now recertified as a ThinManager Systems Integrator for the next two years. 
	        You should notice that your certification expiration date has been updated below and on your profile page. If you need to update your lab license as well, 
	        please contact us at certification@thinmanager.com."
	        
	        if @user.save
	        	@current_user.send_notice_certification(@score, @wrongs) #sends email to Bryan, Paul and Tom
	        	@current_user.send_zap
	        	@current_user.send_cert_conf
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

		flash[:danger] = "That didn't go so well did it? You only got #{@score} right out of #{@count}. You Missed Questions #{@wrongs}"
		
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
	@q1 = "How does ThinManager define Redundancy?" #Licensing
	@q2 = "How does ThinManager define Failover?" #Licensing
	@q3 = "What does the database password do?" #New Features
	@q4 = "How do you set portrait mode?" #New Features
	@q5 = "What happens when the ThinServer stops?" #General
	@q6 = "How do you set a static IP on a PXE boot thin client?" #General
	@q7 = "Where do you get a Container Host?" #New Features
	@q8 = "Answer Security"
	@q9 = "Answer Security"
	@q10 = "Answer Support"
	
	#Quiz Answers
	@a1 = "Redundancy is a synchronized pair of ThinManager Servers that allows a thin client to boot and receive a configuration from either ThinManager Server."
	@a1_2 = "Redundancy is using multiple Remote Desktop Servers so that a thin client can run on a backup if the primary remote desktop server fails."
	@a1_3 = "Redundancy is using one server as both the ThinManager Server and Remote Desktop Server."
	@a1_4 = "Redundancy is running on multiple networks at the same time."
	@a2 = "Failover is using multiple Remote Desktop Servers so that a thin client can run on a backup if the primary remote desktop server fails."
	@a2_2 = "Failover is a synchronized pair of ThinManager Servers that allows a thin client to boot and receive a configuration from either ThinManager Server."
	@a2_3 = "Failover is using one server as both the ThinManager Server and Remote Desktop Server."
	@a2_4 = "Failover is running on multiple networks at the same time."
	@a3 = "The database password acts as a variable key in the encryption."
	@a3_2 = "It forces authentication to save any new configuration"
	@a3_3 = "It helps the relationship between two admin users"
	@a3_4 = "It secures active directory synchronization"
	@a4 = "On the Video page of the Terminal Configuration Wizard"
	@a4_2 = "With the Portrait Mode Module"
	@a4_3 = "ThinManager does not support Portrait Mode"
	@a4_4 = "In the Group Policy as Computer Configuration > Administrative Templates > Windows Components > Remote Desktop Services > Remote Desktop Session Host > Video>Portrait Mode = Enabled"
	@a5 = "The thin clients continue running with their existing configuration"
	@a5_2 = "The thin clients stop and need to be restarted"
	@a5_3 = "ThinManager needs to be closed and restarted"
	@a5_4 = "The thin clients will run with a seven day grace period"
	@a6 = "You can’t, all PXE boot thin clients use DHCP"
	@a6_2 = "Option 66 of the DHCP server"
	@a6_3 = "Option 67 of the DHCP server"
	@a6_4 = "In the BIOS under IP Configuration"
	@a7 = "The Container Host is a component of Microsoft Server 2016 and later and can be installed using the PowerShell"
	@a7_2 = "The container host can be downloaded for free at the ThinManager website"
	@a7_3 = "Your personal computer is the container host"
	@a7_4 = "The Container Store"
	@a8 = "Security"
	@a8_2 = "Not The Answer"
	@a8_3 = "Not The Answer"
	@a8_4 = "Not The Answer"
	@a9 = "Security"
	@a9_2 = "Not The Answer"
	@a9_3 = "Not The Answer"
	@a9_4 = "Not The Answer"
	@a10 = "Support"
	@a10_2 = "Not The Answer"
	@a10_3 = "Not The Answer"
	@a10_4 = "Not The Answer"

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

	@answers1 = [@a1, @a1_2, @a1_3, @a1_4].shuffle
	@answers2 = [@a2, @a2_2, @a2_3, @a2_4].shuffle
	@answers3 = [@a3, @a3_2, @a3_3, @a3_4].shuffle
	@answers4 = [@a4, @a4_2, @a4_3, @a4_4].shuffle
	@answers5 = [@a5, @a5_2, @a5_3, @a5_4].shuffle
	@answers6 = [@a6, @a6_2, @a6_3, @a6_4].shuffle
	@answers7 = [@a7, @a7_2, @a7_3, @a7_4].shuffle
	@answers8 = [@a8, @a8_2, @a8_3, @a8_4].shuffle
	@answers9 = [@a9, @a9_2, @a9_3, @a9_4].shuffle
	@answers10 = [@a10, @a10_2, @a10_3, @a10_4].shuffle

	@count = @questions.count
end


def require_admin
    if (logged_in? and !current_user.admin?) || !logged_in? 
        flash[:danger] = "Only admin users can perform that action"
        redirect_to root_path
    end
end


end