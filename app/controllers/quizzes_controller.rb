class QuizzesController < ApplicationController
	before_action :require_user
    before_action :is_admin?, only: [:index, :new, :create, :edit, :update, :destroy]
	before_action :set_quiz, only: [:edit, :update, :show]
    
	

	def index
		@quizzes = Quiz.all
	end

	def new
		@quiz = Quiz.new
        # respond_to do |format|
        #     format.html
        #     format.js
        # end
	end

    
    def show_modal
      @question = Question.new(quiz_id: @quiz.id)
    end


	def create

		@quiz = Quiz.new(quiz_params)

        if @quiz.save
            flash[:success] = "Quiz information has been saved"
            redirect_to quizzes_path
        else
            render 'new'
        end

	end



	def edit
       @question = Question.new
       @questions = @quiz.questions.all
        # respond_to do |format|
        #     format.html
        #     format.js
        # end
    end



    def show_modal
      
    end



    def show
        @user = User.find(current_user.id)
        @quiz_questions = @quiz.questions.all
    end


    def update
    	if @quiz.update(quiz_params)
            flash[:success] = "Quiz information was successfully updated"
            redirect_to quiz_path(@quiz)
        else
            render 'edit'
        end
    end







    def destroy
        @quiz = Quiz.find(params[:id])
        @quiz.destroy
        flash[:danger] = "Quiz information has been deleted"
        redirect_to quizzes_path
    end

    


	private


        def quiz_params
            params.require(:quiz).permit(:name, category_ids: [], question_ids: [])
        end

        def set_quiz
            @quiz = Quiz.find(params[:id])
        end

        def is_admin?
        	if !logged_in? || (logged_in? && !current_user.admin)
        		flash[:danger] = "Only admins can perform that operation"
        		redirect_to root_path
        	end
        end



end