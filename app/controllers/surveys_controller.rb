class SurveysController < ApplicationController
	before_action :require_admin, except: [:show, :submit]
	before_action :set_survey, only: [:edit, :update, :show, :submit]
    before_action :needs_user, only: :show
    before_action :must_be_live, only: :show
    before_action :not_expired, only: :show


def index
	
    @filterrific = initialize_filterrific(
     Survey,
     params[:filterrific],
      select_options: {
        survey_sort: Survey.options_for_survey_sort,
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:survey_sort, :survey_search],
      sanitize_params: true,
   ) or return
   #@surveyexport = @filterrific.find
   @surveys = @filterrific.find.paginate(page: params[:page], per_page: 10)

   respond_to do |format|
     format.html { render "index" }
     format.js
     #format.csv { send_data @surveyexport.to_csv, filename: "ThinManagerPortal_SurveysQuery-#{Date.today}.csv" }
   end

   rescue ActiveRecord::RecordNotFound => e
     # There is an issue with the persisted param_set. Reset it.
     puts "Had to reset filterrific params: #{e.message}"
     redirect_to(reset_filterrific_url(format: :html)) && return

end


def new
	@survey = Survey.new
end


def show

end


def edit
	@questions = SurveyQuestion.where(survey_id: @survey.id)
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




def destroy
    @survey = Survey.find(params[:id])
    @survey.destroy
    flash[:danger] = "The Survey has been deleted"
    redirect_back(fallback_location:"/")
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

def needs_user
    @survey = Survey.find(params[:id])
    if !logged_in? && @survey.required_user
        flash[:info] = "Sorry. you must be logged in to take this survey."
        redirect_back(fallback_location:"/")
    end
end

def must_be_live
    @survey = Survey.find(params[:id])
    if (logged_in? && !current_user.admin? && !@survey.live) || (!logged_in? && !@survey.live)
        flash[:info] = "That survey isn't marked live yet."
        redirect_back(fallback_location:"/")
    end
end

def not_expired
    @survey = Survey.find(params[:id])
    if (logged_in? && !current_user.admin? && @survey.exp_date != nil && @survey.exp_date < Date.today) || (!logged_in? && @survey.exp_date != nil && @survey.exp_date < Date.today)
        flash[:info] = "That survey has expired."
        redirect_back(fallback_location:"/")
    end
end


end