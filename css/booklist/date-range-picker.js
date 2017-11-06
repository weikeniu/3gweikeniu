var __mypicker = $.fn.datepicker;
var speciald = new Array();
//	speciald=["2017/5/4","2017/5/7"];
$.fn.datepicker = function (options) {
    options.disableddates = options.disableddates || [];
    options.daterange = options.daterange || [];

    options.min_max = options.min_max || []; //最小、最大日期数组

    var oldOptions = jQuery.extend(true, {}, options);
    options.beforeShowDay = function (date, me) {

        //格式化月份、日
        function formatDates(str) {
            return str < 10 ? ("0" + str) : str;
        }

        var m = date.getMonth();
        var d = date.getDate();
        var y = date.getFullYear();
        var formatDate = y + "-" + formatDates(m + 1) + "-" + formatDates(d); //此处日期的格式化和speciald中的格式一样
        //inArray实现数组的匹配
        if ($.inArray(formatDate, speciald) != -1) {
            //此处要返回一个数组，specialdays是添加样式的类
            return [true, "specialdays", formatDate];
        }



        if (oldOptions.beforeShowDay) {
            oldOptions.beforeShowDay(date, me);
        }
        var dd = options.disableddates.map(function (item) { return item.getTime(); });
        var dr = options.daterange.map(function (item) { return item.getTime(); });

        if ($.inArray(date.getTime(), dd) != -1) {
            return [false, '', ''];
        }
        if ($.inArray(date.getTime(), dr) != -1) {
            return [true, "ui-range-selected"];
        }
        return [true, '', ''];
    }
    options.onSelect = function (date, me) {

        if (speciald.length < 2) {
            //speciald.push(date);
            if ($.inArray(date, speciald) == -1) {
                speciald.push(date);
            }

            console.log(speciald)
        } else {
            speciald.length = 0;
            speciald.push(date);
            console.log(speciald)
        }



        if (!options.dateFormat) {
            options.dateFormat = "mm-dd-yy"
        }
        var d = $.datepicker.parseDate(options.dateFormat, date);
        if (oldOptions.onSelect) {
            oldOptions.onSelect(date, me);
        }
        me.inline = true;
        var disabled = $.inArray(d.getTime(), options.disableddates.map(function (item) { return item.getTime(); })) != -1;
        if (disabled) {
            return;
        }
        if (options.ctrlKey) {
            var result = $.grep(options.daterange, function (e) { return e.getTime() == d.getTime(); });
            if (result.length == 0) {
                options.daterange.push(d);
            } else {
                options.daterange = $.grep(options.daterange, function (e) { return e.getTime() != d.getTime(); });
            }
        } else if (options.daterange.length == 0) {
            options.daterange.push(d);
        } else {
            //新加了这句控制(当选择开始和结束日期后， 重新点击)
            if (options.daterange.length > 1) {
                options.daterange.length = 0;
                options.daterange.push(d);
            }

            var nr = [];
            var max = new Date(Math.max.apply(Math, options.daterange));
            var min = new Date(Math.min.apply(Math, options.daterange));
            if (d > max) {
                max = d;
            } else if (min > d) {
                max = min;
                min = d;
            } else {
                min = d;
            }
            for (var d1 = min; d1 <= max; d1.setDate(d1.getDate() + 1)) {
                if ($.inArray(d1.getTime(), options.disableddates.map(function (item) { return item.getTime(); })) == -1) {
                    nr.push(new Date(d1));
                }
            }
            options.daterange = nr;
        }
        var max = new Date(Math.max.apply(Math, options.daterange));
        var min = new Date(Math.min.apply(Math, options.daterange));

        //赋值最小、最大日期
        options.min_max = [min, max];

        //设置入住几晚
        $(".selectNum").text(options.daterange.length - 1);

        //设置入住、离店
        setTimeout(function () {
            $(".specialdays").each(function (i, item) {

                if ($(this).attr("title") == $.datepicker.formatDate("yy-mm-dd", min)) {
                    //入住class
                    $(this).addClass("first");

                } else if ($(this).attr("title") == $.datepicker.formatDate("yy-mm-dd", max)) {
                    //离店class
                    $(this).addClass("last");
                }

                if ($(".specialdays").length == 1) {
                    //layer.msg("请选择离店日期");
                    layer.tips('请选择离店日期', $(".specialdays"), {
                        tips: [1, '#666'],
                        time: 1500
                    });
                }


                if ($(".specialdays").length == 2 && i == 0) {

                    layer.tips('共' + $(".selectNum").text() + '晚', $(".specialdays")[1], {
                        tips: [1, '#666'],
                        time: 1500
                    });

                    setTimeout('$(".select_qd").click(); layer.closeAll();', 600);
                }
            });
        }, 100)

        //把日期范围(最小日期-最大日期)赋值给input
        $(this).val($.datepicker.formatDate(options.dateFormat, max, options) + " - " + $.datepicker.formatDate(options.dateFormat, min, options));
    }
    options.onClose = function (date, me) {
        if (oldOptions.onClose) {
            oldOptions.onClose(date, me);
        }
        me.inline = false;
    }

    __mypicker.apply(this, [options]);
    $(document).bind('keydown', function (event) {
        if (event.ctrlKey || event.metaKey) {
            options.ctrlKey = event.ctrlKey || event.metaKey;
        }
    });
    $(document).bind('keyup', function (event) {
        options.ctrlKey = false;
    });

    //数据返回函数接口
    var $self = this;
    //返回日期范围(set the date range)
    $self.getDateRange = function () {
        return options.daterange;
    }
    //返回最小、最大日期
    $self.getDateMinMax = function () {
        return options.min_max;
    }

    return this;
}