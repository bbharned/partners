class VideosController < ApplicationController
	before_action :require_user
    before_action :is_admin?, only: [:index, :new, :create, :edit, :update, :destroy]
	before_action :set_video, only: [:edit, :update, :show]
    
	

	def index
		@videos = Video.all
	end

	def new
		@video = Video.new
        
	end

	def create

		@video = Video.new(video_params)

        if @video.save
            flash[:success] = "Video information has been saved"
            redirect_to videos_path
        else
            render 'new'
        end

	end


	def edit
       
    end


    def show
        @vidId = @video.path[30..41]
        
    end


    def update
    	if @video.update(video_params)
            flash[:success] = "Video information was successfully updated"
            redirect_to videos_path
        else
            render 'edit'
        end
    end







    def destroy
        @video = Video.find(params[:id])
        @video.destroy
        flash[:danger] = "Video information has been deleted"
        redirect_to videos_path
    end

    


	private


        def video_params
            params.require(:video).permit(:name, :path)
        end

        def set_video
            @video = Video.find(params[:id])
        end

        def is_admin?
        	if !logged_in? || (logged_in? && !current_user.admin)
        		flash[:danger] = "Only admins can perform that operation"
        		redirect_to root_path
        	end
        end



end