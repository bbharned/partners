class TermnotesController < ApplicationController
	before_action :require_admin
	before_action :set_note, only: [:edit, :update]

def new
	@note = Termnote.new
	@terminal = Terminal.where(TermcapModel: params[:termcapmodel]).first
end

def edit
	@note = Termnote.find(params[:id])
	@terminal = Terminal.where(TermcapModel: @note.termcapmodel).first

end


def create

    @note = Termnote.new(termnote_params)
    @terminal = Terminal.where(TermcapModel: @note.termcapmodel).first
  
    if @note.save
        flash[:success] = "Note was sucessfully created"
        redirect_to terminal_path(@terminal)
    else
        flash[:danger] = "That didnt work"
        redirect_to terminal_path(@terminal)
    end

end



def update
	if @note.update(termnote_params)
        flash[:success] = "Terminal note was successfully updated"
        @terminal = Terminal.where(TermcapModel: @note.termcapmodel).first
        redirect_to terminal_path(@terminal)
    else
        render 'edit'
    end
end




private

	def termnote_params
        params.require(:termnote).permit(:termcapmodel, :note)
    end

    def set_note
        @note = Termnote.find(params[:id])
    end

    def require_admin
		if (logged_in? and (!current_user.admin? && !current_user.hw_admin?)) || !logged_in?
			flash[:danger] = "Only Admins can perform that action"
			redirect_to root_path
		end
	end


end