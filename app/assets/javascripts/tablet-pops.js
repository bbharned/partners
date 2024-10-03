$( document ).on('turbolinks:load', function() {

	"use strict";

	$('.first-card').on('click', function(){
		$('body').prepend('<div class="bs-canvas-overlay position-fixed w-100 h-100"></div>');
		if($(this).hasClass('first-card'))
			$('.bs-first-canvas-right').addClass('mr-0');
		return false;
	});

	$('.second-card').on('click', function(){
		$('body').prepend('<div class="bs-canvas-overlay position-fixed w-100 h-100"></div>');
		if($(this).hasClass('second-card'))
			$('.bs-second-canvas-right').addClass('mr-0');
		return false;
	});
	







	//close info popovers
	$(document).on('click', '.bs-canvas-close, .bs-canvas-overlay', function(){
		var elm = $(this).hasClass('bs-canvas-close') ? $(this).closest('.bs-canvas') : $('.bs-canvas');
		elm.removeClass('mr-0 ml-0');
		$('.bs-canvas-overlay').remove();
		return false;
	});
	
});