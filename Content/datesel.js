$(function () {
    $("#selectCKI,#selectCKO").active();
    var p = Date.parseDate($("#today").val());
    var m = Date.parseDate($("#mindate").val());
    var r = p.getTime() != m.getTime();
    var s = null;
    var q = $H.url.path();
    var a = $("#CheckInDate").val();
    var b = $("#CheckOutDate").val();
    var temp = $("#selectCKI").attr("t");
    var c = new $.luiCalendar({
        iptid: "CheckInDate",
        wrapid: "calcki",
        minDate: m,
        onPicking: function (u) {
            var t = Date.parseDate(a);
            var v = Date.parseDate(b);
            $H.hashEvent.pop();
            if (u.getTime() != t.getTime()) {
                if (u.trim().getTime() >= v.trim().getTime()) {
                    v = u.addDays(1)
                }
                location.replace($H.url.queryString({
                    checkInDate: u.format("yyyy-MM-dd"),
                    checkOutDate: v.format("yyyy-MM-dd")
                },
                location.href.split("#")[0]))
            }
            return false
        },
        onOpen: function () {
            $("#artLivedate").show();
            $("#artDefault").hide();
            $("#artDetail").hide();
            if (temp == "1") {
                $(document).scrollTop(15 + parseInt($(".attr").css("height").replace('px', '')))
            } else {
                $(document).scrollTop(25 + parseInt($(".hotel").css("height").replace('px', '')))
            }
            if (r) {
                var t = $("td.yesterday");
                if (t) {
                    $("<div>").addClass("yOrderTipClose").html("<div class='ordercomplete_prompt_close'>\u00d7</div>").click(function () {
                        s.remove()
                    }).appendTo(s);
                    s.css({
                        top: t.offset().top - s.height(),
                        left: "4%"
                    }).show()
                }
            }
        },
        onDateShow: function (t) {
            if (r && t.date.getMonth() == p.getMonth() && t.pointer.getTime() == p.addDays(-1).getTime()) {
                t.cl += " yesterday line2";
                t.cl = t.cl.replace("disable", "");
                t.txt += "<br/><span>深夜</span>";
                t.show = true
            }
            return t
        },
        onNext: function () {
            if (s) {
                s.hide()
            }
        }
    });
    var d = new $.luiCalendar({
        iptid: "CheckOutDate",
        wrapid: "calcko",
        minDate: m.addDays(1),
        onPicking: function (v) {
            var t = Date.parseDate(b);
            var u = Date.parseDate(a);
            $H.hashEvent.pop();
            if (v.getTime() != t.getTime()) {
                if (v.trim().getTime() <= u.trim().getTime()) {
                    u = v.addDays(-1)
                }
                location.replace($H.url.queryString({
                    checkInDate: u.format("yyyy-MM-dd"),
                    checkOutDate: v.format("yyyy-MM-dd")
                },
                location.href.split("#")[0]))
            }
            return false
        },
        onOpen: function () {
            $("#artLivedate").show();
            $("#artDefault").hide();
            $("#artDetail").hide();
            if (temp == "1") {
                $(document).scrollTop(15 + parseInt($(".attr").css("height").replace('px', '')))
            } else {
                $(document).scrollTop(25 + parseInt($(".hotel").css("height").replace('px', '')))
            }
        },
        onPrevOut: function (t) {
            var u = t.firstDay() % 7;
            if (r && t.getMonth() == p.getMonth()) {
                return u == 0 ? 7 : u
            }
            return u
        }
    });
    var o = function (v) {
        var t = Date.parseDate($("#CheckInDate").val());
        var u = Date.parseDate($("#CheckOutDate").val());
        $("#calckil").html("入住:&nbsp; " + t.format("MM-dd") + "&nbsp;" + t.getWeek());
        $("#calckol").html("离店:&nbsp; " + u.format("MM-dd") + "&nbsp;" + u.getWeek());
        if (v) {
            $("#calckil").addClass("active");
            $("#calckol").removeClass("active");
            d.sync("close");
            c.sync("open")
        } else {
            if (s) {
                s.hide()
            }
            $("#calckol").addClass("active");
            $("#calckil").removeClass("active");
            c.sync("close");
            d.sync("open")
        }
    };
    $H.hashEvent.bind(function (t) {
        switch (t) {
            default:
                $("#artDefault").show();
                $("#artDetail").hide();
                $("#artLivedate").hide();
                break;
            case "detail":
                $("#artDefault").hide();
                $("#artDetail").show();
                $("#artLivedate").hide();
                break;
            case "livedate":
                o($("#artLivedate").attr("data-type") == "0");
                break
        }
        if (t != "livedate") {
            if (s) {
                s.hide()
            }
        }
    });
    $("#selectCKI").click(function () {
        $("#artLivedate").attr("data-type", "0");
        $H.hashEvent.pop("livedate")
    });
    $("#selectCKO").click(function () {
        $("#artLivedate").attr("data-type", "1");
        $H.hashEvent.pop("livedate")
    });
    $("#calckil").click(function () {
        o(true)
    });
    $("#calckol").click(function () {
        o(false)
    });
    var l = false
});
function reshow() {
    if ($.platform.isSafari) {
        if (backflag) {
            setTimeout(function () {
                $(window).unbind("scroll").bind("scroll",
                function () {
                    lazyImg.trigger("check")
                })
            },
            1)
        } else {
            backflag = true
        }
    }
}