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

	$('.enable-card').on('click', function(){
		$('body').prepend('<div class="bs-canvas-overlay position-fixed w-100 h-100"></div>');
		if($(this).hasClass('enable-card'))
			$('.bs-third-canvas-right').addClass('mr-0');
		return false;
	});

	$('.choice-card').on('click', function(){
		$('body').prepend('<div class="bs-canvas-overlay position-fixed w-100 h-100"></div>');
		if($(this).hasClass('choice-card'))
			$('.bs-fourth-canvas-right').addClass('mr-0');
		return false;
	});

	$('.behavior-card').on('click', function(){
		$('body').prepend('<div class="bs-canvas-overlay position-fixed w-100 h-100"></div>');
		if($(this).hasClass('behavior-card'))
			$('.bs-fifth-canvas-right').addClass('mr-0');
		return false;
	});

	$('.expand-card').on('click', function(){
		$('body').prepend('<div class="bs-canvas-overlay position-fixed w-100 h-100"></div>');
		if($(this).hasClass('expand-card'))
			$('.bs-sixth-canvas-right').addClass('mr-0');
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