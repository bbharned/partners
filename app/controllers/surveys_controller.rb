class SurveysController < ApplicationController
	before_action :require_admin, except: [:show, :submit]



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

end


def results

end


def submit

end








private

def survey_params
    params.require(:survey).permit()
end

def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.evt_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end