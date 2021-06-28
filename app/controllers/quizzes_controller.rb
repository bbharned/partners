class QuizzesController < ApplicationController
	before_action :require_user
    before_action :is_admin?, only: [:index, :new, :create, :edit, :update, :destroy]
	before_action :set_quiz, only: [:edit, :update, :show, :submit_quiz]
    before_action :quiz_answers, only: [:submit_quiz]
    
	

	def index
		@quizzes = Quiz.all
	end

	def new
		@quiz = Quiz.new
        
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
       @questions = @quiz.questions.all
       @videos = @quiz.videos.all
    end



    def submit_quiz
        @possiblequestions = 0
        @correctanswers = 0
        @wrongquestions = []
        @wronganswers = []
        @questions = @quiz.questions
        @user = current_user
        @questions.each do |q|
            if q.answers.any? && q.answers.count > 0
                @possiblequestions += 1
            end
        end

        if @qanswers.count != @possiblequestions
            
            flash[:warning] = "You did not answer all the questions" 
            render 'show'
        
        else
            
            @qanswers.each do |answer|
                if Answer.find(answer).correct == true 
                    @correctanswers += 1
                else
                    @wronganswers.append(answer)
                end
            end

            @score = ((@correctanswers).to_f / (@possiblequestions).to_f).to_f

            if @wronganswers.any?
                #flash[:danger] = "You missed questions"
                @wronganswers.each do |answer|
                    @question = Answer.find(answer).question
                    @wrongquestions.append(@question.question)
                    Wrong.create(user_id: @user.id, quiz_id: @quiz.id, question_id: @question.id, answer_id: answer)
                end
            end

            #flash[:success] = "Quiz Submitted. There were #{@possiblequestions} questions and you got #{@correctanswers} correct."
            if @score >= 0.5
                #pass
                # save quiz to user
                flash[:success] = "You passed! Your score was #{@score * 100}%. " +
                    if @score < 1 
                        "You missed #{@possiblequestions - @correctanswers}. #{@wrongquestions}."
                    else
                        ""
                    end
                redirect_to learning_path
            else
                #fail
                flash[:danger] = "You failed the quiz, Your score is #{@score * 100}%."
                redirect_to learning_path
            end

        end

        


    end





    def show
        @quiz = Quiz.find(params[:id])
        @user = User.find(current_user.id)
        @questions = @quiz.questions.all
    
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
        @questions = @quiz.questions
        if @questions.any?
            @questions.each do |q|
                q.destroy
            end
        end
        @quiz.destroy
        flash[:danger] = "Quiz information has been deleted"
        redirect_to quizzes_path
    end

    


	private


        def quiz_params
            params.require(:quiz).permit(:name, category_ids: [], question_ids: [], video_ids: [])
        end

        def set_quiz
            @quiz = Quiz.find(params[:id])
        end

        def quiz_answers
            @qanswers = []
            if params[:Question]
                params[:Question][:id].to_a
                params[:Question].each do | q, a |
                    @qanswers.push(a)
                end
            end
        end

        def is_admin?
        	if !logged_in? || (logged_in? && !current_user.admin)
        		flash[:danger] = "Only admins can perform that operation"
        		redirect_to root_path
        	end
        end



end