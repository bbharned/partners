class AnswersController < ApplicationController
	before_action :require_user
	before_action :require_admin


	


	def new
		@answer = Answer.new
		@question = Question.find(params['question_id'])
		
	end


	def create

	    @answer = Answer.new(answer_params)
	    @question = Question.find(params[:question_id])
	    @answer.question_id = @question.id
	    @quiz = @question.quizzes.last
	  
	    if @answer.save
	        flash[:success] = "Answer was sucessfully created"
	        redirect_to edit_quiz_path(@quiz)
	    else
	        flash[:danger] = "That didnt work"
	        redirect_to quiz_path(@quiz)
	    end

	end

	def edit
		@question = Question.find(params['question_id'])
		@answer = Answer.find(params[:id]) 
	end 


	def update
		@answer = Answer.find(params[:id])
		@question = @answer.question
		@quiz = @question.quizzes.last

		if @answer.update(answer_params)
			flash[:success] = "Answer was successfully updated"
			redirect_to edit_quiz_path(@quiz)
		else
			render 'edit'
		end
	end


	def destroy
        @answer = Answer.find(params[:id])
        @answer.destroy
        flash[:danger] = "The Answer has been deleted"
        redirect_back(fallback_location:"/")
    end



private

	def answer_params
        params.require(:answer).permit(:answer, :question_id, :correct)
    end

    def require_admin
		if !logged_in? || (logged_in? && !current_user.admin?)
			flash[:danger] = "Only Admins can perform that action"
			redirect_to root_path
		end
	end

end