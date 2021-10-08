class PagesController < ApplicationController
	before_action :must_login, only: [:dashboard, :pricing, :documents, :vflex, :flexforward, :mycert, :learning, :labs, :upload, :upload_file]
	before_action :can_see_pricing, only: [:pricing]
    before_action :can_print_cert, only: [:mycert]
    before_action :require_admin, only: [:uploads, :reports]
    

def new_dl
	@download = Download.new(user_id: current_user.id)

    if @download.save
        
        flash[:success] = "Your Download should have iniated. If you have issues, please contact us."
        redirect_back(fallback_location:"/")
    else
        flash[:danger] = "There seems to have been a problem with the download. Feel free to contact us."
        redirect_back(fallback_location:"/")
    end
end

def new_calc
    @calculator = Calculator.new(user_id: current_user.id)

    if @calculator.save
        
        flash[:success] = "Your ROI Calculator download should have initiated. If you have issues, please contact us."
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
    
end 


def learning

    @user = current_user
    @quizzes = Quiz.joins(:categories).where.not(categories: { name: "Certification" })
    @prodquizzes = @quizzes.where(categories: { name: "Productivity" })
    @visquizzes = @quizzes.where(categories: { name: "Visualization" })
    @secquizzes = @quizzes.where(categories: { name: "Security" })
    @mobquizzes = @quizzes.where(categories: { name: "Mobility" })
    @badge = UserBadge.where(user_id: @user.id).take


    
    #### Productivity Badge ####
    @prod_q_passed = 0
    @prodquizzes.each do |quiz|
        @uqquery = UserQuiz.where(user_id: @user.id, quiz_id: quiz.id)
        if @uqquery != [] 
            @prod_q_passed += 1
        end
    end

    if (@prod_q_passed == @prodquizzes.count) && @prodquizzes.count > 0
        if  @badge == nil
            @newprodbadge = UserBadge.new(user_id: @user.id, productivity: true)
            if @newprodbadge.save
                flash[:success] = "You earned your PRODUCTIVITY badge!"
                redirect_to learning_path 
            end
        elsif @badge != nil && !@badge.productivity
            if @badge.update(productivity: true)
                flash[:success] = "You earned your PRODUCTIVITY badge!"
                redirect_to learning_path
            else
                flash[:danger] = "There was a problem awarding your badge."
                redirect_to learning_path
            end
        end 
    end
    #### END Productivity Badge ####
    

end






def reports
    @users = User.all
    @allquizzed = UserQuiz.all
    @prodbadges = UserBadge.where(productivity: true)
    @visbadges = UserBadge.where(visualization: true)
    @secbadges = UserBadge.where(security: true)
    @mobbadges = UserBadge.where(mobility: true)
    @badgesearned = @prodbadges.count + @visbadges.count + @secbadges.count + @mobbadges.count
    
    #@userslastmonth = User.where(created_at: 1.month.ago..Date.tomorrow)
    @distributors = User.where(prttype: "Distributor")
    @integrators = User.where(prttype: "Integrator")
    @oems = User.where(prttype: "OEM")
    @endusers = User.where(prttype: "End User")
    @baseusers = User.where(needs_review: true)

    @usersthisweek = User.where(created_at: 1.week.ago..Date.tomorrow)
    @quizthisweek = UserQuiz.where(created_at: 1.week.ago..Date.tomorrow)
    
    @usersthismonth = User.where(created_at: 1.month.ago..Date.tomorrow)
    @quizthismonth = UserQuiz.where(created_at: 1.month.ago..Date.tomorrow)
    #@loggedlastmonth = User.where(lastlogin: Date.today.beginning_last_month..Date.today.end_of_last_month)
    @loggedthismonth = User.where(lastlogin: Date.today.beginning_of_month..Date.today.end_of_month)
    
    @usersthisquarter = User.where(created_at: 3.months.ago..Date.tomorrow)
    @quizthisquarter = UserQuiz.where(created_at: 3.months.ago..Date.tomorrow)
    @loggedthisquarter = User.where(lastlogin: Date.today.beginning_of_quarter..Date.today.end_of_quarter)

    @usersthisyear = User.where(created_at: 12.months.ago..Date.tomorrow)
    @quizthisyear = UserQuiz.where(created_at: 12.months.ago..Date.tomorrow)
    @loggedthisyear = User.where(lastlogin: Date.today.beginning_of_year..Date.today.end_of_year)

    @certified = User.where.not(certexpire: nil)
    @certsignedup = User.where(cert_signup: true)
    @inprogress = User.where(cert_signup: true, needs_review: true)
    
    @wrongs = Wrong.all
    if @wrongs.count >= 1
        @wrongs_month = Wrong.where(created_at: 1.month.ago..Date.tomorrow)
        @mostmissed = Wrong.group(:question_id).select(:question_id).order("count(*) desc").first.question_id
        @mostmissed_month = @wrongs_month.group(:question_id).select(:question_id).order("count(*) desc").first.question_id
        @most_missed_quiz = Question.find(@mostmissed).quizzes.last
        @most_missed_quiz_month = Question.find(@mostmissed_month).quizzes.last
        @question_missed_most = Question.find(@mostmissed).question
        @question_missed_most_month = Question.find(@mostmissed_month).question
    else 
        @wrongs_month = nil
        @mostmissed = nil
        @mostmissed_month = nil
        @most_missed_quiz = nil
        @most_missed_quiz_month = nil
        @question_missed_most = nil
        @question_missed_most_month = nil
    end 
   

    @flexes = Flexforward.all
    @flexmonth = Flexforward.where(created_at: 1.month.ago..Date.tomorrow)
    @flexred = Flexforward.where(red_exchange: true)

    @qrs = Qrcode.all
    @qrmonth = Qrcode.where(created_at: 1.month.ago..Date.tomorrow)
    if @qrmonth.count > 0
    @qr_most_user_month = @qrmonth.group(:user_id).select(:user_id).order("count(*) desc").first.user_id
    else 
       @qr_most_user_month = nil 
    end
    @qr_most_user = Qrcode.group(:user_id).select(:user_id).order("count(*) desc").first.user_id
    @qr_best_user = User.find(@qr_most_user)
    if @qr_most_user_month != nil 
        @qr_best_user_month = User.find(@qr_most_user_month)
    else
        @qr_best_user_month = nil
    end
end


def labs
    @user = current_user
end


def upload #file selection and upload
    @user = current_user
end


def uploads #index of uploads
    require 'aws-sdk-s3'

        
        ######################## aws calls and checks ############################
        def bucket_exists?(s3_client, bucket_name)
          response = s3_client.list_buckets
          response.buckets.each do |bucket|
            return true if bucket.name == bucket_name
          end
          return false
        rescue StandardError => e
          puts "Error listing buckets: #{e.message}"
          return false
        end

        
    @user = current_user
    @s3 = Aws::S3::Client.new
    @bucket_name = 'rails-partners-bucket'
    @message
    
    if bucket_exists?(@s3, @bucket_name)
        @message = true
    else
        @message = false
    end

    @objects = @s3.list_objects_v2(
        bucket: @bucket_name,
        max_keys: 1000
      ).contents

    #@objects = @objects.order("last_modified desc")


end 




def download_lab #download file from AWS
    require 'aws-sdk-s3'

    @s3 = Aws::S3::Client.new
    #@s3 = Aws::S3::Presigner.new

    @bucket_name = 'rails-partners-bucket'
    @object_key = params[:object_key]
    #@local_path = "./#{@object_key}"
    @message_log = ""
    #@url = @s3.presigned_url(:get_object, bucket: "bucket", key: "key")

    def download_db(key:, bucket:)
      # @s3.get_object(
      #   #response_target: to,
      #   bucket: bucket,
      #   key: key
      # )

      # File.open(key, 'wb') do |file| 
      #     @s3.get_object( bucket: bucket, key: key) do |chunk|
      #       file.write(chunk)
      #     end
      # end

      File.open(key, 'wb') do |file|
          resp = @s3.get_object({ bucket: bucket, key: key }, target: file)
      end

      @message_log = response.message
    end

    begin
        download_db(key: @object_key, bucket: @bucket_name)
    rescue StandardError => e
        @message_log = e.message
        flash[:danger] = "#{@message_log} - Object '#{@object_key}' in bucket '#{@bucket_name}' was not downloaded."
        redirect_to uploads_path
    else
        flash[:success] = "AWS Message about Download - \"#{@message_log}\""
        redirect_to uploads_path
    end

    
end



def upload_file #upload action
    require 'aws-sdk-s3'

    @user = current_user
    @s3 = Aws::S3::Resource.new
    @bucket_name = 'rails-partners-bucket'
    
    @message_log = ""
    
    @file = params[:user][:cert_lab]
    @object_key = @file.original_filename
    
    begin
        if @file.content_type != "application/octet-stream"
            flash[:danger] = "Sorry, you can only upload .db files"
            redirect_to upload_path
        elsif @file.original_filename.include? ".db"
            @s3.bucket(@bucket_name).object(@object_key).upload_file(@file.tempfile)
            @user.lab_file = @object_key
            @user.save

            ## send email confirming file upload to certification@thinmanager.com
            @user.send_lab_upload_notice
            ## send email integrating Hubspot via Zapier to lab submission
            @user.send_zap_lab_upload

            flash[:success] = "Your file named \"#{@object_key}\" has been uploaded. We will review it for grading and contact you after."
            redirect_to root_path
        else
            flash[:danger] = "Sorry, you can only upload .db files"
            redirect_to upload_path
        end
        rescue StandardError => e
            @message_log = e.message
            flash[:danger] = "#{@message_log}"
            redirect_to upload_path
        end
       
        


end


def destroy_labfile
    require 'aws-sdk-s3'
    
    @s3 = Aws::S3::Resource.new
    @key = params[:key]
    @bucket_name = 'rails-partners-bucket'

    # @bucket = @s3.buckets[@bucket_name]
    # @object = @bucket.objects[@key]
    # @object.delete

    # @s3.delete_object({
    #     bucket: @bucket_name,
    #     key: @key, 
    # })

    @s3.bucket(@bucket_name).object(@key).delete

    # @obj.delete

    # @s3.delete_object(bucket: @bucket_name, key: @key)

    #flash[:warning] = "this action is not functional.  You have to do it through the AWS Console for now."
    flash[:success] = "#{@key} was successfully deleted."

    redirect_back(fallback_location:"/")
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

def flexforward
    @user = @current_user
    respond_to do |format| 
      format.html { render "flexforward" } 
    end 
end

def mycert
    @user = @current_user
    respond_to do |format| 
      format.html { render "mycert" } 
    end 
end






private

def must_login
	if !logged_in?
        redirect_to login_path
    end
end

def can_see_pricing
	if @current_user.admin? || (@current_user.prttype == "Distributor" && (@current_user.continent == "North America" || @current_user.continent == "NA"))

	else
		flash[:danger] = "You do not have permission to view this page."
		redirect_to root_path
	end
end


def can_print_cert
    if @current_user.admin? || (@current_user.certifications.any? && @current_user.certifications.last.exp_date > Date.today) || (@current_user.certexpire != nil && @current_user.certexpire > Date.today)

    else
        flash[:danger] = "You do not have permission to view this page."
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