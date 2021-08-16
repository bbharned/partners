class HardwaresController < ApplicationController
	before_action :require_admin, only: [:new, :edit, :update, :destroy]
	before_action :set_hardware, only: [:edit, :update, :show, :destroy]



def index
	if !logged_in?
		@current_user = nil
	end
end



def new

end



def create

end


def update

end


def show

end


def edit

end


def destroy

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