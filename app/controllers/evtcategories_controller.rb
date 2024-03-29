class EvtcategoriesController < ApplicationController
	before_action :require_admin, except: [:show]
	before_action :set_type, only: [:edit, :update, :show]




def index
	@evtcategories = Evtcategory.all

end



def new
	@etype = Evtcategory.new
end


def edit

end


def show
    @groups = Tag.where(:private => false).where(evtcategory_id: params[:id])
    @allevents = EventCategory.where(evtcategory_id: params[:id])
    @events = []
    if @allevents.any?
        @allevents.each do |event|
            @e = Event.find(event.event_id)
            if @e.tags.any?
                @e.tags.each do |tag|
                    if tag.name.include? "Internal"

                    else
                        if event.event.starttime != nil && event.event.starttime != "" && event.event.starttime >= Date.today && !event.event.private
                            @events.push(Event.find(event.event_id))
                        end
                    end
                end
            else
                if event.event.starttime >= Date.today && !event.event.private
                    @events.push(Event.find(event.event_id))
                end
            end
        end
    end
    @events.delete_if {|x| !x.live?}
    
    @events = @events.sort_by {|event| event.starttime}

end


def update
    if @etype.update(etype_params)
        flash[:success] = "Event type was successfully updated"
        redirect_to evtcategories_path
    else
        render 'edit'
    end
end




def create
    @etype = Evtcategory.new(etype_params)

    if @etype.save
        flash[:success] = "Event type has been created and saved"
        redirect_to evtcategories_path
    else
        render 'new'
    end
end


def destroy
    @etype = Evtcategory.find(params[:id])
    @etype.destroy
    flash[:danger] = "Event type has been deleted"
    redirect_to evtcategories_path
end




private

	def etype_params
        params.require(:evtcategory).permit(:name, :description, :image_link, :private)
    end


    def set_type
        @etype = Evtcategory.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.evt_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end