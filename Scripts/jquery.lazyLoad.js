(function ($) {
    $.fn.scrollPagination = function (options) {
        var dWrap = $(this),
			opts = $.extend($.fn.scrollPagination.defaults, options);
        dWrap.attr('scrollPagination', 'enabled');
        $(window).scroll(function (e) {
            if (dWrap.attr('scrollPagination') == 'enabled') {
                $.fn.scrollPagination.loadContent(dWrap, opts);
            } else {
                e.stopPropagation();
            }
        });
    };
    $.fn.stopScrollPagination = function () {
        $(this).attr('scrollPagination', 'disabled');
    };
    $.fn.scrollPagination.loadContent = function (dWrap, opts) {
        var mayLoadContent = $(window).scrollTop() >= parseInt(($(document).height() - $(window).height()) * opts.percentage, 10);
        if (mayLoadContent) {
            if (opts.beforeLoad != null) {
                opts.beforeLoad();
            }
            if (opts.afterLoad != null) {
                opts.afterLoad();
            }
        }
    };
    $.fn.scrollPagination.defaults = {
        'beforeLoad': null,
        'afterLoad': null,
        'scrollTarget': $(window),
        'percentage': 1
    };
})(jQuery);