class QuestionsController < ApplicationController
	before_action :require_user
	before_action :require_admin


def index
		@questions = Question.all
	end


	def new
		@question = Question.new
		#@answer = Answer.new
	end


	def create

	    @question = Question.new(question_params)

	    if @question.save
	        flash[:success] = "Question was sucessfully created"
	        redirect_to questions_path
	    else
	        render 'new'
	    end

	end

	def edit
		@question = Question.find(params[:id])
		@hasanswers = QuestionAnswer.all
		# @allanswers = Answer.all
		@answers = @question.answers.all
		@availablea = Answer.where.not(id: @answers) 
	end 

	def update
		@question = Question.find(params[:id])
		if @question.update(question_params)
			flash[:success] = "Question was successfully updated"
			redirect_to questions_path
		else
			render 'edit'
		end
	end



private

	def question_params
        params.require(:question).permit(:name, quiz_ids:[])
    end

    def require_admin
		if !logged_in? || (logged_in? && !current_user.admin?)
			flash[:danger] = "Only Admins can perform that action"
			redirect_to root_path
		end
	end

end