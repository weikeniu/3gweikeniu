<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%string hotelid = RouteData.Values["id"].ToString();
  var hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
  //string pos = HotelCloud.Common.HCRequest.GetString("pos"); 
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
  string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO",weixinID);
  string pos="";
 
  if (weixinID.Equals(""))
  {
      string key = HotelCloud.Common.HCRequest.GetString("key");
      string []a = key.Split('@');
      if (a.Count() == 3) {
          pos = a[2];
      }
      weixinID = key.Split('@')[0];
  }
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,target-densitydpi=medium-dpi,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-touch-fullscreen" content="yes" />
    <title><%=hotel.SubName %>官网</title>
    <link href="/Content/default.css" rel="stylesheet" type="text/css" />
    <link href="/css/style.css" rel="stylesheet" type="text/css" />
    <script type="application/x-javascript">addEventListener('load',function(){setTimeout(function(){scrollTo(0,1);},0);},false);</script> 
</head>
<%Html.RenderPartial("JS"); %>
<style type="text/css">
body, html,#map {width: 100%;height: 100%;overflow: hidden;margin:0;}
</style>
<body>
    <div id="mapnav">
        <p class="transparent"></p>
        <ul>
            <li><a href="javascript:void(0)" id="dh">导航到酒店</a></li>
            <li><a href="javascript:void(0)" id="ms">美食</a></li>
            <li><a href="javascript:void(0)" id="jd">景点</a></li>
            <li><a href="javascript:void(0)" id="jt">交通</a></li>
        </ul>
    </div>
    <div id="container">
    <div id="map" class="map">
   </div></div>
    <div id="navigation">
        <ul>
           <li class="cur"><a href="/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>">预订</a></li>
            <li><a href="/Hotel/Info/<%=hotelid %>?weixinID=<%=weixinID %>">简介</a></li>
            <li><a href="/Hotel/Images/<%=hotelid %>?weixinID=<%=weixinID %>">图片</a></li>
            <li><a href="/Hotel/Map/<%=hotelid %>?weixinID=<%=weixinID %>">地图</a></li>
        </ul>
    </div>
</body>
</html>
<script src="http://api.map.baidu.com/api?v=1.2"></script>
<script src="/Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
<script src="/Scripts/jquery_cook.js" type="text/javascript"></script>
<script type="text/javascript">

     $(function () {
   $("#mapnav>ul>li").each(function() {
			$(this).click(function(){
				switch($(this).index()){
					case 0: 
						$(this).attr("class", "orange").siblings("li").removeClass(); 
						break;
					case 1: 
						$(this).attr("class", "green").siblings("li").removeClass(); 
						break;
					case 2: 
						$(this).attr("class", "red").siblings("li").removeClass(); 
						break;
					case 3: 
						$(this).attr("class", "blue").siblings("li").removeClass(); 
						break;
				}
			});
		});
        $("#navigation>ul>li").each(function() {
			$(this).click(function(){
				$(this).attr("class", "cur").siblings("li").removeClass(); 
			});
		});
        $("#container").css("height", (document.body.clientHeight - parseFloat($("#mapnav").height().toString().replace('px', ''))) + 'px');
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
            var pixel = map.pointToOverlayPixel(this._point);//根据地理坐标获取对应的覆盖物容器的坐标，此方法用于自定义覆盖物
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
            map.panTo(point);
            map.clearOverlays();
            mark = 1;
            map.addOverlay(myCompOverlay);//将覆盖物添加到地图中，一个覆盖物实例只能向地图中添加一次。
            var myKeys = ["机场", "火车站", "长途汽车站"];
            var local = new BMap.LocalSearch(map, {
                renderOptions: { map: map, panel: "r-result" }//panel结果列表的HTML容器id或容器元素，提供此参数后，结果列表将在此容器中进行展示。此属性对LocalCity无效。
            });
            local.setPageCapacity(15);//设置每页容量，取值范围：1 - 100，对于多关键字检索，每页容量表示每个关键字返回结果的数量（例如当用2个关键字检索时，实际结果数量范围为：2 - 200）。此值只对下一次检索有效。
            local.searchInBounds(myKeys, map.getBounds());//区域检索
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

            var ne = getPoi(new BMap.Pixel(x1, y1)), sw = getPoi(new BMap.Pixel(x2, y2));//Pixel创建像素点对象实例。像素坐标的坐标原点为地图区域的左上角。
            return new BMap.Bounds(sw, ne);

        }
        //根据球面坐标获得平面坐标。
        function getMecator(poi) {
            return map.getMapType().getProjection().lngLatToPoint(poi);//getMapType返回地图类型getProjection返回地图类型所使用的投影实例。lngLatToPoint(lngLat:Point)根据球面坐标获得平面坐标。
        }
        //根据平面坐标获得球面坐标。
        function getPoi(mecator) {
            return map.getMapType().getProjection().pointToLngLat(mecator);
        }
        function searchnearms() {
            var circle = new BMap.Circle(point, 1000, { fillColor: "", strokeWeight: 1, fillOpacity: 0.3, strokeOpacity: 0.3 });//创建圆覆盖物strokeWeight	圆形边线的宽度，以像素为单位。fillOpacity 圆形填充的透明度，取值范围0 - 1。strokeOpacity 圆形边线透明度，取值范围0 - 1。
            map.addOverlay(circle);
            var local = new BMap.LocalSearch(map, { renderOptions: { map: map, autoViewport: false} });//autoViewport检索结束后是否自动调整地图视野。此属性对LocalCity无效。
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
