$H.uiCalendar = $H.klass(null, {
    _d: function (a, c) {
        var b = $("<div>").addClass(a);
        if (c) {
            b.appendTo(c);
        }
        return b;
    },
    _td: function (a, b) {
        return $("<td>").addClass(a).attr("id", b);
    },
    _tm: function (a) {
        a.setHours(0, 0, 0, 0);
    },
    _cb: function (d, b) {
        if (this.cfg[d]) {
            try {
                this.cfg[d](b);
            } catch (c) { }
        }
    },
    _build: function (a) {
        a.setDate(1);
        this._tm(a);
        var k = 0;
        if (this.cfg.onPrevOut) {
            k = this.cfg.onPrevOut(a);
        } else {
            k = a.firstDay() % 7;
        }
        var b = a.daysInMonth();
        var j = a.addDays(-1 * k);
        var l = this.getStartDate();
        var o = new Date();
        this._tm(o);
        var g = Date.parseDate(this.cfg.minDate);
        this._tm(g);
        var e = Date.parseDate(this.cfg.maxDate);
        this._tm(e);
        var h = {
            cl: null,
            inval: null,
            txt: null,
            show: null,
            date: a
        };
        var m,
        q,
        n,
        c,
        f = this;
        for (var d = 0; d < 42; d++) {
            n = j.getTime();
            c = "";
            h.cl = "";
            h.show = true;
            if (d < k) {
                h.show = false;
                h.cl = "disable";
            } else {
                if (d >= (k + b)) {
                    h.cl = "moreday";
                } else {
                    if (n == l.getTime()) {
                        h.cl = "active";
                    } else {
                        if (n == o.getTime()) {
                            h.cl = "today";
                        }
                    }
                }
            }
            h.inval = j < g || j > e || (this.cfg.validDateFn && !this.cfg.validDateFn(j));
            if (h.inval) {
                h.cl += " disable";
            }
            if (d % 7 == 0) {
                q = $("<tr>").appendTo(this._f.mbody);
            }
            h.txt = j.getDate();
            if (this.cfg.onDateShow) {
                h.pointer = j;
                h = this.cfg.onDateShow(h);
            }
            if (h.show) {
                if (n == o.getTime()) {
                    h.cl += " line2";
                    c = [h.txt, "<br/><span class='tag'>今天</span>"].join("");
                } else {
                    if (j.getDate() == 1 && j.getMonth() != a.getMonth()) {
                        h.cl += " line2";
                        c = [h.txt, "<br/><span class='tag'>", j.getMonth() + 1, "月</span>"].join("");
                    } else {
                        c = h.txt;
                    }
                }
            }
            m = this._td(h.cl, ["dp", j.getFullYear(), "-", j.getMonth() + 1, "-", j.getDate()].join("")).html(c || "").appendTo(q);
            if (!h.inval && h.show) {
                m.click(function () {
                    f.val(Date.parseDate($(this).attr("id").substr(2)));
                }).hoverClass();
            }
            j.setDate(j.getDate() + 1);
        }
    },
    _to: function (b) {
        var c = this._f;
        c.mbody.empty();
        this._build(b);
        c.title.html(b.format("yyyy年M月"));
        var g = Date.parseDate(this.cfg.minDate);
        var d = Date.parseDate(this.cfg.maxDate);
        var a = new Date(b.getFullYear(), b.getMonth(), 1);
        this._tm(g);
        this._tm(d);
        c.prevbtn.hide();
        c.nextbtn.hide();
        var e = this;
        if (a.getTime() > g.getTime()) {
            c.prevbtn.unbind().click(function () {
                e.prevMonth();
            }).hoverClass().show();
        }
        a.setDate(b.daysInMonth());
        if (a.getTime() < d.getTime()) {
            c.nextbtn.unbind().click(function () {
                e.nextMonth();
            }).hoverClass().show();
        }
    },
    struct: function (a) {
        this._ipt = null;
        this.currDate = null;
        this._f = {
            wrap: null,
            caption: null,
            title: null,
            prevbtn: null,
            nextbtn: null,
            weeks: null,
            mbody: null
        };
        this.cfg = {
            onPicking: null,
            onPicked: null,
            onClose: null,
            onOpen: null,
            onChange: null,
            minDate: new Date(1900, 0, 1),
            maxDate: new Date(2099, 11, 31),
            validDateFn: null,
            valueFormat: "yyyy-MM-dd",
            onDateShow: null,
            onPrevOut: null
        };
        $.extend(this.cfg, a);
        this._ipt = $("#" + a.iptid);
        this.lastDate = this.getStartDate();
        if (a.wrapid) {
            this._f.wrap = $("#" + a.wrapid);
        }
        if (!this._f.wrap) {
            this._f.wrap = $("<div>").addClass("calendar").appendTo($("body"));
        }
        this._f.caption = this._d("caption", this._f.wrap);
        this._f.prevbtn = this._d("pre_btn", this._f.caption).append($("<span>")).hoverClass();
        this._f.title = this._d("title", this._f.caption);
        this._f.nextbtn = this._d("next_btn", this._f.caption).append($("<span>")).hoverClass();
        this._f.weeks = $("<table>").addClass("weeks").html("<tr><td>周日</td><td>周一</td><td>周二</td><td>周三</td><td>周四</td><td>周五</td><td>周六</td><tr/>").appendTo(this._f.wrap);
        this._f.mbody = $("<table>").addClass("mbody").appendTo(this._f.wrap);
    },
    setMaxDate: function (a) {
        this.cfg.maxDate = Date.parseDate(a, this.cfg.maxDate);
    },
    setMinDate: function (a) {
        this.cfg.minDate = Date.parseDate(a, this.cfg.minDate);
    },
    val: function (b) {
        if (b) {
            var a = Date.parseDate(b);
            if (this.cfg.onPicking && !this.cfg.onPicking(a)) {
                return a;
            }
            this.close();
            this._cb("onPicked", a);
            if (!this.lastDate || (this.cfg.onChange && this.lastDate.getTime() != a.getTime())) {
                this._cb("onChange", {
                    lastDate: this.lastDate,
                    date: a
                });
            }
            this.lastDate = a;
            this._ipt.val(a.format(this.cfg.valueFormat));
            return a;
        } else {
            return Date.parseDate(this._ipt.val());
        }
    },
    close: function () {
        this.currDate = null;
        this._f.wrap.hide();
        this._cb("onClose");
    },
    open: function () {
        this.currDate = this.getStartDate();
        this._to(this.currDate);
        this._f.wrap.show();
        this._cb("onOpen");
    },
    nextMonth: function () {
        this.currDate = this.currDate || new Date();
        this.currDate.setDate(1);
        this.currDate.setMonth(this.currDate.getMonth() + 1);
        this._to(this.currDate);
        this._cb("onNext");
    },
    prevMonth: function () {
        this.currDate = this.currDate || new Date();
        this.currDate.setDate(1);
        this.currDate.setMonth(this.currDate.getMonth() - 1);
        this._to(this.currDate);
        this._cb("onPrev");
    },
    getStartDate: function () {
        return Date.parseDate(this._ipt.val(), new Date());
    }
});