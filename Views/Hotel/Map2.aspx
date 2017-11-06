<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%http://localhost:14458/Hotel/Newsinfo/28288?key=gh_d8730ae00d36@@userWeixinIDstring hotelid = RouteData.Values["id"].ToString();
    var hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
    //string pos = HotelCloud.Common.HCRequest.GetString("pos");
    string pos = "";
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");


    bool hasuser = true;
    if (weixinID.Equals(""))
    {
        string key = HotelCloud.Common.HCRequest.GetString("key");
        string[] a = key.Split('@');
        if (a.Count() == 3)
        {
            pos = a[2];
        }
        weixinID = key.Split('@')[0];
        
        //判断参数是否齐全
        if (string.IsNullOrEmpty(key)|| key.Split('@').Length <2 || string.IsNullOrEmpty(key.Split('@')[1])) {
            hasuser = false;
        }
        
    }
    int hotelid = hotel.ID;
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,target-densitydpi=medium-dpi,initial-scale=1.0, maximum-scale=1.0,minimum-scale=1.0,user-scalable=no" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-touch-fullscreen" content="yes" />
    <title>
        <%=hotel.SubName %>官网</title>
    <link href="http://css.weikeniu.com/Content/default.css" rel="stylesheet" type="text/css" />
    <%Html.RenderPartial("JSHeader"); %>
</head>
<%Html.RenderPartial("JS"); %>
<body>
    <div id="header">
        <div class="nav">
            <% if (hasuser)
               { %>
          <%--  <a href="javascript:void(0);" class="back" onclick="history.go(-1)">返回</a>--%>
            <a href="/Home/Main/<%=ViewData["hId"] %>?key=<%=ViewData["weixinId"] %>@<%=ViewData["userWeiXinID"] %>" class="back">返回</a>
            <%} %>
            <span>酒店地图</span>
            <% if (hasuser)
               { %>
            <a href="/Home/Main/<%=ViewData["hId"] %>?key=<%=ViewData["weixinId"] %>@<%=ViewData["userWeiXinID"] %>"
                class="tel">电话</a>
            <%} %>
        </div>
    </div>
    <div id="container">
        <div class="map" id="map" style="height: 100%">
            <%--<div id="map" style="width: 100%; height: 100%" ></div>--%>
        </div>
    </div>
    <div id="footer">
        <div class="subnav">
            <ul>
                <li><a class="red" id="dh" href="javascript:void(0)">导航至酒店</a></li>
                <li><a class="orange" id="ms" href="javascript:void(0)">美食</a></li>
                <li><a class="purple" id="jd" href="javascript:void(0)">景点</a></li>
                <li><a class="green" id="jt" href="javascript:void(0)">交通枢纽</a></li>
            </ul>
        </div>
    </div>
</body>
</html>
<script src="http://api.map.baidu.com/api?v=1.2"></script>
<script src="http://js.weikeniu.com/Scripts/jquery_cook.js" type="text/javascript"></script>
<script type="text/javascript">
var a = window.document.referrer;
         $(".back").click(function(){
               if(a!=""){
               history.back(-1);
               }else{
                window.location.href="/Hotel/Index/<%=hotelid %>?weixinID=<%=weixinID %>";
               }
            });
    $(function () {
        // alert($("#header").css("height"));
        //var c = { expires: 1, path: '/' };
        $("#container").css("height", (document.body.clientHeight - parseFloat($("#header").height().toString().replace('px', ''))) + 'px');
        var map = new BMap.Map('map');
        var point = new BMap.Point(<%=hotel.Pos %>);
        var weixinpos = "<%=pos %>";
        if (weixinpos == "") {
            weixinpos = $.cookie('pos');
        } else {
            $.cookie('pos',weixinpos,{});
        }
        map.centerAndZoom(point, 15);
        map.addControl(new BMap.NavigationControl());
        map.addControl(new BMap.ScaleControl());
        map.addControl(new BMap.OverviewMapControl());
        map.enableScrollWheelZoom();
        map.enableKeyboard();
        function ComplexCustomOverlay(point, text, mouseoverText) {
            this._point = point;
            this._text = text;
            this._overText = mouseoverText;
        }
        ComplexCustomOverlay.prototype = new BMap.Overlay();
        ComplexCustomOverlay.prototype.initialize = function (map) {
            this._map = map;
            var div = this._div = document.createElement("div");
            div.style.position = "absolute";
            div.style.zIndex = BMap.Overlay.getZIndex(this._point.lat);
            div.style.backgroundColor = "#EE5D5B";
            div.style.border = "1px solid #BC3B3A";
            div.style.color = "white";
            div.style.height = "18px";
            div.style.padding = "2px";
            div.style.lineHeight = "18px";
            div.style.whiteSpace = "nowrap";
            div.style.MozUserSelect = "none";
            div.style.fontSize = "12px"
            var span = this._span = document.createElement("span");
            div.appendChild(span);
            span.appendChild(document.createTextNode(this._text));
            var that = this;
            var arrow = this._arrow = document.createElement("div");
            arrow.style.background = "url(/Content/images/label.png) no-repeat";
            arrow.style.position = "absolute";
            arrow.style.width = "11px";
            arrow.style.height = "10px";
            arrow.style.top = "22px";
            arrow.style.left = "10px";
            arrow.style.overflow = "hidden";
            div.appendChild(arrow);
            div.onmouseover = function () {
                this.style.backgroundColor = "#6BADCA";
                this.style.borderColor = "#0000ff";
                this.getElementsByTagName("span")[0].innerHTML = that._overText;
                arrow.style.backgroundPosition = "0px -20px";
            }
            div.onmouseout = function () {
                this.style.backgroundColor = "#EE5D5B";
                this.style.borderColor = "#BC3B3A";
                this.getElementsByTagName("span")[0].innerHTML = that._text;
                arrow.style.backgroundPosition = "0px 0px";
            }
            map.getPanes().labelPane.appendChild(div);
            return div;
        }
        ComplexCustomOverlay.prototype.draw = function () {
            var map = this._map;
            var pixel = map.pointToOverlayPixel(this._point);
            this._div.style.left = pixel.x - parseInt(this._arrow.style.left) + "px";
            this._div.style.top = pixel.y - 30 + "px";
        }
        var myCompOverlay = new ComplexCustomOverlay(point, "<%=hotel.SubName %>", "酒店位置");
        map.addOverlay(myCompOverlay);
        $("#jd").click(function () {
            $(this).closest("div").find("li").removeClass("cur");
            $(this).parent().addClass("cur");
            map.panTo(point);
            map.clearOverlays();
            mark = 1;
            map.addOverlay(myCompOverlay);
            search("景点");
            //map.addEventListener("dragend",jd);
        });
        $("#ms").click(function () {
            map.setZoom(15);
            $(this).closest("div").find("li").removeClass("cur");
            $(this).parent().addClass("cur");
            map.panTo(point);
            map.clearOverlays();
            mark = 1;
            map.addOverlay(myCompOverlay);
            searchnearms();
        });
        $("#dh").click(function () {
            $(this).closest("div").find("li").removeClass("cur");
            $(this).parent().addClass("cur");
            map.clearOverlays();
            mark = 1;
            map.addOverlay(myCompOverlay);
            //ashbur
            if (weixinpos == ""||weixinpos==null) {                  
                var geolocation = new BMap.Geolocation();
                geolocation.getCurrentPosition(function(r){
                    if(this.getStatus() == BMAP_STATUS_SUCCESS){
                        weixinpos=r.point.lng+','+r.point.lat; 
                         var p1 = new BMap.Point(parseFloat(weixinpos.split(',')[0]), parseFloat(weixinpos.split(',')[1]));
                         mark = addMarker(p1);
                        var driving = new BMap.DrivingRoute(map, { renderOptions: { map: map, autoViewport: true} });
                         driving.search(p1, point);                   
                    }else{
                        alert("定位失败，请返回微信发送位置！");
                    } 
                },{enableHighAccuracy: true})
            }else{ 
            var p1 = new BMap.Point(parseFloat(weixinpos.split(',')[0]), parseFloat(weixinpos.split(',')[1]));
               mark = addMarker(p1);
                var driving = new BMap.DrivingRoute(map, { renderOptions: { map: map, autoViewport: true} });
                driving.search(p1, point); 
            }
        });
        var mark = 1;
        function addMarker(point2) {
            var size= map.getDistance(point,point2);
            var marker = new ComplexCustomOverlay(point2, "当前位置", "距离酒店:"+((size/1000.00).toFixed(3))+"公里");
            map.addOverlay(marker);
            return marker;
        }

        $("#jt").click(function () {
            map.setZoom(15);
            $(this).closest("div").find("li").removeClass("cur");
            $(this).parent().addClass("cur");
            map.panTo(point);
            map.clearOverlays();
            mark = 1;
            map.addOverlay(myCompOverlay);
            var myKeys = ["机场", "火车站", "长途汽车站"];
            var local = new BMap.LocalSearch(map, {
                renderOptions: { map: map, panel: "r-result" }
            });
            local.setPageCapacity(15);
            local.searchInBounds(myKeys, map.getBounds());
        });

        /**
        * 得到圆的内接正方形bounds
        * @param {Point} centerPoi 圆形范围的圆心
        * @param {Number} r 圆形范围的半径
        * @return 无返回值   
        */
        function getSquareBounds(centerPoi, r) {
            var a = Math.sqrt(2) * r; //正方形边长

            mPoi = getMecator(centerPoi);
            var x0 = mPoi.x, y0 = mPoi.y;

            var x1 = x0 + a / 2, y1 = y0 + a / 2; //东北点
            var x2 = x0 - a / 2, y2 = y0 - a / 2; //西南点

            var ne = getPoi(new BMap.Pixel(x1, y1)), sw = getPoi(new BMap.Pixel(x2, y2));
            return new BMap.Bounds(sw, ne);

        }
        //根据球面坐标获得平面坐标。
        function getMecator(poi) {
            return map.getMapType().getProjection().lngLatToPoint(poi);
        }
        //根据平面坐标获得球面坐标。
        function getPoi(mecator) {
            return map.getMapType().getProjection().pointToLngLat(mecator);
        }
        function searchnearms() {
            var circle = new BMap.Circle(point, 1000, { fillColor: "", strokeWeight: 1, fillOpacity: 0.3, strokeOpacity: 0.3 });
            map.addOverlay(circle);
            var local = new BMap.LocalSearch(map, { renderOptions: { map: map, autoViewport: false} });
            var bounds = getSquareBounds(circle.getCenter(), circle.getRadius());
            local.searchInBounds("美食", bounds);
        }

        function search(s) {
            var local = new BMap.LocalSearch(map, {
                renderOptions: { map: map }
            });
            local.searchInBounds(s, map.getBounds());
        }
    });

</script>
