class RoisController < ApplicationController


def index
	@rois = Roi.all
end



def new
	@roi = Roi.new()
end



end