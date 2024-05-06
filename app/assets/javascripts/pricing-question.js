
$(document).ready(function() {

	"use strict";

	var open1 = false;
	var open2 = false;
	var open3 = false;
	var open4 = false;
	
	$(".more-info").on("click", function() {
		if (open1 == false) {
			$('.more-box-1').toggle(400);
			open1 = true;
		} 
	});

	$(".more-info-2").on("click", function() {
		if (open2 == false) {
			$('.more-box-2').toggle(400);
			open2 = true;
		} 
	});

	$(".more-info-3").on("click", function() {
		if (open3 == false) {
			$('.more-box-3').toggle(400);
			open3 = true;
		}
	});

	$(".more-info-4").on("click", function() {
		if (open4 == false) {
			$('.more-box-4').toggle(400);
			open4 = true;
		} 
	});

	$('.more-box-1 .close-this').on('click', function() {
		if (open1 == true) {
			$('.more-box-1').toggle(400);
			open1 = false;
		} 
	});

	$('.more-box-2 .close-this').on('click', function() {
		if (open2 == true) {
			$('.more-box-2').toggle(400);
			open2 = false;
		} 
	});

	$('.more-box-3 .close-this').on('click', function() {
		if (open3 == true) {
			$('.more-box-3').toggle(400);
			open3 = false;
		} 
	});

	$('.more-box-4 .close-this').on('click', function() {
		if (open4 == true) {
			$('.more-box-4').toggle(400);
			open4 = false;
		} 
	});
	

});