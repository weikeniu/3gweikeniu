﻿/*!
* jQuery Mobile v1.0a4.1
* http://jquerymobile.com/
*
* Copyright 2010, jQuery Project
* Dual licensed under the MIT or GPL Version 2 licenses.
* http://jquery.org/license
*/
(function (a, c) {
    if (a.cleanData) { var d = a.cleanData; a.cleanData = function (b) { for (var f = 0, h; (h = b[f]) != null; f++) a(h).triggerHandler("remove"); d(b) } } else { var e = a.fn.remove; a.fn.remove = function (b, f) { return this.each(function () { if (!f) if (!b || a.filter(b, [this]).length) a("*", this).add([this]).each(function () { a(this).triggerHandler("remove") }); return e.call(a(this), b, f) }) } } a.widget = function (b, f, h) {
        var i = b.split(".")[0], g; b = b.split(".")[1]; g = i + "-" + b; if (!h) { h = f; f = a.Widget } a.expr[":"][g] = function (j) {
            return !!a.data(j,
b)
        }; a[i] = a[i] || {}; a[i][b] = function (j, m) { arguments.length && this._createWidget(j, m) }; f = new f; f.options = a.extend(true, {}, f.options); a[i][b].prototype = a.extend(true, f, { namespace: i, widgetName: b, widgetEventPrefix: a[i][b].prototype.widgetEventPrefix || b, widgetBaseClass: g }, h); a.widget.bridge(b, a[i][b])
    }; a.widget.bridge = function (b, f) {
        a.fn[b] = function (h) {
            var i = typeof h === "string", g = Array.prototype.slice.call(arguments, 1), j = this; h = !i && g.length ? a.extend.apply(null, [true, h].concat(g)) : h; if (i && h.charAt(0) === "_") return j;
            i ? this.each(function () { var m = a.data(this, b); if (!m) throw "cannot call methods on " + b + " prior to initialization; attempted to call method '" + h + "'"; if (!a.isFunction(m[h])) throw "no such method '" + h + "' for " + b + " widget instance"; var p = m[h].apply(m, g); if (p !== m && p !== c) { j = p; return false } }) : this.each(function () { var m = a.data(this, b); m ? m.option(h || {})._init() : a.data(this, b, new f(h, this)) }); return j
        } 
    }; a.Widget = function (b, f) { arguments.length && this._createWidget(b, f) }; a.Widget.prototype = { widgetName: "widget", widgetEventPrefix: "",
        options: { disabled: false }, _createWidget: function (b, f) { a.data(f, this.widgetName, this); this.element = a(f); this.options = a.extend(true, {}, this.options, this._getCreateOptions(), b); var h = this; this.element.bind("remove." + this.widgetName, function () { h.destroy() }); this._create(); this._trigger("create"); this._init() }, _getCreateOptions: function () { var b = {}; if (a.metadata) b = a.metadata.get(element)[this.widgetName]; return b }, _create: function () { }, _init: function () { }, destroy: function () {
            this.element.unbind("." + this.widgetName).removeData(this.widgetName);
            this.widget().unbind("." + this.widgetName).removeAttr("aria-disabled").removeClass(this.widgetBaseClass + "-disabled ui-state-disabled")
        }, widget: function () { return this.element }, option: function (b, f) { var h = b; if (arguments.length === 0) return a.extend({}, this.options); if (typeof b === "string") { if (f === c) return this.options[b]; h = {}; h[b] = f } this._setOptions(h); return this }, _setOptions: function (b) { var f = this; a.each(b, function (h, i) { f._setOption(h, i) }); return this }, _setOption: function (b, f) {
            this.options[b] = f; if (b ===
"disabled") this.widget()[f ? "addClass" : "removeClass"](this.widgetBaseClass + "-disabled ui-state-disabled").attr("aria-disabled", f); return this
        }, enable: function () { return this._setOption("disabled", false) }, disable: function () { return this._setOption("disabled", true) }, _trigger: function (b, f, h) {
            var i = this.options[b]; f = a.Event(f); f.type = (b === this.widgetEventPrefix ? b : this.widgetEventPrefix + b).toLowerCase(); h = h || {}; if (f.originalEvent) { b = a.event.props.length; for (var g; b; ) { g = a.event.props[--b]; f[g] = f.originalEvent[g] } } this.element.trigger(f,
h); return !(a.isFunction(i) && i.call(this.element[0], f, h) === false || f.isDefaultPrevented())
        } 
    }
})(jQuery); (function (a, c) { a.widget("mobile.widget", { _getCreateOptions: function () { var d = this.element, e = {}; a.each(this.options, function (b) { var f = d.jqmData(b.replace(/[A-Z]/g, function (h) { return "-" + h.toLowerCase() })); if (f !== c) e[b] = f }); return e } }) })(jQuery);
(function (a) {
    function c() { var f = d.width(), h = [], i = [], g; e.removeClass("min-width-" + b.join("px min-width-") + "px max-width-" + b.join("px max-width-") + "px"); a.each(b, function (j, m) { f >= m && h.push("min-width-" + m + "px"); f <= m && i.push("max-width-" + m + "px") }); if (h.length) g = h.join(" "); if (i.length) g += " " + i.join(" "); e.addClass(g) } var d = a(window), e = a("html"), b = [320, 480, 768, 1024]; a.mobile.media = function () {
        var f = {}, h = a("<div id='jquery-mediatest'>"), i = a("<body>").append(h); return function (g) {
            if (!(g in f)) {
                var j = document.createElement("style"),
m = "@media " + g + " { #jquery-mediatest { position:absolute; } }"; j.type = "text/css"; if (j.styleSheet) j.styleSheet.cssText = m; else j.appendChild(document.createTextNode(m)); e.prepend(i).prepend(j); f[g] = h.css("position") === "absolute"; i.add(j).remove()
            } return f[g]
        } 
    } (); a.mobile.addResolutionBreakpoints = function (f) { if (a.type(f) === "array") b = b.concat(f); else b.push(f); b.sort(function (h, i) { return h - i }); c() }; a(document).bind("mobileinit.htmlclass", function () {
        d.bind("orientationchange.htmlclass resize.htmlclass",
function (f) { f.orientation && e.removeClass("portrait landscape").addClass(f.orientation); c() })
    }); a(function () { d.trigger("orientationchange.htmlclass") })
})(jQuery);
(function (a, c) {
    function d(g) { var j = g.charAt(0).toUpperCase() + g.substr(1); g = (g + " " + f.join(j + " ") + j).split(" "); for (var m in g) if (b[m] !== c) return true } var e = a("<body>").prependTo("html"), b = e[0].style, f = ["webkit", "moz", "o"], h = window.palmGetResource || window.PalmServiceBridge, i = window.blackberry; a.mobile.browser = {}; a.mobile.browser.ie = function () { for (var g = 3, j = document.createElement("div"), m = j.all || []; j.innerHTML = "<!--[if gt IE " + ++g + "]><br><![endif]--\>", m[0]; ); return g > 4 ? g : !g } (); a.extend(a.support, { orientation: "orientation" in
window, touch: "ontouchend" in document, cssTransitions: "WebKitTransitionEvent" in window, pushState: !!history.pushState, mediaquery: a.mobile.media("only all"), cssPseudoElement: !!d("content"), boxShadow: !!d("boxShadow") && !i, scrollTop: ("pageXOffset" in window || "scrollTop" in document.documentElement || "scrollTop" in e[0]) && !h, dynamicBaseTag: function () {
    var g = location.protocol + "//" + location.host + location.pathname + "ui-dir/", j = a("head base"), m = null, p = ""; if (j.length) p = j.attr("href"); else j = m = a("<base>", { href: g }).appendTo("head");
    var k = a("<a href='testurl'></a>").prependTo(e)[0].href; j[0].href = p ? p : location.pathname; m && m.remove(); return k.indexOf(g) === 0
} (), eventCapture: "addEventListener" in document
    }); e.remove(); a.support.boxShadow || a("html").addClass("ui-mobile-nosupport-boxshadow")
})(jQuery);
(function (a, c, d, e) {
    function b(n) { for (; n && typeof n.originalEvent !== "undefined"; ) n = n.originalEvent; return n } function f(n) { var v = {}; for (n = a(n); n && n.length; ) { var s = n.data(w), z; for (z in s) if (s[z]) v[z] = v.hasVirtualBinding = true; n = n.parent() } return v } function h() { if (o.touchbindings) { G.unbind("touchmove", k).unbind("touchend", q).unbind("scroll", p); o.touchbindings = 0 } } function i() { if (t) { clearTimeout(t); t = 0 } t = setTimeout(function () { N = t = 0; L.length = 0; Q = false; h() }, a.vmouse.resetTimerDuration) } function g(n, v, s) {
        var z =
false, D; if (!(D = s && s[n])) { if (s = !s)a: { for (s = a(v.target); s && s.length; ) { if ((D = s.data(w)) && (!n || D[n])) { s = s; break a } s = s.parent() } s = null } D = s } if (D) { z = v; s = z.type; z = a.Event(z); z.type = n; var H = z.originalEvent, J = a.event.props; if (H) for (n = J.length; n; ) { D = J[--n]; z[D] = H[D] } if (s.search(/^touch/) !== -1) { n = b(H); s = n.touches; n = n.changedTouches; if (s = s && s.length ? s[0] : n && n.length ? n[0] : e) { n = 0; for (H = l.length; n < H; n++) { D = l[n]; z[D] = s[D] } } } z = z; a(v.target).trigger(z); z = z.isDefaultPrevented() } return z
    } function j(n) {
        var v = a(n.target).data(x);
        if (!Q && (!N || N !== v)) g("v" + n.type, n)
    } function m(n) { var v = b(n).touches; if (v && v.length === 1) { var s = n.target; v = f(s); if (v.hasVirtualBinding) { N = O++; a(s).data(x, N); if (t) { clearTimeout(t); t = 0 } if (!o.touchbindings) { G.bind("touchend", q).bind("touchmove", k).bind("scroll", p); o.touchbindings = 1 } K = false; s = b(n).touches[0]; B = s.pageX; E = s.pageY; if (F) { I = c.pageXOffset; R = c.pageYOffset } g("vmouseover", n, v); g("vmousedown", n, v) } } } function p(n) { K || g("vmousecancel", n, f(n.target)); K = true; i() } function k(n) {
        var v = b(n).touches[0], s =
K, z = a.vmouse.moveDistanceThreshold; K = K || F && (I !== c.pageXOffset || R !== c.pageYOffset) || Math.abs(v.pageX - B) > z || Math.abs(v.pageY - E) > z; v = f(n.target); K && !s && g("vmousecancel", n, v); g("vmousemove", n, v); i()
    } function q(n) { h(); var v = f(n.target); g("vmouseup", n, v); if (!K) if (g("vclick", n, v)) { var s = b(n).changedTouches[0]; L.push({ touchID: N, x: s.clientX, y: s.clientY }); Q = true } g("vmouseout", n, v); K = false; i() } function u(n) { n = n.data(w); var v; if (n) for (v in n) if (n[v]) return true; return false } function r() { } function y(n) {
        var v =
n.substr(1); return { setup: function () { var s = a(this); u(s) || s.data(w, {}); s.data(w)[n] = true; o[n] = (o[n] || 0) + 1; o[n] === 1 && G.bind(v, j); s.bind(v, r); if (C) { o.touchstart = (o.touchstart || 0) + 1; o.touchstart === 1 && G.bind("touchstart", m) } }, teardown: function () { --o[n]; o[n] || G.unbind(v, j); if (C) { --o.touchstart; o.touchstart || G.unbind("touchstart", m) } var s = a(this); s.data(w)[n] = false; s.unbind(v, r); u(s) || s.removeData(w) } }
    } var w = "virtualMouseBindings", x = "virtualTouchID", A = "vmouseover vmousedown vmousemove vmouseup vclick vmouseout vmousecancel".split(" "),
l = "clientX clientY pageX pageY screenX screenY".split(" "), o = {}, t = 0, B = 0, E = 0, I = 0, R = 0, K = false, L = [], Q = false, F = a.support.scrollTop, C = a.support.eventCapture, G = a(d), O = 1, N = 0; a.vmouse = { moveDistanceThreshold: 10, clickDistanceThreshold: 10, resetTimerDuration: 1500 }; for (var U = 0; U < A.length; U++) a.event.special[A[U]] = y(A[U]); C && d.addEventListener("click", function (n) {
    var v = L.length, s = n.target; if (v) for (var z = n.clientX, D = n.clientY, H = a.vmouse.clickDistanceThreshold, J = s; J; ) {
        for (var P = 0; P < v; P++) {
            var T = L[P]; if (J === s && Math.abs(T.x -
z) < H && Math.abs(T.y - D) < H || a(J).data(x) === T.touchID) { n.preventDefault(); n.stopPropagation(); return } 
        } J = J.parentNode
    } 
}, true)
})(jQuery, window, document);
(function (a, c) {
    function d(i, g, j) { var m = j.type; j.type = g; a.event.handle.call(i, j); j.type = m } a.each("touchstart touchmove touchend orientationchange tap taphold swipe swipeleft swiperight scrollstart scrollstop".split(" "), function (i, g) { a.fn[g] = function (j) { return j ? this.bind(g, j) : this.trigger(g) }; a.attrFn[g] = true }); var e = a.support.touch, b = e ? "touchstart" : "mousedown", f = e ? "touchend" : "mouseup", h = e ? "touchmove" : "mousemove"; a.event.special.scrollstart = { enabled: true, setup: function () {
        function i(p, k) {
            j = k; d(g, j ?
"scrollstart" : "scrollstop", p)
        } var g = this, j, m; a(g).bind("touchmove scroll", function (p) { if (a.event.special.scrollstart.enabled) { j || i(p, true); clearTimeout(m); m = setTimeout(function () { i(p, false) }, 50) } })
    } 
    }; a.event.special.tap = { setup: function () {
        var i = this, g = a(i); g.bind("vmousedown", function (j) {
            function m() { k = false; clearTimeout(u); g.unbind("vclick", p).unbind("vmousecancel", m) } function p(r) { m(); q == r.target && d(i, "tap", r) } if (j.which && j.which !== 1) return false; var k = true, q = j.target, u; g.bind("vmousecancel", m).bind("vclick",
p); u = setTimeout(function () { k && d(i, "taphold", j) }, 750)
        })
    } 
    }; a.event.special.swipe = { setup: function () {
        var i = a(this); i.bind(b, function (g) {
            function j(q) { if (p) { var u = q.originalEvent.touches ? q.originalEvent.touches[0] : q; k = { time: (new Date).getTime(), coords: [u.pageX, u.pageY] }; Math.abs(p.coords[0] - k.coords[0]) > 10 && q.preventDefault() } } var m = g.originalEvent.touches ? g.originalEvent.touches[0] : g, p = { time: (new Date).getTime(), coords: [m.pageX, m.pageY], origin: a(g.target) }, k; i.bind(h, j).one(f, function () {
                i.unbind(h, j);
                if (p && k) if (k.time - p.time < 1E3 && Math.abs(p.coords[0] - k.coords[0]) > 30 && Math.abs(p.coords[1] - k.coords[1]) < 75) p.origin.trigger("swipe").trigger(p.coords[0] > k.coords[0] ? "swipeleft" : "swiperight"); p = k = c
            })
        })
    } 
    }; (function (i) {
        function g() { var k = m(); if (k !== p) { p = k; j.trigger("orientationchange") } } var j = i(window), m, p; i.event.special.orientationchange = { setup: function () { if (i.support.orientation) return false; p = m(); j.bind("resize", g) }, teardown: function () { if (i.support.orientation) return false; j.unbind("resize", g) }, add: function (k) {
            var q =
k.handler; k.handler = function (u) { u.orientation = m(); return q.apply(this, arguments) } 
        } 
        }; m = function () { var k = document.documentElement; return k && k.clientWidth / k.clientHeight < 1.1 ? "portrait" : "landscape" } 
    })(jQuery); a.each({ scrollstop: "scrollstart", taphold: "tap", swipeleft: "swipe", swiperight: "swipe" }, function (i, g) { a.event.special[i] = { setup: function () { a(this).bind(g, a.noop) } } })
})(jQuery);
(function (a, c, d) {
    function e(m) { m = m || location.href; return "#" + m.replace(/^[^#]*#?(.*)$/, "$1") } var b = "hashchange", f = document, h, i = a.event.special, g = f.documentMode, j = "on" + b in c && (g === d || g > 7); a.fn[b] = function (m) { return m ? this.bind(b, m) : this.trigger(b) }; a.fn[b].delay = 50; i[b] = a.extend(i[b], { setup: function () { if (j) return false; a(h.start) }, teardown: function () { if (j) return false; a(h.stop) } }); h = function () {
        function m() {
            var w = e(), x = y(q); if (w !== q) { r(q = w, x); a(c).trigger(b) } else if (x !== q) location.href = location.href.replace(/#.*/,
"") + x; k = setTimeout(m, a.fn[b].delay)
        } var p = {}, k, q = e(), u = function (w) { return w }, r = u, y = u; p.start = function () { k || m() }; p.stop = function () { k && clearTimeout(k); k = d }; a.browser.msie && !j && function () {
            var w, x; p.start = function () { if (!w) { x = (x = a.fn[b].src) && x + e(); w = a('<iframe tabindex="-1" title="empty"/>').hide().one("load", function () { x || r(e()); m() }).attr("src", x || "javascript:0").insertAfter("body")[0].contentWindow; f.onpropertychange = function () { try { if (event.propertyName === "title") w.document.title = f.title } catch (A) { } } } };
            p.stop = u; y = function () { return e(w.location.href) }; r = function (A, l) { var o = w.document, t = a.fn[b].domain; if (A !== l) { o.title = f.title; o.open(); t && o.write('<script>document.domain="' + t + '"<\/script>'); o.close(); w.location.hash = A } } 
        } (); return p
    } ()
})(jQuery, this);
(function (a) {
    a.widget("mobile.page", a.mobile.widget, { options: { backBtnText: "Back", addBackBtn: true, backBtnTheme: null, degradeInputs: { color: false, date: false, datetime: false, "datetime-local": false, email: false, month: false, number: false, range: "number", search: true, tel: false, time: false, url: false, week: false }, keepNative: null }, _create: function () {
        var c = this.element, d = this.options; this.keepNative = ":jqmData(role='none'), :jqmData(role='nojs')" + (d.keepNative ? ", " + d.keepNative : ""); if (this._trigger("beforeCreate") !==
false) {
            c.find(":jqmData(role='page'), :jqmData(role='content')").andSelf().each(function () { a(this).addClass("ui-" + a(this).jqmData("role")) }); c.find(":jqmData(role='nojs')").addClass("ui-nojs"); c.find(":jqmData(role)").andSelf().each(function () {
                var e = a(this), b = e.jqmData("role"), f = e.jqmData("theme"); if (b === "header" || b === "footer") {
                    e.addClass("ui-bar-" + (f || e.parent(":jqmData(role='page')").jqmData("theme") || "a")); e.attr("role", b === "header" ? "banner" : "contentinfo"); f = e.children("a"); var h = f.hasClass("ui-btn-left"),
i = f.hasClass("ui-btn-right"); if (!h) h = f.eq(0).not(".ui-btn-right").addClass("ui-btn-left").length; i || f.eq(1).addClass("ui-btn-right"); if (d.addBackBtn && b === "header" && a(".ui-page").length > 1 && c.jqmData("url") !== a.mobile.path.stripHash(location.hash) && !h && e.jqmData("backbtn") !== false) { f = a("<a href='#' class='ui-btn-left' data-" + a.mobile.ns + "rel='back' data-" + a.mobile.ns + "icon='arrow-l'>" + d.backBtnText + "</a>").prependTo(e); d.backBtnTheme && f.attr("data-" + a.mobile.ns + "theme", d.backBtnTheme) } e.children("h1, h2, h3, h4, h5, h6").addClass("ui-title").attr({ tabindex: "0",
    role: "heading", "aria-level": "1"
})
                } else if (b === "content") { f && e.addClass("ui-body-" + f); e.attr("role", "main") } else if (b === "page") e.addClass("ui-body-" + (f || "c")); switch (b) { case "header": case "footer": case "page": case "content": e.addClass("ui-" + b); break; case "collapsible": case "fieldcontain": case "navbar": case "listview": case "dialog": e[b]() } 
            }); this._enhanceControls(); c.find(":jqmData(role='button'), .ui-bar > a, .ui-header > a, .ui-footer > a").not(".ui-btn").not(this.keepNative).buttonMarkup(); c.find(":jqmData(role='controlgroup')").controlgroup();
            c.find("a:not(.ui-btn):not(.ui-link-inherit)").not(this.keepNative).addClass("ui-link"); c.fixHeaderFooter()
        } 
    }, _typeAttributeRegex: /\s+type=["']?\w+['"]?/, _enhanceControls: function () {
        var c = this.options, d = this; this.element.find("input").not(this.keepNative).each(function () { var f = this.getAttribute("type"), h = c.degradeInputs[f] || "text"; c.degradeInputs[f] && a(this).replaceWith(a("<div>").html(a(this).clone()).html().replace(d._typeAttributeRegex, ' type="' + h + '" data-' + a.mobile.ns + 'type="' + f + '" ')) }); var e =
this.element.find("input, textarea, select, button"), b = e.not(this.keepNative); e = e.filter("input[type=text]"); e.length && typeof e[0].autocorrect !== "undefined" && e.each(function () { this.setAttribute("autocorrect", "off"); this.setAttribute("autocomplete", "off") }); b.filter("[type='radio'], [type='checkbox']").checkboxradio(); b.filter("button, [type='button'], [type='submit'], [type='reset'], [type='image']").button(); b.filter("input, textarea").not("[type='radio'], [type='checkbox'], [type='button'], [type='submit'], [type='reset'], [type='image'], [type='hidden']").textinput();
        b.filter("input, select").filter(":jqmData(role='slider'), :jqmData(type='range')").slider(); b.filter("select:not(:jqmData(role='slider'))").selectmenu()
    } 
    })
})(jQuery);
(function (a, c) {
    a.extend(a.mobile, { ns: "", subPageUrlKey: "ui-page", nonHistorySelectors: "dialog", activePageClass: "ui-page-active", activeBtnClass: "ui-btn-active", ajaxEnabled: true, hashListeningEnabled: true, ajaxLinksEnabled: true, ajaxFormsEnabled: true, defaultTransition: "slide", loadingMessage: "loading", pageLoadErrorMessage: "Error Loading Page", metaViewportContent: "width=device-width, minimum-scale=1, maximum-scale=1", gradeA: function () {
        return a.support.mediaquery || a.mobile.browser.ie && a.mobile.browser.ie >=
7
    }, keyCode: { ALT: 18, BACKSPACE: 8, CAPS_LOCK: 20, COMMA: 188, COMMAND: 91, COMMAND_LEFT: 91, COMMAND_RIGHT: 93, CONTROL: 17, DELETE: 46, DOWN: 40, END: 35, ENTER: 13, ESCAPE: 27, HOME: 36, INSERT: 45, LEFT: 37, MENU: 93, NUMPAD_ADD: 107, NUMPAD_DECIMAL: 110, NUMPAD_DIVIDE: 111, NUMPAD_ENTER: 108, NUMPAD_MULTIPLY: 106, NUMPAD_SUBTRACT: 109, PAGE_DOWN: 34, PAGE_UP: 33, PERIOD: 190, RIGHT: 39, SHIFT: 16, SPACE: 32, TAB: 9, UP: 38, WINDOWS: 91 }, silentScroll: function (e) {
        e = e || 0; a.event.special.scrollstart.enabled = false; setTimeout(function () {
            c.scrollTo(0, e); a(document).trigger("silentscroll",
{ x: 0, y: e })
        }, 20); setTimeout(function () { a.event.special.scrollstart.enabled = true }, 150)
    } 
    }); a.fn.jqmData = function (e, b) { return this.data(e ? a.mobile.ns + e : e, b) }; a.jqmData = function (e, b, f) { return a.data(e, b && a.mobile.ns + b, f) }; a.fn.jqmRemoveData = function (e) { return this.removeData(a.mobile.ns + e) }; a.jqmRemoveData = function (e, b) { return a.removeData(e, b && a.mobile.ns + b) }; a.jqmHasData = function (e, b) { return a.hasData(e, b && a.mobile.ns + b) }; var d = a.find; a.find = function (e, b, f, h) {
        e = e.replace(/:jqmData\(([^)]*)\)/g, "[data-" +
(a.mobile.ns || "") + "$1]"); return d.call(this, e, b, f, h)
    }; a.extend(a.find, d); a.find.matches = function (e, b) { return a.find(e, null, null, b) }; a.find.matchesSelector = function (e, b) { return a.find(b, null, null, [e]).length > 0 } 
})(jQuery, this);
(function (a, c) {
    function d(l) { if (i && (!i.closest(".ui-page-active").length || l)) i.removeClass(a.mobile.activeBtnClass); i = null } var e = a(window), b = a("html"), f = a("head"), h = { get: function (l) { if (l === c) l = location.hash; return h.stripHash(l).replace(/[^\/]*\.[^\/*]+$/, "") }, getFilePath: function (l) { var o = "&" + a.mobile.subPageUrlKey; return l && l.split(o)[0].split(q)[0] }, set: function (l) { location.hash = l }, origin: "", setOrigin: function () { h.origin = h.get(location.protocol + "//" + location.host + location.pathname) }, makeAbsolute: function (l) {
        return h.isPath(window.location.hash) ?
h.get() + l : l
    }, isPath: function (l) { return /\//.test(l) }, clean: function (l) { return l.replace(RegExp("^" + location.protocol + "//" + location.host + location.pathname), "") }, stripHash: function (l) { return l.replace(/^#/, "") }, isExternal: function (l) { return h.hasProtocol(h.clean(l)) }, hasProtocol: function (l) { return /^(:?\w+:)/.test(l) }, isRelative: function (l) { return /^[^\/|#]/.test(l) && !h.hasProtocol(l) }, isEmbeddedPage: function (l) { return /^#/.test(l) } 
    }, i = null, g = { stack: [], activeIndex: 0, getActive: function () { return g.stack[g.activeIndex] },
        getPrev: function () { return g.stack[g.activeIndex - 1] }, getNext: function () { return g.stack[g.activeIndex + 1] }, addNew: function (l, o, t, B) { g.getNext() && g.clearForward(); g.stack.push({ url: l, transition: o, title: t, page: B }); g.activeIndex = g.stack.length - 1 }, clearForward: function () { g.stack = g.stack.slice(0, g.activeIndex + 1) }, directHashChange: function (l) { var o, t, B; a.each(g.stack, function (E, I) { if (l.currentUrl === I.url) { o = E < g.activeIndex; t = !o; B = E } }); this.activeIndex = B !== c ? B : this.activeIndex; if (o) l.isBack(); else t && l.isForward() },
        ignoreNextHashChange: true
    }, j = "[tabindex],a,button:visible,select:visible,input", m = null, p = [], k = false, q = "&ui-state=dialog", u = f.children("base"), r = location.protocol + "//" + location.host, y = h.get(r + location.pathname), w = y; if (u.length) { var x = u.attr("href"); if (x) w = x.search(/^[^:\/]+:\/\/[^\/]+\/?/) === -1 ? x.charAt(0) === "/" ? r + x : y + x : x; w += w.charAt(w.length - 1) === "/" ? " " : "/" } var A = a.support.dynamicBaseTag ? { element: u.length ? u : a("<base>", { href: w }).prependTo(f), set: function (l) { A.element.attr("href", w + h.get(l)) }, reset: function () {
        A.element.attr("href",
w)
    } 
    } : c; h.setOrigin(); a.fn.animationComplete = function (l) { if (a.support.cssTransitions) return a(this).one("webkitAnimationEnd", l); else { setTimeout(l, 0); return a(this) } }; a.mobile.updateHash = h.set; a.mobile.path = h; a.mobile.base = A; a.mobile.urlstack = g.stack; a.mobile.urlHistory = g; a.mobile.allowCrossDomainPages = false; a.mobile.changePage = function (l, o, t, B, E) {
        function I() { k = false; p.length > 0 && a.mobile.changePage.apply(a.mobile, p.pop()) } function R() {
            function H() {
                if (B !== false && C) { g.ignoreNextHashChange = false; h.set(C) } var M =
l.jqmData("title") || l.find(".ui-header .ui-title").text(); if (M && D == document.title) D = M; !s && !z && g.addNew(C, o, D, l); document.title = g.getActive().title; d(); a.mobile.silentScroll(l.jqmData("lastScroll")); M = l; var S = M.jqmData("lastClicked"); if (S && S.length) S.focus(); else { S = M.find(".ui-title:eq(0)"); S.length ? S.focus() : M.find(j).eq(0).focus() } F && F.data("page")._trigger("hide", null, { nextPage: l }); l.data("page")._trigger("show", null, { prevPage: F || a("") }); a.mobile.activePage = l; n !== null && n.remove(); b.removeClass("ui-mobile-rendering");
                I()
            } function J(M) { a.mobile.pageContainer.addClass(M); V.push(M) } a.mobile.silentScroll(); var P = e.scrollTop(), T = ["flip"], V = []; if (C.indexOf("&" + a.mobile.subPageUrlKey) > -1) l = a(":jqmData(url='" + C + "')"); if (F) { F.jqmData("lastScroll", P).jqmData("lastClicked", i); F.data("page")._trigger("beforehide", null, { nextPage: l }) } l.data("page")._trigger("beforeshow", null, { prevPage: F || a("") }); if (o && o !== "none") {
                a.mobile.pageLoading(true); a.inArray(o, T) >= 0 && J("ui-mobile-viewport-perspective"); J("ui-mobile-viewport-transitioning");
                if (F) F.addClass(o + " out " + (t ? "reverse" : "")); l.addClass(a.mobile.activePageClass + " " + o + " in " + (t ? "reverse" : "")); l.animationComplete(function () { l.add(F).removeClass("out in reverse " + o); F && F.removeClass(a.mobile.activePageClass); H(); a.mobile.pageContainer.removeClass(V.join(" ")); V = [] })
            } else { a.mobile.pageLoading(true); F && F.removeClass(a.mobile.activePageClass); l.addClass(a.mobile.activePageClass); H() } 
        } function K() {
            if (m || l.jqmData("role") === "dialog") {
                C = g.getActive().url + q; if (m) {
                    l.attr("data-" + a.mobile.ns +
"role", m); m = null
                } 
            } l.page()
        } var L = a.type(l) === "array", Q = a.type(l) === "object", F = L ? l[0] : a.mobile.activePage; l = L ? l[1] : l; var C = a.type(l) === "string" ? h.stripHash(l) : "", G = C, O, N = "get", U = false, n = null, v = g.getActive(), s = false, z = false, D = document.title; if (!(v && g.stack.length > 1 && v.url === C && !L && !Q)) if (k) p.unshift(arguments); else {
            k = true; E && g.directHashChange({ currentUrl: C, isBack: function () { z = !(s = true); t = true; o = o || v.transition }, isForward: function () { z = !(s = false); o = o || g.getActive().transition } }); if (Q && l.url) {
                C = l.url;
                O = l.data; N = l.type; U = true; if (O && N === "get") { if (a.type(O) === "object") O = a.param(O); C += "?" + O; O = c } 
            } A && A.reset(); if (window.document.activeElement) a(window.document.activeElement || "").add("input:focus, textarea:focus, select:focus").blur(); if (C) { l = a(":jqmData(url='" + C + "')"); G = h.getFilePath(C) } else { L = l.attr("data-" + a.mobile.ns + "url"); Q = h.getFilePath(L); if (L !== Q) G = Q } if (o === c) o = m && m === "dialog" ? "pop" : a.mobile.defaultTransition; if (l.length && !U) { G && A && A.set(G); K(); R() } else {
                if (l.length) n = l; a.mobile.pageLoading();
                a.ajax({ url: G, type: N, data: O, dataType: "html", success: function (H) {
                    var J = a("<div></div>"), P, T = H.match(/<title[^>]*>([^<]*)/) && RegExp.$1, V = RegExp("\\bdata-" + a.mobile.ns + "url=[\"']?([^\"'>]*)[\"']?"); if (RegExp(".*(<[^>]+\\bdata-" + a.mobile.ns + "role=[\"']?page[\"']?[^>]*>).*").test(H) && RegExp.$1 && V.test(RegExp.$1) && RegExp.$1) P = RegExp.$1; if (P) { A && A.set(P); C = G = h.getFilePath(P) } else A && A.set(G); J.get(0).innerHTML = H; l = J.find(":jqmData(role='page'), :jqmData(role='dialog')").first(); if (T) D = T; if (!a.support.dynamicBaseTag) {
                        var M =
h.get(G); l.find("[src], link[href], a[rel='external'], :jqmData(ajax='false'), a[target]").each(function () { var S = a(this).is("[href]") ? "href" : "src", W = a(this).attr(S); W = W.replace(location.protocol + "//" + location.host + location.pathname, ""); /^(\w+:|#|\/)/.test(W) || a(this).attr(S, M + W) })
                    } l.attr("data-" + a.mobile.ns + "url", G).appendTo(a.mobile.pageContainer); K(); setTimeout(function () { R() }, 0)
                }, error: function () {
                    a.mobile.pageLoading(true); d(true); A && A.set(h.get()); I(); a("<div class='ui-loader ui-overlay-shadow ui-body-e ui-corner-all'><h1>" +
a.mobile.pageLoadErrorMessage + "</h1></div>").css({ display: "block", opacity: 0.96, top: a(window).scrollTop() + 100 }).appendTo(a.mobile.pageContainer).delay(800).fadeOut(400, function () { a(this).remove() })
                } 
                })
            } 
        } 
    }; a("form").live("submit", function (l) {
        if (!(!a.mobile.ajaxEnabled || !a.mobile.ajaxFormsEnabled || a(this).is(":jqmData(ajax='false')"))) {
            var o = a(this).attr("method"), t = h.clean(a(this).attr("action")), B = a(this).attr("target"); if (!(h.isExternal(t) || B)) {
                if (h.isRelative(t)) t = h.makeAbsolute(t); a.mobile.changePage({ url: t.length &&
t || h.get(), type: o.length && o.toLowerCase() || "get", data: a(this).serialize()
                }, a(this).jqmData("transition"), a(this).jqmData("direction"), true); l.preventDefault()
            } 
        } 
    }); a("a").live("vclick", function () { a(this).closest(".ui-btn").not(".ui-disabled").addClass(a.mobile.activeBtnClass) }); a("a").live("click", function (l) {
        var o = a(this), t = o.attr("href") || "#", B = h.hasProtocol(t); t = h.clean(t); var E = o.is("[rel='external']"), I = h.isEmbeddedPage(t), R = a.mobile.allowCrossDomainPages && location.protocol === "file:" && t.search(/^https?:/) !=
-1; E = h.isExternal(t) && !R || E && !I; I = o.is("[target]"); R = o.is(":jqmData(ajax='false')"); var K = h.stripHash(t) == a.mobile.activePage.jqmData("url"); if (o.is(":jqmData(rel='back')")) { window.history.back(); return false } if (t.replace(h.get(), "") == "#" || K) l.preventDefault(); else {
            i = o.closest(".ui-btn"); if (E || R || I || !a.mobile.ajaxEnabled || !a.mobile.ajaxLinksEnabled) window.setTimeout(function () { d(true) }, 200); else {
                E = o.jqmData("transition"); I = (I = o.jqmData("direction")) && I === "reverse" || o.jqmData("back"); m = o.attr("data-" +
a.mobile.ns + "rel"); if (h.isRelative(t) && !B) t = h.makeAbsolute(t); t = h.stripHash(t); a.mobile.changePage(t, E, I); l.preventDefault()
            } 
        } 
    }); e.bind("hashchange", function () {
        var l = h.stripHash(location.hash), o = a.mobile.urlHistory.stack.length === 0 ? false : c; if (!a.mobile.hashListeningEnabled || !g.ignoreNextHashChange) { if (!g.ignoreNextHashChange) g.ignoreNextHashChange = true } else {
            if (g.stack.length > 1 && l.indexOf(q) > -1) if (a.mobile.activePage.is(".ui-dialog")) {
                var t = function () { l = a.mobile.urlHistory.getActive().page }; g.directHashChange({ currentUrl: l,
                    isBack: t, isForward: t
                })
            } else { g.directHashChange({ currentUrl: l, isBack: function () { window.history.back() }, isForward: function () { window.history.forward() } }); return } l ? a.mobile.changePage(l, o, c, false, true) : a.mobile.changePage(a.mobile.firstPage, o, true, false, true)
        } 
    })
})(jQuery);
(function (a, c) {
    a.fn.fixHeaderFooter = function () { if (!a.support.scrollTop) return this; return this.each(function () { var d = a(this); d.jqmData("fullscreen") && d.addClass("ui-page-fullscreen"); d.find(".ui-header:jqmData(position='fixed')").addClass("ui-header-fixed ui-fixed-inline fade"); d.find(".ui-footer:jqmData(position='fixed')").addClass("ui-footer-fixed ui-fixed-inline fade") }) }; a.fixedToolbars = function () {
        function d() { if (!h && f == "overlay") { i || a.fixedToolbars.hide(true); a.fixedToolbars.startShowTimer() } }
        function e(k) { var q = 0; if (k) { var u = k.offsetParent, r = document.body; for (q = k.offsetTop; k && k != r; ) { q += k.scrollTop || 0; if (k == u) { q += u.offsetTop; u = k.offsetParent } k = k.parentNode } } return q } function b(k) { var q = a(window).scrollTop(), u = e(k[0]), r = k.css("top") == "auto" ? 0 : parseFloat(k.css("top")), y = window.innerHeight, w = k.outerHeight(), x = k.parents(".ui-page:not(.ui-page-fullscreen)").length; if (k.is(".ui-header-fixed")) { r = q - u + r; if (r < u) r = 0; return k.css("top", x ? r : q) } else { r = q + y - w - (u - r); return k.css("top", x ? r : q + y - w) } } if (a.support.scrollTop) {
            var f =
"inline", h = false, i, g, j = null, m = false, p = true; a(function () {
    a(document).bind("vmousedown", function () { if (p) j = f }).bind("vclick", function (k) { if (p) if (!a(k.target).closest("a,input,textarea,select,button,label,.ui-header-fixed,.ui-footer-fixed").length) if (!m) { a.fixedToolbars.toggle(j); j = null } }).bind("scrollstart", function () { m = true; if (j == null) j = f; var k = j == "overlay"; if (h = k || !!i) { a.fixedToolbars.clearShowTimer(); k && a.fixedToolbars.hide(true) } }).bind("scrollstop", function (k) {
        if (!a(k.target).closest("a,input,textarea,select,button,label,.ui-header-fixed,.ui-footer-fixed").length) {
            m =
false; if (h) { h = false; a.fixedToolbars.startShowTimer() } j = null
        } 
    }).bind("silentscroll", d); a(window).bind("resize", d)
}); a(".ui-page").live("pagebeforeshow", function (k, q) { var u = a(k.target).find(":jqmData(role='footer')"), r = u.data("id"), y = q.prevPage; prevFooter = y && y.find(":jqmData(role='footer')"); y = prevFooter.jqmData("id") === r; if (r && y) { g = u; b(g.removeClass("fade in out").appendTo(a.mobile.pageContainer)) } }); a(".ui-page").live("pageshow", function () {
    var k = a(this); g && g.length && setTimeout(function () {
        b(g.appendTo(k).addClass("fade"));
        g = null
    }, 500); a.fixedToolbars.show(true, this)
}); return { show: function (k, q) {
    a.fixedToolbars.clearShowTimer(); f = "overlay"; return (q ? a(q) : a.mobile.activePage ? a.mobile.activePage : a(".ui-page-active")).children(".ui-header-fixed:first, .ui-footer-fixed:not(.ui-footer-duplicate):last").each(function () {
        var u = a(this), r = a(window).scrollTop(), y = e(u[0]), w = window.innerHeight, x = u.outerHeight(); r = u.is(".ui-header-fixed") && r <= y + x || u.is(".ui-footer-fixed") && y <= r + w; u.addClass("ui-fixed-overlay").removeClass("ui-fixed-inline");
        !r && !k && u.animationComplete(function () { u.removeClass("in") }).addClass("in"); b(u)
    })
}, hide: function (k) {
    f = "inline"; return (a.mobile.activePage ? a.mobile.activePage : a(".ui-page-active")).children(".ui-header-fixed:first, .ui-footer-fixed:not(.ui-footer-duplicate):last").each(function () {
        var q = a(this), u = q.css("top"); u = u == "auto" ? 0 : parseFloat(u); q.addClass("ui-fixed-inline").removeClass("ui-fixed-overlay"); if (u < 0 || q.is(".ui-header-fixed") && u != 0) if (k) q.css("top", 0); else q.css("top") !== "auto" && parseFloat(q.css("top")) !==
0 && q.animationComplete(function () { q.removeClass("out reverse"); q.css("top", 0) }).addClass("out reverse")
    })
}, startShowTimer: function () { a.fixedToolbars.clearShowTimer(); var k = a.makeArray(arguments); i = setTimeout(function () { i = c; a.fixedToolbars.show.apply(null, k) }, 100) }, clearShowTimer: function () { i && clearTimeout(i); i = c }, toggle: function (k) { if (k) f = k; return f == "overlay" ? a.fixedToolbars.hide() : a.fixedToolbars.show() }, setTouchToggleEnabled: function (k) { p = k } 
}
        } 
    } ()
})(jQuery);
(function (a, c) {
    a.widget("mobile.checkboxradio", a.mobile.widget, { options: { theme: null }, _create: function () {
        var d = this, e = this.element, b = e.closest("form,fieldset,:jqmData(role='page')").find("label").filter("[for=" + e[0].id + "]"), f = e.attr("type"), h = "ui-icon-" + f + "-off"; if (!(f != "checkbox" && f != "radio")) {
            a.extend(this, { label: b, inputtype: f, checkedicon: "ui-icon-" + f + "-on", uncheckedicon: h }); if (!this.options.theme) this.options.theme = this.element.jqmData("theme"); b.buttonMarkup({ theme: this.options.theme, icon: this.element.parents(":jqmData(type='horizontal')").length ?
c : h, shadow: false
            }); e.add(b).wrapAll("<div class='ui-" + f + "'></div>"); b.bind({ vmouseover: function () { if (a(this).parent().is(".ui-disabled")) return false }, vclick: function (i) { if (e.is(":disabled")) i.preventDefault(); else { d._cacheVals(); e.attr("checked", f === "radio" && true || !e.is(":checked")); d._updateAll(); return false } } }); e.bind({ vmousedown: function () { this._cacheVals() }, vclick: function () { d._updateAll() }, focus: function () { b.addClass("ui-focus") }, blur: function () { b.removeClass("ui-focus") } }); this.refresh()
        } 
    },
        _cacheVals: function () { this._getInputSet().each(function () { a(this).jqmData("cacheVal", a(this).is(":checked")) }) }, _getInputSet: function () { return this.element.closest("form,fieldset,:jqmData(role='page')").find("input[name='" + this.element.attr("name") + "'][type='" + this.inputtype + "']") }, _updateAll: function () { var d = this; this._getInputSet().each(function () { if (a(this).is(":checked") || d.inputtype === "checkbox") a(this).trigger("change") }).checkboxradio("refresh") }, refresh: function () {
            var d = this.element, e = this.label,
b = e.find(".ui-icon"); if (d[0].checked) { e.addClass(a.mobile.activeBtnClass); b.addClass(this.checkedicon).removeClass(this.uncheckedicon) } else { e.removeClass(a.mobile.activeBtnClass); b.removeClass(this.checkedicon).addClass(this.uncheckedicon) } d.is(":disabled") ? this.disable() : this.enable()
        }, disable: function () { this.element.attr("disabled", true).parent().addClass("ui-disabled") }, enable: function () { this.element.attr("disabled", false).parent().removeClass("ui-disabled") } 
    })
})(jQuery);
(function (a) {
    a.widget("mobile.textinput", a.mobile.widget, { options: { theme: null }, _create: function () {
        var c = this.element, d = this.options, e = d.theme; if (!e) { e = this.element.closest("[class*='ui-bar-'],[class*='ui-body-']"); e = e.length ? /ui-(bar|body)-([a-z])/.exec(e.attr("class"))[2] : "c" } e = " ui-body-" + e; a("label[for=" + c.attr("id") + "]").addClass("ui-input-text"); c.addClass("ui-input-text ui-body-" + d.theme); var b = c; if (c.is("[type='search'],:jqmData(type='search')")) {
            b = c.wrap('<div class="ui-input-search ui-shadow-inset ui-btn-corner-all ui-btn-shadow ui-icon-searchfield' +
e + '"></div>').parent(); var f = a('<a href="#" class="ui-input-clear" title="clear text">clear text</a>').tap(function (g) { c.val("").focus(); c.trigger("change"); f.addClass("ui-input-clear-hidden"); g.preventDefault() }).appendTo(b).buttonMarkup({ icon: "delete", iconpos: "notext", corners: true, shadow: true }); d = function () { c.val() == "" ? f.addClass("ui-input-clear-hidden") : f.removeClass("ui-input-clear-hidden") }; d(); c.keyup(d)
        } else c.addClass("ui-corner-all ui-shadow-inset" + e); c.focus(function () { b.addClass("ui-focus") }).blur(function () { b.removeClass("ui-focus") });
        if (c.is("textarea")) { var h = function () { var g = c[0].scrollHeight; c[0].clientHeight < g && c.css({ height: g + 15 }) }, i; c.keyup(function () { clearTimeout(i); i = setTimeout(h, 100) }) } 
    }, disable: function () { (this.element.attr("disabled", true).is("[type='search'],:jqmData(type='search')") ? this.element.parent() : this.element).addClass("ui-disabled") }, enable: function () { (this.element.attr("disabled", false).is("[type='search'],:jqmData(type='search')") ? this.element.parent() : this.element).removeClass("ui-disabled") } 
    })
})(jQuery);
(function (a) {
    a.widget("mobile.selectmenu", a.mobile.widget, { options: { theme: null, disabled: false, icon: "arrow-d", iconpos: "right", inline: null, corners: true, shadow: true, iconshadow: true, menuPageTheme: "b", overlayTheme: "a", hidePlaceholderMenuItems: true, closeText: "Close", nativeMenu: true }, _create: function () {
        var c = this, d = this.options, e = this.element.wrap("<div class='ui-select'>"), b = e.attr("id"), f = a("label[for=" + b + "]").addClass("ui-select"), h = e[0].selectedIndex == -1 ? 0 : e[0].selectedIndex, i = (c.options.nativeMenu ?
a("<div/>") : a("<a>", { href: "#", role: "button", id: m, "aria-haspopup": "true", "aria-owns": p })).text(a(e[0].options.item(h)).text()).insertBefore(e).buttonMarkup({ theme: d.theme, icon: d.icon, iconpos: d.iconpos, inline: d.inline, corners: d.corners, shadow: d.shadow, iconshadow: d.iconshadow }), g = c.isMultiple = e[0].multiple; d.nativeMenu && window.opera && window.opera.version && e.addClass("ui-select-nativeonly"); if (!d.nativeMenu) {
            var j = e.find("option"), m = b + "-button", p = b + "-menu", k = e.closest(".ui-page"); h = /ui-btn-up-([a-z])/.exec(i.attr("class"))[1];
            var q = a("<div data-" + a.mobile.ns + "role='dialog' data-" + a.mobile.ns + "theme='" + d.menuPageTheme + "'><div data-" + a.mobile.ns + "role='header'><div class='ui-title'>" + f.text() + "</div></div><div data-" + a.mobile.ns + "role='content'></div></div>").appendTo(a.mobile.pageContainer).page(), u = q.find(".ui-content"); q.find(".ui-header a"); var r = a("<div>", { "class": "ui-selectmenu-screen ui-screen-hidden" }).appendTo(k), y = a("<div>", { "class": "ui-selectmenu ui-selectmenu-hidden ui-overlay-shadow ui-corner-all pop ui-body-" +
d.overlayTheme
            }).insertAfter(r), w = a("<ul>", { "class": "ui-selectmenu-list", id: p, role: "listbox", "aria-labelledby": m }).attr("data-" + a.mobile.ns + "theme", h).appendTo(y), x = a("<div>", { "class": "ui-header ui-bar-" + h }).prependTo(y), A = a("<h1>", { "class": "ui-title" }).appendTo(x), l = a("<a>", { text: d.closeText, href: "#", "class": "ui-btn-left" }).attr("data-" + a.mobile.ns + "iconpos", "notext").attr("data-" + a.mobile.ns + "icon", "delete").appendTo(x).buttonMarkup()
        } if (g) c.buttonCount = a("<span>").addClass("ui-li-count ui-btn-up-c ui-btn-corner-all").hide().appendTo(i);
        d.disabled && this.disable(); e.change(function () { c.refresh() }); a.extend(c, { select: e, optionElems: j, selectID: b, label: f, buttonId: m, menuId: p, thisPage: k, button: i, menuPage: q, menuPageContent: u, screen: r, listbox: y, list: w, menuType: void 0, header: x, headerClose: l, headerTitle: A, placeholder: "" }); if (d.nativeMenu) e.appendTo(i).bind("vmousedown", function () { i.addClass(a.mobile.activeBtnClass) }).bind("focus vmouseover", function () { i.trigger("vmouseover") }).bind("vmousemove", function () { i.removeClass(a.mobile.activeBtnClass) }).bind("change blur vmouseout",
function () { i.trigger("vmouseout").removeClass(a.mobile.activeBtnClass) }); else {
            c.refresh(); e.attr("tabindex", "-1").focus(function () { a(this).blur(); i.focus() }); i.bind("vclick keydown", function (o) { if (o.type == "vclick" || o.keyCode && (o.keyCode === a.mobile.keyCode.ENTER || o.keyCode === a.mobile.keyCode.SPACE)) { c.open(); o.preventDefault() } }); w.attr("role", "listbox").delegate(".ui-li>a", "focusin", function () { a(this).attr("tabindex", "0") }).delegate(".ui-li>a", "focusout", function () { a(this).attr("tabindex", "-1") }).delegate("li:not(.ui-disabled, .ui-li-divider)",
"vclick", function (o) { var t = e[0].selectedIndex, B = w.find("li:not(.ui-li-divider)").index(this), E = c.optionElems.eq(B)[0]; E.selected = g ? !E.selected : true; g && a(this).find(".ui-icon").toggleClass("ui-icon-checkbox-on", E.selected).toggleClass("ui-icon-checkbox-off", !E.selected); t !== B && e.trigger("change"); g || c.close(); o.preventDefault() }).keydown(function (o) {
    var t = a(o.target), B = t.closest("li"); switch (o.keyCode) {
        case 38: o = B.prev(); if (o.length) { t.blur().attr("tabindex", "-1"); o.find("a").first().focus() } return false;
        case 40: o = B.next(); if (o.length) { t.blur().attr("tabindex", "-1"); o.find("a").first().focus() } return false; case 13: case 32: t.trigger("vclick"); return false
    } 
}); r.bind("vclick", function () { c.close() }); c.headerClose.click(function () { if (c.menuType == "overlay") { c.close(); return false } })
        } 
    }, _buildList: function () {
        var c = this, d = this.options, e = this.placeholder, b = [], f = [], h = c.isMultiple ? "checkbox-off" : "false"; c.list.empty().filter(".ui-listview").listview("destroy"); c.select.find("option").each(function () {
            var i = a(this),
g = i.parent(), j = i.text(), m = "<a href='#'>" + j + "</a>", p = [], k = []; if (g.is("optgroup")) { g = g.attr("label"); if (a.inArray(g, b) === -1) { f.push("<li data-" + a.mobile.ns + "role='list-divider'>" + g + "</li>"); b.push(g) } } if (!this.getAttribute("value") || j.length == 0 || i.jqmData("placeholder")) { d.hidePlaceholderMenuItems && p.push("ui-selectmenu-placeholder"); e = c.placeholder = j } if (this.disabled) { p.push("ui-disabled"); k.push("aria-disabled='true'") } f.push("<li data-" + a.mobile.ns + "icon='" + h + "' class='" + p.join(" ") + "' " + k.join(" ") +
">" + m + "</li>")
        }); c.list.html(f.join(" ")); c.list.find("li").attr({ role: "option", tabindex: "-1" }).first().attr("tabindex", "0"); this.isMultiple || this.headerClose.hide(); !this.isMultiple && !e.length ? this.header.hide() : this.headerTitle.text(this.placeholder); c.list.listview()
    }, refresh: function (c) {
        var d = this, e = this.element, b = this.isMultiple, f = this.optionElems = e.find("option"), h = f.filter(":selected"), i = h.map(function () { return f.index(this) }).get(); if (!d.options.nativeMenu && (c || e[0].options.length != d.list.find("li").length)) d._buildList();
        d.button.find(".ui-btn-text").text(function () { if (!b) return h.text(); return h.length ? h.map(function () { return a(this).text() }).get().join(", ") : d.placeholder }); if (b) d.buttonCount[h.length > 1 ? "show" : "hide"]().text(h.length); d.options.nativeMenu || d.list.find("li:not(.ui-li-divider)").removeClass(a.mobile.activeBtnClass).attr("aria-selected", false).each(function (g) { if (a.inArray(g, i) > -1) { g = a(this).addClass(a.mobile.activeBtnClass); g.find("a").attr("aria-selected", true); b && g.find(".ui-icon").removeClass("ui-icon-checkbox-off").addClass("ui-icon-checkbox-on") } })
    },
        open: function () {
            function c() { d.list.find(".ui-btn-active").focus() } if (!(this.options.disabled || this.options.nativeMenu)) {
                var d = this, e = d.list.parent().outerHeight(), b = d.list.parent().outerWidth(), f = a(window).scrollTop(), h = d.button.offset().top, i = window.innerHeight, g = window.innerWidth; d.button.addClass(a.mobile.activeBtnClass); setTimeout(function () { d.button.removeClass(a.mobile.activeBtnClass) }, 300); if (e > i - 80 || !a.support.scrollTop) {
                    f == 0 && h > i && d.thisPage.one("pagehide", function () {
                        a(this).jqmData("lastScroll",
h)
                    }); d.menuPage.one("pageshow", function () { a(window).one("silentscroll", function () { c() }) }); d.menuType = "page"; d.menuPageContent.append(d.list); a.mobile.changePage(d.menuPage, "pop", false, true)
                } else {
                    d.menuType = "overlay"; d.screen.height(a(document).height()).removeClass("ui-screen-hidden"); var j = h - f, m = f + i - h, p = e / 2, k = parseFloat(d.list.parent().css("max-width")); e = j > e / 2 && m > e / 2 ? h + d.button.outerHeight() / 2 - p : j > m ? f + i - e - 30 : f + 30; if (b < k) k = (g - b) / 2; else {
                        k = d.button.offset().left + d.button.outerWidth() / 2 - b / 2; if (k < 30) k =
30; else if (k + b > g) k = g - b - 30
                    } d.listbox.append(d.list).removeClass("ui-selectmenu-hidden").css({ top: e, left: k }).addClass("in"); c()
                } setTimeout(function () { d.isOpen = true }, 400)
            } 
        }, close: function () {
            function c() { setTimeout(function () { d.button.focus() }, 40); d.listbox.removeAttr("style").append(d.list) } if (!(this.options.disabled || !this.isOpen || this.options.nativeMenu)) {
                var d = this; if (d.menuType == "page") { a.mobile.changePage([d.menuPage, d.thisPage], "pop", true, false); d.menuPage.one("pagehide", c) } else {
                    d.screen.addClass("ui-screen-hidden");
                    d.listbox.addClass("ui-selectmenu-hidden").removeAttr("style").removeClass("in"); c()
                } this.isOpen = false
            } 
        }, disable: function () { this.element.attr("disabled", true); this.button.addClass("ui-disabled").attr("aria-disabled", true); return this._setOption("disabled", true) }, enable: function () { this.element.attr("disabled", false); this.button.removeClass("ui-disabled").attr("aria-disabled", false); return this._setOption("disabled", false) } 
    })
})(jQuery);
(function (a) {
    a.fn.buttonMarkup = function (d) {
        return this.each(function () {
            var e = a(this), b = a.extend({}, a.fn.buttonMarkup.defaults, e.jqmData(), d), f, h = "ui-btn-inner", i; c && c(); if (!b.theme) { f = e.closest("[class*='ui-bar-'],[class*='ui-body-']"); b.theme = f.length ? /ui-(bar|body)-([a-z])/.exec(f.attr("class"))[2] : "c" } f = "ui-btn ui-btn-up-" + b.theme; if (b.inline) f += " ui-btn-inline"; if (b.icon) { b.icon = "ui-icon-" + b.icon; b.iconpos = b.iconpos || "left"; i = "ui-icon " + b.icon; if (b.shadow) i += " ui-icon-shadow" } if (b.iconpos) {
                f +=
" ui-btn-icon-" + b.iconpos; b.iconpos == "notext" && !e.attr("title") && e.attr("title", e.text())
            } if (b.corners) { f += " ui-btn-corner-all"; h += " ui-btn-corner-all" } if (b.shadow) f += " ui-shadow"; e.attr("data-" + a.mobile.ns + "theme", b.theme).addClass(f); b = ("<D class='" + h + "'><D class='ui-btn-text'></D>" + (b.icon ? "<span class='" + i + "'></span>" : "") + "</D>").replace(/D/g, b.wrapperEls); e.wrapInner(b)
        })
    }; a.fn.buttonMarkup.defaults = { corners: true, shadow: true, iconshadow: true, wrapperEls: "span" }; var c = function () {
        a(".ui-btn:not(.ui-disabled)").live({ vmousedown: function () {
            var d =
a(this).attr("data-" + a.mobile.ns + "theme"); a(this).removeClass("ui-btn-up-" + d).addClass("ui-btn-down-" + d)
        }, "vmousecancel vmouseup": function () { var d = a(this).attr("data-" + a.mobile.ns + "theme"); a(this).removeClass("ui-btn-down-" + d).addClass("ui-btn-up-" + d) }, "vmouseover focus": function () { var d = a(this).attr("data-" + a.mobile.ns + "theme"); a(this).removeClass("ui-btn-up-" + d).addClass("ui-btn-hover-" + d) }, "vmouseout blur": function () {
            var d = a(this).attr("data-" + a.mobile.ns + "theme"); a(this).removeClass("ui-btn-hover-" +
d).addClass("ui-btn-up-" + d)
        } 
        }); c = null
    } 
})(jQuery);
(function (a) {
    a.widget("mobile.button", a.mobile.widget, { options: { theme: null, icon: null, iconpos: null, inline: null, corners: true, shadow: true, iconshadow: true }, _create: function () {
        var c = this.element, d = this.options; this.button = a("<div></div>").text(c.text() || c.val()).buttonMarkup({ theme: d.theme, icon: d.icon, iconpos: d.iconpos, inline: d.inline, corners: d.corners, shadow: d.shadow, iconshadow: d.iconshadow }).insertBefore(c).append(c.addClass("ui-btn-hidden")); d = c.attr("type"); d !== "button" && d !== "reset" && c.bind("vclick",
function () { var e = a("<input>", { type: "hidden", name: c.attr("name"), value: c.attr("value") }).insertBefore(c); a(document).submit(function () { e.remove() }) }); this.refresh()
    }, enable: function () { this.element.attr("disabled", false); this.button.removeClass("ui-disabled").attr("aria-disabled", false); return this._setOption("disabled", false) }, disable: function () { this.element.attr("disabled", true); this.button.addClass("ui-disabled").attr("aria-disabled", true); return this._setOption("disabled", true) }, refresh: function () {
        this.element.attr("disabled") ?
this.disable() : this.enable()
    } 
    })
})(jQuery);
(function (a) {
    a.widget("mobile.slider", a.mobile.widget, { options: { theme: null, trackTheme: null, disabled: false }, _create: function () {
        var c = this, d = this.element, e = d.parents("[class*=ui-bar-],[class*=ui-body-]").eq(0); e = e.length ? e.attr("class").match(/ui-(bar|body)-([a-z])/)[2] : "c"; var b = this.options.theme ? this.options.theme : e, f = this.options.trackTheme ? this.options.trackTheme : e, h = d[0].nodeName.toLowerCase(); e = h == "select" ? "ui-slider-switch" : ""; var i = d.attr("id"), g = i + "-label"; i = a("[for=" + i + "]").attr("id", g);
        var j = function () { return h == "input" ? parseFloat(d.val()) : d[0].selectedIndex }, m = h == "input" ? parseFloat(d.attr("min")) : 0, p = h == "input" ? parseFloat(d.attr("max")) : d.find("option").length - 1, k = window.parseFloat(d.attr("step") || 1), q = a('<div class="ui-slider ' + e + " ui-btn-down-" + f + ' ui-btn-corner-all" role="application"></div>'), u = a('<a href="#" class="ui-slider-handle"></a>').appendTo(q).buttonMarkup({ corners: true, theme: b, shadow: true }).attr({ role: "slider", "aria-valuemin": m, "aria-valuemax": p, "aria-valuenow": j(),
            "aria-valuetext": j(), title: j(), "aria-labelledby": g
        }); a.extend(this, { slider: q, handle: u, dragging: false, beforeStart: null }); if (h == "select") {
            q.wrapInner('<div class="ui-slider-inneroffset"></div>'); d.find("option"); d.find("option").each(function (r) {
                var y = r == 0 ? "b" : "a", w = r == 0 ? "right" : "left"; r = r == 0 ? " ui-btn-down-" + f : " ui-btn-active"; a('<div class="ui-slider-labelbg ui-slider-labelbg-' + y + r + " ui-btn-corner-" + w + '"></div>').prependTo(q); a('<span class="ui-slider-label ui-slider-label-' + y + r + " ui-btn-corner-" +
w + '" role="img">' + a(this).text() + "</span>").prependTo(u)
            })
        } i.addClass("ui-slider"); d.addClass(h == "input" ? "ui-slider-input" : "ui-slider-switch").change(function () { c.refresh(j(), true) }).keyup(function () { c.refresh(j(), true, true) }).blur(function () { c.refresh(j(), true) }); a(document).bind("vmousemove", function (r) { if (c.dragging) { c.refresh(r); return false } }); q.bind("vmousedown", function (r) { c.dragging = true; if (h === "select") c.beforeStart = d[0].selectedIndex; c.refresh(r); return false }); q.add(document).bind("vmouseup",
function () { if (c.dragging) { c.dragging = false; if (h === "select") { if (c.beforeStart === d[0].selectedIndex) c.refresh(c.beforeStart === 0 ? 1 : 0); var r = j(); r = Math.round(r / (p - m) * 100); u.addClass("ui-slider-handle-snapping").css("left", r + "%").animationComplete(function () { u.removeClass("ui-slider-handle-snapping") }) } return false } }); q.insertAfter(d); this.handle.bind("vmousedown", function () { a(this).focus() }).bind("vclick", false); this.handle.bind("keydown", function (r) {
    var y = j(); if (!c.options.disabled) {
        switch (r.keyCode) {
            case a.mobile.keyCode.HOME: case a.mobile.keyCode.END: case a.mobile.keyCode.PAGE_UP: case a.mobile.keyCode.PAGE_DOWN: case a.mobile.keyCode.UP: case a.mobile.keyCode.RIGHT: case a.mobile.keyCode.DOWN: case a.mobile.keyCode.LEFT: r.preventDefault();
                if (!c._keySliding) { c._keySliding = true; a(this).addClass("ui-state-active") } 
        } switch (r.keyCode) { case a.mobile.keyCode.HOME: c.refresh(m); break; case a.mobile.keyCode.END: c.refresh(p); break; case a.mobile.keyCode.PAGE_UP: case a.mobile.keyCode.UP: case a.mobile.keyCode.RIGHT: c.refresh(y + k); break; case a.mobile.keyCode.PAGE_DOWN: case a.mobile.keyCode.DOWN: case a.mobile.keyCode.LEFT: c.refresh(y - k) } 
    } 
}).keyup(function () { if (c._keySliding) { c._keySliding = false; a(this).removeClass("ui-state-active") } }); this.refresh()
    },
        refresh: function (c, d, e) {
            if (!this.options.disabled) {
                var b = this.element, f = b[0].nodeName.toLowerCase(), h = f === "input" ? parseFloat(b.attr("min")) : 0, i = f === "input" ? parseFloat(b.attr("max")) : b.find("option").length - 1; if (typeof c === "object") { c = c; if (!this.dragging || c.pageX < this.slider.offset().left - 8 || c.pageX > this.slider.offset().left + this.slider.width() + 8) return; c = Math.round((c.pageX - this.slider.offset().left) / this.slider.width() * 100) } else {
                    if (c == null) c = f === "input" ? parseFloat(b.val()) : b[0].selectedIndex; c = (parseFloat(c) -
h) / (i - h) * 100
                } if (!isNaN(c)) {
                    if (c < 0) c = 0; if (c > 100) c = 100; var g = Math.round(c / 100 * (i - h)) + h; if (g < h) g = h; if (g > i) g = i; this.handle.css("left", c + "%"); this.handle.attr({ "aria-valuenow": f === "input" ? g : b.find("option").eq(g).attr("value"), "aria-valuetext": f === "input" ? g : b.find("option").eq(g).text(), title: g }); if (f === "select") g === 0 ? this.slider.addClass("ui-slider-switch-a").removeClass("ui-slider-switch-b") : this.slider.addClass("ui-slider-switch-b").removeClass("ui-slider-switch-a"); if (!e) {
                        if (f === "input") b.val(g); else b[0].selectedIndex =
g; d || b.trigger("change")
                    } 
                } 
            } 
        }, enable: function () { this.element.attr("disabled", false); this.slider.removeClass("ui-disabled").attr("aria-disabled", false); return this._setOption("disabled", false) }, disable: function () { this.element.attr("disabled", true); this.slider.addClass("ui-disabled").attr("aria-disabled", true); return this._setOption("disabled", true) } 
    })
})(jQuery);
(function (a) {
    a.widget("mobile.collapsible", a.mobile.widget, { options: { expandCueText: " click to expand contents", collapseCueText: " click to collapse contents", collapsed: false, heading: ">:header,>legend", theme: null, iconTheme: "d" }, _create: function () {
        var c = this.element, d = this.options, e = c.addClass("ui-collapsible-contain"), b = c.find(d.heading).eq(0), f = e.wrapInner('<div class="ui-collapsible-content"></div>').find(".ui-collapsible-content"); c = c.closest(":jqmData(role='collapsible-set')").addClass("ui-collapsible-set");
        if (b.is("legend")) { b = a('<div role="heading">' + b.html() + "</div>").insertBefore(b); b.next().remove() } b.insertBefore(f); b.addClass("ui-collapsible-heading").append('<span class="ui-collapsible-heading-status"></span>').wrapInner('<a href="#" class="ui-collapsible-heading-toggle"></a>').find("a:eq(0)").buttonMarkup({ shadow: !!!c.length, corners: false, iconPos: "left", icon: "plus", theme: d.theme }).find(".ui-icon").removeAttr("class").buttonMarkup({ shadow: true, corners: true, iconPos: "notext", icon: "plus", theme: d.iconTheme });
        if (c.length) e.jqmData("collapsible-last") && b.find("a:eq(0), .ui-btn-inner").addClass("ui-corner-bottom"); else b.find("a:eq(0)").addClass("ui-corner-all").find(".ui-btn-inner").addClass("ui-corner-all"); e.bind("collapse", function (h) {
            if (!h.isDefaultPrevented()) {
                h.preventDefault(); b.addClass("ui-collapsible-heading-collapsed").find(".ui-collapsible-heading-status").text(d.expandCueText); b.find(".ui-icon").removeClass("ui-icon-minus").addClass("ui-icon-plus"); f.addClass("ui-collapsible-content-collapsed").attr("aria-hidden",
true); e.jqmData("collapsible-last") && b.find("a:eq(0), .ui-btn-inner").addClass("ui-corner-bottom")
            } 
        }).bind("expand", function (h) { if (!h.isDefaultPrevented()) { h.preventDefault(); b.removeClass("ui-collapsible-heading-collapsed").find(".ui-collapsible-heading-status").text(d.collapseCueText); b.find(".ui-icon").removeClass("ui-icon-plus").addClass("ui-icon-minus"); f.removeClass("ui-collapsible-content-collapsed").attr("aria-hidden", false); e.jqmData("collapsible-last") && b.find("a:eq(0), .ui-btn-inner").removeClass("ui-corner-bottom") } }).trigger(d.collapsed ?
"collapse" : "expand"); if (c.length && !c.jqmData("collapsiblebound")) { c.jqmData("collapsiblebound", true).bind("expand", function (h) { a(this).find(".ui-collapsible-contain").not(a(h.target).closest(".ui-collapsible-contain")).not("> .ui-collapsible-contain .ui-collapsible-contain").trigger("collapse") }); c = c.find(":jqmData(role=collapsible)"); c.first().find("a:eq(0)").addClass("ui-corner-top").find(".ui-btn-inner").addClass("ui-corner-top"); c.last().jqmData("collapsible-last", true) } b.bind("vmouseup", function (h) {
    b.is(".ui-collapsible-heading-collapsed") ?
e.trigger("expand") : e.trigger("collapse"); h.preventDefault()
}).bind("vclick", false)
    } 
    })
})(jQuery);
(function (a) {
    a.fn.controlgroup = function (c) {
        return this.each(function () {
            function d(h) { h.removeClass("ui-btn-corner-all ui-shadow").eq(0).addClass(f[0]).end().filter(":last").addClass(f[1]).addClass("ui-controlgroup-last") } var e = a.extend({ direction: a(this).jqmData("type") || "vertical", shadow: false }, c), b = a(this).find(">legend"), f = e.direction == "horizontal" ? ["ui-corner-left", "ui-corner-right"] : ["ui-corner-top", "ui-corner-bottom"]; a(this).find("input:eq(0)").attr("type"); if (b.length) {
                a(this).wrapInner('<div class="ui-controlgroup-controls"></div>');
                a('<div role="heading" class="ui-controlgroup-label">' + b.html() + "</div>").insertBefore(a(this).children(0)); b.remove()
            } a(this).addClass("ui-corner-all ui-controlgroup ui-controlgroup-" + e.direction); d(a(this).find(".ui-btn")); d(a(this).find(".ui-btn-inner")); e.shadow && a(this).addClass("ui-shadow")
        })
    } 
})(jQuery); (function (a) { a.fn.fieldcontain = function () { return this.addClass("ui-field-contain ui-body ui-br") } })(jQuery);
(function (a) {
    a.widget("mobile.listview", a.mobile.widget, { options: { theme: "c", countTheme: "c", headerTheme: "b", dividerTheme: "b", splitIcon: "arrow-r", splitTheme: "b", inset: false }, _create: function () { var c = this.element, d = this.options; c.addClass("ui-listview"); d.inset && c.addClass("ui-listview-inset ui-corner-all ui-shadow"); this._itemApply(c, c); this.refresh(true) }, _itemApply: function (c, d) {
        d.find(".ui-li-count").addClass("ui-btn-up-" + (c.jqmData("counttheme") || this.options.countTheme) + " ui-btn-corner-all"); d.find("h1, h2, h3, h4, h5, h6").addClass("ui-li-heading");
        d.find("p, dl").addClass("ui-li-desc"); c.find("li").find(">img:eq(0), >:first>img:eq(0)").addClass("ui-li-thumb").each(function () { a(this).closest("li").addClass(a(this).is(".ui-li-icon") ? "ui-li-has-icon" : "ui-li-has-thumb") }); var e = d.find(".ui-li-aside"); e.length && e.each(function (b, f) { a(f).prependTo(a(f).parent()) }); a.support.cssPseudoElement || a.nodeName(d[0], "ol")
    }, _removeCorners: function (c) { c.add(c.find(".ui-btn-inner, .ui-li-link-alt, .ui-li-thumb")).removeClass("ui-corner-top ui-corner-bottom ui-corner-br ui-corner-bl ui-corner-tr ui-corner-tl") },
        refresh: function (c) {
            this._createSubPages(); var d = this.options, e = this.element, b = this, f = e.jqmData("dividertheme") || d.dividerTheme, h = e.children("li"), i = a.support.cssPseudoElement || !a.nodeName(e[0], "ol") ? 0 : 1; i && e.find(".ui-li-dec").remove(); h.each(function (g) {
                var j = a(this), m = "ui-li"; if (!(!c && j.hasClass("ui-li"))) {
                    var p = j.jqmData("theme") || d.theme, k = j.find(">a"); if (k.length) {
                        var q = j.jqmData("icon"); j.buttonMarkup({ wrapperEls: "div", shadow: false, corners: false, iconpos: "right", icon: k.length > 1 || q === false ? false :
q || "arrow-r", theme: p
                        }); k.first().addClass("ui-link-inherit"); if (k.length > 1) { m += " ui-li-has-alt"; k = k.last(); q = e.jqmData("splittheme") || k.jqmData("theme") || d.splitTheme; k.appendTo(j).attr("title", k.text()).addClass("ui-li-link-alt").empty().buttonMarkup({ shadow: false, corners: false, theme: p, icon: false, iconpos: false }).find(".ui-btn-inner").append(a("<span>").buttonMarkup({ shadow: true, corners: true, theme: q, iconpos: "notext", icon: e.jqmData("spliticon") || k.jqmData("icon") || d.splitIcon })) } 
                    } else if (j.jqmData("role") ===
"list-divider") { m += " ui-li-divider ui-btn ui-bar-" + f; j.attr("role", "heading"); if (i) i = 1 } else m += " ui-li-static ui-body-" + p; if (d.inset) {
                        if (g === 0) { m += " ui-corner-top"; j.add(j.find(".ui-btn-inner")).find(".ui-li-link-alt").addClass("ui-corner-tr").end().find(".ui-li-thumb").addClass("ui-corner-tl"); j.next().next().length && b._removeCorners(j.next()) } if (g === h.length - 1) {
                            m += " ui-corner-bottom"; j.add(j.find(".ui-btn-inner")).find(".ui-li-link-alt").addClass("ui-corner-br").end().find(".ui-li-thumb").addClass("ui-corner-bl");
                            j.prev().prev().length && b._removeCorners(j.prev())
                        } 
                    } if (i && m.indexOf("ui-li-divider") < 0) (j.is(".ui-li-static:first") ? j : j.find(".ui-link-inherit")).addClass("ui-li-jsnumbering").prepend("<span class='ui-li-dec'>" + i++ + ". </span>"); j.add(j.find(".ui-btn-inner")).addClass(m); c || b._itemApply(e, j)
                } 
            })
        }, _idStringEscape: function (c) { return c.replace(/[^a-zA-Z0-9]/g, "-") }, _createSubPages: function () {
            var c = this.element, d = c.closest(".ui-page"), e = d.jqmData("url"), b = this.options, f = this, h = d.find(":jqmData(role='footer')").jqmData("id");
            a(c.find("li>ul, li>ol").toArray().reverse()).each(function (i) {
                var g = a(this), j = g.parent(), m = a(g.prevAll().toArray().reverse()); m = m.length ? m : a("<span>" + a.trim(j.contents()[0].nodeValue) + "</span>"); var p = m.first().text(); i = e + "&" + a.mobile.subPageUrlKey + "=" + f._idStringEscape(p + " " + i); var k = g.jqmData("theme") || b.theme, q = g.jqmData("counttheme") || c.jqmData("counttheme") || b.countTheme; g.wrap("<div data-" + a.mobile.ns + "role='page'><div data-" + a.mobile.ns + "role='content'></div></div>").parent().before("<div data-" +
a.mobile.ns + "role='header' data-" + a.mobile.ns + "theme='" + b.headerTheme + "'><div class='ui-title'>" + p + "</div></div>").after(h ? a("<div data-" + a.mobile.ns + "role='footer'  data-" + a.mobile.ns + "id='" + h + "'>") : "").parent().attr("data-" + a.mobile.ns + "url", i).attr("data-" + a.mobile.ns + "theme", k).attr("data-" + a.mobile.ns + "count-theme", q).appendTo(a.mobile.pageContainer).page(); g = j.find("a:first"); g.length || (g = a("<a></a>").html(m || p).prependTo(j.empty())); g.attr("href", "#" + i)
            }).listview()
        } 
    })
})(jQuery);
(function (a) {
    a.mobile.listview.prototype.options.filter = false; a.mobile.listview.prototype.options.filterPlaceholder = "Filter items..."; a(":jqmData(role='listview')").live("listviewcreate", function () {
        var c = a(this), d = c.data("listview"); if (d.options.filter) {
            var e = a("<form>", { "class": "ui-listview-filter ui-bar-c", role: "search" }); a("<input>", { placeholder: d.options.filterPlaceholder }).attr("data-" + a.mobile.ns + "type", "search").bind("keyup change", function () {
                var b = this.value.toLowerCase(), f = c.children(); f.show();
                if (b) for (var h = false, i, g = f.length; g >= 0; g--) { i = a(f[g]); if (i.is("li:jqmData(role=list-divider)")) { h || i.hide(); h = false } else if (i.text().toLowerCase().indexOf(b) === -1) i.hide(); else h = true } 
            }).appendTo(e).textinput(); a(this).jqmData("inset") && e.addClass("ui-listview-filter-inset"); e.insertBefore(c)
        } 
    })
})(jQuery);
(function (a) {
    a.widget("mobile.dialog", a.mobile.widget, { options: { closeBtnText: "Close" }, _create: function () {
        this.element.attr("role", "dialog").addClass("ui-page ui-dialog ui-body-a").find(":jqmData(role=header)").addClass("ui-corner-top ui-overlay-shadow").prepend("<a href='#' data-" + a.mobile.ns + "icon='delete' data-" + a.mobile.ns + "rel='back' data-" + a.mobile.ns + "iconpos='notext'>" + this.options.closeBtnText + "</a>").end().find('.ui-content:not([class*="ui-body-"])').addClass("ui-body-c").end().find(".ui-content,:jqmData(role='footer')").last().addClass("ui-corner-bottom ui-overlay-shadow");
        this.element.bind("vclick submit", function (c) { c = c.type == "vclick" ? a(c.target).closest("a") : a(c.target).closest("form"); c.length && !c.jqmData("transition") && c.attr("data-" + a.mobile.ns + "transition", a.mobile.urlHistory.getActive().transition).attr("data-" + a.mobile.ns + "direction", "reverse") })
    }, close: function () { window.history.back() } 
    })
})(jQuery);
(function (a, c) { a.widget("mobile.navbar", a.mobile.widget, { options: { iconpos: "top", grid: null }, _create: function () { var d = this.element, e = d.find("a"), b = e.filter(":jqmData(icon)").length ? this.options.iconpos : c; d.addClass("ui-navbar").attr("role", "navigation").find("ul").grid({ grid: this.options.grid }); b || d.addClass("ui-navbar-noicons"); e.buttonMarkup({ corners: false, shadow: false, iconpos: b }); d.delegate("a", "vclick", function () { e.not(".ui-state-persist").removeClass(a.mobile.activeBtnClass); a(this).addClass(a.mobile.activeBtnClass) }) } }) })(jQuery);
(function (a) { a.fn.grid = function (c) { return this.each(function () { var d = a.extend({ grid: null }, c), e = a(this).children(), b = { solo: 1, a: 2, b: 3, c: 4, d: 5 }; d = d.grid; if (!d) if (e.length <= 5) for (var f in b) { if (b[f] == e.length) d = f } else d = "a"; b = b[d]; a(this).addClass("ui-grid-" + d); e.filter(":nth-child(" + b + "n+1)").addClass("ui-block-a"); b > 1 && e.filter(":nth-child(" + b + "n+2)").addClass("ui-block-b"); b > 2 && e.filter(":nth-child(3n+3)").addClass("ui-block-c"); b > 3 && e.filter(":nth-child(4n+4)").addClass("ui-block-d"); b > 4 && e.filter(":nth-child(5n+5)").addClass("ui-block-e") }) } })(jQuery);
(function (a, c, d) {
    var e = a("html"), b = a("head"), f = a(c); a(c.document).trigger("mobileinit"); if (a.mobile.gradeA()) {
        e.addClass("ui-mobile ui-mobile-rendering"); a.mobile.metaViewportContent && !b.find("meta[name='viewport']").length && a("<meta>", { name: "viewport", content: a.mobile.metaViewportContent }).prependTo(b); var h = a.mobile.loadingMessage ? a("<div class='ui-loader ui-body-a ui-corner-all'><span class='ui-icon ui-icon-loading spin'></span><h1>" + a.mobile.loadingMessage + "</h1></div>") : d; typeof h === "undefined" &&
alert(a.mobile.loadingMessage); a.extend(a.mobile, { pageLoading: function (i) { if (i) e.removeClass("ui-loading"); else { if (a.mobile.loadingMessage) { i = a("." + a.mobile.activeBtnClass).first(); typeof h === "undefined" && alert(a.mobile.loadingMessage); h.appendTo(a.mobile.pageContainer).css({ top: a.support.scrollTop && a(c).scrollTop() + a(c).height() / 2 || i.length && i.offset().top || 100 }) } e.addClass("ui-loading") } }, initializePage: function () {
    var i = a(":jqmData(role='page')"); i.add(":jqmData(role='dialog')").each(function () {
        var g =
a(this); g.jqmData("url") || g.attr("data-" + a.mobile.ns + "url", g.attr("id"))
    }); a.mobile.firstPage = i.first(); a.mobile.pageContainer = i.first().parent().addClass("ui-mobile-viewport"); a.mobile.pageLoading(); !a.mobile.hashListeningEnabled || !a.mobile.path.stripHash(location.hash) ? a.mobile.changePage(a.mobile.firstPage, false, true, false, true) : f.trigger("hashchange", [true])
} 
}); a(a.mobile.initializePage); f.load(a.mobile.silentScroll)
    } 
})(jQuery, this);
