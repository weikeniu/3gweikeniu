<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    var adImgs = ViewData["adImgs"] as List<hotel3g.Models.Advertisement>;
    var hId = ViewData["hId"].ToString();
    var key = ViewData["key"].ToString();
    var hotelWxId = ViewData["hotelWxId"].ToString();
    var defCity = ViewData["defCity"] as Dictionary<int,string>;
    var defCityId = defCity.First().Key;
    var defCityName = defCity.First().Value;
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
<title>酒店预订</title>
<link type="text/css" rel="stylesheet" href="../../css/booklist/font/iconfont.css"/> 
<link type="text/css" rel="stylesheet" href="../../swiper/swiper-3.4.1.min.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/jquery-ui.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/Restaurant.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/new-style.css"/>
<%--<link type="text/css" rel="stylesheet" href="../../css/booklist/fontSize.css"/>--%>
<link type="text/css" rel="stylesheet" href="../../css/booklist/travel.css"/>        
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
</style>
</head>
<body style="overflow:auto">
<form action="/TravelAgencyHotel/List/<%=hId+"?key="+key %>" method="post" id="queryCdtForm" style="display:none">
    <input type="hidden" name="qJson" />
    <input type="submit" id="subForm"/>
</form>
<input type="hidden" id="token" value="<%=hId+"?key="+key %>" />
<input type="hidden" id="hotelWxId" value="<%=hotelWxId %>" />
<div id="mainDiv">
<article class="base-page">
	<section class="yu-pos-r">
		 <div class="swiper-container yu-h360r">
		    <div class="swiper-wrapper">
                <% if (adImgs.Count > 0)
                   {
                       foreach (hotel3g.Models.Advertisement ad in adImgs)
                       {
                           string href = "javascript:void(0)";

                           if (!string.IsNullOrEmpty(ad.ImageUrl))
                           {
                               if (!string.IsNullOrEmpty(ad.LinkUrl))
                               {
                                   if (ad.LinkUrl.Contains("/Hotel/Fillorder"))
                                       href = ad.LinkUrl + "&userweixinid=" + ViewData["userWxId"];
                                   else
                                       href = ad.LinkUrl.Trim() + "@" + ViewData["userWxId"];


                                   href = href.Replace("@{{userweixinID}}", "");
                               }
                                 
                    %>
                    <div class="swiper-slide full-img"">
                        <a href="<%=href %>">
                            <img src="<%=ad.ImageUrl %>" />
                        </a>   
                    </div>
                     

                    <%}
                       }
                   } %>


				</div>
		    <div class="swiper-pagination"></div>
	  	</div>
  	</section>
  	<section class="yu-lpad20r">
  		<div class="yu-grid yu-alignc yu-h90r">
  			<p class="yu-w70r yu-textc yu-f30r iconfont icon-dingwei1"></p>
  			<div class="yu-bor bbor yu-h90r yu-overflow">
  				<div class="yu-grid yu-alignc yu-h90r">
  					<a class="yu-overflow yu-arr arr1 yu-f32r yu-black J_selectArea" data-cityid = "0" data-lnglat="0,0" href="javascript:void(0)">
  						<%=defCityName%>
  					</a>
  					<a class="yu-overflow yu-arr arr1 yu-f32r yu-black J_myLocation near-btn" href="javascript:void(0)">
  						<div class="yu-grid yu-alignc J_query" data-qtype = 0>
  							<p class="yu-f30r iconfont icon-jiudian1 yu-rmar20r"></p>
  							<p class="yu-f32r">附近酒店</p>
  						</div>
  					</a>
  				</div>
  			</div>
  		</div>
  		<div class="yu-grid yu-alignc yu-h137r yu-arr arr1 J_selectDate">
  			<p class="yu-w70r yu-textc yu-f30r iconfont icon-rili1"></p>
  			<a class="yu-bor bbor yu-h137r yu-overflow" href="javascript:void(0)">
  				<div class="yu-grid yu-alignc yu-h137r yu-rpad82r">
  					<div class="yu-overflow">
  						<div class="yu-f32r J_inRoomDate">
  							<span class="yu-f32r yu-black yu-rmar20r" data-date></span>
  							<span class="yu-f26r yu-c77 yu-rmar10r" ></span>
  							<span class="yu-f26r yu-c77">入住</span>
  						</div>
  						<div class="yu-f32r J_lveRoomDate">
  							<span class="yu-f32r yu-black yu-rmar20r" data-date></span>
  							<span class="yu-f26r yu-c77 yu-rmar10r"></span>
  							<span class="yu-f26r yu-c77">离店</span>
  						</div>
  					</div>
  					<p class="yu-f32r yu-black">共<span>1</span>晚</p>
  				</div>
  			</a>
  		</div>
  		<div class="yu-grid yu-alignc yu-h90r yu-arr arr1 J_selectKeyWord">
  			<p class="yu-w70r yu-textc yu-f30r iconfont icon-soushuo1"></p>
  			<div class="yu-bor bbor yu-h90r yu-overflow">
  				<div class="yu-grid yu-alignc yu-h90r yu-f32r yu-cc0 yu-rpad82r" id="qKeyWord">
  					<p class="yu-overflow" data-kwdata="-1,-1">关键字</p>
  					<p>位置、品牌、酒店</p>
  				</div>
  			</div>
  		</div>
  		<div class="yu-grid yu-alignc yu-h90r yu-arr arr1">
  			<p class="yu-w70r yu-textc yu-f30r iconfont icon-xingji2"></p>
  			<div class="yu-bor bbor yu-h90r yu-overflow">
  				<div class="yu-grid yu-alignc yu-h90r yu-f32r yu-cc0 yu-rpad82r screen-btn">
  					<p class="yu-overflow " id="priceStar">价格/星级</p>
  				</div>
  			</div>
  		</div>
  	</section>
	<section class="submit-row">
		<input type="button" value="查询" class="J_query" data-qtype = "1"/>
	</section>
</article>
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
	<ul class="tab-nav type3 yu-f28r" id="kwTagName">
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
			<p class="sp" id="curPos" data-id = 0>定位中...</p>
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
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=Y4ofkWPl6nHN41oFEZj39HPA"></script>
<script src="../../Scripts/pca.js" type="text/javascript"></script>
<script type="text/javascript">
    var swiper = new Swiper('.swiper-container', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        autoplay: 2500,
        autoplayDisableOnInteraction: false,
        loop: true,
        onSlideChangeStart: function (swiper) {
            $(".hotel-img-mask li").eq(swiper.activeIndex).addClass("cur").siblings().removeClass("cur");
            $(".activeIndex").text(swiper.activeIndex);
        }
    });
    var hasHotelConditionIDsDic = []; //拥有酒店的条件Id字典,城市、行政区、品牌、商圈能查到酒店的才供选择
    var defCityId = <%=defCityId %>;
    var defCityName = '<%=defCityName %>';
    $(function () {
        initMainPage();
    });
    /*******主要页 s*******/
    function initMainPage() {
        //设置默认城市
        $(".J_selectArea").data('cityid',defCityId).text(defCityName);
        //价格星级
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
        //价格星级确认/重置
        $(".cancel-btn2").on("click", function () {
            var that = $(this), that_price = $(".price-screen>div:eq(0)"), that_hType = $(".type-screen>div:eq(0)");
            if (that.hasClass("J_maskReset")) {//重置 
                that_price.addClass("cur").siblings().removeClass("cur");
                that_hType.addClass("cur").siblings().removeClass("cur");
            } else if (that.hasClass("J_maskOK")) { //确认
                if (that_price.hasClass("cur") && that_hType.hasClass("cur")) {
                    $("#priceStar").text("价格/星级");
                } else {
                    var tArr = [];
                    if (!that_price.hasClass("cur")) {
                        tArr.push($(".J_screenPrice div[class='cur']").text());
                    }
                    if (!that_hType.hasClass("cur")) {
                        $(".J_screenType div[class='cur']").each(function () {
                            tArr.push($(this).text())
                        })
                    }
                    $("#priceStar").text(tArr.join(","));
                }
                $(".mask").fadeOut();
            }
        })
        $(".screen-btn").click(function () {
            $(".screen-mask").fadeIn();
        })
        //默认日期
        var inRoomDay = new Date();
        var lvRoomDay = new Date(new Date().setDate(inRoomDay.getDate() + 1));
        $(".J_inRoomDate span:eq(0)").html(fillZero(inRoomDay.getMonth() * 1 + 1) + "月" + fillZero(inRoomDay.getDate()) + "日").data("date", (inRoomDay.getFullYear() + "-" + (inRoomDay.getMonth() * 1 + 1) + "-" + fillZero(inRoomDay.getDate())));
        $(".J_inRoomDate span:eq(1)").html(getDay(inRoomDay));
        $(".J_lveRoomDate span:eq(0)").html(fillZero(lvRoomDay.getMonth() * 1 + 1) + "月" + fillZero(lvRoomDay.getDate()) + "日").data("date", (lvRoomDay.getFullYear() + "-" + (lvRoomDay.getMonth() * 1 + 1) + "-" + lvRoomDay.getDate()));
        $(".J_lveRoomDate span:eq(1)").html(getDay(lvRoomDay));
        //选择区域城市
        $(".J_selectArea").on("click", function () {
            $("#mainDiv").hide();
            $("#selectArea").show();
        })
        //选择入房日期
        $(".J_selectDate").on("click", function () {
            $("#mainDiv").hide();
            $("#selectDate").show();
            $("body").css("overflow", "hidden")
            //设置默认日期
            setDefDate($(".J_inRoomDate span:eq(0)").data("date"), $(".J_lveRoomDate span:eq(0)").data("date"));
        })
        //选择关键字
        $(".J_selectKeyWord").on("click", function () {
            $("#mainDiv").hide();
            $("#selectKeyWord").show();
            if ($("#qKeyWord p").html() != "关键字") {
                $(".J_rtKeyWord").val($("#qKeyWord p").html());
            }
            bindKwData();
        })
        //查询
        $(".J_query").on("click", function () {
            var cityID = $(".J_selectArea").data("cityid");
            var token = $("#token").val();
            var cityName = $(".J_selectArea").text();
            var qType = $(this).data("qtype"); //0附近搜索，1直接查询
            var inRoomDate = $(".J_inRoomDate span:eq(0)").data("date");
            var lvRoomDate = $(".J_lveRoomDate span:eq(0)").data("date");
            var price = $(".J_screenPrice div[class='cur']").text();
            var kwVal = $("#qKeyWord p:eq(0)").data("kwdata");
            var kwText = kwVal == "-1,-1" ? "" : $("#qKeyWord p:eq(0)").text();
            var hType = "";
            $(".J_screenType div[class='cur']").each(function () {
                hType += $(this).data("id") + ",";
            })
            var postData = {CityID:cityID,CityName:cityName,InRoomDate:inRoomDate,LvRoomDate:lvRoomDate,Price:price,HType:hType,KeyWordVal:kwVal,KeyWordText:kwText,QType:qType};
            $('#queryCdtForm input[name="qJson"]').val(JSON.stringify(postData));
            $('#subForm').trigger('click');
        })
        initCalendarPage();
        initCityPage();
        initKeyWordPage();
    }
    /*******主要页 e*******/

    /*******日历页相关 s*******/
    var selDatas = [];//选择的日期
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
                 }                 if(selDatas.length == 2){                  setTimeout(function(){                    var sDateStr =selDatas[0],eDateStr = selDatas[1];                    if(new Date(selDatas[0]) > new Date(selDatas[1])){                        var sDateStr =selDatas[1],eDateStr = selDatas[0];                       }
                    var sDateArr = sDateStr.split('-'),eDateArr = eDateStr.split('-');
                    var diffDays =  Math.abs((new Date(sDateStr) - new Date(eDateStr)))/(1000*60*60*24);
                    $(".J_inRoomDate span:eq(0)").html(sDateArr[1] + "月" + sDateArr[2] + "日").data("date", sDateStr);
                    $(".J_inRoomDate span:eq(1)").html(getDay(sDateStr));
                    $(".J_lveRoomDate span:eq(0)").html(eDateArr[1] + "月" + eDateArr[2] + "日").data("date", eDateStr);
                    $(".J_lveRoomDate span:eq(1)").html(getDay(eDateStr));
                    $(".J_selectDate p span").html(diffDays);
                    $("#mainDiv").show();
                    $("#selectDate").hide();
                    $("body").css("overflow", "auto")                  }, 800)                 }            }
        });
    }
    function getDay(date) {
        var day = new Date(date).getDay(), text = "";
        switch (day) {
            case 0:
                text = "周日";
                break;
            case 1:
                text = "周一";
                break;
            case 2:
                text = "周二";
                break;
            case 3:
                text = "周三";
                break;
            case 4:
                text = "周四";
                break;
            case 5:
                text = "周五";
                break;
            case 6:
                text = "周六";
                break;
        }
        return text;
    }
    function fillZero(num) {
        if (num < 10) {
            return "0" + num;
        } else {
            return num;
        }
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
    }
    /*******日历页相关 e*******/

    /*******区域页相关 s*******/
    function initCityPage() {
        $("#selectArea").hide();
        
        $(".letter dl dt").each(function () {
            $(this).after("<dd></dd>");
        })
        $("#selectArea").on("click", ".J_hotCity p,.letter p", function () {
            var that = $(this);
            if (that.parents(".J_hotCity").length > 0) {
                that.addClass("cur").siblings().removeClass("cur");
            } else {
                $(".J_hotCity p").removeClass("cur");
                $(".J_hotCity p[data-id=" + that.data("id") + "]").addClass("cur").siblings().removeClass("cur");
            }
            //重置关键字
            if (that.text() != $(".J_selectArea").text()) {
                $(".tab-inner-scroll li").removeClass("cur");
                $(".J_rtKeyWord").val("");
                $("#qKeyWord p").eq(0).text("关键字").data("kwdata", "-1,-1").next().text("位置、品牌、酒店");
            }
            $(".J_selectArea").text(that.html()).data("cityid", that.data("id"));
            $("#mainDiv").show();
            $("#selectArea").hide();
        })
        //绑定拥有酒店数据的城市
        var hotelWxId = $("#hotelWxId").val();
        $.get("/TravelAgencyHotel/GetHasHotelConditionIDs", { hotelWxId: hotelWxId }, function (r) {
            hasHotelConditionIDsDic = JSON.parse(r);
            var hasHotelCityIDs = hasHotelConditionIDsDic[1];//拥有酒店数据的城市
            //绑定所有城市
            var pyArr = [];
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
                                if(city_arr[j].id == defCityId){
                                    $(".J_hotCity").append("<p data-id=" + city_arr[j].id + " class='cur'>" + city_arr[j].name + "</p>");
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
            //绑定热门城市
//            for (var i = 0; i < hot_citys.length; i++) {
//                if (hasHotelCityIDs.indexOf(hot_citys[i].id) >= 0) {
//                    $(".J_hotCity").append("<p data-id=" + hot_citys[i].id + ">" + hot_citys[i].name + "</p>");
//                }
//            }
            $("#selectArea").on("click", ".J_hotCity p,.letter p,#curPos", function () {
                var that = $(this);
                if (that.parents(".J_hotCity").length > 0) {
                    that.addClass("cur").siblings().removeClass("cur");
                }
                //Index
                $(".J_selectArea").text(that.html()).data("cityid", that.data("id"));
                $("#mainDiv").show();
                $("#selectArea").hide();
            })
            getCity();
        })
    }
    function getCity() {
        new BMap.LocalCity().get(function (res) {
            //获取当前用户所在城市,酒店有该城市数据则替换默认城市。
//            var curCityName = res.name;
//            $(".J_hotCity p,.letter p").each(function () {
//                var that = $(this);
//                if (curCityName.indexOf(that.text()) > -1) {
//                    $("#curPos").html(that.text());
//                    if ($("#mainDiv").is(":visible")) {
//                        $(".J_selectArea").text(that.text());
//                    }
//                    if (that.parent(".J_hotCity").length > 0) {
//                        that.addClass("cur").siblings().removeClass("cur");
//                    }
//                    $(".J_selectArea").data("cityid", that.data("id"));
//                    $("#curPos").data("cityid", that.data("id"));
//                    return;
//                }else{
//                    //选择城市定位时，如果酒店有该城市则选择城市，否则展示定位城市，查询时无结果。
//                    $("#curPos").text(curCityName.replace("市",'')).data("id", 0);
//                }
//            })

            new BMap.Geolocation().getCurrentPosition(function (r) {
                if (this.getStatus() == BMAP_STATUS_SUCCESS) {
                    new BMap.Geocoder().getLocation(r.point, function (rs) {
                        var curCityName = rs.addressComponents.city;
                        $(".J_hotCity p,.letter p").each(function () {
                            var that = $(this);
                            if (curCityName.indexOf(that.text()) > -1) {
                                $("#curPos").html(that.text());
                                if ($("#mainDiv").is(":visible")) {
                                    $(".J_selectArea").text(that.text());
                                }
                                if (that.parent(".J_hotCity").length > 0) {
                                    that.addClass("cur").siblings().removeClass("cur");
                                }
                                $(".J_selectArea").data("cityid", that.data("id"));
                                $("#curPos").data("cityid", that.data("id"));
                                return;
                            }else{
                                //选择城市定位时，如果酒店有该城市则选择城市，否则展示定位城市，查询时无结果。
                                $("#curPos").text(curCityName.replace("市",'')).data("id", 0);
                            }
                        })
                    });
                }
                else {
                    $(".J_curLocation p").html("定位失败!请点击刷新!");
                }
            }, { enableHighAccuracy: true })
        });
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
            $("#qKeyWord p").eq(0).text(that.text()).data("kwdata", (that.parent().data("kwtype") + "," + that.data("id"))).next().text("");
            $("#selectKeyWord").hide();
            $("#mainDiv").show();
        })
        //确认关键字搜索
        $("#selectKeyWord .J_kwSure").on("click", function () {
            var inputKw = $(".J_rtKeyWord").val().trim();
            if (inputKw.length > 0) {
                $(".tab-inner-scroll li").removeClass("cur");
                $("#qKeyWord p").eq(0).text(inputKw).data("kwdata", "0,0").next().text("");
            } else {
                $(".tab-inner-scroll li").removeClass("cur");
                $("#qKeyWord p").eq(0).text("关键字").data("kwdata", "-1,-1").next().text("位置、品牌、酒店");
            } 
            $("#selectKeyWord").hide();
            $("#mainDiv").show();
            $("#selectKeyWord section:eq(1)").show();
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
                kwTagLis.eq(0).show();isHidekwTag = false;
                for (var i = 0; i < chains.length; i++) {
                    if (hasHotelConditionIDsDic[3].indexOf(chains[i].id) >= 0) {
                        that_brand.append("<li data-id=" + chains[i].id + ">" + chains[i].name + "</li>")
                    }
                }
            }
            //区域
            var cid = $(".J_selectArea").data("cityid");
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
            var chosArr = $("#qKeyWord p").data("kwdata").split(',');
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