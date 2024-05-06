// (function(){
$(document).ready(function() {

	"use strict";

	var open1 = 0;
	var open2 = 1;
	
	
	$('.bio-dropdown').on('click', function() {
		if (open1 == 0) {
			$('.the-bio').slideDown(400);
			$('.bi-caret-down-fill').css('transform', 'rotate(180deg)');
			open1 = 1;
			return;
		} 
		if (open1 == 1) {
			$('.the-bio').slideUp(400);
			$('.bi-caret-down-fill').css('transform', 'rotate(0deg)');
			open1 = 0;
			return;
		} 
	});


	$('.locations-dropdown').on('click', function() {
		if (open2 == 0) {
			$('.the-locations').slideDown(400);
			$('.bi-caret-up-fill').css('transform', 'rotate(0deg)');
			open2 = 1;
			return;
		} 
		if (open2 == 1) {
			$('.the-locations').slideUp(400);
			$('.bi-caret-up-fill').css('transform', 'rotate(180deg)');
			open2 = 0;
			return;
		} 
	});
	
	

});