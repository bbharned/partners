class TermTypesController < ApplicationController
	before_action :require_admin
	before_action :set_termtype, only: [:edit, :update, :show]


def index
	@sort = [params[:sort]]
    @termtypes = TermType.all.order(@sort)
end



def new
    @termtype = TermType.new 

end

def show

end



def edit

end



def update
    if @@termtype.update(termtype_params)
        flash[:success] = "Hardware terminal bpoot type was successfully updated"
        redirect_to term_types_path
    else
        render 'edit'
    end
end




def create
    @termtype = TermType.new(termtype_params)

    if @termtype.save
        flash[:success] = "Hardware terminal boot type has been created and saved"
        redirect_to term_types_path
    else
        render 'new'
    end
end


def destroy
    @termtype = TermType.find(params[:id])
    @termtype.destroy
    flash[:danger] = "Hardware terminal boot type has been deleted"
    redirect_to term_types_path
end









private

	def termtype_params
        params.require(:term_type).permit(:name)
    end


    def set_termtype
        @termtype = TermType.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.hw_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end





end