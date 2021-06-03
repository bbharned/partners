class QrcodesController < ApplicationController
	before_action :must_login
	before_action :require_admin, only: [:index]
	before_action :set_qr, only: [:edit, :update, :show, :destroy]

def index 
	@user = current_user
	if @user.admin?
		@qrcodes = Qrcode.all
	else
		@qrcodes = Qrcode.where(user_id: @user.id)
	end
end


def new 
	@qrcode = Qrcode.new
end


def create

    @qrcode = Qrcode.new(qr_params)
    @qrcode.user = current_user
    

    if @qrcode.save
        flash[:success] = "Your new QR Code has been saved"
        redirect_to qrcode_path(@qrcode)
    else
        render 'new'
    end
end


def show
	

	require "rqrcode"

	@q = RQRCode::QRCode.new(@qrcode.content)


	@svg = @q.as_svg(
		  color: "000",
		  shape_rendering: "crispEdges",
		  module_size: 12,
		  standalone: true,
		  use_path: true
	)


end


def edit

end


def destroy
	@qrcode.destroy
    flash[:danger] = "The QR Code has been deleted"
    redirect_back(fallback_location:"/")
end

def myqrs
	@user = current_user
	@qrcodes = Qrcode.where(user_id: @user)
end






private

	def qr_params
        params.require(:qrcode).permit(:content, :user_id)
    end

	def must_login
    	if !logged_in?
            redirect_to login_path
        end
    end

    def require_admin
	    if (logged_in? and !current_user.admin?) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

	def set_qr
	    @qrcode = Qrcode.find(params[:id])
	end

	


end