class QuestionsController < ApplicationController
	before_action :require_user
	before_action :require_admin



	def new
		@question = Question.new
		@quiz = Quiz.find(params['quiz_id'])
		#@answer = Answer.new
	end


	def create

	    @question = Question.new(question_params)
	    @quiz = Quiz.find(params[:quiz_id])
	  
	    if @question.save
	    	@join = QuizQuestion.new(quiz_id: @quiz.id, question_id: @question.id)
	    	@join.save
	        flash[:success] = "Question was sucessfully created"
	        redirect_to edit_quiz_path(@quiz)
	    else
	        flash[:danger] = "That didnt work"
	        redirect_to quiz_path(@quiz)
	    end

	end

	def edit
		@question = Question.find(params[:id])
		@quiz = Quiz.find(params[:quiz_id])
		# @hasanswers = QuestionAnswer.all
		# @allanswers = Answer.all
		# @answers = @question.answers.all
		# @availablea = Answer.where.not(id: @answers) 
	end 


	def update
		@question = Question.find(params[:id])
		@quiz = Quiz.find(params[:quiz_id])

		if @question.update(question_params)
			flash[:success] = "Question was successfully updated"
			redirect_to edit_quiz_path(@quiz)
		else
			render 'edit'
		end
	end


	def destroy
        @question = Question.find(params[:id])
        @question.destroy
        flash[:danger] = "The Quiz Question has been deleted"
        redirect_back(fallback_location:"/")
    end



private

	def question_params
        params.require(:question).permit(:question, quiz_ids: [])
    end

    def require_admin
		if !logged_in? || (logged_in? && !current_user.admin?)
			flash[:danger] = "Only Admins can perform that action"
			redirect_to root_path
		end
	end

end