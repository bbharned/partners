class TerminalsController < ApplicationController

def index
	@user = current_user
	@terminals = Terminal.all

end






end