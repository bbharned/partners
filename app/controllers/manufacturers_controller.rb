class ManufacturersController < ApplicationController

def index
	@user = current_user
	@manufacturers = Manufacturer.all

end






end