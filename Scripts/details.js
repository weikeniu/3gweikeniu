window["$"] = window.jquip = (function () {
    var bo = window,
    bU = function () {
        return bo.Sizzle || bo.qwery
    },
    b0 = document,
    cc = b0.documentElement,
    b4 = [],
    bT = [],
    bv,
    b6 = /Until$/,
    bn = /,/,
    cp = /^(?:parents|prevUntil|prevAll)/,
    bp = /<([\w:]+)/,
    bq = /[\n\t\r]/g,
    ch = /\s+/,
    a7 = /\d/,
    bH = /\S/,
    bw = /\r\n/g,
    bL = /^<(\w+)\s*\/?>(?:<\/\1>)?$/,
    bE = /\r?\n/g,
    bX = /^(?:select|textarea)/i,
    bK = /^(?:color|date|datetime|datetime-local|email|hidden|month|number|password|range|search|tel|text|time|url|week)$/i,
    b2 = String.prototype.trim,
    bf,
    bQ = /^\s+/,
    cl = /\s+$/,
    a4,
    a0,
    aY = {
        children: true,
        contents: true,
        next: true,
        prev: true
    },
    bz = Object.prototype.toString,
    a9 = {},
    cq = false,
    cg = true,
    ct = {
        option: [1, "<select multiple='multiple'>", "</select>"],
        legend: [1, "<fieldset>", "</fieldset>"],
        thead: [1, "<table>", "</table>"],
        tr: [2, "<table><tbody>", "</tbody></table>"],
        td: [3, "<table><tbody><tr>", "</tr></tbody></table>"],
        col: [2, "<table><tbody></tbody><colgroup>", "</colgroup></table>"],
        area: [1, "<map>", "</map>"],
        _default: [0, "", ""]
    },
    bF = /[,\s.#\[>+]/,
    bY = [],
    cd = {},
    a6 = Array.prototype,
    br = Object.prototype,
    bc = br.hasOwnProperty,
    J = a6.slice,
    bN = a6.push,
    b1 = a6.indexOf,
    bx = a6.forEach,
    bg = a6.filter,
    bM = a6.indexOf;
    if (bH.test("\xA0")) {
        bQ = /^[\s\xA0]+/;
        cl = /[\s\xA0]+$/
    }
    function bi(a, d) {
        var b;
        for (var c = 0, e = a3.length; c < e; c++) {
            if (a3[c].apply(this, arguments)) {
                return this
            }
        }
        if (!a) {
            return this
        }
        if (bs(a)) {
            if (bv) {
                a()
            } else {
                b4.push(a)
            }
            return this
        } else {
            if (bB(a)) {
                return this["make"](a)
            }
        }
        if (a.nodeType || bl(a)) {
            return this["make"]([a])
        }
        if (a == "body" && !d && b0.body) {
            this["context"] = a.context;
            this[0] = b0.body;
            this.length = 1;
            this["selector"] = a;
            return this
        }
        if (a.selector !== undefined) {
            this["context"] = a.context;
            this["selector"] = a.selector;
            return this["make"](a)
        }
        a = be(a) && a.charAt(0) === "<" ? (b = bL.exec(a)) ? (a = [b0.createElement(b[1])]) && aZ(d) ? bb.fn.attr.call(a, d) && a : a : a2(a).childNodes : by(a, d);
        return this["make"](a)
    }
    var a3 = [],
    a1 = {},
    bJ = 0,
    b5 = {
        _id: 0
    },
    cf = {},
    cj;
    function bb(a, b) {
        return new bi(a, b)
    }
    cj = bi.prototype = bb.prototype = bb.fn = {
        constructor: bb,
        selector: "",
        length: 0,
        dm: function (b, g, h) {
            var c = b[0],
            d,
            e,
            a,
            j,
            f;
            if (c) {
                if (this[0]) {
                    if (!(e = c.nodeType === 3 && c)) {
                        d = c && c.parentNode;
                        e = d && d.nodeType === 11 && d.childNodes.length === this.length ? d : a2(c);
                        a = e.firstChild;
                        if (e.childNodes.length === 1) {
                            e = a
                        }
                        if (!a) {
                            return this
                        }
                    }
                    for (f = 0, j = this.length; f < j; f++) {
                        h.call(this[f], e)
                    }
                }
            }
            return this
        },
        ps: function (b, a, d) {
            var c = this.constructor();
            if (bB(b)) {
                bN.apply(c, b)
            } else {
                bO(c, b)
            }
            c.prevObject = this;
            c.context = this.context;
            if (a === "find") {
                c.selector = this["selector"] + (this["selector"] ? " " : "") + d
            } else {
                if (a) {
                    c.selector = this["selector"] + "." + a + "(" + d + ")"
                }
            }
            return c
        }
    };
    cj.make = function (a) {
        bt(this, a);
        return this
    };
    cj.toArray = function () {
        return J.call(this, 0)
    };
    cj.get = function (a) {
        return a == null ? this["toArray"]() : (a < 0 ? this[this.length + a] : this[a])
    };
    cj.add = function (a, d) {
        var b = typeof a == "string" ? bb(a, d) : a5(a && a.nodeType ? [a] : a),
        c = bO(this.get(), b);
        return this.ps(bj(b[0]) || bj(c[0]) ? c : ci(c))
    };
    function bj(a) {
        return !a || !a.parentNode || a.parentNode.nodeType == 11
    }
    cj.each = function (a) {
        if (!bs(a)) {
            return this
        }
        for (var b = 0, c = this.length; b < c; b++) {
            a.call(this[b], b, this[b])
        }
        return this
    };
    cj.attr = function (c, a) {
        var b = this[0];
        return (be(c) && a === undefined) ? cv(b, c) : this["each"](function (f) {
            var e = this.nodeType;
            if (e !== 3 && e !== 8 && e !== 2) {
                if (bm(c)) {
                    for (var d in c) {
                        if (a === null) {
                            this.removeAttribute(c)
                        } else {
                            this.setAttribute(d, c[d])
                        }
                    }
                } else {
                    this.setAttribute(c, bs(a) ? a.call(this, f, this.getAttribute(c)) : a)
                }
            }
        })
    };
    cj.removeAttr = function (a) {
        return this["each"](function () {
            this.removeAttribute(a)
        })
    };
    cj.data = function (b, a) {
        return co(this[0], b, a)
    };
    cj.append = function () {
        return this.dm(arguments, true,
        function (a) {
            if (this.nodeType === 1) {
                this.appendChild(a)
            }
        })
    };
    cj.prepend = function () {
        return this.dm(arguments, true,
        function (a) {
            if (this.nodeType === 1) {
                this.insertBefore(a, this.firstChild)
            }
        })
    };
    cj.before = function () {
        return this.dm(arguments, false,
        function (a) {
            this.parentNode.insertBefore(a, this)
        })
    };
    cj.after = function () {
        if (this[0] && this[0].parentNode) {
            return this.dm(arguments, false,
            function (a) {
                this.parentNode.insertBefore(a, this.nextSibling)
            })
        }
        return this
    };
    cj.hide = function () {
        return this["each"](function () {
            b3(this, "display", this.style.display);
            this.style.display = "none"
        })
    };
    cj.show = function () {
        return this["each"](function () {
            this.style.display = b3(this, "display") || bP(this.tagName)
        })
    };
    cj.toggle = function () {
        return this["each"](function () {
            this.style.display = bb.Expr.hidden(this) ? b3(this, "display") || bP(this.tagName) : (b3(this, "display", this.style.display), "none")
        })
    };
    cj.eq = function (a) {
        return a === -1 ? this.slice(a) : this.slice(a, +a + 1)
    };
    cj.first = function () {
        return this["eq"](0)
    };
    cj.last = function () {
        return this["eq"](-1)
    };
    cj.slice = function () {
        return this.ps(J.apply(this, arguments), "slice", J.call(arguments).join(","))
    };
    cj.map = function (a) {
        return this.ps(cu(this,
        function (b, c) {
            return a.call(b, c, b)
        }))
    };
    cj.find = function (c) {
        var e = this,
        a,
        g;
        if (!be(c)) {
            return bb(c).filter(function () {
                for (a = 0, g = e.length; a < g; a++) {
                    if (a4(e[a], this)) {
                        return true
                    }
                }
            })
        }
        var f = this.ps("", "find", c),
        h,
        d,
        b;
        for (a = 0, g = this.length; a < g; a++) {
            h = f.length;
            bO(f, bb(c, this[a]));
            if (a == 0) {
                for (d = h; d < f.length; d++) {
                    for (b = 0; b < h; b++) {
                        if (f[b] === f[d]) {
                            f.splice(d--, 1);
                            break
                        }
                    }
                }
            }
        }
        return f
    };
    cj.not = function (a) {
        return this.ps(a8(this, a, false), "not", a)
    };
    cj.filter = function (a) {
        return this.ps(a8(this, a, true), "filter", a)
    };
    cj.indexOf = function (a) {
        return b8(this, a)
    };
    cj.is = function (a) {
        return this.length > 0 && bb(this[0]).filter(a).length > 0
    };
    cj.remove = function () {
        for (var b = 0, a; (a = this[b]) != null; b++) {
            if (a.parentNode) {
                a.parentNode.removeChild(a)
            }
        }
        return this
    };
    cj.closest = function (b, d) {
        var c = [],
        a;
        for (a = 0, l = this.length; a < l; a++) {
            cur = this[a];
            while (cur) {
                if (bS(b, [cur]).length > 0) {
                    c.push(cur);
                    break
                } else {
                    cur = cur.parentNode;
                    if (!cur || !cur.ownerDocument || cur === d || cur.nodeType === 11) {
                        break
                    }
                }
            }
        }
        c = c.length > 1 ? ci(c) : c;
        return this.ps(c, "closest", b)
    };
    cj.val = function (a) {
        if (a == null) {
            return (this[0] && this[0].value) || ""
        }
        return this["each"](function () {
            this.value = a
        })
    };
    cj.html = function (a) {
        if (a == null) {
            return (this[0] && this[0].innerHTML) || ""
        }
        return this["each"](function () {
            this.innerHTML = a
        })
    };
    cj.text = function (a) {
        var b = this[0],
        c;
        return typeof a == "undefined" ? (b && (c = b.nodeType) ? ((c === 1 || c === 9) ? (typeof b.textContent == "string" ? b.textContent : b.innerText.replace(bw, "")) : (c === 3 || c === 4) ? b.nodeValue : null) : null) : this["empty"]()["append"]((b && b.ownerDocument || b0).createTextNode(a))
    };
    cj.empty = function () {
        for (var b = 0, a; (a = this[b]) != null; b++) {
            while (a.firstChild) {
                a.removeChild(a.firstChild)
            }
        }
        return this
    };
    cj.addClass = function (c) {
        var e,
        f,
        g,
        a,
        b,
        d,
        h;
        if (bs(c)) {
            return this["each"](function (j) {
                bb(this)["addClass"](c.call(this, j, this.className))
            })
        }
        if (c && be(c)) {
            e = c.split(ch);
            for (f = 0, g = this.length; f < g; f++) {
                a = this[f];
                if (a && a.nodeType === 1) {
                    if (!a.className && e.length === 1) {
                        a.className = c
                    } else {
                        b = " " + a.className + " ";
                        for (d = 0, h = e.length; d < h; d++) {
                            if (! ~b.indexOf(" " + e[d] + " ")) {
                                b += e[d] + " "
                            }
                        }
                        a.className = bf(b)
                    }
                }
            }
        }
        return this
    };
    cj.removeClass = function (c) {
        var f,
        a,
        e,
        b,
        g,
        d,
        h;
        if (bs(c)) {
            return this["each"](function (j) {
                bb(this)["removeClass"](c.call(this, j, this.className))
            })
        }
        if ((c && be(c)) || c === undefined) {
            f = (c || "").split(ch);
            for (a = 0, e = this.length; a < e; a++) {
                b = this[a];
                if (b.nodeType === 1 && b.className) {
                    if (c) {
                        g = (" " + b.className + " ").replace(bq, " ");
                        for (d = 0, h = f.length; d < h; d++) {
                            g = g.replace(" " + f[d] + " ", " ")
                        }
                        b.className = bf(g)
                    } else {
                        b.className = ""
                    }
                }
            }
        }
        return this
    };
    cj.hasClass = function (a) {
        return bI(this, a)
    };
    cj.serializeArray = function () {
        return this["map"](function () {
            return this.elements ? a5(this.elements) : this
        }).filter(function () {
            return this.name && !this.disabled && (this.checked || bX.test(this.nodeName) || bK.test(this.type))
        }).map(function (c, b) {
            var a = bb(this)["val"]();
            return a == null || bB(a) ? cu(a,
            function (d) {
                return {
                    name: b.name,
                    value: d.replace(bE, "\r\n")
                }
            }) : {
                name: b.name,
                value: a.replace(bE, "\r\n")
            }
        }).get()
    };
    bb.Expr = {
        hidden: function (a) {
            return a.offsetWidth === 0 || a.offsetHeight == 0 || ((bb.css && bb.css(a, "display") || a.style.display) === "none")
        },
        visible: function (a) {
            return !bb.Expr.hidden(a)
        }
    };
    function a8(c, a, d) {
        a = a || 0;
        if (bs(a)) {
            return bZ(c,
            function (f, e) {
                return !!a.call(f, e, f) === d
            })
        } else {
            if (a.nodeType) {
                return bZ(c,
                function (e) {
                    return (e === a) === d
                })
            } else {
                if (be(a)) {
                    var b = a.charAt(0) == ":" && bb.Expr[a.substring(1)];
                    return bZ(c,
                    function (e) {
                        return b ? b(e) : e.parentNode && b8(by(a, e.parentNode), e) >= 0
                    })
                }
            }
        }
        return bZ(c,
        function (e) {
            return (b8(a, e) >= 0) === d
        })
    }
    function b3(c, d, a) {
        var b = bb.data(c, "_J");
        if (typeof a === "undefined") {
            return b && b5[b] && b5[b][d]
        }
        if (!b) {
            bb.data(c, "_J", (b = ++b5.id))
        }
        return (b5[b] || (b5[b] = {}))[d] = a
    }
    function bP(c) {
        if (!cf[c]) {
            var b = bb("<" + c + ">")["appendTo"](b0.body),
            a = (bb.css && bb.css(b[0], "display")) || b[0].style.display;
            b.remove();
            cf[c] = a
        }
        return cf[c]
    }
    function bt(d, b) {
        d.length = (b && b.length || 0);
        if (d.length == 0) {
            return d
        }
        for (var a = 0, c = b.length; a < c; a++) {
            d[a] = b[a]
        }
        return d
    }
    function bI(b, c) {
        var c = " " + c + " ";
        for (var a = 0, d = b.length; a < d; a++) {
            if (cr(b[a], c)) {
                return true
            }
        }
        return false
    }
    bb.hasClass = bI;
    function cr(a, b) {
        return a.nodeType === 1 && (" " + a.className + " ").replace(bq, " ").indexOf(b) > -1
    }
    function bC(b, f, d) {
        f = f || b0;
        d = d || [];
        if (f.nodeType == 1) {
            if (b(f)) {
                d.push(f)
            }
        }
        var a = f.childNodes;
        for (var e = 0, g = a.length; e < g; e++) {
            var c = a[e];
            if (c.nodeType == 1) {
                bC(b, c, d)
            }
        }
        return d
    }
    bb.walk = bC;
    function by(c, g, b) {
        if (c && be(c)) {
            if (g instanceof bb) {
                g = g[0]
            }
            g = g || b0;
            b = b || bb.query;
            var a = c.charAt(0),
            h = c.substring(1),
            f = bF.test(h),
            e;
            try {
                if (f) {
                    return J.call(b(c, g))
                }
                return f ? J.call(b(c, g)) : (a == "#" ? ((e = b0.getElementById(h)) ? [e] : bY) : a5(a == "." ? (g.getElementsByClassName ? g.getElementsByClassName(h) : b(c, g)) : g.getElementsByTagName(c)))
            } catch (d) {
                bG(d)
            }
        }
        return c.nodeType == 1 || c.nodeType == 9 ? [c] : bY
    }
    bb["$$"] = by;
    bb.setQuery = function (a) {
        bb.query = function (b, c) {
            return by(b, c, (a ||
            function (d, e) {
                return e.querySelectorAll(d)
            }))
        }
    };
    var ca = bU();
    bb.setQuery(ca ||
    function (a, b) {
        return b0.querySelectorAll ? a5((b || b0).querySelectorAll(a)) : []
    });
    function bd(c, f, b) {
        var a = b0.head || b0.getElementsByTagName("head")[0] || cc,
        d = b0.createElement("script"),
        e;
        if (b) {
            d.async = "async"
        }
        d.onreadystatechange = function () {
            if (!(e = d.readyState) || e == "loaded" || e == "complete") {
                d.onload = d.onreadystatechange = null;
                if (a && d.parentNode) {
                    a.removeChild(d)
                }
                d = undefined;
                if (f) {
                    f()
                }
            }
        };
        d.onload = f;
        d.src = c;
        a.insertBefore(d, a.firstChild)
    }
    bb.loadScript = bd;
    function bG(a) {
        bo.console && bo.console.warn(arguments)
    }
    bb.each = function (c, g, a) {
        var d,
        b = 0,
        f = c.length,
        e = f === undefined || bs(c);
        if (a) {
            if (e) {
                for (d in c) {
                    if (g.apply(c[d], a) === false) {
                        break
                    }
                }
            } else {
                for (; b < f; ) {
                    if (g.apply(c[b++], a) === false) {
                        break
                    }
                }
            }
        } else {
            if (e) {
                for (d in c) {
                    if (g.call(c[d], d, c[d]) === false) {
                        break
                    }
                }
            } else {
                for (; b < f; ) {
                    if (g.call(c[b], b, c[b++]) === false) {
                        break
                    }
                }
            }
        }
        return c
    };
    function bV(b, a, e) {
        if (b == null) {
            return
        }
        if (bx && b.forEach === bx) {
            b.forEach(a, e)
        } else {
            if (b.length === +b.length) {
                for (var d = 0, f = b.length; d < f; d++) {
                    if (d in b && a.call(e, b[d], d, b) === cd) {
                        return
                    }
                }
            } else {
                for (var c in b) {
                    if (bc.call(b, c)) {
                        if (a.call(e, b[c], c, b) === cd) {
                            return
                        }
                    }
                }
            }
        }
    }
    bb._each = bV;
    function cv(a, b) {
        return (a && a.nodeName === "INPUT" && a.type === "text" && b === "value") ? a.value : (a ? (a.getAttribute(b) || (b in a ? a[b] : undefined)) : null)
    }
    var bA = [/#((?:[\w\u00c0-\uFFFF\-]|\\.)+)/, /^((?:[\w\u00c0-\uFFFF\*\-]|\\.)+)/, /\.((?:[\w\u00c0-\uFFFF\-]|\\.)+)/, /\[\s*((?:[\w\u00c0-\uFFFF\-]|\\.)+)\s*(?:(\S?=)\s*(?:(['"])(.*?)\3|(#?(?:[\w\u00c0-\uFFFF\-]|\\.)*)|)|)\s*\]/];
    function bS(d, b) {
        var f = [],
        a,
        e,
        g,
        c,
        h;
        for (a = 0, g = bA.length; a < g; a++) {
            if (h = bA[a].exec(d)) {
                break
            }
        }
        if (a < bA.length) {
            for (e = 0; (c = b[e]); e++) {
                if ((a == 0 && h[1] == c.id) || (a == 1 && cs(h[1], c.tagName)) || (a == 2 && cr(c, h[1])) || (a == 3 && h[2] == cv(c, h[1]))) {
                    f.push(c)
                }
            }
        } else {
            bG(d + " not supported")
        }
        return f
    }
    bb.filter = bS;
    function b8(d, b) {
        if (d == null) {
            return -1
        }
        var a,
        c;
        if (bM && d.indexOf === bM) {
            return d.indexOf(b)
        }
        for (a = 0, c = d.length; a < c; a++) {
            if (d[a] === b) {
                return a
            }
        }
        return -1
    }
    bb._indexOf = b8;
    bb._defaults = function (a) {
        bV(J.call(arguments, 1),
        function (b) {
            for (var c in b) {
                if (a[c] == null) {
                    a[c] = b[c]
                }
            }
        });
        return a
    };
    function cb(b, a, d) {
        var c = [];
        if (b == null) {
            return c
        }
        if (bg && b.filter === bg) {
            return b.filter(a, d)
        }
        bV(b,
        function (g, f, e) {
            if (a.call(d, g, f, e)) {
                c[c.length] = g
            }
        });
        return c
    }
    bb._filter = cb;
    bb.proxy = function (a, e) {
        if (typeof e == "string") {
            var c = a[e];
            e = a;
            a = c
        }
        if (bs(a)) {
            var d = J.call(arguments, 2),
            b = function () {
                return a.apply(e, d.concat(J.call(arguments)))
            };
            b.guid = a.guid = a.guid || b.guid || bJ++;
            return b
        }
    };
    function cm(b, d, a) {
        var e = [],
        c = b[d];
        while (c && c.nodeType !== 9 && (a === undefined || c.nodeType !== 1 || !bb(c).is(a))) {
            if (c.nodeType === 1) {
                e.push(c)
            }
            c = c[d]
        }
        return e
    }
    bb.dir = cm;
    function b7(b, a, c) {
        a = a || 1;
        var d = 0;
        for (; b; b = b[c]) {
            if (b.nodeType === 1 && ++d === a) {
                break
            }
        }
        return b
    }
    bb.nth = b7;
    function ba(a, c) {
        var b = [];
        for (; a; a = a.nextSibling) {
            if (a.nodeType === 1 && a !== c) {
                b.push(a)
            }
        }
        return b
    }
    bb.sibling = ba;
    function bZ(b, f, g) {
        var e = [],
        c;
        g = !!g;
        for (var a = 0, d = b.length; a < d; a++) {
            c = !!f(b[a], a);
            if (g !== c) {
                e.push(b[a])
            }
        }
        return e
    }
    bb.grep = bZ;
    function cu(f, h, e) {
        var c,
        d,
        b = [],
        g = 0,
        j = f.length,
        a = f instanceof bb || typeof j == "number" && ((j > 0 && f[0] && f[j - 1]) || j === 0 || bB(f));
        if (a) {
            for (; g < j; g++) {
                c = h(f[g], g, e);
                if (c != null) {
                    b[b.length] = c
                }
            }
        } else {
            for (d in f) {
                c = h(f[d], d, e);
                if (c != null) {
                    b[b.length] = c
                }
            }
        }
        return b.concat.apply([], b)
    }
    bb.map = cu;
    function co(c, d, a) {
        if (!c) {
            return {}
        }
        if (d && a) {
            c.setAttribute(d, a);
            return null
        }
        var b = {};
        bV(p(c),
        function (e, f) {
            if (f.indexOf("data-") !== 0 || !e) {
                return
            }
            b[f.substr("data-".length)] = e
        });
        if (be(d)) {
            return b[d]
        }
        return b
    }
    bb.data = co;
    function p(c) {
        var a = {};
        for (var b = 0, d = c.attributes, e = d.length; b < e; b++) {
            a[d.item(b).nodeName] = d.item(b).nodeValue
        }
        return a
    }
    bb.attrs = p;
    function cs(a, b) {
        return !a || !b ? a == b : a.toLowerCase() === b.toLowerCase()
    }
    bb.eqSI = cs;
    bb.trim = bf = b2 ?
    function (a) {
        return a == null ? "" : b2.call(a)
    } : function (a) {
        return a == null ? "" : a.toString().replace(bQ, "").replace(cl, "")
    };
    bb.indexOf = bb.inArray = function (a, d) {
        if (!d) {
            return -1
        }
        if (b1) {
            return b1.call(d, a)
        }
        for (var c = 0, b = d.length; c < b; c++) {
            if (d[c] === a) {
                return c
            }
        }
        return -1
    };
    bV("Boolean Number String Function Array Date RegExp Object".split(" "),
    function (a) {
        a9["[object " + a + "]"] = a.toLowerCase();
        return this
    });
    function bD(a) {
        return a == null ? String(a) : a9[bz.call(a)] || "object"
    }
    bb.type = bD;
    function be(a) {
        return typeof a == "string"
    }
    function bm(a) {
        return typeof a == "object"
    }
    function bs(a) {
        return typeof a == "function" || bD(a) === "function"
    }
    bb.isFunction = bs;
    function bB(a) {
        return bD(a) === "array"
    }
    bb.isArray = Array.isArray || bB;
    function ce(a) {
        return !be(a) && typeof a.length == "number"
    }
    function bl(a) {
        return a && typeof a == "object" && "setInterval" in a
    }
    bb.isWindow = bl;
    function cn(a) {
        return a == null || !a7.test(a) || isNaN(a)
    }
    bb.isNaN = cn;
    function aZ(a) {
        if (!a || bD(a) !== "object" || a.nodeType || bl(a)) {
            return false
        }
        try {
            if (a.constructor && !bc.call(a, "constructor") && !bc.call(a.constructor.prototype, "isPrototypeOf")) {
                return false
            }
        } catch (b) {
            return false
        }
        var c;
        for (c in a) { }
        return c === undefined || bc.call(a, c)
    }
    function bO(b, e) {
        var a = b.length,
        c = 0;
        if (typeof e.length == "number") {
            for (var d = e.length; c < d; c++) {
                b[a++] = e[c]
            }
        } else {
            while (e[c] !== undefined) {
                b[a++] = e[c++]
            }
        }
        b.length = a;
        return b
    }
    bb.merge = bO;
    function bk() {
        var j,
        h,
        m,
        k,
        g,
        d,
        c = arguments,
        e = c[0] || {},
        b = 1,
        a = c.length,
        f = false;
        if (typeof e == "boolean") {
            f = e;
            e = c[1] || {};
            b = 2
        }
        if (typeof e != "object" && !bs(e)) {
            e = {}
        }
        if (a === b) {
            e = this; --b
        }
        for (; b < a; b++) {
            if ((j = c[b]) != null) {
                for (h in j) {
                    m = e[h];
                    k = j[h];
                    if (e === k) {
                        continue
                    }
                    if (f && k && (aZ(k) || (g = bB(k)))) {
                        if (g) {
                            g = false;
                            d = m && bB(m) ? m : []
                        } else {
                            d = m && aZ(m) ? m : {}
                        }
                        e[h] = bk(f, d, k)
                    } else {
                        if (k !== undefined) {
                            e[h] = k
                        }
                    }
                }
            }
        }
        return e
    }
    bb.extend = bb.fn.extend = bk;
    function a5(d, a) {
        var c = a || [];
        if (d != null) {
            var b = bD(d);
            if (d.length == null || b == "string" || b == "function" || b === "regexp" || bl(d)) {
                bN.call(c, d)
            } else {
                bO(c, d)
            }
        }
        return c
    }
    bb.makeArray = a5;
    function a2(c, d, b) {
        d = ((d || b0) || d.ownerDocument || d[0] && d[0].ownerDocument || b0);
        b = b || d.createDocumentFragment();
        if (ce(c)) {
            return bu(c, d, b) && b
        }
        var a = ck(c);
        while (a.firstChild) {
            b.appendChild(a.firstChild)
        }
        return b
    }
    bb.htmlFrag = a2;
    function ck(c, e) {
        var b = (e || b0).createElement("div"),
        f = (bp.exec(c) || ["", ""])[1].toLowerCase(),
        d = ct[f] || ct._default,
        a = d[0];
        b.innerHTML = d[1] + c + d[2];
        while (a--) {
            b = b.lastChild
        }
        return b
    }
    function bu(d, f, b) {
        var e = [],
        c,
        a;
        for (c = 0; (a = d[c]) != null; c++) {
            if (be(a)) {
                a = ck(a, f)
            }
            if (a.nodeType) {
                e.push(a)
            } else {
                e = bO(e, a)
            }
        }
        if (b) {
            for (c = 0; c < e.length; c++) {
                if (e[c].nodeType) {
                    b.appendChild(e[c])
                }
            }
        }
        return e
    }
    var b9 = function (c, d, a) {
        if (c === d) {
            return a
        }
        var b = c.nextSibling;
        while (b) {
            if (b === d) {
                return -1
            }
            b = b.nextSibling
        }
        return 1
    };
    a4 = bb.contains = cc.contains ?
    function (a, b) {
        return a !== b && (a.contains ? a.contains(b) : true)
    } : function () {
        return false
    };
    a0 = cc.compareDocumentPosition ? (a4 = function (a, b) {
        return !!(a.compareDocumentPosition(b) & 16)
    }) &&
    function (a, b) {
        if (a === b) {
            cq = true;
            return 0
        }
        if (!a.compareDocumentPosition || !b.compareDocumentPosition) {
            return a.compareDocumentPosition ? -1 : 1
        }
        return a.compareDocumentPosition(b) & 4 ? -1 : 1
    } : function (e, d) {
        if (e === d) {
            cq = true;
            return 0
        } else {
            if (e.sourceIndex && d.sourceIndex) {
                return e.sourceIndex - d.sourceIndex
            }
        }
        var b,
        j,
        g = [],
        k = [],
        a = e.parentNode,
        c = d.parentNode,
        f = a;
        if (a === c) {
            return b9(e, d)
        } else {
            if (!a) {
                return -1
            } else {
                if (!c) {
                    return 1
                }
            }
        }
        while (f) {
            g.unshift(f);
            f = f.parentNode
        }
        f = c;
        while (f) {
            k.unshift(f);
            f = f.parentNode
        }
        b = g.length;
        j = k.length;
        for (var h = 0; h < b && h < j; h++) {
            if (g[h] !== k[h]) {
                return b9(g[h], k[h])
            }
        }
        return h === b ? b9(e, k[h], -1) : b9(g[h], d, 1)
    };
    function ci(a) {
        if (a0) {
            cq = cg;
            a.sort(a0);
            if (cq) {
                for (var b = 1; b < a.length; b++) {
                    if (a[b] === a[b - 1]) {
                        a.splice(b--, 1)
                    }
                }
            }
        }
        return a
    }
    bb.unique = ci;
    bV({
        parent: function (a) {
            var b = a.parentNode;
            return b && b.nodeType !== 11 ? b : null
        },
        parents: function (a) {
            return cm(a, "parentNode")
        },
        parentsUntil: function (b, c, a) {
            return cm(b, "parentNode", a)
        },
        next: function (a) {
            return b7(a, 2, "nextSibling")
        },
        prev: function (a) {
            return b7(a, 2, "previousSibling")
        },
        nextAll: function (a) {
            return cm(a, "nextSibling")
        },
        prevAll: function (a) {
            return cm(a, "previousSibling")
        },
        nextUntil: function (b, c, a) {
            return cm(b, "nextSibling", a)
        },
        prevUntil: function (b, c, a) {
            return cm(b, "previousSibling", a)
        },
        siblings: function (a) {
            return ba(a.parentNode.firstChild, a)
        },
        children: function (a) {
            return ba(a.firstChild)
        },
        contents: function (a) {
            return a.nodeName === "iframe" ? a.contentDocument || a.contentWindow["document "] : a5(a.childNodes)
        }
    },
    function (a, b) {
        bb.fn[b] = function (d, c) {
            var f = cu(this, a, d),
            e = J.call(arguments);
            if (!b6.test(b)) {
                c = d
            }
            if (typeof c == "string") {
                f = bS(c, f)
            }
            f = this.length > 1 && !aY[b] ? ci(f) : f;
            if ((this.length > 1 || bn.test(c)) && cp.test(b)) {
                f = f.reverse()
            }
            return this.ps(f, b, e.join(","))
        }
    });
    bV({
        appendTo: "append",
        prependTo: "prepend",
        insertBefore: "before",
        insertAfter: "after"
    },
    function (a, b) {
        bb.fn[b] = function (e) {
            var j = [],
            g = bb(e),
            d,
            c,
            h,
            f = this.length === 1 && this[0].parentNode;
            if (f && f.nodeType === 11 && f.childNodes.length === 1 && g.length === 1) {
                g[a](this[0]);
                return this
            } else {
                for (d = 0, h = g.length; d < h; d++) {
                    c = (d > 0 ? this.clone(true) : this).get();
                    bb(g[d])[a](c);
                    j = j.concat(c)
                }
                return this.ps(j, b, g.selector)
            }
        }
    });
    function bh() {
        if (!b0.body) {
            return null
        }
        var a = b0.createElement("div");
        b0.body.appendChild(a);
        a.style.width = "20px";
        a.style.padding = "10px";
        var b = a.offsetWidth;
        b0.body.removeChild(a);
        return b == 40
    } (function () {
        var j = document.createElement("div");
        j.style.display = "none";
        j.innerHTML = "   <link/><table></table><a href='/a' style='color:red;float:left;opacity:.55;'>a</a><input type='checkbox'/>";
        var e = j.getElementsByTagName("a")[0];
        bb.support = {
            boxModel: null,
            opacity: /^0.55$/.test(e.style.opacity),
            cssFloat: !!e.style.cssFloat
        };
        var b = /(webkit)[ \/]([\w.]+)/,
        f = /(opera)(?:.*version)?[ \/]([\w.]+)/,
        d = /(msie) ([\w.]+)/,
        a = /(mozilla)(?:.*? rv:([\w.]+))?/,
        h = navigator.userAgent.toLowerCase(),
        g = b.exec(h) || f.exec(h) || d.exec(h) || h.indexOf("compatible") < 0 && a.exec(h) || [],
        c;
        c = bb.browser = {
            version: g[2] || "0"
        };
        c[g[1] || ""] = true
    })();
    bb.scriptsLoaded = function (a) {
        if (bs(a)) {
            b4.push(a)
        }
    };
    function bW(a, b) {
        bT.push({
            url: a,
            cb: b
        })
    }
    bb.loadAsync = bW;
    function bR() {
        bV(b4,
        function (a) {
            a()
        });
        bv = true
    }
    bb.init = false;
    bb.onload = function () {
        if (!bb.init) {
            try {
                bb.support.boxModel = bh();
                var b = 0;
                bV(bT,
                function (c) {
                    b++;
                    bd(c.url,
                    function () {
                        try {
                            if (c.cb) {
                                c.cb()
                            }
                        } catch (d) { }
                        if (! --b) {
                            bR()
                        }
                    })
                });
                bb.init = true;
                if (!b) {
                    bR()
                }
            } catch (a) {
                bG(a)
            }
        }
    };
    if (b0.body && !bb.init) {
        setTimeout(bb.onload, 1)
    }
    bb.hook = function (a) {
        a3.push(a)
    };
    bb.plug = function (a, b) {
        var c = be(a) ? a : a.name;
        b = bs(a) ? a : b;
        if (!bs(b)) {
            throw "Plugin fn required"
        }
        if (c && b) {
            a1[c] = b
        }
        b(bb)
    };
    return bb
})();
$.plug("ajax",
function ($) {
    var xhrs = [function () {
        return new XMLHttpRequest()
    },
    function () {
        return new ActiveXObject("Microsoft.XMLHTTP")
    },
    function () {
        return new ActiveXObject("MSXML2.XMLHTTP.3.0")
    },
    function () {
        return new ActiveXObject("MSXML2.XMLHTTP")
    } ],
    _xhrf = null;
    function _xhr() {
        if (_xhrf != null) {
            return _xhrf()
        }
        for (var i = 0, l = xhrs.length; i < l; i++) {
            try {
                var f = xhrs[i],
                req = f();
                if (req != null) {
                    _xhrf = f;
                    return req
                }
            } catch (e) { }
        }
        return function () { }
    }
    $.xhr = _xhr;
    function _xhrResp(xhr, dataType) {
        dataType = (dataType || xhr.getResponseHeader("Content-Type").split(";")[0]).toLowerCase();
        if (dataType.indexOf("json") >= 0) {
            return window.JSON ? window.JSON.parse(xhr.responseText) : eval(xhr.responseText)
        }
        if (dataType.indexOf("script") >= 0) {
            return eval(xhr.responseText)
        }
        if (dataType.indexOf("xml") >= 0) {
            return xhr.responseXML
        }
        return xhr.responseText
    }
    $._xhrResp = _xhrResp;
    $.formData = function formData(o) {
        var kvps = [],
        regEx = /%20/g;
        for (var k in o) {
            kvps.push(encodeURIComponent(k).replace(regEx, "+") + "=" + encodeURIComponent(o[k].toString()).replace(regEx, "+"))
        }
        return kvps.join("&")
    };
    $.each("ajaxStart ajaxStop ajaxComplete ajaxError ajaxSuccess ajaxSend".split(" "),
    function (i, o) {
        $.fn[o] = function (f) {
            return this["bind"](o, f)
        }
    });
    function ajax(url, o) {
        var xhr = _xhr(),
        timer,
        n = 0;
        if (typeof url === "object") {
            o = url
        } else {
            o.url = url
        }
        o = $._defaults(o, {
            userAgent: "XMLHttpRequest",
            lang: "en",
            type: "GET",
            data: null,
            contentType: "application/x-www-form-urlencoded",
            dataType: null,
            processData: true,
            headers: {
                "X-Requested-With": "XMLHttpRequest"
            }
        });
        if (o.timeout) {
            timer = setTimeout(function () {
                xhr.abort();
                if (o.timeoutFn) {
                    o.timeoutFn(o.url)
                }
            },
            o.timeout)
        }
        var cbCtx = $(o.context || document),
        evtCtx = cbCtx;
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4) {
                if (timer) {
                    clearTimeout(timer)
                }
                if (xhr.status < 300) {
                    var res = _xhrResp(xhr, o.dataType);
                    if (o.success) {
                        o.success(res)
                    }
                    evtCtx.trigger("ajaxSuccess", [xhr, res, o])
                } else {
                    if (o.error) {
                        o.error(xhr, xhr.status, xhr.statusText)
                    }
                    evtCtx.trigger(cbCtx, "ajaxError", [xhr, xhr.statusText, o])
                }
                if (o.complete) {
                    o.complete(xhr, xhr.statusText)
                }
                evtCtx.trigger(cbCtx, "ajaxComplete", [xhr, o])
            } else {
                if (o.progress) {
                    o.progress(++n)
                }
            }
        };
        var url = o.url,
        data = null;
        var isPost = o.type == "POST" || o.type == "PUT";
        if (o.data && o.processData && typeof o.data == "object") {
            data = $.formData(o.data)
        }
        if (!isPost && data) {
            url += "?" + data
        }
        xhr.open(o.type, url);
        try {
            for (var i in o.headers) {
                xhr.setRequestHeader(i, o.headers[i])
            }
        } catch (_) {
            console.log(_)
        }
        if (isPost) {
            xhr.setRequestHeader("Content-Type", o.contentType)
        }
        xhr.send(data)
    }
    $.ajax = ajax;
    $.getJSON = function (url, data, success, error) {
        if ($.isFunction(data)) {
            error = success;
            success = data;
            data = null
        }
        ajax({
            url: url,
            data: data,
            success: success,
            dataType: "json"
        })
    };
    $.get = function (url, data, success, dataType) {
        if ($.isFunction(data)) {
            dataType = success;
            success = data;
            data = null
        }
        ajax({
            url: url,
            type: "GET",
            data: data,
            success: success,
            dataType: dataType || "text/plain"
        })
    };
    $.post = function (url, data, success, dataType) {
        if ($.isFunction(data)) {
            dataType = success;
            success = data;
            data = null
        }
        ajax({
            url: url,
            type: "POST",
            data: data,
            success: success,
            dataType: dataType || "text/plain"
        })
    };
    $.getScript = function (script, callback) {
        $.loadScript(script, callback, true)
    };
    if (!window.JSON) {
        $.loadAsync("http://ajax.cdnjs.com/ajax/libs/json2/20110223/json2.js")
    }
});
$.plug("css",
function (X) {
    var U = document,
    R = U.documentElement,
    Y = /alpha\([^)]*\)/i,
    N = /opacity=([^)]*)/,
    ac = /-([a-z])/ig,
    I = /([A-Z])/g,
    P = /^-?\d+(?:px)?$/i,
    aa = /^-?\d/,
    J = /^(?:body|html)$/i,
    ab = {
        position: "absolute",
        visibility: "hidden",
        display: "block"
    },
    af = ["Left", "Right"],
    ai = ["Top", "Bottom"],
    K,
    ak,
    ae,
    O = function (b, a) {
        return a.toUpperCase()
    };
    X.cssHooks = {
        opacity: {
            get: function (c, a) {
                if (!a) {
                    return c.style.opacity
                }
                var b = K(c, "opacity", "opacity");
                return b === "" ? "1" : b
            }
        }
    };
    X._each(["height", "width"],
    function (a) {
        X.cssHooks[a] = {
            get: function (d, c, b) {
                var e;
                if (c) {
                    if (d.offsetWidth !== 0) {
                        return M(d, a, b)
                    }
                    ag(d, ab,
                    function () {
                        e = M(d, a, b)
                    });
                    return e
                }
            },
            set: function (b, c) {
                if (P.test(c)) {
                    c = parseFloat(c);
                    if (c >= 0) {
                        return c + "px"
                    }
                } else {
                    return c
                }
            }
        }
    });
    function M(c, b, a) {
        var e = b === "width" ? c.offsetWidth : c.offsetHeight,
        d = b === "width" ? af : ai;
        if (e > 0) {
            if (a !== "border") {
                X.each(d,
                function () {
                    if (!a) {
                        e -= parseFloat(ad(c, "padding" + this)) || 0
                    }
                    if (a === "margin") {
                        e += parseFloat(ad(c, a + this)) || 0
                    } else {
                        e -= parseFloat(ad(c, "border" + this + "Width")) || 0
                    }
                })
            }
            return e + "px"
        }
        return ""
    }
    if (!X.support.opacity) {
        X.support.opacity = {
            get: function (a, b) {
                return N.test((b && a.currentStyle ? a.currentStyle.filter : a.style.filter) || "") ? (parseFloat(RegExp.$1) / 100) + "" : b ? "1" : ""
            },
            set: function (d, e) {
                var c = d.style;
                c.zoom = 1;
                var a = X.isNaN(e) ? "" : "alpha(opacity=" + e * 100 + ")",
                b = c.filter || "";
                c.filter = Y.test(b) ? b.replace(Y, a) : c.filter + " " + a
            }
        }
    }
    if (U.defaultView && U.defaultView.getComputedStyle) {
        ak = function (e, a, d) {
            var c,
            f,
            b;
            d = d.replace(I, "-$1").toLowerCase();
            if (!(f = e.ownerDocument.defaultView)) {
                return undefined
            }
            if ((b = f.getComputedStyle(e, null))) {
                c = b.getPropertyValue(d);
                if (c === "" && !X.contains(e.ownerDocument.documentElement, e)) {
                    c = X.style(e, d)
                }
            }
            return c
        }
    }
    if (U.documentElement.currentStyle) {
        ae = function (e, c) {
            var f,
            b = e.currentStyle && e.currentStyle[c],
            a = e.runtimeStyle && e.runtimeStyle[c],
            d = e.style;
            if (!P.test(b) && aa.test(b)) {
                f = d.left;
                if (a) {
                    e.runtimeStyle.left = e.currentStyle.left
                }
                d.left = c === "fontSize" ? "1em" : (b || 0);
                b = d.pixelLeft + "px";
                d.left = f;
                if (a) {
                    e.runtimeStyle.left = a
                }
            }
            return b === "" ? "auto" : b
        }
    }
    K = ak || ae;
    X.fn.css = function (a, b) {
        if (arguments.length === 2 && b === undefined) {
            return this
        }
        return W(this, a, b, true,
        function (d, c, e) {
            return e !== undefined ? am(d, c, e) : ad(d, c)
        })
    };
    X.cssNumber = {
        zIndex: true,
        fontWeight: true,
        opacity: true,
        zoom: true,
        lineHeight: true
    };
    X.cssProps = {
        "float": X.support.cssFloat ? "cssFloat" : "styleFloat"
    };
    function am(c, b, h, d) {
        if (!c || c.nodeType === 3 || c.nodeType === 8 || !c.style) {
            return
        }
        var g,
        e = ah(b),
        a = c.style,
        j = X.cssHooks[e];
        b = X.cssProps[e] || e;
        if (h !== undefined) {
            if (typeof h === "number" && isNaN(h) || h == null) {
                return
            }
            if (typeof h === "number" && !X.cssNumber[e]) {
                h += "px"
            }
            if (!j || !("set" in j) || (h = j.set(c, h)) !== undefined) {
                try {
                    a[b] = h
                } catch (f) { }
            }
        } else {
            if (j && "get" in j && (g = j.get(c, false, d)) !== undefined) {
                return g
            }
            return a[b]
        }
    }
    X.style = am;
    function ad(f, e, b) {
        var d,
        c = ah(e),
        a = X.cssHooks[c];
        e = X.cssProps[c] || c;
        if (a && "get" in a && (d = a.get(f, true, b)) !== undefined) {
            return d
        } else {
            if (K) {
                return K(f, e, c)
            }
        }
    }
    X.css = ad;
    function ag(e, d, a) {
        var b = {},
        c;
        for (var c in d) {
            b[c] = e.style[c];
            e.style[c] = d[c]
        }
        a.call(e);
        for (c in d) {
            e.style[c] = b[c]
        }
    }
    X.swap = ag;
    function ah(a) {
        return a.replace(ac, O)
    }
    X.camelCase = ah;
    function W(d, j, g, a, f, h) {
        var b = d.length;
        if (typeof j === "object") {
            for (var c in j) {
                W(d, c, j[c], a, f, g)
            }
            return d
        }
        if (g !== undefined) {
            a = !h && a && X.isFunction(g);
            for (var e = 0; e < b; e++) {
                f(d[e], j, a ? g.call(d[e], e, f(d[e], j)) : g, h)
            }
            return d
        }
        return b ? f(d[0], j) : undefined
    }
    var al,
    V,
    T,
    H,
    Q,
    S,
    L = function () {
        if (al) {
            return
        }
        var a = U.body,
        h = U.createElement("div"),
        g,
        e,
        d,
        f,
        b = parseFloat(ad(a, "marginTop")) || 0,
        c = "<div style='position:absolute;top:0;left:0;margin:0;border:5px solid #000;padding:0;width:1px;height:1px;'><div></div></div><table style='position:absolute;top:0;left:0;margin:0;border:5px solid #000;padding:0;width:1px;height:1px;' cellpadding='0' cellspacing='0'><tr><td></td></tr></table>";
        X.extend(h.style, {
            position: "absolute",
            top: 0,
            left: 0,
            margin: 0,
            border: 0,
            width: "1px",
            height: "1px",
            visibility: "hidden"
        });
        h.innerHTML = c;
        a.insertBefore(h, a.firstChild);
        g = h.firstChild;
        e = g.firstChild;
        f = g.nextSibling.firstChild.firstChild;
        Q = (e.offsetTop !== 5);
        S = (f.offsetTop === 5);
        e.style.position = "fixed";
        e.style.top = "20px";
        H = (e.offsetTop === 20 || e.offsetTop === 15);
        e.style.position = e.style.top = "";
        g.style.overflow = "hidden";
        g.style.position = "relative";
        T = (e.offsetTop === -5);
        V = (a.offsetTop !== b);
        a.removeChild(h);
        al = true
    },
    Z = function (a) {
        var c = a.offsetTop,
        b = a.offsetLeft;
        L();
        if (V) {
            c += parseFloat(ad(a, "marginTop")) || 0;
            b += parseFloat(ad(a, "marginLeft")) || 0
        }
        return {
            top: c,
            left: b
        }
    };
    X.fn.offset = function () {
        var b = this[0],
        f;
        if (!b || !b.ownerDocument) {
            return null
        }
        if (b === b.ownerDocument.body) {
            return Z(b)
        }
        try {
            f = b.getBoundingClientRect()
        } catch (k) { }
        if (!f || !X.contains(R, b)) {
            return f ? {
                top: f.top,
                left: f.left
            } : {
                top: 0,
                left: 0
            }
        }
        var g = U.body,
        h = aj(U),
        e = R.clientTop || g.clientTop || 0,
        j = R.clientLeft || g.clientLeft || 0,
        a = h.pageYOffset || X.support.boxModel && R.scrollTop || g.scrollTop,
        d = h.pageXOffset || X.support.boxModel && R.scrollLeft || g.scrollLeft,
        m = f.top + a - e,
        c = f.left + d - j;
        return {
            top: m,
            left: c
        }
    };
    X.fn.position = function () {
        if (!this[0]) {
            return null
        }
        var c = this[0],
        a = this["offsetParent"](),
        d = this["offset"](),
        b = J.test(a[0].nodeName) ? {
            top: 0,
            left: 0
        } : a.offset();
        d.top -= parseFloat(ad(c, "marginTop")) || 0;
        d.left -= parseFloat(ad(c, "marginLeft")) || 0;
        b.top += parseFloat(ad(a[0], "borderTopWidth")) || 0;
        b.left += parseFloat(ad(a[0], "borderLeftWidth")) || 0;
        return {
            top: d.top - b.top,
            left: d.left - b.left
        }
    };
    X.fn.offsetParent = function () {
        return this["map"](function () {
            var a = this.offsetParent || U.body;
            while (a && (!J.test(a.nodeName) && ad(a, "position") === "static")) {
                a = a.offsetParent
            }
            return a
        })
    };
    X._each(["Height", "Width"],
    function (a, b) {
        var c = a.toLowerCase();
        X.fn["inner" + a] = function () {
            var d = this[0];
            return d && d.style ? parseFloat(ad(d, c, "padding")) : null
        };
        X.fn["outer" + a] = function (e) {
            var d = this[0];
            return d && d.style ? parseFloat(ad(d, c, e ? "margin" : "border")) : null
        };
        X.fn[c] = function (f) {
            var g = this[0];
            if (!g) {
                return f == null ? null : this
            }
            if (X.isFunction(f)) {
                return this["each"](function (m) {
                    var k = X(this);
                    k[c](f.call(this, m, k[c]()))
                })
            }
            if (X.isWindow(g)) {
                var h = g.document.documentElement["client" + a],
                d = g.document.body;
                return g.document.compatMode === "CSS1Compat" && h || d && d["client" + a] || h
            } else {
                if (g.nodeType === 9) {
                    return Math.max(g.documentElement["client" + a], g.body["scroll" + a], g.documentElement["scroll" + a], g.body["offset" + a], g.documentElement["offset" + a])
                } else {
                    if (f === undefined) {
                        var j = ad(g, c),
                        e = parseFloat(j);
                        return X.isNaN(e) ? j : e
                    } else {
                        return this["css"](c, typeof f === "string" ? f : f + "px")
                    }
                }
            }
        }
    });
    function aj(a) {
        return X.isWindow(a) ? a : a.nodeType === 9 ? a.defaultView || a.parentWindow : false
    }
    X._each(["Left", "Top"],
    function (a, b) {
        var c = "scroll" + a;
        X.fn[c] = function (f) {
            var d,
            e;
            if (f === undefined) {
                d = this[0];
                if (!d) {
                    return null
                }
                e = aj(d);
                return e ? ("pageXOffset" in e) ? e[b ? "pageYOffset" : "pageXOffset"] : X.support.boxModel && e.document.documentElement[c] || e.document.body[c] : d[c]
            }
            return this["each"](function () {
                e = aj(this);
                if (e) {
                    e.scrollTo(!b ? f : X(e)["scrollLeft"](), b ? f : X(e)["scrollTop"]())
                } else {
                    this[c] = f
                }
            })
        }
    })
});
$.plug("custom",
function (o) {
    var r = window,
    q = document,
    n = {},
    p = r.location.search.substring(1).split("&");
    for (var m = 0; m < p.length; m++) {
        var k = p[m].split("=");
        n[k[0]] = decodeURIComponent(k[1])
    }
    o.queryString = function (b) {
        var a = n[b];
        return a == undefined ? null : a
    };
    var j = o.Key = function (a) {
        this.keyCode = a
    };
    j.namedKeys = {
        Backspace: 8,
        Tab: 9,
        Enter: 13,
        Shift: 16,
        Ctrl: 17,
        Alt: 18,
        Pause: 19,
        Capslock: 20,
        Escape: 27,
        PageUp: 33,
        PageDown: 34,
        End: 35,
        Home: 36,
        LeftArrow: 37,
        UpArrow: 38,
        RightArrow: 39,
        DownArrow: 40,
        Insert: 45,
        Delete: 46
    };
    o._each(j.namedKeys,
    function (c, a) {
        var b = c;
        j.prototype["is" + a] = function () {
            return this.keyCode === b
        }
    });
    o.key = function (a) {
        a = a || window.event;
        return new j(a.keyCode || a.which)
    };
    o.cancelEvent = function (a) {
        if (!a) {
            a = window.event
        }
        a.cancelBubble = true;
        a.returnValue = false;
        if (a.stopPropagation) {
            a.stopPropagation();
            a.preventDefault()
        }
        return false
    }
});
$.plug("docready",
function (m) {
    var n = window,
    t = document,
    q,
    o,
    u = [],
    p = false,
    s = 1;
    m.hook(function (b, a) {
        if (typeof b == "function") {
            this["ready"](b);
            return true
        }
    });
    function k() {
        if (p) {
            return
        }
        try {
            t.documentElement.doScroll("left")
        } catch (a) {
            setTimeout(k, 1);
            return
        }
        r()
    }
    function r(d) {
        if (d === true) {
            s--
        }
        if (!s || (d !== true && !p)) {
            if (!t.body) {
                return setTimeout(b, 1)
            }
            p = true;
            if (d !== true && --s > 0) {
                return
            }
            if (u) {
                var c,
                a = 0,
                b = u;
                u = null;
                while ((c = b[a++])) {
                    c.call(t, m)
                }
                if (m.fn.trigger) {
                    m(t)["trigger"]("ready")["unbind"]("ready")
                }
            }
        }
    }
    m.ready = r;
    q = t.addEventListener ?
    function () {
        t.removeEventListener("DOMContentLoaded", q, false);
        r()
    } : function () {
        if (t.readyState === "complete") {
            t.detachEvent("onreadystatechange", q);
            r()
        }
    };
    m.bindReady = function () {
        if (o) {
            return
        }
        o = true;
        if (t.readyState === "complete") {
            return setTimeout(r, 1)
        }
        if (t.addEventListener) {
            t.addEventListener("DOMContentLoaded", q, false);
            n.addEventListener("load", r, false)
        } else {
            if (t.attachEvent) {
                t.attachEvent("onreadystatechange", q);
                n.attachEvent("onload", r);
                var a = false;
                try {
                    a = window.frameElement == null
                } catch (b) { }
                if (t.documentElement.doScroll && a) {
                    k()
                }
            }
        }
    };
    m.fn.ready = function (a) {
        m.bindReady();
        if (p) {
            a.call(t, m)
        } else {
            if (u) {
                u.push(a)
            }
        }
        return this
    };
    if (!m.init) {
        m(document)["ready"](m.onload)
    }
});
$.plug("events",
function (w) {
    var C = document,
    u = {},
    r = 1;
    function D(a) {
        return a._jquid || (a._jquid = r++)
    }
    function B(c, b, a) {
        if (c.addEventListener) {
            c.addEventListener(b, a, false)
        } else {
            c["e" + b + a] = a;
            c[b + a] = function () {
                c["e" + b + a](window.event)
            };
            c.attachEvent("on" + b, c[b + a])
        }
    }
    w.bind = B;
    function F(c, b, a) {
        if (c.removeEventListener) {
            c.removeEventListener(b, a, false)
        } else {
            c.detachEvent("on" + b, c[b + a]);
            c[b + a] = null
        }
    }
    w.unbind = F;
    function s(a) {
        var b = ("" + a).split(".");
        return {
            e: b[0],
            ns: b.slice(1).sort().join(" ")
        }
    }
    function z(a) {
        return new RegExp("(?:^| )" + a.replace(" ", " .* ?") + "(?: |$)")
    }
    function p(d, b, c, e) {
        b = s(b);
        if (b.ns) {
            var a = z(b.ns)
        }
        return w._filter(u[D(d)] || [],
        function (f) {
            return f && (!b.e || f.e == b.e) && (!b.ns || a.test(f.ns)) && (!c || f.fn == c) && (!e || f.sel == e)
        })
    }
    function E(d, a, c, e, b) {
        var g = D(d),
        f = (u[g] || (u[g] = []));
        w._each(a.split(/\s/),
        function (h) {
            var j = w.extend(s(h), {
                fn: c,
                sel: e,
                del: b,
                i: f.length
            });
            f.push(j);
            B(d, j.e, b || c)
        });
        d = null
    }
    function A(c, a, b, d) {
        var e = D(c);
        w._each((a || "").split(/\s/),
        function (f) {
            w._each(p(c, f, b, d),
            function (g) {
                delete u[e][g.i];
                F(c, g.e, g.del || g.fn)
            })
        })
    }
    var y = ["preventDefault", "stopImmediatePropagation", "stopPropagation"];
    function x(a) {
        var b = w.extend({
            originalEvent: a
        },
        a);
        w._each(y,
        function (c) {
            b[c] = function () {
                return a[c].apply(a, arguments)
            }
        });
        return b
    }
    var t = w.fn;
    w._each(("blur focus focusin focusout load resize scroll unload click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup error").split(" "),
    function (a) {
        t[a] = function (b, c) {
            return arguments.length > 0 ? this["bind"](a, b, c) : this["trigger"](a)
        }
    });
    t.bind = function (b, a) {
        return this["each"](function () {
            E(this, b, a)
        })
    };
    t.unbind = function (b, a) {
        return this["each"](function () {
            A(this, b, a)
        })
    };
    t.one = function (b, a) {
        return this["each"](function () {
            var c = this;
            E(this, b,
            function d() {
                a();
                A(c, b, arguments.callee)
            })
        })
    };
    t.delegate = function (c, b, a) {
        return this["each"](function (d, e) {
            E(e, b, a, c,
            function (h) {
                var g = h.target,
                f = w["$$"](c, e);
                while (g && f.indexOf(g) < 0) {
                    g = g.parentNode
                }
                if (g && !(g === e) && !(g === document)) {
                    a.call(g, w.extend(x(h || window.event), {
                        currentTarget: g,
                        liveFired: e
                    }))
                }
            })
        })
    };
    t.undelegate = function (c, b, a) {
        return this["each"](function () {
            A(this, b, a, c)
        })
    };
    t.live = function (b, a) {
        w(C.body)["delegate"](this["selector"], b, a);
        return this
    };
    t.die = function (b, a) {
        w(C.body)["undelegate"](this["selector"], b, a);
        return this
    };
    t.trigger = function (a) {
        return this["each"](function () {
            if ((a == "click" || a == "blur" || a == "focus") && this[a]) {
                return this[a]()
            }
            if (C.createEvent) {
                var b = C.createEvent("Events");
                this.dispatchEvent(b, b.initEvent(a, true, true))
            } else {
                if (this.fireEvent) {
                    try {
                        if (a !== "ready") {
                            this.fireEvent("on" + a)
                        }
                    } catch (b) { }
                }
            }
        })
    };
    if (!w.init) {
        w(window)["bind"]("load", w.onload)
    }
});
$.extend({
    config: {
        ver: "13062701",
        staticSrcRoot: "/",
        luiCalendarScript: "content/hobbit/plugin/calendar/calendar.js",
        luiCalendarCss: "content/hobbit/plugin/calendar/calendar.css",
        luiImggalleryScript: "Hobbit/js/hobbit.lui.imggallery.js",
        luiImggalleryCss: "Hobbit/css/hobbit.lui.imggallery.css"
    },
    getStaticSrcPath: function (a) {
        return $.config.staticSrcRoot + a;
    },
    fxPath: document.scripts[document.scripts.length - 1].src.substring(0, document.scripts[document.scripts.length - 1].src.lastIndexOf("/") + 1)
});
$(function () {
    $(window).bind("autoHeight",
    function () {
        var b = $("div.ui_page");
        var a = function (c) { };
        if (b.length == 0) {
            return
        }
        a(100);
        $.scrollTop();
        if ($.platform.isIphoneOS) {
            if ($.platform.isQQ) {
                a(0)
            } else {
                a(0)
            }
        } else {
            if ($.platform.isAndroid) {
                a(0)
            } else {
                a(0)
            }
        }
        $.autoFillHeight(0)
    }).trigger("autoHeight").bind("orientationchange",
    function () {
        var a = $H.browser.scrollHeight();
        $(this).trigger("autoHeight");
        window.scrollTo(0, a)
    });
    if ($.platform.isIphoneOS && !$.platform.isIOS4) {
        $(window).bind("touchstart",
        function () { }).bind("touchend",
        function () { })
    } else {
        $("a").add(".btn").hoverClass()
    }
    $("form").submit(function (a) {
        a.stopPropagation();
        a.preventDefault();
        return false
    })
});
var platformClass = function () {
    var b = navigator.userAgent;
    var a = function (c) {
        return b.toLowerCase().indexOf(c.toLowerCase()) != -1
    };
    this.userAgent = b;
    this.isAndroid = a("android");
    this.isIphoneOS = a("iphone os");
    this.isIOS4 = a("os 4_") || a("os 3_");
    this.isIOS6 = a("os 6_");
    this.isQQ = a("qqbrowser");
    this.isSafari = a("mac os") && a("safari") && !a("crios")
};
$.extend({
    platform: new platformClass(),
    json2nvp: function (b) {
        var c = [];
        for (var a in b) {
            c.push(a + "=" + b[a])
        }
        return c.join("&")
    },
    nvp2Json: function (f) {
        if (!f) {
            return {}
        }
        var c = {},
        e = f.split("&"),
        a = decodeURIComponent,
        b,
        g;
        $.each(e,
        function (d, h) {
            h = h.split("=");
            b = a(h[0]);
            g = a(h[1]);
            c[b] = !c[b] ? g : [].concat(c[b]).concat(g)
        });
        return c
    },
    scrollTop: function (a, b) {
        if (a) {
            window.scrollTo(0, a.offset().top + (b || 0))
        } else {
            window.scrollTo(0, 1)
        }
    },
    autoFillHeight: function (b) {
        if ($("footer").length == 0) {
            return
        }
        var a = function (c) {
            $("#footer_fillHeight").css("height", Math.max(0, $.browserSize().height - $("footer").offset().top - $("footer").height() + ($("#footer_fillHeight").height() || 0) + (b || 0) + c))
        };
        $("#footer_fillHeight").css("height", 200);
        a(0);
        setTimeout(function () {
            a(0)
        },
        500)
    },
    blurScrollTop: function () {
        $("input").add("select").bind("blur",
        function () {
            window.scrollTo(0, 1)
        })
    },
    browserSize: function () {
        return {
            height: window.innerHeight || $(window).height(),
            width: window.innerWidth || $(window).width()
        }
    },
    ajaxLink: function (a) {
        window.location.href = a
    },
    ajaxFormPost: function (c, b, a, e, f) {
        var d = function () {
            var g = $(document.getElementById(c));
            isSubmit = e || Validator.Validate(document.getElementById(c), 1);
            if (isSubmit) {
                $.showLoader();
                var k = g.attr("action");
                var h = g.serialize();
                var j = {
                    set: null,
                    state: 0
                };
                j.set = window.setTimeout(function () {
                    $.hideLoader();
                    window.clearTimeout(j);
                    j.state = 1;
                    $.dialog("网络超时，点击确定重试。", null,
                    function () {
                        d()
                    },
                    function () { })
                },
                (f || 30) * 1000);
                k += ((k.indexOf("?") > -1) ? "&" : "?") + "t=" + new Date().getTime() + "&" + h;
                $.ajax({
                    type: "POST",
                    url: k,
                    dataType: "json",
                    complete: function () {
                        window.clearTimeout(j.set);
                        $.hideLoader()
                    },
                    success: function (n) {
                        if (j.state != 0) {
                            return
                        }
                        if (n.Msg) {
                            $.dialog(n.Msg, null,
                            function () {
                                if (n.IsCallBack && a) {
                                    a(n)
                                }
                                if (n.EscapeRedirctUrl) {
                                    window.location.href = n.EscapeRedirctUrl
                                }
                                if (n.Refresh) {
                                    window.location.href = window.location.href + (window.location.href.indexOf("?") == -1 ? "?t=" : "&t=") + new Date().getTime()
                                }
                            })
                        } else {
                            if (n.IsCallBack && a) {
                                try {
                                    a(n)
                                } catch (m) { }
                            }
                            if (n.EscapeRedirctUrl) {
                                window.location.href = n.EscapeRedirctUrl
                            }
                            if (n.Refresh) {
                                window.location.href = window.location.href
                            }
                        }
                    },
                    error: function (n, o, m) {
                        if (o == 404) {
                            $.dialog("操作超时，点击确定返回首页", null,
                            function () {
                                location.href = "/"
                            })
                        }
                    }
                })
            }
        };
        if (b) {
            $.dialog(b, null, d,
            function () { })
        } else {
            d()
        }
    },
    getCss: function (a) {
        var b = document.getElementsByTagName("head").item(0) || document.documentElement;
        var c = document.createElement("link");
        c.setAttribute("rel", "stylesheet");
        c.setAttribute("type", "text/css");
        c.setAttribute("href", a);
        b.appendChild(c)
    },
    NVC: function (e) {
        var f = new Array();
        var d = function (g, h) {
            this.name = g;
            this.value = h
        };
        var a = 0;
        this.set = function (h, j) {
            if (h == null) {
                f.push(new d(a++, j))
            } else {
                var g = this.findName(h);
                if (g == -1) {
                    f.push(new d(h, j))
                } else {
                    f[g].value = j
                }
            }
        };
        this.get = function (h) {
            var g = this.findName(h);
            if (g == -1) {
                return null
            }
            return f[g].value
        };
        this.index = function (g) {
            if (f.length == 0 || g < 0 || g >= f.length) {
                return null
            }
            return f[g]
        };
        this.findName = function (h) {
            if (f.length == 0) {
                return -1
            }
            for (var g = 0; g < f.length; g++) {
                if (f[g].name == h) {
                    return g
                }
            }
            return -1
        };
        this.pop = function () {
            if (f.length == 0) {
                return null
            }
            return f.pop()
        };
        this.shift = function () {
            if (f.length == 0) {
                return null
            }
            return f.shift()
        };
        this.clear = function () {
            f.splice(0, f.length - 1);
            a = 0
        };
        this.count = function () {
            return f.length
        };
        this.reverse = function () {
            f.reverse()
        };
        this.sort = function (g) {
            f.sort(g)
        };
        this.toString = function () {
            var g = encodeURIComponent;
            var j = [];
            for (var h = 0; h < f.length; h++) {
                j.push(g(f[h].name) + "=" + g(f[h].value))
            }
            return j.join("&")
        };
        if (e && e.length > 0) {
            var c = $.nvp2Json(e);
            for (var b in c) {
                this.set(b, c[b])
            }
        }
    }
});
$.fn.extend({
    serialize: function () {
        var a = [];
        $.each(this.serializeArray(),
        function (c, b) {
            a.push(b.name + "=" + encodeURIComponent(b.value))
        });
        return a.join("&")
    },
    serializeToJson: function () {
        var c = {};
        var b = this.serializeArray();
        $.each(b,
        function () {
            if (c[this.name]) {
                if (!c[this.name].push) {
                    c[this.name] = [c[this.name]]
                }
                c[this.name].push(this.value || "")
            } else {
                c[this.name] = this.value || ""
            }
        });
        return c
    },
    hoverClass: function (a) {
        if (!$(this).hasClass(a || "active")) {
            $(this).bind("touchstart mousedown",
            function () {
                $(this).addClass(a || "active");
                var b = $(this);
                b.addClass(a || "active");
                if ($H.browser.info.android()) {
                    setTimeout(function () {
                        b.removeClass(a || "active")
                    },
                    500)
                }
            }).bind("touchcancel touchend mouseup",
            function () {
                $(this).removeClass(a || "active")
            })
        }
        return $(this)
    },
    ajaxHtml: function (f, c, e, a, d) {
        var b = $(this);
        if (!d) {
            $.showLoader()
        }
        if (c) {
            c.t = new Date().getDate()
        }
        $.ajax({
            type: e,
            url: f,
            data: c,
            complete: function () {
                if (!d) {
                    $.hideLoader()
                }
            },
            success: function (h) {
                b.html(h);
                b.find("a").hoverClass();
                if (a) {
                    try {
                        a()
                    } catch (g) { }
                }
            }
        })
    }
});
$.extend({
    weekText: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
    dialog: function (d, h, f, b) {
        $.uiDialog.children(".ui_dialog_content").html(d);
        $.uiDialog.children(".ui_dialog_title").html(h || "提示");
        var e = $.uiDialog.find(".ui_dialog_ok");
        var a = $.uiDialog.find(".ui_dialog_cancel");
        var c = function () {
            $.uiDialog.hide();
            $.uiDialog_Mask.hide();
            $("select").css("display", "block")
        };
        var g = function () {
            $.uiDialog_Mask.css({
                height: $(document).height()
            }).appendTo("body").show();
            if ($.platform.isIOS4) {
                $.uiDialog.appendTo("body").css({
                    top: ($(window).scrollTop() + $.browserSize().height / 2) - ($.uiDialog.height() / 2)
                }).show()
            } else {
                $.uiDialog.appendTo("body").css({
                    top: ($.browserSize().height / 2) - ($.uiDialog.height() / 2) - 20
                }).show()
            }
            $("select").css("display", "none")
        };
        e.unbind("click").click(function () {
            c();
            if (f) {
                try {
                    f()
                } catch (j) { }
            }
        }).hoverClass();
        if (b) {
            e.css({
                width: "44%"
            });
            a.css("display", "block").unbind("click").click(function () {
                c();
                try {
                    b()
                } catch (j) { }
            }).hoverClass()
        } else {
            e.css({
                width: "100%"
            });
            a.css("display", "none")
        }
        g()
    },
    uiDialog: $("<div>").addClass("ui_dialog").html('<div class="ui_dialog_title"></div><div class="ui_dialog_content"></div><div class="ui_dialog_footer"><a class="ui_dialog_cancel" style="float:left;width:44%;display:none">取 消</a><a class="ui_dialog_ok" style="float:right;width:100%">确 定</a></div>'),
    uiLoader: $("<div>").addClass("ui_loader").html("<div class='ui_loader_close'>\u00d7</div><div class='ui_loader_icon'><img src='data:image/gif;base64,R0lGODlhIAAgAMQAAAAAAHNzczMzM8TExKWlpRAQEFpaWu/v74yMjEpKSt7e3iEhIbW1tUNDQ/// /2ZmZpmZmYSEhNbW1gcHBxkZGTo6OikpKXp6eq2trVFRUWtra+Xl5b+/v/n5+czMzJSUlCH5BAAH AP8ALAAAAAAgACAAAAX/ICCOZCFkWnBFrJYsZCyPVGM8WnqtCPJBF8tsNqlkDDeciueDQAgRypDW yByTOt7vScAQKtNaI2FFKneRJhfDYCRmhUplTDZn0z9Cl83ggEkTAnINdEcPh0gXCE57bRwDDFIj CwKVc2NWAgUlCU98jwMeECMTFqaWhAITQxMajgOhHh4CIhQLp5aSUwAZoB4SwAQiC8S3FgIwuyMB ssASCgoUBRS2xcnKIgUMwNAKGwHT1NQLm9gjBtAb6hsYBe7vuuYABesH9goT+e/l8iIc9gAP5BuY r9+IAR0SKjQ4JYKDhxAZDlkA8aEwiTMMHLDID6PHjyBDihxJsqTJkyhTBapcGTIEADs='></div><h1></h1>"),
    uiDialog_Mask: $("<div>").addClass("ui_mask"),
    uiMask: $("<div>").addClass("ui_mask").css({
        position: "absolute"
    }),
    uiToggle: $("<div>").addClass("ui_toggle").html("<div class='ui_icon ui_icon_toggle_arrow_r'></div>"),
    uiDrawer: function (a) {
        $.extend({
            top: false,
            height: "auto",
            onopen: null,
            onclose: null
        },
        a);
        this.drawer = $("#" + a.id).css("height", a.height);
        var b = 0;
        this.open = function () {
            b = document.documentElement.scrollTop || document.body.scrollTop;
            if (a.onopen) {
                if (!a.onopen()) {
                    return
                }
            }
            this.drawer.show();
            if (a.top) {
                $.scrollTop(this.drawer)
            }
        };
        this.close = function (c) {
            if (a.onclose) {
                if (!a.onclose()) {
                    return
                }
            }
            this.drawer.hide();
            if (c) {
                window.scrollTo(0, b)
            }
        };
        this.setHeight = function (c) {
            this.drawer.css("height", c)
        }
    },
    uiSearcher: function (a) {
        $.extend({
            onupdate: null,
            onok: null,
            oncancle: null,
            onfocus: null
        },
        a);
        var e = this;
        var g = $("#" + a.id);
        var d = g.find("input").bind("input",
        function () {
            e.update()
        }).bind("focus",
        function () {
            if (a.onfocus) {
                a.onfocus()
            }
        });
        var f = {
            n: 0,
            fn: function (h) {
                if (f.n++ == 0) {
                    d.focus();
                    h.preventDefault && (h.preventDefault(), h.stopPropagation())
                }
            }
        };
        if ($.platform.isIphoneOS) {
            d.bind("blur",
            function () {
                f.n = 0
            });
            d.bind("touchstart", f.fn)
        }
        var b = g.find(".ui_searcher_btn").hoverClass().bind("click",
        function () {
            if (b.attr("data-type") == "ok") {
                if (a.onok) {
                    a.onok(d.val())
                }
            } else {
                if (a.oncancle) {
                    a.oncancle(d.val())
                }
            }
        });
        var c = $("<div>").addClass("ui_searcher_clear_back").html("<div class='ui_searcher_clear'>\u00d7</div>").click(function () {
            d.val("");
            e.update();
            d.focus()
        }).appendTo(g);
        this.update = function (h) {
            if (d.val().length == 0) {
                b.html("取消").attr("data-type", "cancel");
                c.hide()
            } else {
                b.html("确定").attr("data-type", "ok");
                c.show()
            }
            if (!h && a.onupdate) {
                a.onupdate(d.val())
            }
            return this
        };
        this.update(true);
        this.set = function (j, h) {
            d.val(j);
            e.update(h);
            return this
        };
        this.get = function () {
            return d.val(v);
            return this
        };
        this.focus = function () {
            d.focus();
            return this
        }
    },
    uiSuggestion: function (a) {
        $.extend({
            delay: 1000,
            count: 10,
            onclick: null,
            jsonp: null,
            format: null,
            cache: 10,
            onload: null,
            onshowed: null,
            onhided: null,
            isSetInput: false,
            inputID: null,
            hideType: null,
            cacheInpteID: null
        },
        a);
        var g = this;
        var j = $("#" + a.id);
        var d = new $.NVC();
        var f = null;
        var m = null;
        var e = null;
        var b = function (q, p, r, n) {
            q.click(function () {
                r.hide();
                if (n.onclick) {
                    n.onclick(p)
                }
            })
        };
        var c = function (o, p, q, n) {
            o.click(function () {
                var s = $("#" + n.hideType);
                var r = $("#" + n.cacheInpteID);
                if (s) {
                    s.val(p.Type)
                }
                if (r) {
                    r.val(p.Name)
                }
                $("#" + n.inputID).val(p.Name);
                g.fire({
                    cityId: n.cityID,
                    keyword: p.Name
                });
                $("#" + n.inputID).focus()
            })
        };
        var k = function (q) {
            j.empty();
            if (m) {
                f = m;
                m = null;
                h(f)
            } else {
                f = null;
                if (!q || q.length == 0) {
                    j.hide();
                    if (a.onhided) {
                        a.onhided()
                    }
                } else {
                    for (var s = null, p = 0; p < Math.min(q.length, a.count); p++) {
                        if (typeof q[p] == "string") {
                            s = format.replace(/{value}/g, q[p])
                        } else {
                            if (typeof q[p] == "object") {
                                s = a.format;
                                for (var r in q[p]) {
                                    s = s.replace(new RegExp("{" + r + "}", "g"), q[p][r])
                                }
                            }
                        }
                        if (a.isSetInput) {
                            var n = $("<a>").html(s).addClass("flex1").appendTo(j);
                            b(n, q[p], j, a);
                            if (p == 0) {
                                n.find("span")[0].style.right = "120px";
                                continue
                            }
                            n.wrap("<div style='display:-webkit-box;' />");
                            c($("<div class='newSuggestionBtn'>+</div>").insertAfter(n), q[p], j, a)
                        } else {
                            b($("<a>").html(s).appendTo(j), q[p], j, a)
                        }
                    }
                    j.show();
                    if (a.onshowed) {
                        a.onshowed()
                    }
                }
            }
        };
        var h = function (q) {
            f = q;
            var o = d.get($.json2nvp(f));
            if (o != null) {
                k(o)
            } else {
                var p = a.jsonp;
                for (var n in q) {
                    p = p.replace(new RegExp("{" + n + "}", "g"), q[n])
                }
                if (a.onload) {
                    a.onload()
                }
                $.getScript(p, null)
            }
        };
        this.fire = function (n) {
            if (f) {
                m = n;
                return g
            }
            clearTimeout(e);
            e = setTimeout(function () {
                h(n)
            },
            a.delay);
            return g
        };
        this.callback = function (n) {
            if (d.count() >= a.cache) {
                d.shift()
            }
            d.set($.json2nvp(f), n);
            k(n)
        };
        this.hide = function () {
            setTimeout(function () {
                j.hide()
            },
            100);
            return g
        }
    },
    showLoader: function (a) {
        $.uiDialog_Mask.css({
            height: $(document).height()
        }).appendTo("body").show();
        $.uiLoader.find("h1").html(a || "努力加载中...");
        if ($.platform.isIOS4) {
            $.uiLoader.appendTo("body").css({
                top: ($(window).scrollTop() + $.browserSize().height / 2) - ($.uiLoader.height() / 2)
            }).show()
        } else {
            $.uiLoader.appendTo("body").css({
                top: ($.browserSize().height / 2) - ($.uiLoader.height() / 2)
            }).show()
        }
        $(".ui_loader_close").click(function (b) {
            b.stopPropagation();
            b.preventDefault();
            $.hideLoader()
        })
    },
    loaderStatus: function () {
        return $.uiLoader.is(":hidden") ? 0 : 1
    },
    hideLoader: function () {
        $.uiLoader.hide();
        $.uiDialog_Mask.hide()
    },
    luiCalendar: function (b) {
        $.luiCalendar.loaded = 0;
        var c = null;
        var d = $("#" + b.iptid);
        var e = 0;
        var a = function (g, h, f) {
            if ($.luiCalendar.loaded == 2) {
                if (c == null) {
                    c = new $H.uiCalendar(b)
                }
                c[g](h);
                if (f) {
                    f()
                }
            } else {
                e += 100;
                if (e < 5000) {
                    window.setTimeout(function () {
                        a(g, h, f)
                    },
                    e)
                }
            }
        };
        if (b.onPicked && d.val().length > 0) {
            b.onPicked(Date.parseDate(d.val()))
        }
        this.sync = function (g, h, f) {
            switch ($.luiCalendar.loaded) {
                case 0:
                    $.luiCalendar.loaded = 1;
                    $.showLoader();
                    $.getCss($.getStaticSrcPath($.config.luiCalendarCss));
                    $.getScript($.getStaticSrcPath($.config.luiCalendarScript),
                function () {
                    $.luiCalendar.loaded = 2;
                    $.hideLoader();
                    c = new $H.uiCalendar(b);
                    c[g](h);
                    if (f) {
                        f()
                    }
                });
                    break;
                case 1:
                case 2:
                    a(g, h, f);
                    break
            }
        }
    }
});
$.fn.extend({
    active: function () {
        $(this).each(function () {
            if (!$(this).hasClass("active")) {
                $(this).bind("touchstart mousedown",
                function () {
                    var a = $(this);
                    a.addClass("active");
                    if ($H.browser.info.android()) {
                        setTimeout(function () {
                            a.removeClass("active")
                        },
                        500)
                    }
                }).bind("touchcancel touchend mouseup",
                function () {
                    $(this).removeClass("active")
                })
            }
        })
    },
    wrap: function (a) {
        return this.each(function () {
            $(this).wrapAll($(a)[0].cloneNode(false))
        })
    },
    wrapAll: function (a) {
        if (this[0]) {
            $(this[0]).before(a = $(a));
            a.append(this)
        }
        return this
    },
    uiSpan: function () {
        var a = $(this);
        a.unbind("updateState").bind("updateState",
        function () {
            $(this).html($("#" + $(this).attr("data-for")).val())
        }).trigger("updateState");
        return a
    },
    uiCheckbox: function () {
        var a = $(this);
        a.unbind("updateState click").bind("updateState",
        function () {
            var b = $(this).find("input");
            if (b.attr("checked")) {
                b.parent("label").addClass("ui_checkbox_active")
            } else {
                b.parent("label").removeClass("ui_checkbox_active")
            }
        }).trigger("updateState").click(function () {
            var b = $(this);
            if (b.attr("_hasClicked") == "1") {
                b.trigger("updateState");
                b.attr("_hasClicked", "0")
            } else {
                b.attr("_hasClicked", "1")
            }
        });
        return a
    },
    uiRadio: function () {
        var a = $(this);
        a.unbind("updateState click").bind("updateState",
        function () {
            $("input[name=" + $(this).children("input").attr("name") + "]").each(function () {
                var b = $(this);
                if (b.attr("checked")) {
                    b.parent("label").addClass("ui_radio_active")
                } else {
                    b.parent("label").removeClass("ui_radio_active")
                }
            })
        }).trigger("updateState").click(function () {
            var b = $(this);
            if (b.attr("_hasClicked") == "1") {
                b.trigger("updateState");
                b.attr("_hasClicked", "0")
            } else {
                b.attr("_hasClicked", "1")
            }
        });
        return a
    },
    uiTabs: function () {
        var b = $(this);
        var a = b.find("label");
        a.unbind("updateState click").bind("updateState",
        function () {
            var d = $(this).find("input");
            var c = $("#" + d.attr("data-content-for"));
            if (d.attr("checked")) {
                if (!$(this).hasClass("ui_tabs_active")) {
                    $(this).addClass("ui_tabs_active");
                    $(this).trigger("show")
                }
                if (c) {
                    c.show()
                }
            } else {
                if ($(this).hasClass("ui_tabs_active")) {
                    $(this).removeClass("ui_tabs_active");
                    $(this).trigger("hide")
                }
                if (c) {
                    c.hide()
                }
            }
        }).click(function () {
            var c = $(this);
            if (c.attr("_hasClicked") == "1") {
                a.trigger("updateState");
                b.trigger("changed");
                c.attr("_hasClicked", "0")
            } else {
                c.attr("_hasClicked", "1")
            }
        }).trigger("updateState");
        return b
    },
    uiToolbar: function () {
        var b = $(this);
        var a = b.find("label");
        a.unbind("updateState click").bind("updateState",
        function () {
            var d = $(this).find("input");
            var c = $("#" + d.attr("data-content-for"));
            if (d.attr("checked")) {
                if (!$(this).hasClass("active")) {
                    $(this).addClass("active");
                    $(this).trigger("show")
                }
                if (c) {
                    c.show()
                }
            } else {
                if ($(this).hasClass("active")) {
                    $(this).removeClass("active");
                    $(this).trigger("hide")
                }
                if (c) {
                    c.hide()
                }
            }
        }).click(function () {
            var c = $(this);
            if (c.attr("_hasClicked") == "1") {
                a.trigger("updateState");
                b.trigger("changed");
                c.attr("_hasClicked", "0")
            } else {
                c.attr("_hasClicked", "1")
            }
        }).trigger("updateState");
        return b
    },
    uiSelect: function () {
        var a = $(this);
        a.each(function () {
            if ($(this).find("a").length == 0) {
                $("<a>").appendTo($(this))
            }
        }).find("select").unbind("updateState change touchstart touchend").bind("updateState",
        function () {
            $(this).parent().find("a").html($(this).find("option[value='" + $(this).val() + "']").html())
        }).bind("change",
        function () {
            $(this).trigger("updateState")
        }).bind("touchstart",
        function () {
            $(this).parent().addClass("ui_select_active")
        }).bind("touchend",
        function () {
            $(this).parent().removeClass("ui_select_active")
        }).trigger("updateState");
        return a
    },
    uiAccordion: function () {
        var a = $(this);
        var b = a.find(".ui_accordion_header");
        b.unbind("updateStateFirst updateState click").bind("updateStateFirst",
        function () {
            var d = $(this).children("input.ui_accordion_input");
            var c = $(this).next("div.ui_accordion_content");
            var e = $(this).children("span.ui_radio");
            if (d.attr("checked")) {
                if (e.length > 0) {
                    e.addClass("ui_radio_active checked")
                }
                if (c) {
                    c.show()
                }
                $(this).trigger("show")
            } else {
                if (e.length > 0) {
                    e.removeClass("ui_radio_active checked")
                }
                if (c) {
                    c.hide()
                }
                $(this).trigger("hide")
            }
        }).bind("updateState",
        function () {
            var d = $(this).children("input.ui_accordion_input");
            var c = $(this).next("div.ui_accordion_content");
            var e = $(this).children("span.ui_radio");
            if (d.attr("checked")) {
                if (c && c.css("display") != "block") {
                    c.css("display", "block");
                    $(this).trigger("show")
                }
                if (e.length > 0) {
                    e.addClass("ui_radio_active checked")
                }
            } else {
                if (c && c.css("display") != "none") {
                    c.css("display", "none");
                    $(this).trigger("hide")
                }
                if (e.length > 0) {
                    e.removeClass("ui_radio_active checked")
                }
            }
        }).trigger("updateStateFirst").click(function () {
            var c = $(this);
            if (c.attr("_hasClicked") == "1") {
                b.trigger("updateState");
                a.trigger("changed");
                c.attr("_hasClicked", "0")
            } else {
                c.attr("_hasClicked", "1")
            }
        });
        return a
    },
    luiImageGallery: function (a) {
        var b = $(this);
        $.getCss($.getStaticSrcPath($.config.luiImggalleryCss));
        $.getScript($.getStaticSrcPath($.config.luiImggalleryScript),
        function () {
            b.uiImageGallery(a)
        })
    }
});
$.extend(Date.prototype, {
    format: function (a) {
        a = a || "yyyy-MM-dd";
        var c = {
            "M+": this.getMonth() + 1,
            "d+": this.getDate(),
            "h+": this.getHours(),
            "m+": this.getMinutes(),
            "s+": this.getSeconds(),
            "q+": Math.floor((this.getMonth() + 3) / 3),
            S: this.getMilliseconds()
        };
        if (/(y+)/.test(a)) {
            a = a.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length))
        }
        for (var b in c) {
            if (new RegExp("(" + b + ")").test(a)) {
                a = a.replace(RegExp.$1, RegExp.$1.length == 1 ? c[b] : ("00" + c[b]).substr(("" + c[b]).length))
            }
        }
        return a
    },
    isLeapYear: function () {
        return (0 == this.getYear() % 4 && ((this.getYear() % 100 != 0) || (this.getYear() % 400 == 0)))
    },
    daysInMonth: function () {
        switch (this.getMonth()) {
            default:
                return 0;
            case 0:
            case 2:
            case 4:
            case 6:
            case 7:
            case 9:
            case 11:
                return 31;
            case 3:
            case 5:
            case 8:
            case 10:
                return 30;
            case 1:
                return this.isLeapYear() ? 29 : 28
        }
    },
    firstDay: function () {
        return new Date(this.getFullYear(), this.getMonth(), 1).getDay()
    },
    addDays: function (a) {
        return new Date(this.getTime() + 86400000 * a)
    },
    addSeconds: function (a) {
        return new Date(this.getTime() + 1000 * a)
    },
    trim: function () {
        return new Date(this.getFullYear(), this.getMonth(), this.getDate())
    },
    copy: function () {
        return new Date(this.getTime())
    },
    getWeek: function () {
        return $.weekText[this.getDay()]
    }
});
$.extend(Date, {
    parseDate: function (b, a) {
        if (typeof b === "object") {
            b = new Date(b)
        } else {
            if (typeof b === "string") {
                b = new Date(b.trim().replace(/\-/g, "/"))
            }
        }
        return b == "Invalid Date" ? a : b
    }
});
$.extend(String.prototype, {
    getHashCode: function () {
        var b = 1315423911,
        c,
        a;
        for (c = this.length - 1; c >= 0; c--) {
            a = this.charCodeAt(c);
            b ^= ((b << 5) + a + (b >> 2))
        }
        return (b & 2147483647)
    },
    idxOf: function (b, a) {
        if (!this || !b) {
            return -1
        }
        if (a) {
            return this.indexOf(b)
        } else {
            return this.toLowerCase().indexOf(b.toLowerCase())
        }
    }
});
var $H = {
    zfn: function (a) {
        return function () {
            return a
        }
    },
    radian: function (a) {
        return a * Math.PI / 180
    },
    getDistance: function (f, h, g, j) {
        var e = 6378.137;
        var k = $H.radian(f);
        var m = $H.radian(g);
        var c = k - m;
        var d = $H.radian(h) - $H.radian(j);
        return e * 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(c / 2), 2) + Math.cos(k) * Math.cos(m) * Math.pow(Math.sin(d / 2), 2)))
    },
    submit: function (c) {
        var a = $("<form>").hide().attr({
            method: c.method || "POST",
            action: c.action,
            data: c.data,
            target: c.target || "_self"
        }).appendTo(document.body);
        if (c.data) {
            for (var b in c.data) {
                $("<input>").attr({
                    type: "hidden",
                    name: b,
                    value: encodeURIComponent(c.data[b])
                }).appendTo(a)
            }
        }
        a[0].submit();
        a.remove()
    },
    getCss: function (a) {
        var b = document.getElementsByTagName("head").item(0) || document.documentElement;
        var c = document.createElement("link");
        c.setAttribute("rel", "stylesheet");
        c.setAttribute("type", "text/css");
        c.setAttribute("href", a);
        b.appendChild(c)
    },
    loadScript: function (b) {
        var a = doc.head || doc.getElementsByTagName("head")[0] || docEl,
        d = doc.createElement("script"),
        c;
        if (b.async) {
            d.async = "async"
        }
        d.onreadystatechange = function () {
            if (!(c = d.readyState) || c == "loaded" || c == "complete") {
                d.onload = d.onreadystatechange = null;
                if (a && d.parentNode) {
                    a.removeChild(d)
                }
                d = undefined;
                if (b.success) {
                    b.success()
                }
            }
        };
        d.onload = b.success;
        d.onerror = b.error;
        d.src = b.url;
        a.insertBefore(d, a.firstChild)
    },
    ui: {}
};
$H.klass = function (e, d) {
    var a,
    b,
    c;
    a = function () {
        if (a.uber && a.uber.hasOwnProperty("struct")) {
            a.uber.struct.apply(this, arguments)
        }
        if (a.prototype.hasOwnProperty("struct")) {
            a.prototype.struct.apply(this, arguments)
        }
    };
    e = e || Object;
    b = function () { };
    b.prototype = e.prototype;
    a.prototype = new b();
    a.uber = e.prototype;
    a.prototype.constructor = a;
    for (c in d) {
        if (d.hasOwnProperty(c)) {
            a.prototype[c] = d[c]
        }
    }
    return a
};
$H.tj = function (d, h, a, f) {
    var g = [];
    if (f) {
        g.push("t=" + new Date().getTime())
    }
    for (var b in d) {
        g.push(b + "=" + d[b])
    }
    var e = document.createElement("img");
    e.setAttribute("src", h + "?" + g.join("&"));
    e.style.display = "none";
    if (a) {
        e.addEventListener("load", a, false)
    }
    document.body.appendChild(e)
};
$H.jSon = {
    stringify: function (a) {
        return window.JSON.stringify(a)
    },
    parse: function (a) {
        return window.JSON.parse(a)
    },
    toNvp: function (b) {
        var c = [];
        for (var a in b) {
            c.push(a + "=" + encodeURIComponent(b[a]))
        }
        return c.join("&")
    },
    fromNvp: function (f) {
        if (!f) {
            return {}
        }
        var c = {},
        e = f.split("&"),
        a = decodeURIComponent,
        b,
        g;
        $.each(e,
        function (d, h) {
            h = h.split("=");
            b = a(h[0]);
            g = a(h[1]);
            c[b] = !c[b] ? g : [].concat(c[b]).concat(g)
        });
        return c
    },
    isempty: function (a) {
        if (a) {
            for (i in a) {
                return false
            }
        }
        return true
    }
};
$H.browser = {
    height: function () {
        return $(window).height()
    },
    docHeight: function () {
        return $(document).height()
    },
    scrollHeight: function () {
        return $(window).scrollTop()
    },
    geo: function (b) {
        if ($H.browser.sup.geolocation) {
            if ($H.browser.sup.sessionStorage) {
                var a = $H.session.get("coords");
                if (a && b.onSuccess) {
                    b.onSuccess(a);
                    return
                }
            }
            $.showLoader();
            navigator.geolocation.getCurrentPosition(function (d) {
                if ($H.browser.sup.sessionStorage) {
                    var c = new Date();
                    c.setSeconds(c.getSeconds() + b.expires);
                    $H.session.set("coords", {
                        longitude: d.coords.longitude,
                        latitude: d.coords.latitude
                    },
                    c)
                }
                $.hideLoader();
                if (b.onSuccess) {
                    b.onSuccess(d.coords)
                }
            },
            function (c, d) {
                $.hideLoader();
                if (b.onError) {
                    b.onError(c, d)
                }
            },
            {
                maximumAge: b.maximumAge || 60000,
                enableHighAccuracy: b.enableHighAccuracy || false,
                timeout: b.timeout || 30000
            })
        } else {
            if (b.onError) {
                b.onError(4, "无法获取位置信息")
            }
        }
    },
    ua: navigator.userAgent,
    sup: {
        css3: function () {
            var f = [["-webkit-", "Webkit"]];
            var a = [["background-size:1px 1px", "backgroundSize"], ["border-bottom-left-radius:1px", "borderBottomLeftRadius"], ["transform: rotate(45deg)", "transform"], ["box-shadow:1px 1px 1px #999", "boxShadow"], ["animation: rotate 1s linear infinite", "animation"]];
            var b = document.createElement("i");
            var g = b.style;
            var h,
            e;
            for (var c = 0; c < a.length; c++) {
                h = a[c][1];
                e = 0;
                for (var d = 0; d < f.length; d++) {
                    g.cssText = f[d][0] + a[c][0];
                    if (f[d][1]) {
                        h = h.charAt(0).toUpperCase() + h.substr(1)
                    }
                    if (g[f[d][1] + h] !== undefined) {
                        e = 1;
                        break
                    }
                }
                if (!e) {
                    $H.browser.sup.css3 = $H.zfn(0);
                    return 0
                }
            }
            $H.browser.sup.css3 = $H.zfn(1);
            return 1
        },
        localStorage: function () {
            var d = window.localStorage;
            if (d) {
                var c,
                b = "__lssup";
                try {
                    d.setItem(b, "1");
                    c = d.getItem(b) == "1";
                    d.removeItem(b);
                    d = c
                } catch (a) {
                    d = null
                }
            }
            $H.browser.sup.localStorage = $H.zfn(d);
            return d
        },
        sessionStorage: function () {
            var d = window.sessionStorage;
            if (d) {
                var c,
                b = "__sssup";
                try {
                    d.setItem(b, "1");
                    c = d.getItem(b) == "1";
                    d.removeItem(b);
                    d = c
                } catch (a) {
                    d = null
                }
            }
            $H.browser.sup.sessionStorage = $H.zfn(d);
            return d
        },
        json: function () {
            var a = window.JSON;
            $H.browser.sup.json = $H.zfn(a);
            return a
        },
        selector: function () {
            var a = document.querySelectorAll;
            $H.browser.sup.selector = $H.zfn(a);
            return a
        },
        geolocation: function () {
            var a = navigator.geolocation;
            $H.browser.sup.geolocation = $H.zfn(a);
            return a
        },
        cookie: function () {
            $H.cookie.set("__cookiesup", "1", 9);
            var a = $H.cookie.get("__cookiesup");
            $H.cookie.remove("__cookiesup");
            $H.browser.sup.cookie = $H.zfn(a);
            return a
        }
    },
    info: {
        android: function () {
            var a = $H.browser.ua.idxOf("android", 0) != -1;
            $H.browser.info.android = $H.zfn(a);
            return a
        },
        ios: function () {
            var a = $H.browser.ua.idxOf("ios", 0) != -1 || $H.browser.ua.idxOf("iphone os", 0) != -1;
            $H.browser.info.ios = $H.zfn(a);
            return a
        }
    }
};
$H.cookie = {
    get: function (c) {
        if (!c) {
            return null
        }
        c = c.toUpperCase();
        var a = document.cookie.split("; ");
        var d = null;
        for (var b = 0; b < a.length; b++) {
            d = a[b].split("=");
            if (d[0].toUpperCase() == c) {
                return unescape(d[1])
            }
        }
        return null
    },
    set: function (d, f, c, e) {
        var a = d + "=" + escape(f);
        if (c > 0) {
            var b = new Date();
            b.setTime(b.getTime() + c * 1000);
            a += ";expires=" + b.toGMTString()
        }
        a += ";path=" + (e || "/");
        document.cookie = a
    },
    remove: function (b, c) {
        var a = new Date();
        a.setTime(a.getTime() - 9999);
        document.cookie = b + "=;expires=" + a.toGMTString() + ";path=" + c || "/"
    }
};
$H.storageClass = $H.klass(null, {
    struct: function (a, b, d, c) {
        this.lock = false;
        this.defaultExpires = a;
        this.maxSize = b;
        this.s = d;
        this.ns = c
    },
    size: function (a) {
        if (!isNaN(a) && this.s) {
            this.s.setItem("@" + this.ns + "size", a);
            return a
        } else {
            return parseInt(this.s.getItem("@" + this.ns + "size") || 0)
        }
    },
    set: function (c, g, b, h) {
        if (this.lock) {
            return -5
        }
        if (!c) {
            return -1
        }
        if (!this.s) {
            return -2
        }
        if (!b) {
            b = new Date();
            b.setMinutes(b.getMinutes() + this.defaultExpires)
        }
        var f = $H.jSon.stringify({
            ver: h,
            expr: b,
            val: g
        });
        var d = this.size() + f.length;
        if (d > this.maxSize) {
            return -3
        }
        this.size(d);
        this.remove(c);
        try {
            this.s.setItem(this.ns + c, f)
        } catch (a) {
            return -6
        }
        return d
    },
    get: function (b, c) {
        if (!b) {
            return null
        }
        if (!this.s) {
            return null
        }
        var a = this.s.getItem(this.ns + b);
        if (!a) {
            return null
        }
        a = $H.jSon.parse(a);
        if (!a) {
            return null
        }
        if (!this.lock && (Date.parse(a.expr) <= new Date())) {
            this.remove(this.ns + b);
            return null
        }
        if (a.ver && c && a.ver != c) {
            return null
        }
        return a.val
    },
    remove: function (b) {
        if (this.lock) {
            return false
        }
        if (!b) {
            return false
        }
        if (!this.s) {
            return false
        }
        var a = this.s.getItem(this.ns + b);
        if (a) {
            this.s.removeItem(this.ns + b);
            this.size(this.size() - a.length);
            return true
        }
        return false
    },
    recycle: function () {
        if (this.lock) {
            return
        }
        if (!this.s) {
            return
        }
        this.lock = true;
        var d = new Date();
        var e = 0;
        var f = [];
        for (var a = 0, c, g, b; a < this.s.length; a++) {
            c = this.s.key(a);
            if (!c || c.indexOf(this.ns) != 0) {
                continue
            }
            g = this.s.getItem(c);
            if (g) {
                b = $H.jSon.parse(g);
                if (b) {
                    if (Date.parse(b.expr) <= d) {
                        f.push(c);
                        e += g.length
                    }
                }
            }
        }
        for (var a = 0; a < f.length; a++) {
            this.s.removeItem(f[a])
        }
        this.size(this.size() - e);
        this.lock = false
    }
});
$H.storage = new $H.storageClass(40, 2500000, window.localStorage, "ELH5:");
$H.session = new $H.storageClass(40, 2500000, window.sessionStorage, "ELH5:");
$H.listCache = $H.klass(null, {
    struct: function (a) {
        this.defaultExpiresSecond = a
    },
    set: function (a, c, e, g, b) {
        if (typeof c != "string") {
            return
        }
        var f = [a, ":", c.length > 20 ? c.getHashCode() : c, ":", e || "0"].join("");
        var d = new Date();
        $H.storage.set(f, {
            L: d,
            P: e,
            V: g
        },
        d.addSeconds(b || this.defaultExpiresSecond || 600))
    },
    get: function (a, b, c) {
        if (typeof b != "string") {
            return null
        }
        var d = [a, ":", b.length > 20 ? b.getHashCode() : b, ":", c || "0"].join("");
        d = $H.storage.get(d);
        if (d) {
            return d.V
        }
        return null
    },
    recycle: function () {
        $H.storage.recycle()
    }
});
$H.ajax = function (b) {
    if (b.showLoader) {
        $.showLoader()
    }
    if (!isNaN(b.expires)) {
        b.url = $H.url.queryString({
            expires: (b.expires > 0 ? parseInt(new Date().getTime() / (1000 * b.expires), 10) : new Date().getTime())
        },
        b.url)
    }
    var d = b.timeout;
    d = ((!isNaN(d) && d > 0) ? d : 30) * 1000;
    var e = b.type ? b.type.toUpperCase() : "GET";
    var a = b.dataType ? b.dataType : "html";
    if (a == "json") {
        a = "xjson"
    }
    var c = {
        set: window.setTimeout(function () {
            if (b.showLoader) {
                $.hideLoader()
            }
            window.clearTimeout(c.set);
            c.state = 1;
            if (b.error) {
                b.error("", "ajax timeout", -1)
            }
        },
        d),
        state: 0
    };
    $.ajax({
        type: e,
        url: b.url,
        timeout: d + 60000,
        data: b.data,
        dataType: a == "xjson" ? "html" : a,
        complete: function () {
            window.clearTimeout(c.set);
            if (b.showLoader) {
                $.hideLoader()
            }
            if (b.complete) {
                b.complete()
            }
        },
        success: function (f) {
            if (c.state != 0) {
                return
            }
            if (a == "xjson") {
                try {
                    f = $H.jSon.parse(f);
                    if (b.success) {
                        b.success(f)
                    }
                } catch (g) {
                    if (b.error) {
                        b.error(f, g, -2)
                    }
                }
            } else {
                b.success(f)
            }
        },
        error: function (h, f, g) {
            if (b.error) {
                b.error(f, g, -3)
            }
        }
    })
};
$H.url = {
    queryString: function (f, j) {
        var g = {},
        h,
        a,
        c,
        d;
        if (!j) {
            j = location.href
        }
        h = j.split("?");
        j = h[0];
        if (h.length > 1) {
            h = h[1];
            a = h.split("#");
            h = a[0];
            a = a.length > 1 ? a[1] : ""
        } else {
            h = "";
            a = j.split("#");
            j = a[0];
            a = a.length > 1 ? a[1] : ""
        }
        if (h) {
            d = h.split("&");
            for (var b = 0; b < d.length; b++) {
                c = d[b].split("=");
                g[c[0].toLowerCase()] = decodeURIComponent(c[1])
            }
        }
        if (f) {
            if (typeof f == "object") {
                for (var e in f) {
                    if (f[e] == null) {
                        delete g[e.toLowerCase()]
                    } else {
                        g[e.toLowerCase()] = decodeURIComponent(f[e])
                    }
                }
                h = $H.jSon.isempty(g) ? "" : ("?" + $H.jSon.toNvp(g));
                a = a.length > 0 ? ("#" + a) : "";
                return j + h + a
            } else {
                j = g[f.toLowerCase()];
                return j ? unescape(j) : null
            }
        } else {
            return g
        }
    },
    hash: function (g, h) {
        var a = {},
        d,
        e,
        b;
        if (!h) {
            h = location.href
        }
        b = h.split("#");
        b = b.length > 1 ? b[1] : "";
        if (b) {
            e = b.split("&");
            for (var c = 0; c < e.length; c++) {
                d = e[c].split("=");
                a[d[0].toLowerCase()] = decodeURIComponent(d[1])
            }
        }
        if (g) {
            if (typeof g == "object") {
                for (var f in g) {
                    if (g[f] == null) {
                        delete a[f.toLowerCase()]
                    } else {
                        a[f.toLowerCase()] = decodeURIComponent(g[f])
                    }
                }
                location.hash = $H.jSon.toNvp(a)
            } else {
                h = a[g.toLowerCase()];
                return h ? unescape(h) : null
            }
        }
        return a
    },
    path: function (a) {
        var b = location.href.split(/\?|\#/)[0];
        if (a) {
            b = b + "?" + $H.jSon.toNvp(a)
        }
        return b
    }
};
$H.hashEvent = (function () {
    var a = {
        key: 0,
        fn: 0,
        h0: 0,
        h1: 0,
        popVal: 0,
        bind: function (b, c) {
            a.key = c || "he";
            a.h0 = a.getHash();
            a.h1 = a.h0;
            a.fn = b;
            $(window).bind("hashchange",
            function () {
                var d = a.getHash();
                a.h0 = a.h1;
                a.h1 = d;
                if (a.popVal == 0) {
                    a.trigger(d)
                } else {
                    if (a.popVal == d) {
                        a.trigger(d)
                    } else {
                        a.pop(a.popVal, true)
                    }
                }
            });
            a.trigger(a.h0)
        },
        pop: function (d, b) {
            d = d || null;
            if (d == a.h1) {
                return
            }
            if (!b && a.h0 == null && a.h1 != null) {
                a.popVal = d || 0;
                history.go(-1)
            } else {
                var c = {};
                c[a.key] = d;
                a.popVal = 0;
                $H.url.hash(c)
            }
        },
        getHash: function (b) {
            return $H.url.hash()[a.key] || null
        },
        unbind: function () {
            a.fn = 0
        },
        trigger: function (b) {
            if (a.fn) {
                a.fn(b || "")
            }
        }
    };
    return a
})();
$H.ui.base = $H.klass(null, {
    struct: function (a) { }
});
$H.ui.checkbox = $H.klass($H.ui.base, {
    struct: function (a) {
        if ($(a).length == 0) {
            return null
        }
        this.ckb = $(a);
        this.box = $("<span></span>");
        this.$ = this.ckb.parent().attr("for", this.ckb.attr("id")).append(this.box);
        if (this.ckb.attr("disabled")) {
            this.$.addClass("disabled")
        }
        this.refresh();
        var b = this;
        this.ckb.change(function () {
            b.refresh()
        });
        this.$.bind("click",
        function () { })
    },
    refresh: function () {
        if (this.ckb[0].checked) {
            this.box.addClass("checked")
        } else {
            this.box.removeClass("checked")
        }
    },
    checked: function () {
        if (!this.ckb[0].checked) {
            this.ckb[0].checked = true;
            this.ckb.trigger("change")
        }
    },
    unchecked: function () {
        if (this.ckb[0].checked) {
            this.ckb[0].checked = false;
            this.ckb.trigger("change")
        }
    },
    val: function (a) {
        return this.ckb.val(a)
    },
    ischecked: function () {
        return this.ckb[0].checked
    }
});
$H.ui.radio = $H.klass($H.ui.base, {
    struct: function (a) {
        if ($(a).length == 0) {
            return null
        }
        this.rad = $(a);
        this.circle = $("<span></span>");
        this.$ = this.rad.parent().attr("for", this.rad.attr("id")).append(this.circle);
        if (this.rad.attr("disabled")) {
            this.$.addClass("disabled")
        }
        this.name = this.rad.attr("name");
        this.refresh();
        var b = this;
        this.rad.change(function () {
            b.refresh()
        });
        this.$.bind("click",
        function () { })
    },
    refresh: function () {
        $("input[name=" + this.name + "]").each(function () {
            if ($(this)[0].checked) {
                $(this).next().addClass("checked")
            } else {
                $(this).next().removeClass("checked")
            }
        })
    },
    checked: function () {
        if (!this.rad[0].checked) {
            this.rad[0].checked = true;
            this.rad.trigger("change")
        }
    },
    unchecked: function () {
        if (this.rad[0].checked) {
            this.rad[0].checked = false;
            this.rad.trigger("change")
        }
    },
    val: function (a) {
        return this.rad.val(a)
    },
    ischecked: function () {
        return this.rad[0].checked
    }
});
$H.ui.select = $H.klass($H.ui.base, {
    struct: function (a) {
        if ($(a).length == 0) {
            return null
        }
        this.sel = $(a);
        if ($(a).parent("lable").length == 0) {
            this.sel = $(a).wrap("<lable class='select'></lable>")
        }
        this.$ = this.sel.parent();
        this.txt = $("<span>").appendTo(this.$);
        this.refresh();
        var b = this;
        this.sel.change(function () {
            b.refresh()
        })
    },
    refresh: function () {
        this.txt.html(this.text())
    },
    index: function (b) {
        var a = this.sel[0].selectedIndex;
        if (b !== undefined) {
            if (a != b) {
                this.sel[0].selectedIndex = b;
                this.sel.trigger("change")
            }
        } else {
            return a
        }
    },
    text: function (c) {
        var b = this.sel[0].options[this.index()].innerHTML;
        if (c !== undefined) {
            if (b != c) {
                for (var a = 0; a < this.sel[0].options.length; a++) {
                    if (this.sel[0].options[a].text == c) {
                        this.sel[0].selectedIndex = a;
                        this.sel.trigger("change");
                        break
                    }
                }
            }
        } else {
            return b
        }
    },
    val: function (b) {
        var a = this.sel.val();
        if (b !== undefined) {
            if (a != b) {
                this.sel.val(b);
                this.sel.trigger("change")
            }
        } else {
            return a
        }
    }
});
$H.ui.listview = $H.klass($H.ui.base, {
    struct: function (a) {
        if ($(a).length == 0) {
            return
        }
        this.list = $(a);
        this.items = this.list.children();
        this.items.each(function (b) {
            if ($(this).hasClass("disabled")) {
                $(this).active()
            }
        })
    }
});
$H.ui.editPanel = $H.klass($H.ui.base, {
    struct: function (a) {
        this.ipt = $("#" + a.id);
        if (this.ipt.length == 0) {
            return
        }
        this.cfg = a;
        this.$ = this.ipt.parent();
        this.btn = this.$.children("button");
        this.txt = $("<span>").appendTo(this.$);
        this.refresh();
        var c = this;
        this.ipt.bind("input",
        function () {
            if (c.cfg.oninput) {
                c.cfg.oninput()
            }
        }).bind("focus",
        function () {
            c.$.addClass("active");
            c.btn.show();
            if (c.cfg.onfocus) {
                c.cfg.onfocus()
            }
        });
        var b = {
            n: 0,
            fn: function (d) {
                if (b.n++ == 0) {
                    c.ipt.focus();
                    d.preventDefault && (d.preventDefault(), d.stopPropagation())
                }
            }
        };
        if ($H.browser.info.ios()) {
            this.ipt.bind("blur",
            function () {
                b.n = 0
            });
            this.ipt.bind("touchstart", b.fn)
        }
        this.btn.click(function () {
            c.refresh();
            c.$.removeClass("active");
            c.btn.hide();
            if (c.cfg.onclick) {
                c.cfg.onclick()
            }
        })
    },
    refresh: function () {
        var a = this.ipt.val();
        if (this.cfg.onshow) {
            a = this.cfg.onshow(a)
        }
        if (a != null) {
            this.txt.html(a)
        }
    },
    val: function (a) {
        return this.ipt.val(a)
    }
});
$H.ui.tabs = $H.klass($H.ui.base, {
    struct: function (a) {
        if ($(a).length == 0) {
            return null
        }
        this.$ = $(a);
        this.rads = this.$.find("input");
        this.name = this.rads.attr("name");
        this.refresh();
        var b = this;
        this.rads.change(function () {
            b.refresh()
        });
        this.$.bind("click",
        function () { });
        this.$.children("li").click(function () {
            var c = $(this).children("input")[0];
            if (!c.checked) {
                c.checked = true;
                b.refresh()
            }
        })
    },
    refresh: function () {
        for (var b = 0; b < this.rads.length; b++) {
            var a = $(this.rads[b]).attr("data-for");
            if (this.rads[b].checked) {
                $(this.rads[b]).parent().addClass("active");
                if (a) {
                    $("#" + a).show()
                }
                this.onchange(this.rads[b].value)
            } else {
                $(this.rads[b]).parent().removeClass("active");
                if (a) {
                    $("#" + a).hide()
                }
            }
        }
    },
    val: function (b) {
        if (b !== undefined) {
            for (var a = 0; a < this.rads.length; a++) {
                if (this.rads[a].value == b) {
                    if (!this.rads[a].checked) {
                        this.rads[a].checked = true;
                        this.refresh()
                    }
                    break
                }
            }
        } else {
            for (var a = 0; a < this.rads.length; a++) {
                if (this.rads[a].checked) {
                    return this.rads[a].value
                }
            }
            return null
        }
    },
    onchange: function () { }
});