class SurveyQuestionsController < ApplicationController
	before_action :require_admin
	before_action :set_survey_question, only: [:edit, :update]



def new
	@survey_question = SurveyQuestion.new
	@survey = Survey.find(params[:survey_id])
end


def create

	# @survey = Survey.find(params[:survey_id])
	@survey_question = SurveyQuestion.new(survey_question_params)
	@survey_question.survey_id = params[:survey_id]
	
	
	if @survey_question.save
		flash[:success] = "Survey Question has been created"
        redirect_to edit_survey_path(@survey_question.survey_id)
    else
        flash[:danger] = "There was a problem attaching the question"
	    redirect_to edit_survey_path(@survey_question.survey_id)
    end

end


def edit
	@survey_question = SurveyQuestion.find(params[:id])
	@survey = Survey.find(params[:survey_id])
end


def update

	@survey_question = SurveyQuestion.find(params[:id])
	@survey = Survey.find(params[:survey_id])

	if @survey_question.update(survey_question_params)
        flash[:success] = "Survey Question was successfully updated"
        redirect_to edit_survey_path(@survey)
    else
        flash[:danger] = "There was a problem updating the question"
	    redirect_to edit_survey_path(@survey)
    end

end


def destroy
    @survey_question = SurveyQuestion.find(params[:id])
    @survey_question.destroy
    flash[:danger] = "The Survey Question has been deleted"
    redirect_back(fallback_location:"/")
end





private

def survey_question_params
    params.require(:survey_question).permit(:survey_id, :question, :image_url, :answer_type, :possible_answers)
end

def set_survey_question
    @survey_question = SurveyQuestion.find(params[:id])
end

def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.evt_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end