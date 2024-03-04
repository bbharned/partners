class SurveyAnswersController < ApplicationController
	before_action :require_admin
	before_action :set_survey_answer, only: [:edit, :update]



def new
	@survey_answer = SurveyAnswer.new
	@survey_question = SurveyQuestion.find(params[:survey_question_id])
end


def create

	# @survey = Survey.find(params[:survey_id])
	@survey_answer = SurveyAnswer.new(survey_answer_params)
	@survey_answer.survey_question_id = params[:survey_question_id]
	
	
	if @survey_answer.save
		flash[:success] = "Question Answer has been created"
        redirect_to edit_survey_path(@survey_answer.survey_question.survey)
    else
        flash[:danger] = "There was a problem attaching the answer"
	    redirect_to edit_survey_path(@survey_answer.survey_question.survey)
    end

end


def edit
	@survey_answer = SurveyAnswer.find(params[:id])
	@survey_question = SurveyQuestion.find(params[:survey_question_id])
end


def update

	@survey_answer = SurveyAnswer.find(params[:id])
	@survey_question = SurveyQuestion.find(params[:survey_question_id])

	if @survey_answer.update(survey_answer_params)
        flash[:success] = "Survey Answer was successfully updated"
        redirect_to edit_survey_path(@survey_answer.survey_question.survey)
    else
        flash[:danger] = "There was a problem updating the answer"
	    redirect_to edit_survey_path(@survey_answer.survey_question.survey)
    end

end


def destroy
    @survey_answer = SurveyAnswer.find(params[:id])
    @survey_answer.destroy
    flash[:danger] = "The Survey Answer has been deleted"
    redirect_back(fallback_location:"/")
end





private

def survey_answer_params
    params.require(:survey_answer).permit(:survey_question_id, :answer, :image_url)
end

def set_survey_answer
    @survey_answer = SurveyAnswer.find(params[:id])
end

def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.evt_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end