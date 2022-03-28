class ListingsController < ApplicationController



def index
	@listings = Listing.all
end


def new
	@listing = Listing.new
end




end