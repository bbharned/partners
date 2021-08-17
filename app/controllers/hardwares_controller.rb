class HardwaresController < ApplicationController
	before_action :require_admin, only: [:new, :edit, :update, :destroy]
	before_action :set_hardware, only: [:edit, :update, :show, :destroy]



def index
	if !logged_in?
		@current_user = nil
	end
	@hardwares = Hardware.all
end



def new
	@hardware = Hardware.new
end



def create
	@hardware = Maker.new(hardware_params)

    if @hardware.save
        flash[:success] = "Hardware company has been created and saved"
        redirect_to hardwares_path
    else
        render 'new'
    end
end


def update
	if @hardware.update(hardware_params)
        flash[:success] = "Hardware Company was successfully updated"
        redirect_to hardwares_path
    else
        render 'edit'
    end
end


def show

end


def edit

end


def destroy
	@hardware = Hardware.find(params[:id])
    @hardware.destroy
    flash[:danger] = "That piece of hardware has been deleted"
    redirect_to hardwares_path
end






private

	def hardware_params
	    params.require(:hardware).permit(:maker_id, :hwstatus_id, :hwtype_id, :model, :terminal_type, :min_firmware, :max_firmware, :hardware_gpu_id, :cpu, :touch_interface, :network_card, :pci_network_id, :note)
	end

	def set_hardware
	    @hardware = Hardware.find(params[:id])
	end


	def require_admin
	    if (logged_in? and (!current_user.admin? && !current_user.hw_admin?)) || !logged_in? 
	        flash[:danger] = "Only admin users can perform that action"
	        redirect_to root_path
	    end
	end


end