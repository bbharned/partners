class TerminalsController < ApplicationController

def index
	
	@filterrific = initialize_filterrific(
     Terminal,
     params[:filterrific],
      select_options: {
        sorted_by: Terminal.options_for_sorted_by,
        with_manufacturer: Manufacturer.options_for_select,
        with_boot_type: TerminalType.options_for_select,
        # with_venue: Venue.options_for_select,
        # with_state: ['Upcoming Events', 'Past Events'],
        # with_live_status: ['Live Events', 'Draft Events'],
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [:sorted_by, :with_search, :with_manufacturer, :with_boot_type],
      sanitize_params: true,
   ) or return
   @terminals = @filterrific.find.paginate(page: params[:page], per_page: 10)

   respond_to do |format|
     format.html
     format.js
   end

   rescue ActiveRecord::RecordNotFound => e
     # There is an issue with the persisted param_set. Reset it.
     puts "Had to reset filterrific params: #{e.message}"
     redirect_to(reset_filterrific_url(format: :html)) && return


	#@terminals = Terminal.paginate(page: params[:page], per_page: 25).order(:Model)

end


def show
	@terminal = Terminal.find(params[:id])

end


end