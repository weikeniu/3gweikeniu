<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    var hQuery = ViewData["hQuery"] as hotel3g.Models.Home.TravelAgencyHotelQuery;
    var qJson = Newtonsoft.Json.JsonConvert.SerializeObject(hQuery);
    var defCityId = Convert.ToInt32(ViewData["defCityId"]);
 %>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta name="format-detection" content="telephone=no">
<!--自动将网页中的电话号码显示为拨号的超链接-->
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
<!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
<meta name="apple-mobile-web-app-capable" content="yes">
<!--IOS设备-->
<meta name="apple-touch-fullscreen" content="yes">
<!--IOS设备-->
<meta http-equiv="Access-Control-Allow-Origin" content="*">
<title><%=hQuery.QType == 0?"附近酒店":hQuery.CityName+"酒店" %></title>
<link type="text/css" rel="stylesheet" href="../../swiper/swiper-3.4.1.min.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/jquery-ui.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/Restaurant.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/new-style.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/fontSize.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/travel.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/font/iconfont.css"/>
<style>                                     
	.room-num{
		display: none;
	}
	#datepicker{
		max-width: 7.5rem;
		padding-bottom: 1.2rem;
		box-sizing: border-box;
	}
	.room-price-d{
		display: none;
	}
	.ui-datepicker td span, .ui-datepicker td a{
		line-height: 1.08rem;
	}
	#datepicker .specialdays a{
		line-height: .8rem;
	}
	.specialdays.first::after,.specialdays.last::after{
		top: .55rem;
	}
	.data-btn.sub{
		background: #12B7F5;
	}
	.tab-nav.type3>.cur {
    border-bottom: 0;
    line-height: 1rem;
    height: 1rem;
}
.icon{background:none;display:inline-block;overflow:hidden;fill:currentColor;margin-top:0;vertical-align:-.4em;height:1.4em;width:1.4em;}
.near-pic2{
		height:2.3rem; width: 2.1rem; position:relative;
	}
</style>
</head>
<body class="yu-bgw" style="overflow:auto">
<section class="loading-page" style="position: fixed;">
	<div class="inner">
		<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
		<img src="http://css.weikeniu.com/images/loading-n.png" />
	</div>
</section>
<div id="mainDiv" data-type="1">
<input type="hidden" value = '1' id="hPage"/>
<input type="hidden" value = '<%=qJson%>' id="qJson"/>
<section class="yu-h80r yu-bgw yu-bor bbor yu-grid yu-alignc yu-lpad20r ">
		<a href="javascript:void(0)" class="yu-blue2 yu-f20r yu-grid yu-alignc J_selectDate">
			<div class="yu-overflow yu-rmar10r">
				<div class="J_inRoomDate"><span class="yu-rmar8r">住</span><span data-date="<%=hQuery.InRoomDate %>"><%=hQuery.InRoomDate.Substring(5, hQuery.InRoomDate.Length-5)%></span></div>
				<div class="J_lveRoomDate" ><span class="yu-rmar8r">离</span><span data-date="<%=hQuery.LvRoomDate %>"><%=hQuery.LvRoomDate.Substring(5, hQuery.LvRoomDate.Length-5)%></span></div>
			</div>
			<span class="t-arr"></span>
		</a>
		<div class="yu-overflow yu-lrpad20r">
			<div class="search-bg2 yu-grid yu-alignc">
				<span class="iconfont icon-soushuo1 yu-rmar10r"></span>
				<input type="text" class="yu-overflow" placeholder="搜索关键字/位置/品牌/酒店名" id="qKeyWord" data-kwdata="-1,-1"/>
			</div>
		</div>
	</section>
<section class="yu-grid yu-lrpad20r yu-h65r yu-bor bbor yu-alignc J_curLocation" style="display:none">
	<p class="yu-overflow yu-f24r">当前位置：定位中...</p>
	<span class="icon-shuaxin iconfont yu-blue yu-f36r"></span>
</section>
 <article class="nodata-page" id="noRes" style="display: none;">
<section class="yu-tpad120r">
<div class="no-r-ico"></div>
<p class="yu-c77 yu-f28r yu-textc">抱歉，未找到您想要的结果！</p>
</section>
 </article>
<ul class="yu-lpad20r" id="hotelList"></ul>
    <p style="text-align:center;color:#aaa;padding:10px 0px 10px 0px;display:none;" id="nomore">没有更多了...</p>
    <br /><br /><br /><br />
	<footer class="screen-bottom yu-grid yu-alignc yu-f26r yu-c22">
 	<div class="yu-overflow">
 		<div class="yu-grid yu-alignc yu-j-c">
 			<p class="yu-rmar10r J_selectArea1" data-cityid="0">城市</p>
 			<p class="arr"></p>
 		</div>
 	</div>
 	<div class="yu-overflow">
 		<div class="yu-grid yu-alignc yu-j-c sort-btn">
 			<p class="yu-rmar10r J_specSort" data-sortid= 1>推荐排序</p>
 			<p class="arr"></p>
 		</div>
 	</div>
 	<div class="yu-overflow">
 		<div class="yu-grid yu-alignc yu-j-c screen-btn">
 			<p class="yu-rmar10r">筛选</p>
 			<p class="arr"></p>
 		</div>
 	</div>
 </footer>
 <!--排序-->
 <div class="mask sort-mask">
 	<div class="mask-inner ">
 		<ul class="yu-f26r sort-list">
 			<li class="yu-grid yu-alignc yu-blue">
 				<p class="iconfont icon-gouxuan yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r" data-sortid=1>推荐排序</p>
 			</li>
 			<li class="yu-grid yu-alignc">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r" data-sortid=2>距离优先</p>
 			</li>
 			<li class="yu-grid yu-alignc">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r" data-sortid=3>低价优先</p>
 			</li>
 			<li class="yu-grid yu-alignc">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r" data-sortid=4>高价优先</p>
 			</li>
 			<li class="yu-grid yu-alignc">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r" data-sortid=5>星级优先</p>
 			</li>
 		</ul>
 	</div>
 </div>
 <!--筛选-->
 <div class="mask screen-mask">
 	<div class="mask-inner yu-lrpad20r">
 		<div class="yu-grid yu-h90r yu-f32r yu-alignc yu-bor bbor yu-textc yu-j-s  yu-bmar60r" >
 			<p class="yu-w120r cancel-btn2 J_maskReset">重置</p>
 			<p class="yu-w120r yu-blue2  cancel-btn2 J_maskOK">完成</p>
 		</div>
 		<dl class="yu-bor bbor yu-bmar60r">
 			<dt class="yu-f26r yu-c99 yu-bmar30r">价格筛选(¥)</dt>
	 		<dd class="yu-grid yu-j-s price-screen J_screenPrice">
	 			<div class="cur">不限</div>
	 			<div>0-150</div>
	 			<div>150-300</div>
	 			<div>300-600</div>
	 			<div>600-1000</div>
	 			<div>1000+</div>
	 			
	 		</dd>
	 	</dl>
	 	<dl class="">
 			<dt class="yu-f26r yu-c99 yu-bmar30r">类别筛选(复选)</dt>
	 		<dd class="yu-grid yu-j-s type-screen J_screenType">
	 			<div class="cur" data-id=0>不限</div>
	 			<div data-id=2>二星级及以下/经济</div>
	 			<div data-id=3>三星级/舒适</div>
	 			<div data-id=4>四星级/高档</div>
	 			<div data-id=5>五星级/豪华</div>
	 		</dd>
	 	</dl>
 	</div>
 </div>
</div>
 <!--关键字-->
 <div id="selectKeyWord" style="display:none">
 <section class="yu-h80r yu-bgw yu-bor bbor yu-grid yu-alignc yu-lpad20r ">
		<a class="yu-back-arr J_kwBack" href="javascript:void(0)"></a>
		<div class="yu-overflow">
			<div class="search-bg2 yu-grid yu-alignc">
				<span class="iconfont icon-soushuo1 yu-rmar10r yu-c99"></span>
				<input type="text" class="yu-overflow J_rtKeyWord" placeholder="搜索关键字/位置/品牌/酒店名"/>
				<i class="ico-close J_iptClear">×</i>
			</div>
		</div>
		<a class="yu-f26r yu-blue2 yu-lrpad20r J_kwSure">确认</a>
</section>
<section class="tab-con type2 yu-grid">
	<ul class="tab-nav type3 yu-f28r " id="kwTagName">
		<li class="cur">品牌</li>
		<li>行政区</li>
        <li>商圈</li>
	</ul>
	<ul class="tab-inner yu-overflow yu-lrpad20r">
		<li class="cur">
			<ul class="tab-inner-scroll type2 yu-f26r J_brand" data-kwtype=1>
			</ul>
		</li>
		<li>
			<ul class="tab-inner-scroll type2 yu-f26r J_area" data-kwtype=2>
			</ul>
		</li>
        <li>
			<ul class="tab-inner-scroll type2 yu-f26r J_tradingArea" data-kwtype=3>
			</ul>
		</li>
	</ul>
</section>
 </div>
 <!--日历-->
 <div id="selectDate" style="display:none">
<div id="datepicker"></div>
<div class="selectNum" style="display:none">1</div>
</div>
<!--区域-->
<div id="selectArea" style="display:none">
<section class="yu-lpad20r yu-tpad40r">
	<dl class="yu-bmar40r">
		<dt class="yu-c77 yu-f26r yu-bmar30r">我的位置</dt>
		<dd class="yu-grid select-item yu-flex-w-w">
			<p class="sp" id="curPos" data-pos data-cityname=''>定位中...</p>
		</dd>
	</dl>
	<dl>
		<dt class="yu-c77 yu-f26r yu-bmar30r">热门</dt>
		<dd class="yu-grid select-item yu-flex-w-w select-item J_hotCity">
		</dd>
	</dl>
</section>
<section class="letter">
	<dl>
		<dt id="a">A</dt>
		<dt id="b">B</dt>
        <dt id="c">C</dt>
		<dt id="d">D</dt>
        <dt id="e">E</dt>
		<dt id="f">F</dt>
        <dt id="g">G</dt>
		<dt id="h">H</dt>
        <dt id="i">I</dt>
		<dt id="j">J</dt>
        <dt id="k">K</dt>
		<dt id="l">L</dt>
        <dt id="m">M</dt>
		<dt id="n">N</dt>
        <dt id="o">O</dt>
		<dt id="p">P</dt>
        <dt id="q">Q</dt>
		<dt id="r">R</dt>
        <dt id="s">S</dt>
		<dt id="t">T</dt>
        <dt id="u">U</dt>
		<dt id="v">V</dt>
        <dt id="w">W</dt>
		<dt id="x">X</dt>
        <dt id="y">Y</dt>
		<dt id="z">Z</dt>
	</dl>
</section>
<%--<ul class="index">
	<li><a href="#a">A</a></li>
	<li><a href="#b">B</a></li>
	<li><a href="#c">C</a></li>
	<li><a href="#d">D</a></li>
	<li><a href="#e">E</a></li>
	<li><a href="#f">F</a></li>
	<li><a href="#g">G</a></li>
	<li><a href="#h">H</a></li>
	<li><a href="#i">I</a></li>
	<li><a href="#j">J</a></li>
	<li><a href="#k">K</a></li>
	<li><a href="#l">L</a></li>
	<li><a href="#m">M</a></li>
	<li><a href="#n">N</a></li>
	<li><a href="#o">O</a></li>
	<li><a href="#p">P</a></li>
	<li><a href="#q">Q</a></li>
	<li><a href="#r">R</a></li>
	<li><a href="#s">S</a></li>
	<li><a href="#t">T</a></li>
	<li><a href="#u">U</a></li>
	<li><a href="#v">V</a></li>
	<li><a href="#w">W</a></li>
	<li><a href="#x">X</a></li>
	<li><a href="#y">Y</a></li>
	<li><a href="#z">Z</a></li>
</ul>--%>
</div>
<script type="text/javascript" src="../../Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="../../swiper/swiper-3.4.1.jquery.min.js"></script>
<script type="text/javascript" src="../../Scripts/fontSize.js"></script>
<script src="../../Scripts/layer/layer.js" type="text/javascript"></script>
<script type="text/javascript" src="../../css/booklist/jquery-ui.js"></script>
<script type="text/javascript" src="../../css/booklist/date-range-picker.js"></script>
<script type="text/javascript" src="../../css/booklist/font/iconfont.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=Y4ofkWPl6nHN41oFEZj39HPA"></script>
<script src="../../Scripts/pca.js" type="text/javascript"></script>
<script type="text/javascript">
    var hq = $.parseJSON($("#qJson").val());//首页的查询条件
    var hasHotelConditionIDsDic = []; //拥有酒店的条件Id字典,城市、行政区、品牌、商圈能查到酒店的才供选择
    $(function () {
        initMainPage();
    })

    /*******主要页 s*******/
    function initMainPage() {
        $(".screen-bottom>div").on("click", function () {
            $(this).toggleClass("cur").siblings().removeClass("cur");
        })
        //mask通用
        $(".mask").click(function () {
            $(this).fadeOut();
            $(".screen-bottom>div").removeClass("cur");

        })
        $(".mask-inner").click(function (e) {
            e.stopPropagation();
        })
        //排序
        $(".sort-btn").click(function () {
            $(".sort-mask").fadeIn();
        })
        //特殊排序
        $(".sort-list>li").on("click", function () {
            $(this).addClass("yu-blue").siblings().removeClass("yu-blue");
            $(this).children(".iconfont").addClass("icon-gouxuan").parent().siblings().children(".iconfont").removeClass("icon-gouxuan");
            $(".sort-mask").fadeOut();
            $(".screen-bottom>div").removeClass("cur");
            var curp = $(this).find("p:eq(1)");
            $(".J_specSort").text(curp.text()).data("sortid", curp.data("sortid"));
            hotelSeach();

        })
        //筛选
        $(".price-screen>div").on("click", function () {
            $(this).addClass("cur").siblings().removeClass("cur");
        })
        $(".type-screen>div").on("click", function () {
            var that = $(this);
            if (that.data("id") == 0) {
                that.addClass("cur").siblings().removeClass("cur");
            } else {
                $(".type-screen>div[data-id='0']").removeClass("cur");
                that.toggleClass("cur");
            }
        })
        $(".cancel-btn2").on("click", function () {
            var that = $(this), that_price = $(".price-screen>div:eq(0)"), that_hType = $(".type-screen>div:eq(0)");
            if (that.hasClass("J_maskReset")) {//重置 
                that_price.addClass("cur").siblings().removeClass("cur");
                that_hType.addClass("cur").siblings().removeClass("cur");
            } else if (that.hasClass("J_maskOK")) { //确认
                $(".mask").fadeOut();
                $(".screen-btn").parent().removeClass("cur");
                hotelSeach();
            }
        })
        $(".screen-btn").click(function () {
            $(".screen-mask").fadeIn();
        })
        //跳转酒店详情页
        $("#hotelList").on("click", ".J_toHotelDetail", function () {
            location.href = "/Hotel/Index" + $(this).data("url")+"&indate="+$(".J_inRoomDate span:eq(1)").data("date")+"&outdate="+$(".J_lveRoomDate span:eq(1)").data("date");
        })
        //刷新定位
        $(".J_curLocation span").on("click", function () {
            if ($(".J_curLocation").is(":visible")) {
                getPosition(0);
                var curCityID = $(".J_selectArea1").data("cityid");
                $("selectArea .J_hotCity p[data-id=" + curCityID + "]").addClass("cur").siblings().removeClass("cur");
            }
        })
        //选择区域城市
        $(".J_selectArea1").on("click", function () {
            $("#mainDiv").hide();
            $("#selectArea").show();
        })
        //选择入房日期
        $(".J_selectDate").on("click", function () {
            $("#mainDiv").hide();
            $("#selectDate").show();
            $("body").css("overflow", "hidden")
            //设置默认日期
            setDefDate($(".J_inRoomDate span:eq(1)").data("date"), $(".J_lveRoomDate span:eq(1)").data("date"));
        })
        //选择关键字
        $("#qKeyWord").on("click", function () {
            $("#mainDiv").hide();
            $("#selectKeyWord").show();
            if ($(this).val().length > 0) {
                $(".J_rtKeyWord").val($(this).val());
            }
            bindKwData();
        })
        initCalendarPage();
        initCityPage();
        initKeyWordPage();
    }
    function initQuery(){
        var inDate = hq.InRoomDate, lvDate = hq.LvRoomDate;
        $(".J_inRoomDate span:eq(1)").data("date", inDate).text(fillZero(inDate, 0));
        $(".J_lveRoomDate span:eq(1)").data("date", lvDate).text(fillZero(lvDate, 0));
        if(hq.QType == 0){//附近的酒店查询(与位置无关的条件保留)
            
            $(".J_specSort").data("sortid",2).text("距离优先");
            var s = $(".sort-list p[data-sortid=2]");
            s.parent().addClass("yu-blue").siblings().removeClass("yu-blue");
            $(".sort-list>li>p:eq(0)").removeClass("icon-gouxuan");
            s.prev().addClass("icon-gouxuan");
            $(".J_curLocation").show();
        }else{//城市查询(所有条件保留)
            var cid = hq.CityID, cName = hq.CityName,price = hq.Price, htArr = hq.HType.split(','), kwVal = hq.KeyWordVal, kwText = hq.KeyWordText;
            //区域条件
            $(".J_hotCity p[data-id="+hq.CityID+"]").addClass("cur").siblings().removeClass("cur");
            $(".J_selectArea1").html(hq.CityName).data("cityid",hq.CityID);
            //价格筛选条件
            $(".J_screenPrice div").each(function () {
                if ($(this).text().replace("+", "") == $.trim(hq.Price)) {
                    $(this).addClass("cur").siblings().removeClass("cur");
                    return false;
                }
            })
            //类别筛选
            $(".J_screenType div").removeClass("cur");
            $(".J_screenType div").each(function(){
                if($.inArray($(this).data("id")+"", htArr) != -1){
                    $(this).addClass("cur");
                }
            })
            //关键字
            $("#qKeyWord").val(kwText).data("kwdata", kwVal);
            var kwVal1 = kwVal.split(",")[0], kwVal2 = kwVal.split(",")[1];
            if (kwVal1 > 0) {
                $("#selectKeyWord ul[data-kwtype=" + kwVal1 + "]").find("[data-id=" + kwVal2 + "]").addClass("cur").siblings().removeClass("cur");
            }
        }
        //定位
        getPosition(hq.QType);
    }
    function getPosition(opt) {
        loadstate(true)
        if (opt == 1) {//城市查询
            new BMap.Geocoder().getPoint(hq.CityName,function(p){//获取城市经纬度
                if(p){
                    $("#curPos").data("pos", (p.lng + ',' + p.lat));               
                }
                hotelSeach(); 
            },hq.CityName);
            $("#curPos").data("cityname", hq.CityName).text(hq.CityName);
            $(".J_hotCity p,.letter p").each(function () {
                var that = $(this);
                if (hq.CityName.indexOf(that.text()) > -1) {
                    $(".J_selectArea1").text(that.text()).data("cityid", that.data("id"));
                    if (that.parent(".J_hotCity").length > 0) {
                        that.addClass("cur").siblings().removeClass("cur");
                    }
                    return false;
                }
            })
        }else{//附近查询
            new BMap.Geolocation().getCurrentPosition(function (r) {
                if (this.getStatus() == BMAP_STATUS_SUCCESS) {
                    new BMap.Geocoder().getLocation(r.point, function (rs) {
                        var addComp = rs.addressComponents;
                        var fullAddr = addComp.province + addComp.city + addComp.district + addComp.street + addComp.streetNumber;
                        $(".J_curLocation p").text("当前位置：" + fullAddr);
                        $("#curPos").text(fullAddr);
                    });
                    $("#curPos").data("pos", (r.point.lng + ',' + r.point.lat)).data("cityname", r.address.city);
                    $(".J_hotCity p,.letter p").each(function () {
                        var that = $(this);
                        if (r.address.city.indexOf(that.text()) > -1) {
                            $(".J_selectArea1").text(that.text()).data("cityid", that.data("id"));
                            if (that.parent(".J_hotCity").length > 0) {
                                that.addClass("cur").siblings().removeClass("cur");
                            }
                            return false;
                        }
                    })
                    hotelSeach();
                }
                else {
                    $(".J_curLocation p").html("定位失败!请点击刷新!");
                }
            }, { enableHighAccuracy: true })
        } 
    }
    //滑动加载
    $(window).scroll(function () {
        if ($("#mainDiv").is(":visible") && $(document).scrollTop() >= $(document).height() - $(window).height()) {
            hotelSeach(true)
        }
    })
    function loadstate(display) {
        if (display) {
            setTimeout(function () {
                $(".loading-page").hide();
            }, 5000);
            $(".loading-page").show();
        } else {
            $(".loading-page").hide();
        }
    }
    $(".loading-page").hide();
    //选择条件时实时查询酒店数据
    var isEnd = false;//当前条件的数据是否全部加载完毕
    function hotelSeach(scroll) {
        var isScroll = scroll != undefined;
        var cityID = $(".J_selectArea1").data("cityid");
        if (isScroll == false) {
            $("#hPage").val("1");
            isEnd = false;
        } else {
            $("#hPage").val($("#hPage").val() * 1 + 1);
        }
        if (isEnd == false) {
            var cityName = $(".J_selectArea1").text();
            var inRoomDate = $(".J_inRoomDate span:eq(1)").data("date");
            var lvRoomDate = $(".J_lveRoomDate span:eq(1)").data("date");
            var price = $(".J_screenPrice div[class='cur']").text();
            var kwVal = $("#qKeyWord").data("kwdata");
            var kwText = kwVal == "-1,-1" ? "" : $("#qKeyWord").val();
            var spsort = $(".J_specSort").data("sortid");
            var pos = $("#curPos").data("pos");
            var page = $("#hPage").val();
            var hType = "";
            $(".J_screenType div[class='cur']").each(function () {
                hType += $(this).data("id") + ",";
            })
            var params = { CityID: cityID, CityName: cityName, InRoomDate: inRoomDate, LvRoomDate: lvRoomDate, Price: price, HType: hType, KeyWordVal: kwVal, KeyWordText: kwText, SpecSort: spsort, LngLat: pos, Page: page, HotelWxId: hq.HotelWxId,UserWxId:hq.UserWxId,QType:hq.QType };
            loadstate(true);
            $("#nomore").hide(); $("#noRes").hide()
            $.post("/TravelAgencyHotel/GetHotelSeachRes", params, function (r) {
                var rHtml = ""; isEnd = r.length <= 0;
                if (isEnd == false) {
                    $.each(r, function (idx, item) {
                        var disText = item.Distance > 1000 ? (item.Distance / 1000).toFixed(1) : item.Distance.toFixed(1);
                        var disUnit = item.Distance > 1000 ? "公里" : "米";
                        rHtml += '<li class="yu-bor bbor yu-tbpad20r yu-pos-r J_toHotelDetail" data-url="' + item.LinkUrl + '">';
			            rHtml += '<a href="#" class="yu-grid">';
				        rHtml += '<div class="near-pic2 full-img yu-rmar20r">';
                        if(item.MainPic == null || item.MainPic == ''){//没有图片显示默认svg
                            rHtml += '<svg class="icon" aria-hidden="true" style="height:100%;width:100%;"><use xlink:href="#icon-tongyonmorentu"></use></svg>';
                        }else{//有图片无法加载时也显示默认svg
                            rHtml += '<img src="' + item.MainPic + '" onload="loadedImage(this)" data-index='+idx+' style="display:none;" />';
                            rHtml += '<svg class="icon" aria-hidden="true" style="height:100%;width:100%;"><use xlink:href="#icon-tongyonmorentu"></use></svg>';
                        }
                        var slCss = '',slIconCss = '';
                        switch (item.SpecificLabel) {
                            case 1: slCss='label01';slIconCss="#icon-renqiremai";break;//人气热卖
                            case 2: slCss='label02';slIconCss="#icon-chaogaoxingjiabi";break;//超高性价比
                            case 3: slCss='label03';slIconCss="#icon-shishuiyuantuijian";break;//试睡员推荐
                            default:
                        }
                        if(slCss != '' && slIconCss != ''){
                            rHtml += '<p class="hotel_label '+slCss+'"><i><svg class="icon" aria-hidden="true"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="'+slIconCss+'"></use></svg></i>'+item.SpecificLabelText+'</p>';
                        }
				        rHtml += '</div>';
				        rHtml += '<div class="yu-overflow text-ell yu-rmar10r">';
					    rHtml += '<h3 class="yu-f28r yu-black yu-f-wn yu-bmar10r h-title" style="white-space:normal;">';
                        rHtml += '<span class="yu-overflow">' + item.HotelName + '</span>';
                        if(item.PartnerLevel > 0){
                            var pLevCss = '';
                            switch (item.PartnerLevel) {
                                case 3:pLevCss='jinpai';break;
                                case 2:pLevCss='yinpai';break;
                                case 1:pLevCss='tongpai';break;
                                default:
                            }
                            rHtml += '<svg class="icon" aria-hidden="true"><use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#icon-'+pLevCss+'"></use></svg>';
                        }
                        rHtml += '</h3>';
                        var tagCssArr = [];
                        if(item.HasCouPon){
                            tagCssArr.push('<i class="h-youhui">会员红包</i>');
                        }
                        if(item.HasHourRoom){
                            tagCssArr.push('<i class="h-youhui blue">钟点房</i>');
                        }
                        if(tagCssArr.length < 2){
                            tagCssArr.push('<i class="h-youhui">会员优惠</i>')
                        }
					    rHtml += '<p class="yu-f22r yu-c77" style="white-space:normal;">' + item.StarText + (tagCssArr.length ==2?tagCssArr[0]+tagCssArr[1]:tagCssArr[0])+'</p>';
					    rHtml += '<div class="yu-f22r yu-c77 text-ell yu-bmar10r yu-rmar25r">';
						rHtml += '<span class="iconfont icon-dingwei1 yu-f20r yu-f-wb"></span>';
						rHtml += '<span>' + item.Address + '</span>';
					    rHtml += '</div>';
					    rHtml += '<div class="yu-f22r yu-c77 text-ell">';
                        if(hq.QType == 0){//附近酒店
                            rHtml += '<span class="iconfont icon-daohang yu-f20r "></span>';
                            rHtml += '<span>距离您<i class="yu-c40">' + disText + '</i>' + disUnit + '</span>';
                        }else{//城市酒店
                            rHtml += '<span class="iconfont icon-daohang yu-f20r "></span>';
                            rHtml += '<span>距离市中心<i class="yu-c40">' + disText + '</i>' + disUnit + '</span>';
                        }
					    rHtml += '</div>';
					    rHtml += '<div class="h-scoreorder">';
                        rHtml += '<p class="yu-f22r yu-blue2">评分：'+item.CommentAvgScore.toFixed(1)+'分'+(item.CommentAvgScore>=3.0?'/'+item.CommentAvgScoreText:'')+'</p>';//大于3分显示评级
						rHtml += '<p class="yu-f22r yu-5dc65b">'+item.BookRoomMinText+'</p>';
					    rHtml += '</div>';
					
				        rHtml += '</div>';
				        rHtml += '<div class="yu-c40 h-price">';
						rHtml += '<span class="yu-f24r">￥</span><span class="yu-f40r">' + item.LowerPrice + '</span><span class="yu-f20r">起</span></div></a></li>';
                    })
                }
                if (!isScroll) {
                    $("#hotelList").html(rHtml);
                } else if (isScroll && rHtml != "") {
                    $("#hotelList").append(rHtml);
                }
                if (isEnd) {
                    if ($("#hotelList li").length > 0) {
                        $("#nomore").show();
                    } else {
                        $("#nomore").hide();
                        $("#noRes").show();
                    }
                }
                loadstate(false);
            })
        }
    }
    function loadedImage(t){
        var that = $(t);
        that.show().next().hide();
        that.error(function(){
            that.hide().next().show();
         });
    }
    function testDistance(eLngLat) {//测试计算距离与百度API是否一致
        var map = new BMap.Map("allmap");
        var curPos = $("#curPos").data("pos");
        var pointA = new BMap.Point(curPos.split(',')[0], curPos.split(',')[1]);  // 创建点坐标A
        var pointB = new BMap.Point(eLngLat.split(',')[0], eLngLat.split(',')[1]);  // 创建点坐标B
        return (map.getDistance(pointA, pointB)).toFixed(2) + ' 米。';
    }
    /*******主要页 e*******/

    /*******日历页相关 s*******/
    var selDatas = []; //选择的日期
    function initCalendarPage() {
        $("#selectDate").hide();
        var dClickNum = 0;
        /*日期选择初始号*/
        var __drp;
        __drp = $("#datepicker").datepicker({
            dateFormat: 'yy-mm-dd',
            dayNamesMin: ["日", "一", "二", "三", "四", "五", "六"],
            monthNames: ["1月", "2月", "3月", "4月", "5月", "6月",
     "7月", "8月", "9月", "10月", "11月", "12月"],
            yearSuffix: '年',
            showMonthAfterYear: true,
            minDate: new Date(),
            maxDate: "+2m",
            numberOfMonths: 2,
            showButtonPanel: false,
            onSelect: function (date) {
                if (selDatas.length < 2) {
                    if ($.inArray(date, selDatas) == -1) {
                        selDatas.push(date);
                    }
                } else {
                    selDatas.length = 0;
                    selDatas.push(date);
                }
                if (selDatas.length == 2) {
                    setTimeout(function(){
                    var sDateStr = selDatas[0], eDateStr = selDatas[1];
                    if (new Date(selDatas[0]) > new Date(selDatas[1])) {
                        var sDateStr = selDatas[1], eDateStr = selDatas[0];
                    }
                    var sDateArr = sDateStr.split('-'), eDateArr = eDateStr.split('-');
                    var diffDays = Math.abs((new Date(sDateStr) - new Date(eDateStr))) / (1000 * 60 * 60 * 24);
                    $(".J_inRoomDate span:eq(1)").text(sDateArr[1] + "-" + sDateArr[2]).data("date", sDateStr);
                    $(".J_lveRoomDate span:eq(1)").text(eDateArr[1] + "-" + eDateArr[2]).data("date", eDateStr);
                    $(".J_selectDate p span").html(diffDays);
                    $("#mainDiv").show();
                    $("#selectDate").hide();
                    $("body").css("overflow", "auto");
                    hotelSeach();
                    },800);
                }
            }
        });
    }
    //设置默认日期
    function setDefDate(inRoomDay, lvRoomDay) {
        inRoomDay = new Date(inRoomDay); lvRoomDay = new Date(lvRoomDay);
        $(".ui-state-active").removeClass("ui-state-active");
        $("#datepicker .first").removeClass("specialdays first");
        $("#datepicker .last").removeClass("specialdays last");
        $("td[data-handler='selectDay'][data-year=" + inRoomDay.getFullYear() + "][data-month=" + inRoomDay.getMonth() + "][data-day=" + inRoomDay.getDate() + "]").addClass("specialdays first"); //入住日期
        $("td[data-handler='selectDay'][data-year=" + lvRoomDay.getFullYear() + "][data-month=" + lvRoomDay.getMonth() + "][data-day=" + lvRoomDay.getDate() + "]").addClass("specialdays last"); //离房日期
        $("td[data-handler='selectDay']").each(function () {
            var that = $(this);
            var curDate = new Date(that.data("year") + "-" + (that.data("month") * 1 + 1) + "-" + that.data("day"));
            if (curDate > inRoomDay && curDate < lvRoomDay) {
                that.addClass(" ui-range-selected");
            }
            if (curDate > lvRoomDay) {
                return;
            }
        })
        var days = Math.abs((inRoomDay.getTime() - lvRoomDay.getTime())) / (1000 * 60 * 60 * 24);
        $("#selectDate .selectNum").text(days);
    }
    function fillZero(date, opt) {
        if (opt == 0) {//初始化时
            var curDate = new Date(date);
            var month = curDate.getMonth()+1, day = curDate.getDate();
            if (month < 10) {
                month = "0" + month;
            }
            if (day < 10) {
                day = "0" + day;
            }
            return month + "-" + day;
        } else {//选择日历时
            if (date < 10) {
                return "0" + date;
            } else {
                return date;
            }
        }
    }
    /*******日历页相关 e*******/

    /*******区域页相关 s*******/
    function initCityPage() {
        $("#selectArea").hide();
        $(".letter dl dt").each(function () {
            $(this).after("<dd></dd>");
        })
        $("#curPos").on("click", function () { //选择当前定位城市
            var hasCityData = false;
            var curCityName = $(this).data("cityname");
            if (curCityName != '') {
                $(".J_hotCity p,.letter p").each(function () {
                    if (curCityName.indexOf($(this).text()) > -1) {
                        hasCityData = true;
                        $(this).click();
                        return false;
                    }
                })
                if(!hasCityData){
                    $("#nomore").hide();$("#noRes").show();$("#mainDiv").show();$("#selectArea").hide();$("#hotelList").empty();
                }
            }
        })
        //选择城市后清空除日期条件外所有条件
        $("#selectArea").on("click", ".J_hotCity p,.letter p", function () {
            var that = $(this);
            if (that.parents(".J_hotCity").length > 0) {
                that.addClass("cur").siblings().removeClass("cur");
            } else {
                $(".J_hotCity p").removeClass("cur");
                $(".J_hotCity p[data-id=" + that.data("id") + "]").addClass("cur").siblings().removeClass("cur");
            }
            //重置关键字
            if (that.text() != $(".J_selectArea1").text()) {
                $(".tab-inner-scroll li").removeClass("cur");
                $(".J_rtKeyWord").val("");
                $("#qKeyWord").val("").data("kwdata", "-1,-1");
            }
            $(".J_selectArea1").text(that.html()).data("cityid", that.data("id")).parent().parent().removeClass("cur");
            $("#mainDiv").show();
            $("#selectArea").hide();
            hotelSeach();
        })
        //绑定拥有酒店数据的城市
        var pyArr = [];
        $.get("/TravelAgencyHotel/GetHasHotelConditionIDs", { hotelWxId: hq.HotelWxId }, function (r) {
            hasHotelConditionIDsDic = JSON.parse(r);
            var hasHotelCityIDs = hasHotelConditionIDsDic[1]; //拥有酒店数据的城市
            //绑定所有城市
            for (var i = 0; i < provs.length; i++) {
                var pid = "p" + provs[i].id;
                try {
                    var city_arr = citys[pid];
                    if (city_arr.length > 0) {
                        for (var j = 0; j < city_arr.length; j++) {
                            if (hasHotelCityIDs.indexOf(city_arr[j].id) >= 0) {
                                $("#" + city_arr[j].py).next("dd").append("<p class='yu-bor bbor' data-id = " + city_arr[j].id + ">" + city_arr[j].name + "</p>");
                                pyArr.push(city_arr[j].py);
                                //绑定该酒店数据最多的城市为热门城市
                                if(city_arr[j].id == <%=defCityId %>){
                                    $(".J_hotCity").append("<p data-id=" + city_arr[j].id + ">" + city_arr[j].name + "</p>");
                                }
                            }
                        }
                        //移除没有城市的拼音
                        $.each($("#selectArea .letter dt"),function(){
                            var that = $(this);
                            if(pyArr.indexOf(that.attr("id")) < 0){
                                that.remove();
                            }
                        });
                    }
                } catch (e) {

                }
            }
//            //绑定热门城市
//            for (var i = 0; i < hot_citys.length; i++) {
//                if (hasHotelCityIDs.indexOf(hot_citys[i].id) >= 0) {
//                    $(".J_hotCity").append("<p data-id=" + hot_citys[i].id + ">" + hot_citys[i].name + "</p>");
//                }
//            }
            $("#selectArea").on("click", ".J_hotCity p,.letter p", function () {
                var that = $(this);
                if (that.parents(".J_hotCity").length > 0) {
                    that.addClass("cur").siblings().removeClass("cur");
                }
                $(".J_selectArea1").text(that.html()).data("cityid", that.data("id"));
                $("#mainDiv").show();
                $("#selectArea").hide();
            })
            initQuery();
        })
    }
    /*******区域页相关 e*******/

    /*******关键字页相关 s*******/
    function initKeyWordPage() {
        $("#selectKeyWord").hide();
        $(".tab-nav").children("li").on("click", function () {
            $(this).addClass("cur").siblings("li").removeClass("cur");
            tabIndex = $(this).index();
            $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
        })
        //关键字搜索
        $(".J_rtKeyWord").on("input propertychange", function () {
            if ($(this).val().length > 0) {
                $("#selectKeyWord section:eq(1)").hide();
            } else {
                $("#selectKeyWord section:eq(1)").show();
            }
        })
        //选择关键字(单选)
        $(".tab-inner-scroll").on("click", "li", function () {
            var that = $(this);
            $(".tab-inner-scroll li").removeClass("cur");
            $(that).addClass("cur");
            $("#qKeyWord").val(that.text()).data("kwdata", (that.parent().data("kwtype") + "," + that.data("id")));
            $("#selectKeyWord").hide();
            $("#mainDiv").show();
            hotelSeach();
        })
        //确认关键字搜索
        $("#selectKeyWord .J_kwSure").on("click", function () {
            var inputKw = $(".J_rtKeyWord").val().trim();
            if (inputKw.length > 0) {
                $(".tab-inner-scroll li").removeClass("cur");
                $("#qKeyWord").val(inputKw).data("kwdata", "0,0");
            } else {
                $(".tab-inner-scroll li").removeClass("cur");
                $("#qKeyWord").val(inputKw).data("kwdata", "-1,-1");
            }
            $("#selectKeyWord").hide();
            $("#mainDiv").show();
            $("#selectKeyWord section:eq(1)").show();
            hotelSeach();
        })
        //取消返回
        $(".J_kwBack").on("click", function () { 
            $(".J_rtKeyWord").val($("#qKeyWord").val());
            $("#selectKeyWord").hide();
            $("#mainDiv").show();
            $("#selectKeyWord section:eq(1)").show();
        })
        $(".J_iptClear").on("click", function () {
            $(".J_rtKeyWord").val("");
            $("#selectKeyWord section:eq(1)").show();
        })
        //回车键搜索关键字
        $(document).keydown(function(event) {
        if( event.keyCode == 13 &&!$("#selectKeyWord").is(":hidden"))    
            $("#selectKeyWord .J_kwSure").click();    
        })  
    }
    //绑定关键字数据
    function bindKwData() {
        try {
            var kwTagLis = $("#kwTagName li");
            kwTagLis.hide();
            var isHidekwTag = true;
            //品牌
            var that_brand = $("#selectKeyWord .J_brand");
            that_brand.empty();
            if (hasHotelConditionIDsDic[3].length > 0) {
                kwTagLis.eq(0).show(); isHidekwTag = false;
                for (var i = 0; i < chains.length; i++) {
                    if (hasHotelConditionIDsDic[3].indexOf(chains[i].id) >= 0) {
                        that_brand.append("<li data-id=" + chains[i].id + ">" + chains[i].name + "</li>")
                    }
                }
            }
            //区域
            var cid = $(".J_selectArea1").data("cityid");
            var that_area = $("#selectKeyWord .J_area");
            that_area.empty();
            if (hasHotelConditionIDsDic[2].length > 0) {
                kwTagLis.eq(1).show(); isHidekwTag = false;
                var area_arr = areas["c" + cid];
                if (area_arr.length > 0) {
                    for (var i = 0; i < area_arr.length; i++) {
                        if (hasHotelConditionIDsDic[2].indexOf(area_arr[i].id) >= 0) {
                            that_area.append("<li data-id=" + area_arr[i].id + ">" + area_arr[i].name + "</li>")
                        }
                    }
                }

            }
            
            //商圈
            var that_tradingArea = $("#selectKeyWord .J_tradingArea");
            that_tradingArea.empty();
            if (hasHotelConditionIDsDic[4].length > 0) {
                kwTagLis.eq(2).show(); isHidekwTag = false;
                $.each(trading_area, function (idx, item) {
                    if (item.pid == cid) {
                        if (hasHotelConditionIDsDic[4].indexOf(item.id) >= 0) {
                            that_tradingArea.append("<li data-id=" + item.id + ">" + item.name + "</li>")
                        }
                    }
                })
            }
            //选中已绑定数据
            var chosArr = $("#qKeyWord").data("kwdata").split(',');
            $(".tab-inner-scroll li").removeClass("cur");
            $(".tab-inner-scroll[data-kwtype=" + chosArr[0] + "] li[data-id=" + chosArr[1] + "]").addClass("cur");
            if (isHidekwTag) {//隐藏所有关键字选择
                $("#selectKeyWord section:eq(1)").hide();
            } else {
                $("#selectKeyWord section:eq(1)").show();
            }
        } catch (e) {

        }
    }
    /*******关键字页相关 e*******/
    function BindData() { }
</script>
</body>
</html>
