class PagesController < ApplicationController
	before_action :must_login, only: [:dashboard, :pricing, :documents, :vflex, :flexforward, :mycert, :learning, :labs, :upload, :upload_file, :pinpoint]
	before_action :can_see_pricing, only: [:pricing]
    before_action :can_print_cert, only: [:mycert]
    before_action :require_admin, only: [:uploads, :reports]
    

def new_dl
	@download = Download.new(user_id: current_user.id)

    if @download.save
        
        flash[:success] = "Your Download should have started. If you have issues, please contact us."
        redirect_back(fallback_location:"/")
        #download user email actions here
            current_user.send_download_ext_notice
            current_user.send_download_int_notice
            current_user.send_download_zap
        #zap to workflow for download
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
    @badge = UserBadge.where(user_id: @user.id).take 
    @license = License.where(user_id: current_user.id).first
    @listing = Listing.where(user_id: current_user.id).first
    @postal_code = (@user.zip).to_s
	respond_to do |format| 
      format.html { render "dashboard" } 
    end
    
end 


def tmc

    @url = request.original_url

    if @url.include? "hardware"
        @bg = 'hardware'
    elsif @url.include? "tablets"
        @bg = 'tablets'
    elsif @url.include? "tmc"
        @bg = 'tmc'
    elsif @url.include? "features"
        @bg = 'features'    
    else
        @bg = 'peripheral'
    end

end


def tablets

    @url = request.original_url

    if @url.include? "hardware"
        @bg = 'hardware'
    elsif @url.include? "tablets"
        @bg = 'tablets'
    elsif @url.include? "tmc"
        @bg = 'tmc'
    elsif @url.include? "features"
        @bg = 'features'    
    else
        @bg = 'peripheral'
    end

end


def badgeAwardEmailCheck(user, specific, userbadge)

end

def badgecount(badge)
    @bcount = 0 
      if badge.configuration
        @bcount += 1
      end
      if badge.productivity
        @bcount += 1
      end
      if badge.visualization
        @bcount += 1
      end
      if badge.security
        @bcount += 1
      end
      if badge.mobility
        @bcount += 1
      end
    return @bcount
end


def learning

    @user = current_user
    @quizzes = Quiz.joins(:categories).where.not(categories: { name: "Certification" })
    @prodquizzes = @quizzes.where(categories: { name: "Productivity" })
    @visquizzes = @quizzes.where(categories: { name: "Visualization" })
    @secquizzes = @quizzes.where(categories: { name: "Security" })
    @mobquizzes = @quizzes.where(categories: { name: "Mobility" })
    @configquizzes = @quizzes.where(categories: { name: "Configuration" })
    @advancedquizzes = @quizzes.where(categories: { name: "Advanced" })
    @badge = UserBadge.where(user_id: @user.id).take

    # @count = badgecount(@badge)

    #### Configuration Badge ####
    @config_q_passed = 0
    @configquizzes.each do |quiz|
        @uqquery = UserQuiz.where(user_id: @user.id, quiz_id: quiz.id)
        if @uqquery != [] 
            @config_q_passed += 1
        end
    end

    if (@config_q_passed == @configquizzes.count) && @configquizzes.count > 0
        if  @badge == nil
            @newconfigbadge = UserBadge.new(user_id: @user.id, configuration: true)
            if @newconfigbadge.save
                flash[:success] = "You earned your CONFIGURATION badge!"
                ### Check Progress possibly Send Badge Email ###
                    @badgenew = UserBadge.where(user_id: @user.id).take
                    @specific = "Configuration"
                    @user.send_badge_earned(@specific, @badgenew)
                redirect_to learning_path 
            end
        elsif @badge != nil && !@badge.configuration
            if @badge.update(configuration: true)
                flash[:success] = "You earned your CONFIGURATION badge!"
                ### Check Progress possibly Send Badge Email ###
                    @count = badgecount(@badge) 
                    if @count == 3 || @count == 5
                        @specific = "Configuration"
                        @user.send_badge_earned(@specific, @badge)
                    end 
                redirect_to learning_path
            else
                flash[:danger] = "There was a problem awarding your badge."
                redirect_to learning_path
            end
        end 
    end
    #### END Configuration Badge ####



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
                ### Check Progress possibly Send Badge Email ###
                    @badgenew = UserBadge.where(user_id: @user.id).take
                    @specific = "Productivity"
                    @user.send_badge_earned(@specific, @badgenew)
                redirect_to learning_path 
            end
        elsif @badge != nil && !@badge.productivity
            if @badge.update(productivity: true)
                flash[:success] = "You earned your PRODUCTIVITY badge!"
                ### Check Progress possibly Send Badge Email ###
                    @count = badgecount(@badge) 
                    if @count == 3 || @count == 5
                        @specific = "Configuration"
                        @user.send_badge_earned(@specific, @badge)
                    end
                redirect_to learning_path
            else
                flash[:danger] = "There was a problem awarding your badge."
                redirect_to learning_path
            end
        end 
    end
    #### END Productivity Badge ####



    #### Visualization Badge ####
    @vis_q_passed = 0
    @visquizzes.each do |quiz|
        @uqquery = UserQuiz.where(user_id: @user.id, quiz_id: quiz.id)
        if @uqquery != [] 
            @vis_q_passed += 1
        end
    end

    if (@vis_q_passed == @visquizzes.count) && @visquizzes.count > 0
        if  @badge == nil
            @newvisbadge = UserBadge.new(user_id: @user.id, visualization: true)
            if @newvisbadge.save
                flash[:success] = "You earned your VISUALIZATION badge!"
                ### Check Progress possibly Send Badge Email ###
                    @badgenew = UserBadge.where(user_id: @user.id).take
                    @specific = "Visualization"
                    @user.send_badge_earned(@specific, @badgenew)
                redirect_to learning_path 
            end
        elsif @badge != nil && !@badge.visualization
            if @badge.update(visualization: true)
                flash[:success] = "You earned your VISUALIZATION badge!"
                ## Check Progress possibly Send Badge Email ###
                    @count = badgecount(@badge) 
                    if @count == 3 || @count == 5
                        @specific = "Visualization"
                        @user.send_badge_earned(@specific, @badge)
                    end
                redirect_to learning_path
            else
                flash[:danger] = "There was a problem awarding your badge."
                redirect_to learning_path
            end
        end 
    end
    #### END Visualization Badge ####




    #### Security Badge ####
    @sec_q_passed = 0
    @secquizzes.each do |quiz|
        @uqquery = UserQuiz.where(user_id: @user.id, quiz_id: quiz.id)
        if @uqquery != [] 
            @sec_q_passed += 1
        end
    end

    if (@sec_q_passed == @secquizzes.count) && @secquizzes.count > 0
        if  @badge == nil
            @newsecbadge = UserBadge.new(user_id: @user.id, security: true)
            if @newsecbadge.save
                flash[:success] = "You earned your SECURITY badge!"
                ## Check Progress possibly Send Badge Email ###
                    @badgenew = UserBadge.where(user_id: @user.id).take
                    @specific = "Security"
                    @user.send_badge_earned(@specific, @badgenew)
                redirect_to learning_path 
            end
        elsif @badge != nil && !@badge.security
            if @badge.update(security: true)
                flash[:success] = "You earned your SECURITY badge!"
                ## Check Progress possibly Send Badge Email ###
                    @count = badgecount(@badge) 
                    if @count == 3 || @count == 5
                        @specific = "Security"
                        @user.send_badge_earned(@specific, @badge)
                    end
                redirect_to learning_path
            else
                flash[:danger] = "There was a problem awarding your badge."
                redirect_to learning_path
            end
        end 
    end
    #### END Security Badge ####



    #### Mobility Badge ####
    @mob_q_passed = 0
    @mobquizzes.each do |quiz|
        @uqquery = UserQuiz.where(user_id: @user.id, quiz_id: quiz.id)
        if @uqquery != [] 
            @mob_q_passed += 1
        end
    end

    if (@mob_q_passed == @mobquizzes.count) && @mobquizzes.count > 0
        if  @badge == nil
            @newmobbadge = UserBadge.new(user_id: @user.id, mobility: true)
            if @newmobbadge.save
                flash[:success] = "You earned your MOBILITY badge!"
                ## Check Progress possibly Send Badge Email ###
                    @badgenew = UserBadge.where(user_id: @user.id).take
                    @specific = "Mobility"
                    @user.send_badge_earned(@specific, @badgenew)
                redirect_to learning_path 
            end
        elsif @badge != nil && !@badge.mobility
            if @badge.update(mobility: true)
                flash[:success] = "You earned your MOBILITY badge!"
                ## Check Progress possibly Send Badge Email ###
                    @count = badgecount(@badge) 
                    if @count == 3 || @count == 5
                        @specific = "Mobility"
                        @user.send_badge_earned(@specific, @badge)
                    end
                redirect_to learning_path
            else
                flash[:danger] = "There was a problem awarding your badge."
                redirect_to learning_path
            end
        end 
    end
    #### END Mobility Badge ####


end


def pinpoint

end



def reports
    @users = User.all
    @allquizzed = UserQuiz.all
    @configbadges = UserBadge.where(configuration: true)
    @prodbadges = UserBadge.where(productivity: true)
    @visbadges = UserBadge.where(visualization: true)
    @secbadges = UserBadge.where(security: true)
    @mobbadges = UserBadge.where(mobility: true)
    @allbadgesearned = UserBadge.where(configuration: true, productivity: true, visualization: true, security: true, mobility: true)
    @badgesearned = @configbadges.count + @prodbadges.count + @visbadges.count + @secbadges.count + @mobbadges.count
    
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

    @certified = User.where.not(certexpire: nil).where("certexpire >= ?", Date.today)
    @certexpired = User.where.not(certexpire: nil).where("certexpire < ?", Date.today)
    @sicertexpired = User.where.not(certexpire: nil).where("certexpire < ?", Date.today).where(prttype: "Integrator")
    @siabouttoexpire = User.where.not(certexpire: nil).where("certexpire >= ?", Date.today).where("certexpire < ?", Date.today+90).where(prttype: "Integrator")
    @certsi = User.where.not(certexpire: nil).where("certexpire >= ?", Date.today).where(prttype: "Integrator")
    @certoem = User.where.not(certexpire: nil).where("certexpire >= ?", Date.today).where(prttype: "OEM")
    @certsignedup = User.where(cert_signup: true)
    @inprogress = User.where(cert_signup: true, needs_review: true)
    
    @wrongs = Wrong.all
    if @wrongs.count >= 1
        @wrongs_month = Wrong.where(created_at: 1.month.ago..Date.tomorrow)
        @mostmissed = Wrong.group(:question_id).select(:question_id).order(Arel.sql('COUNT(*) DESC')).first.question_id
        if @wrongs_month.any?
            @mostmissed_month = @wrongs_month.group(:question_id).select(:question_id).order(Arel.sql('COUNT(*) DESC')).first.question_id
        else
            @mostmissed_month = nil
        end
        @most_missed_quiz = Question.find(@mostmissed).quizzes.last
        if @mostmissed_month != nil
            @most_missed_quiz_month = Question.find(@mostmissed_month).quizzes.last
            @question_missed_most_month = Question.find(@mostmissed_month).question
        else
            @most_missed_quiz_month = nil
            @question_missed_most_month = nil
        end
        @question_missed_most = Question.find(@mostmissed).question

        
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
    @qr_most_user_month = @qrmonth.group(:user_id).select(:user_id).order(Arel.sql('COUNT(*) DESC')).first.user_id
    else 
       @qr_most_user_month = nil 
    end
    @qr_most_user = Qrcode.group(:user_id).select(:user_id).order(Arel.sql('COUNT(*) DESC')).first.user_id
    @qr_best_user = User.find(@qr_most_user)
    if @qr_most_user_month != nil 
        @qr_best_user_month = User.find(@qr_most_user_month)
    else
        @qr_best_user_month = nil
    end

    @evt_users = User.where(referred_by: "Events")
    @evt_registrations = EventAttendee.where(:canceled => false)
    @evt_reg_cancels = EventAttendee.where(:canceled => true)
    @event_attended = EventAttendee.where(:canceled => false).where(:checkedin => true)
    @pastevts = Event.where("endtime < ?", Date.today)
    @pastregistered = EventAttendee.joins(:event).where("endtime < ?", Date.today)
    @pastattended = @pastregistered.where(:checkedin => true)
    @evt_average_attend = ((@pastattended.count).to_f / (@pastregistered.count).to_f) * 100

    @learn_users = User.where(referred_by: "Video Learning")

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