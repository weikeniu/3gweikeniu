<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE HTML>
<% 
    var hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
    
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
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta name="keywords" content="关键词1,关键词2,关键词3" />
    <meta name="description" content="对网站的描述" />
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <title><%=hotel.SubName %>官网</title>
    <link href="../../css/booklist/sale-date.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>

    <style>
       #r-result{width:100%;}
    </style>
     <link href="http://css.weikeniu.com/Content/default.css" rel="stylesheet" type="text/css" />
    <%Html.RenderPartial("JSHeader"); %>
</head>
<body>
	<section class="map-box">
		<div class="map" id="map" style="width: 100%;height: 100%;"></div>
        <div class="btn-bar">
			<div class="fl btn yu-grid yu-alignc yu-lmar50" id="goback">
				<p class="l-arr"></p>
			</div>
			<div class="fr btn yu-grid yu-alignc yu-rmar10" id="gofor">
				<p class="dh-ico"></p>
				<p class="yu-overflow yu-white">导航</p>
			</div>
			
		</div>
	</section>
	<section class="fix-bottom-box yu-bgw">
		<div class="yu-grid map-btn-row yu-h60 yu-alignc yu-lrpad10 yu-textc" id="div-bar">
			<p class="yu-bor1 bor yu-overflow2" id="jt">交通</p>
			<p class="yu-bor1 bor yu-overflow2" id="cy">餐饮</p>
			<p class="yu-bor1 bor yu-overflow2" id="yl">娱乐</p>
			<p class="yu-bor1 bor yu-overflow2" id="jd">景点</p>
		</div>
		<div class="map-slide-bottom" >
			<ul class="map-slide-bottom-inner yu-lrpad10 yu-textl" style="height:200px; overflow:scroll;"  id="r-result">
				<%--<li class="yu-bor bbor yu-tbpad10 yu-pos-r">
					<p>广州东站</p>
					<ul class="yu-font12 yu-c66">
						<li class="yu-grid yu-alignc">
							<p class="ico type1"></p>
							<p>距酒店3.7公里</p>
						</li>
						<li class="yu-grid yu-alignc">
							<p class="ico type2"></p>
							<p>(020)61346610</p>
						</li>
						<li class="yu-grid yu-alignc">
							<p class="ico type3"></p>
							<p>广州市天河区东站路1号</p>
						</li>
					</ul>
					<div class="navigation-btn yu-bor1 bor">导航</div>
				</li>
				--%>
                <li class="yu-textc yu-tbpad20">正在玩命加载数据中...</li>
			</ul>
			
		</div>
	</section>
	<script>
	    var a = window.document.referrer;
	    $("#goback").click(function () {
	        if (a != "") {
	            history.back(-1);
	        } else {
	            window.location.href = "/home/main/<%=hotelid %>?key=<%=ViewData["key"] %>";
	        }
	    });


	    $(function () {
	        //按钮
	        $(".map-btn-row>p").on("click", function () {
	            $(this).toggleClass("cur").siblings().removeClass("cur");
	            if ($(this).hasClass("cur")) {
	                $(".map-slide-bottom").slideDown(200);
	                $(".fix-bottom-box").addClass("cur");
	            } else {
	                $(".map-slide-bottom").slideUp(200);
	                $(".fix-bottom-box").removeClass("cur");

	            }
	        })
	        //箭头 
	        $(".map-slide-bottom>.arr").click(function () {
	            $(this).toggleClass("cur");
	            $(".map-slide-bottom-inner").toggleClass("cur");
	            if (!$(this).hasClass("cur")) {
	                $(".map-slide-bottom-inner").scrollTop(0);
	            };
	        })

	        
	    })
	</script>
</body>
</html>

<script src="http://api.map.baidu.com/api?v=1.2"></script>
<script src="http://js.weikeniu.com/Scripts/jquery_cook.js" type="text/javascript"></script>
<script type="text/javascript">

     $(function () {
         
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
        map.enableScrollWheelZoom(true);
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
        $("#jd").click(function () 
        {
           if ($(this).hasClass("cur")){
                var myKeys = ["公园", "景点"];
                search2(myKeys);
            }
             
        });


        $("#cy").click(function () {
             if ($(this).hasClass("cur")){
               var myKeys = ["美食", "餐饮"];
               search2(myKeys);
             }
        });

        $('#yl').click(function()
        {   
            if ($(this).hasClass("cur")){
              var myKeys = ["娱乐"];
              search2(myKeys);
            }
        });


        $("#jt").click(function () {
            if ($(this).hasClass("cur")){
                var myKeys = ["机场", "火车站", "长途汽车站"];
                search2(myKeys);
            }
        });

        //顶部导航
        $("#gofor").click(function () {
            dh2('<%=hotel.SubName %>',0);
            return;
            //
            $(".map-slide-bottom").hide();
            $("#div-bar").children("p").removeClass("cur");

            var map = new BMap.Map("map");
	        map.centerAndZoom(new BMap.Point(<%=hotel.Pos %>), 15);
            map.addControl(new BMap.NavigationControl());
            map.addControl(new BMap.ScaleControl());
            map.addControl(new BMap.OverviewMapControl());
            map.enableScrollWheelZoom(true);
            map.enableKeyboard();

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
                         
                           var juli= map.getDistance(point,p1);

                           dh2('<%=hotel.SubName %>',juli)
                         
                         //mark = addMarker(p1);
                         //var driving = new BMap.DrivingRoute(map, { renderOptions: { map: map, autoViewport: true} });
                         //driving.search(p1, point);                   
                    }else{
                        alert("定位失败，请返回微信发送位置！");
                    } 
                },{enableHighAccuracy: true})
            }else{ 
                var p1 = new BMap.Point(parseFloat(weixinpos.split(',')[0]), parseFloat(weixinpos.split(',')[1]));
                
                var juli= map.getDistance(point,p1);
                 dh2('<%=hotel.SubName %>',juli)

               //mark = addMarker(p1);
               //var driving = new BMap.DrivingRoute(map, { renderOptions: { map: map, autoViewport: true} });
               //driving.search(p1, point); 
            }
        });

        var mark = 1;
        function addMarker(point2) {
            var size= map.getDistance(point,point2);
            var marker = new ComplexCustomOverlay(point2, "当前位置", "距离酒店:"+((size/1000.00).toFixed(3))+"公里");
            map.addOverlay(marker);
            return marker;
        }


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

        function search2(s)
        {
            document.getElementById("r-result").innerHTML = '<li class="yu-textc yu-tbpad20">正在玩命加载数据中...</li>';
            var map = new BMap.Map("map");
	        map.centerAndZoom(new BMap.Point(<%=hotel.Pos %>), 15);
            map.addControl(new BMap.NavigationControl());
            map.addControl(new BMap.ScaleControl());
            map.addControl(new BMap.OverviewMapControl());
            map.enableScrollWheelZoom(true);
            map.enableKeyboard();
            var options = {
		        onSearchComplete: function(results){
			        if (local.getStatus() == BMAP_STATUS_SUCCESS){
				        var array=new Array();
                        var html='';
                        if(results.length!=undefined)
                        {
                           for(var k=0;k<results.length;k++)
                           {
                               var r=results[k];
                               array.push(r);
                           }
                        }else{
                            array.push(results);
				       }
                        
                        for(var j=0;j<array.length;j++){
                        var item=array[j];
                        for (var i = 0; i < item.getCurrentNumPois(); i ++){
                                var pointA=new BMap.Point(item.getPoi(i).point.lng,item.getPoi(i).point.lat);
                                var pointB=new BMap.Point(<%=hotel.Pos %>);
					            var juli=(map.getDistance(pointA,pointB)/1000).toFixed(2);
                                //console.log(item.getPoi(i));
                                //console.log(item.getPoi(i).url);
                                html+='<li class="yu-bor bbor yu-tbpad10 yu-pos-r">'
					            +'<p>'+item.getPoi(i).title+'</p>'
					            +'<ul class="yu-font12 yu-c66">'
					            +'	<li class="yu-grid">'
					            +'		<p class="ico type1"></p>'
					            +'		<p class="yu-overflow yu-tpad5">距酒店'+juli+'km</p>'
					            +'	</li>';
                                if(item.getPoi(i).phoneNumber!=undefined){
					            html+='	<li class="yu-grid yu-alignc">'
					            +'		<p class="ico type2"></p>'
					            +'		<a style="color:gray;" href="tel:'+item.getPoi(i).phoneNumber+'">'+item.getPoi(i).phoneNumber+'</a>'
					            +'	</li>';
                                }
					            html+='	<li class="yu-grid yu-alignc">'
					            +'		<p class="ico type3"></p>'
					            +'		<p>'+item.getPoi(i).address+'</p>'
					            +'	</li>'
					            +'</ul>'
                                +'<div class="navigation-btn yu-bor1 bor" onclick="dh2(\''+item.getPoi(i).title+'\','+juli+')">导航</div>'
                                //+'<div class="navigation-btn yu-bor1 bor" onclick="dh2(\''+item.getPoi(i).point.lng+'\',\''+item.getPoi(i).point.lat+'\')">导航</div>'
				                +'</li>';
				            }
                        }
                        
                        html+='<li class="yu-textc yu-tbpad20">没有更多数据了</li>';
                        document.getElementById("r-result").innerHTML = html;
			        }
		        },
                renderOptions:{map:map}
	        };
            var point = new BMap.Point(<%=hotel.Pos %>);
            var myCompOverlay = new ComplexCustomOverlay(point, "<%=hotel.SubName %>", "酒店位置");
	        var local = new BMap.LocalSearch(map, options);
            map.panTo(point);
            map.clearOverlays();
            mark = 1;
            map.addOverlay(myCompOverlay);
	        local.search(s);
        }


    });
           //直接跳转百度地图
           function dh2(end,juli)
           {
               var type=3;
               if(juli>2)
               {
                  type=2;
               }
               var url="http://map.baidu.com/mobile/webapp/place/linesearch/foo=bar/from=place&end=%3d"+end+"%26&routeType="+type;
               
               window.open(url);
           }
           //获取导航面板数据
           function daohang(lng,lat){
                var point = new BMap.Point(<%=hotel.Pos %>);
                var pointEnd=new BMap.Point(lng,lat);

                var map = new BMap.Map("map");
	            map.centerAndZoom(new BMap.Point(<%=hotel.Pos %>), 15);
	            map.addControl(new BMap.NavigationControl());
                map.addControl(new BMap.ScaleControl());
                map.addControl(new BMap.OverviewMapControl());
                map.enableScrollWheelZoom(true);
                map.enableKeyboard();

//              var walking = new BMap.WalkingRoute(map, {renderOptions: {map: map, panel: "r-result", autoViewport: true}});
//	            walking.search('体育中心', '珠江新城');

//              var walking = new BMap.WalkingRoute(map, {renderOptions:{map: map, autoViewport: true}});
//	            walking.search('珠江新城', point);
                
                
//                var driving = new BMap.DrivingRoute(map, { renderOptions: { map: map, autoViewport: true} });
//                driving.search(point,pointEnd); 
                 
//                  var driving = new BMap.DrivingRoute(map, {renderOptions: {map: map, panel: "r-result", autoViewport: true}});
//	              driving.search(point, pointEnd);
            };
</script>
