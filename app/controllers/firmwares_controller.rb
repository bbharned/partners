class FirmwaresController < ApplicationController
	before_action :require_admin
	before_action :set_firmware, only: [:edit, :update, :show]


def index
    @firmwares = Firmware.all.order(:version)
end



def new
    @firmware = Firmware.new 

end

def show

end



def edit

end



def update
    if @firmware.update(firmware_params)
        flash[:success] = "Firmware version was successfully updated"
        redirect_to firmwares_path
    else
        render 'edit'
    end
end




def create
    @firmware = Firmware.new(firmware_params)

    if @firmware.save
        flash[:success] = "Firmware version has been created and saved"
        redirect_to firmwares_path
    else
        render 'new'
    end
end


def destroy
    @firmware = Firmware.find(params[:id])
    @firmware.destroy
    flash[:danger] = "Firmware version has been deleted"
    redirect_to firmwares_path
end









private

	def firmware_params
        params.require(:firmware).permit(:version)
    end


    def set_firmware
        @firmware = Firmware.find(params[:id])
    end


	def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.hw_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end

end