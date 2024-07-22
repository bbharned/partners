$( document ).on('turbolinks:load', function() {

	var open = false;
	var bannerRun = true;

	if (top.location.pathname === '/' && bannerRun == true) {
		$( '.alert' ).css({
			"position": "fixed",
			"z-index": "1000",
			"bottom": "-15px",
			"width" : "100%",
			"left" : "0px",
			"padding-top": "25px",
			"padding-bottom": "25px"
		});
		$( '.full-drop-banner-ad' ).delay(1500).animate({
			minHeight: "300px"
		}, 1000, "linear", function() {
			$( '.ad-Content' ).fadeIn('slow');
			open = true;
		});
	} else {
		$( '.open_close' ).css("display", "none")
	}

	// add open/close toggle
	$( '.open_close' ).on('click', function() {
		if (open == true) {
			$( '.ad-Content' ).css("display", "none");
			$( '.full-drop-banner-ad' ).animate({
				minHeight: "0px"
			}, 500, "linear", function() {
				open = false;
			});
		} else {
			$( '.full-drop-banner-ad' ).animate({
				minHeight: "300px"
			}, 500, "linear", function() {
				$( '.ad-Content' ).fadeIn('slow');
				open = true;
			});
		}


		
	})

});