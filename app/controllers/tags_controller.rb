class TagsController < ApplicationController
	before_action :require_admin, except: [:show]
	before_action :set_tag, only: [:edit, :update, :show]




def index
	@tags = Tag.all

end



def new
	@tag = Tag.new
    
end


def edit

end


def show

    @events = []
    @tag.events.each do |event|
        if event.starttime >= Date.today && !event.private
            @events.push(Event.find(event.id))
        end
    end

end


def update
    if @tag.update(tag_params)
        flash[:success] = "Event Tag was successfully updated"
        redirect_to tags_path
    else
        render 'edit'
    end
end




def create
    @tag = Tag.new(tag_params)

    if @tag.save
        flash[:success] = "Event tag has been created and saved"
        redirect_to tags_path
    else
        render 'new'
    end
end


def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    flash[:danger] = "Event tag has been deleted"
    redirect_to tags_path
end




private

	def tag_params
        params.require(:tag).permit(:name, :description, :evtcategory_id, :image_link)
    end


    def set_tag
        @tag = Tag.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.evt_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end