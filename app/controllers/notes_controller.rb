class NotesController < ApplicationController
	before_action :require_admin
	before_action :set_note, only: [:edit, :update]

def new
	@note = Note.new
	@terminal = Terminal.find(params[:terminal_id])
end

def edit
	@note = Note.find(params[:id])
	@terminal = Terminal.find(@note.terminal_id)

end


def create

    @note = Note.new(note_params)
    #@terminal = Terminal.find(@note.)
    #@terminalnote = TerminalNote.new(terminal_id: @note.terminal_id, note_id: @note.id)
  
    if @note.save
        flash[:success] = "Note was sucessfully created"
        redirect_to terminal_path(:id => @note.terminal_id)
    else
        flash[:danger] = "That didnt work"
        render 'new'
    end

end



def update
	if @note.update(note_params)
        flash[:success] = "Terminal note was successfully updated"
        redirect_to terminal_path(@note.terminal_id)
    else
        render 'edit'
    end
end




private

	def note_params
        params.require(:note).permit(:terminal_id, :note)
    end

    def set_note
        @note = Note.find(params[:id])
    end

    def require_admin
		if !logged_in? || (logged_in? && !current_user.admin?)
			flash[:danger] = "Only Admins can perform that action"
			redirect_to root_path
		end
	end


end