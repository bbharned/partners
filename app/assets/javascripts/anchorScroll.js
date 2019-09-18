//= require_self

(function($){
    $.fn.anchorscroll = function(param) {
        // Params
        var defaults = {
            speed: 1500,
            easing: 'swing',
            before: 10
        };
        var param = $.extend(defaults, param);
        
         
        // Engine
        return this.each(function() {
            $(this).click(function() {
                if (location.pathname.replace(/^\//,'') === this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
                    var $target = $(this.hash);
                    $target = $target.length && $target || $('[name=' + this.hash.slice(1) +']');
                    if ($target.length) {
                        var targetOffset = $target.offset().top;
                        $('html,body').animate({
                            scrollTop: targetOffset - param.before
                        }, param.speed, param.easing);
                        return false;
                    }
                }
            });        
        });        
    };
})();