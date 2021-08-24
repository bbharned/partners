class HardwaresController < ApplicationController
	before_action :require_admin, only: [:new, :edit, :update, :destroy]
	before_action :set_hardware, only: [:edit, :update, :show, :destroy]



def index
	if !logged_in?
		@current_user = nil
	end
	# @hardwares = Hardware.joins(:maker, :hwtype, :hwstatus)
	# if @company != nil && @company != ""
	# 	#@hardwares = @hardwares.where("maker_id = ?", @company) if @company.present?
	# 	@hardwares = @hardwares.includes(:maker).where(maker: {id: @company.id}) 
	# else
	# 	@hardwares = Hardware.all
	# end
	#@hardwares = @hardwares.where("maker_id = ?", params[:maker_id]) if params[:maker_id].present?
	#@hardwares = @hardwares.select("maker_id = ?", params[:maker_id]) if params[:maker_id].present?
	#@hardwares = @hardwares.where("hwtype_id = ?", params[:hwtype_id]) if params[:hwtype_id].present?
	#@maker_id = params[:maker_id]
	# @makers = Maker.all
	# @types = Hwtype.all
	# @statuses = Hwstatus.all
	#@filter_types = params[:type]

  @filterrific = initialize_filterrific(
     Hardware,
     params[:filterrific],
      select_options: {
        sorted_by: Hardware.options_for_sorted_by,
        with_maker_id: Maker.options_for_select,
        with_hwtype_id: Hwtype.options_for_select,
        with_hwstatus_id: Hwstatus.options_for_select,
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:sorted_by, :with_maker_id, :with_hwtype_id, :with_hwstatus_id],
      sanitize_params: true,
   ) or return
   @hardwares = @filterrific.find.page(params[:page])

   respond_to do |format|
     format.html
     format.js
   end

   rescue ActiveRecord::RecordNotFound => e
	 # There is an issue with the persisted param_set. Reset it.
     puts "Had to reset filterrific params: #{e.message}"
     redirect_to(reset_filterrific_url(format: :html)) && return

end



def new
	@hardware = Hardware.new
	@makers = Maker.all
	@types = Hwtype.all
	@statuses = Hwstatus.all
end



def create
	@hardware = Hardware.new(hardware_params)
	@makers = Maker.all
	@types = Hwtype.all
	@statuses = Hwstatus.all
	@current_user = current_user
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
	if !logged_in?
		@current_user = nil
	end
	@makers = Maker.all
	@types = Hwtype.all
	@statuses = Hwstatus.all
end


def edit
	@makers = Maker.all
	@types = Hwtype.all
	@statuses = Hwstatus.all
end


def destroy
	@hardware = Hardware.find(params[:id])
    @hardware.destroy
    flash[:danger] = "That piece of hardware has been deleted"
    redirect_to hardwares_path
end






private

	def hardware_params
	    params.require(:hardware).permit(:maker_id, :hwstatus_id, :hwtype_id, :model, :terminal_type, :min_firmware, :max_firmware, :hardware_gpu_id, :cpu, :touch_interface, :network_card, :pci_network_id, :note, :priority)
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