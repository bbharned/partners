class TerminalsController < ApplicationController

def index
	# @terminals = Terminal.all
	@user = current_user
	@terminals = Terminal.all
end



end