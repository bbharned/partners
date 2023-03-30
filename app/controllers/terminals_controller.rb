class TerminalsController < ApplicationController

def index
  @url = request.original_url

  if @url.include? "hardware"
    @bg = 'hardware'
  elsif @url.include? "tmc"
    @bg = 'tmc'
  elsif @url.include? "features"
    @bg = 'features'  
  else
    @bg = 'peripheral'
  end
	
	@filterrific = initialize_filterrific(
     Terminal,
     params[:filterrific],
      select_options: {
        # sorted_by: Terminal.options_for_sorted_by,
        with_manufacturer: Manufacturers.options_for_select,
        with_boot_type: TerminalType.options_for_select,
        with_firm: FirmwarePackage.options_for_select,
        with_monitor_count: [1, 2, 3, 4, 5, 6, 7],
        with_ethernet_count: [1, 2, 3, 4],
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      #available_filters: [:with_search_please, :with_manufacturer, :with_boot_type, :with_firm, :with_monitor_count, :with_ethernet_count], #:sorted_by,
      sanitize_params: true,
   ) or return
   @terminals = @filterrific.find.paginate(page: params[:page], per_page: 10).order(:TermcapModel)

   respond_to do |format|
     format.html
     format.js
   end

   rescue ActiveRecord::RecordNotFound => e
     # There is an issue with the persisted param_set. Reset it.
     puts "Had to reset filterrific params: #{e.message}"
     redirect_to(reset_filterrific_url(format: :html)) && return

end


def show
	
  @terminal = Terminal.find(params[:id])
  #@termcapnote = Note.where(TerminalId: @terminal.id).first
  @termcapnote = @terminal.Notes.first
  @note_id = Termnote.where(termcapmodel: @terminal.TermcapModel).first
  if @note_id
    @note = Termnote.find(@note_id.id)
  end
  
  @manufacturer = Manufacturers.find(@terminal.ManufacturerId)
  @firmpktg = TerminalFirmwarePackage.where(TerminalId: @terminal.id)
  @firmwares = []
  if @firmpktg.any?
    @firmpktg.each do |f|
      @pktg = FirmwarePackage.find(f.PackageId)
      @firmwares.push @pktg
    end
  end
  @firmsort = @firmwares.sort_by {|k, v| -k.Version }

end


end