$.fn.extend({
    datepicker: function (a) {
        var b = function (d, c) {
            this.fn = {
                div: function (e, g) {
                    var f = $("<div>").addClass(e);
                    if (g) {
                        f.appendTo(g)
                    }
                    return f
                },
                a: function (e, f) {
                    return $("<a>").addClass(e).attr("id", f)
                },
                parseDate: function (e, f) {
                    if (e) {
                        if (typeof e === "string") {
                            e = Date.fromString(e)
                        }
                        return e
                    } else {
                        return f
                    }
                }
            };
            this.lastDate = null;
            this.currentDate = null;
            this.$input = d;
            this.$f = $.dp_frame;
            this.config = {
                lang: {
                    prevMonth: "",
                    nextMonth: "",
                    today: "今天",
                    cancel: "取消",
                    month: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
                },
                onPicked: null,
                onClose: null,
                onOpen: null,
                onChange: null,
                firstDay: 1,
                minDate: new Date(1900, 0, 1),
                maxDate: new Date(2099, 11, 31),
                validDateFn: null,
                valueFormat: "yyyy-MM-dd",
                titleFormat: "yyyy年M月",
                apiURL: null
            };
            this.setMaxDate = function (e) {
                this.config.maxDate = this.fn.parseDate(e, this.config.maxDate)
            };
            this.setMinDate = function (e) {
                this.config.minDate = this.fn.parseDate(e, this.config.minDate)
            };
            this.val = function (f) {
                if (f) {
                    var g = this.fn.parseDate(f);
                    if (this.config.onPicked) {
                        try {
                            this.config.onPicked(g)
                        } catch (h) { }
                    }
                    if (!this.lastDate || (this.config.onChange && this.lastDate.getTime() != g.getTime())) {
                        try {
                            this.config.onChange(this.lastDate, g)
                        } catch (h) { }
                    }
                    this.lastDate = g;
                    this.$input.val(g.format(this.config.valueFormat));
                    return g
                } else {
                    return Date.fromString(this.$input.val())
                }
            };
            this.close = function () {
                this.currentDate = null;
                this.$f.wrapper.hide();
                $("select").show();
                if (this.config.onClose) {
                    try {
                        this.config.onClose()
                    } catch (f) { }
                }
            };
            this.show = function () {
                this.$f.weeks.empty();
                for (var f = 0; f < 7; f++) {
                    this.fn.div("ui_calendar_week", this.$f.weeks).html($.weekText[(f + this.config.firstDay) % 7])
                }
                this.currentDate = this.getStartDate();
                this.toDate(this.currentDate);
                $("select").hide();
                this.$f.wrapper.show();
                if (this.config.onOpen) {
                    try {
                        this.config.onOpen()
                    } catch (g) { }
                }
            };
            this.nextMonth = function () {
                this.currentDate = this.currentDate || new Date();
                this.currentDate.setDate(1);
                this.currentDate.setMonth(this.currentDate.getMonth() + 1);
                this.toDate(this.currentDate)
            };
            this.prevMonth = function () {
                this.currentDate = this.currentDate || new Date();
                this.currentDate.setDate(1);
                this.currentDate.setMonth(this.currentDate.getMonth() - 1);
                this.toDate(this.currentDate)
            };
            this.toDate = function (g) {
                this.$f.month_content.empty();
                this.buildMonth(g.copy());
                this.$f.caption.html(g.format(this.config.titleFormat));
                var j = this.fn.parseDate(this.config.minDate);
                var i = this.fn.parseDate(this.config.maxDate);
                var f = new Date();
                var e = new Date(g.getFullYear(), g.getMonth(), 1);
                j.setHours(0, 0, 0, 0);
                i.setHours(0, 0, 0, 0);
                f.setHours(0, 0, 0, 0);
                var h = this;
                this.$f.prevbtn.unbind().html(this.config.lang.prevMonth).hide();
                this.$f.nextbtn.unbind().html(this.config.lang.nextMonth).hide();
                this.$f.todaybtn.unbind().html(this.config.lang.today).hide();
                this.$f.cancelbtn.unbind().click(function () {
                    h.close()
                }).html(this.config.lang.cancel);
                if (e.getTime() > j.getTime()) {
                    this.$f.prevbtn.click(function () {
                        h.prevMonth()
                    }).hoverClass().show()
                }
                e.setDate(g.daysInMonth());
                if (e.getTime() < i.getTime()) {
                    this.$f.nextbtn.click(function () {
                        h.nextMonth()
                    }).hoverClass().show()
                }
                if (f.getTime() >= j.getTime() && f.getTime() <= i.getTime() && (!this.config.validDateFn || this.config.validDateFn(f))) {
                    this.$f.todaybtn.click(function () {
                        h.val(new Date());
                        h.close()
                    }).show()
                }
            };
            this.initialize = function () {
                var e = $("body");
                var h = this.$f;
                var g = this;
                if (!h.wrapper) {
                    h.wrapper = $("<div>").addClass("ui_calendar").attr("id", "dp_wrapper").appendTo(e);
                    h.header = this.fn.div("ui_calendar_header", h.wrapper);
                    h.caption = this.fn.div("ui_calendar_month", h.header);
                    h.prevbtn = this.fn.a("ui ui_arrow_l", null).hoverClass().html(this.config.lang.prevMonth).appendTo(h.header);
                    h.nextbtn = this.fn.a("ui ui_arrow_r", null).hoverClass().html(this.config.lang.nextMonth).appendTo(h.header);
                    h.weeks = this.fn.div("ui_calendar_weeks", h.wrapper);
                    h.month_content = this.fn.div("ui_calendar_content", h.wrapper);
                    h.footer = this.fn.div("ui_calendar_footer", h.wrapper);
                    h.todaybtn = this.fn.a("", null).hoverClass().appendTo(h.footer);
                    h.cancelbtn = this.fn.a("", null).css("float", "right").hoverClass().appendTo(h.footer)
                }
            };
            this.getStartDate = function () {
                return this.fn.parseDate(this.$input.val(), new Date())
            };
            this.buildMonth = function (h) {
                var n = this;
                h.setDate(1);
                h.setHours(0, 0, 0, 0);
                var l = (h.firstDay() - this.config.firstDay + 7) % 7;
                var r = h.daysInMonth();
                var e = h.addDays(-1 * l);
                var g = n.getStartDate();
                var o = new Date();
                o.setHours(0, 0, 0, 0);
                var j = this.fn.parseDate(this.config.minDate);
                j.setHours(0, 0, 0, 0);
                var f = this.fn.parseDate(this.config.maxDate);
                f.setHours(0, 0, 0, 0);
                var q = null,
                p = null,
                m = true;
                for (var k = 0; k < 42; k++) {
                    q = k >= l && k < (l + r) ? "ui_calendar_day" : "ui_calendar_day ui_calendar_disable";
                    if (e.getTime() == o.getTime()) {
                        q += " ui_calendar_today"
                    }
                    if (e.getTime() == g.getTime()) {
                        q += " ui_calendar_active"
                    }
                    if (e.getDay() % 6 == 0) {
                        q += " weekendday"
                    }
                    m = e < j || e > f || (this.config.validDateFn && !this.config.validDateFn(e));
                    if (m) {
                        q += " ui_calendar_disable"
                    }
                    p = this.fn.a(q, ["dp", e.getFullYear(), "-", e.getMonth() + 1, "-", e.getDate()].join("")).html("<span class='num'>" +(e.getTime() == o.getTime()?"今天":e.getDate()) + "</span>").appendTo(this.$f.month_content);
                    if (!m) {
                        p.click(function () {
                            n.val(Date.fromString($(this).attr("id").substr(2)));
                            n.close()
                        }).hoverClass()
                    }
                    e.setDate(e.getDate() + 1)
                }
            };
            $.extend(this.config, c);
            this.initialize(this)
        };
        return new b($(this), a)
    }
});
$.extend({
    dp_frame: {
        wrapper: null,
        header: null,
        title: null,
        caption: null,
        prevbtn: null,
        nextbtn: null,
        weeks: null,
        footer: null,
        todaybtn: null,
        cancelbtn: null,
        month_content: null
    }
});