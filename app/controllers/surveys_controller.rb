class SurveysController < ApplicationController
	before_action :require_admin, except: [:show, :submit]
	before_action :set_survey, only: [:edit, :update, :show, :submit]


def index
	@surveys = Survey.all
end


def new
	@survey = Survey.new
end


def show

end


def edit

end


def create

	@survey = Survey.new(survey_params)

    if @survey.save
        flash[:success] = "Survey has been created"
        redirect_to surveys_path
    else
        render 'new'
    end

end

def update

	if @survey.update(survey_params)
        flash[:success] = "Survey information was successfully updated"
        redirect_to survey_path(@survey)
    else
        render 'edit'
    end

end


def results

end


def submit

end








private

def survey_params
    params.require(:survey).permit(:title, :description, :exp_date, :image_url, :randomize, :required_user, :live)
end

def set_survey
    @survey = Survey.find(params[:id])
end

def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.evt_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end