<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string hotelid = RouteData.Values["id"].ToString();
    hotel3g.Models.Hotel hotel = hotel3g.Models.Cache.GetHotel(Convert.ToInt32(hotelid));
    string userweixinID  = hotel3g.Models.Cookies.GetCookies("userWeixinNO",weixinID);
     %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,target-densitydpi=medium-dpi,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-touch-fullscreen" content="yes" />
    <title>我的公众号</title>
    <link href="/css/style.css" rel="stylesheet" type="text/css" />
    <script type="application/x-javascript">addEventListener('load',function(){setTimeout(function(){scrollTo(0,1);},0);},false);</script> 
</head>
<%Html.RenderPartial("JS"); %>
<body>
	<div id="header">
    	<a href="/Hotel/Index/<%=hotelid %>?weixinID=<%=weixinID %>" onclick="history.go(-1)" class="back">返回上一页</a>
        <h1>订单提交成功</h1>
        <a href="/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userweixinID %>" class="home">跳转至首页</a>
    </div>
    
	<div id="container">
    	<div class="order">
            <ul class="info">
                <li>
                    <span class="key">预订房型</span>
                    <span class="value" id="roomtype"></span>
                </li>
                <li>
                    <span class="key">入住日期</span>
                    <span class="value" id="indate"></span>
                </li>
                <li>
                    <span class="key">到店时间</span>
                    <span class="value" id="outdate"></span>
                </li>
                <li>
                    <span class="key" >房型间数</span>
                    <span class="value" id="roomnum"></span>
                </li>
                <li>
                    <span class="key">入住人</span>
                    <span class="value" id="username"></span>
                </li>
                <li>
                    <span class="key">手机号</span>
                    <span class="value" id="phone"></span>
                </li>
                <li>
                    <span class="key" >优惠券</span>
                    <span class="value"><em id="coupon"></em><span class="sm"></span></span>
                </li>
                <li>
                    <span class="key">预订总价</span>
                    <span class="value" ><em id="sumprice"></em><span class="sm"></span></span>
                </li>
            </ul>
            
            <div class="tishi">如果不能在<span id="datein"></span>前到店办理入住，请您提前联系我们客服，协商房间保留事宜。以免房间被过时取消。</div>
            
            <div class="operation">
            	<a href="/Hotel/Map/<%=hotelid %>?weixinID=<%=weixinID %>" class="tohotel">微信导航到酒店</a>
            	<a href="/User/MyOrders/<%=hotelid %>?weixinID=<%=weixinID %>" class="tomember">查看订单详情</a>
            </div>
        </div>
    </div>
    
    <div id="footer">
    	<ul class="links">
        	<li><a href="/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userweixinID %>">首页</a></li>
            <li><a href="/Hotel/NewsinfoList/<%=hotelid %>?weixinID=<%=weixinID %>">优惠促销</a></li>
            <li><a href="/User/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userweixinID %>">会员中心</a></li>
            <li><a href="/User/MyOrders/<%=hotelid %>?weixinID=<%=weixinID %>">我的订单</a></li>
        </ul>
        
        <p class="copyright">技术支持：<a href="http://www.weikeniu.com/">微可牛</a></p>
    </div>
</body>
</html>
<script src="../../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
 <script src="/Scripts/m.hotel.com.core.min.js" type="text/javascript"></script>

<script type="text/javascript">
    (function ($) {
        //没有滚动条则固定在底部
        if ($(document.body).outerHeight(true) == $(document).height()) $("#footer").css("position", "fixed");
    })(jQuery);

    
        var utils = WXweb.utils, OrderJson = utils.getStorage("OrderJson");
        $("#roomtype").html(OrderJson.roomname);
        $("#indate").html(OrderJson.indate);
        $("#outdate").html(OrderJson.lastime);
        $("#roomnum").html(OrderJson.roomnum);
        $("#username").html(OrderJson.username);
        $("#phone").html(OrderJson.linktel);
        $("#coupon").html(OrderJson.coupon);
        $("title").html(OrderJson.hotelname+"官网");
        if ($("#coupon").html() == "0") {
            $("#coupon").parent("span").parent("li").remove();
        }
        $("#sumprice").html("<dfn>¥</dfn>"+OrderJson.sumprice);
        $("#datein").html(OrderJson.indate + OrderJson.lastime);
        var days = GetDateRegion(OrderJson.outdate, OrderJson.indate);
        var jifenFav=<%=hotel.JifenFav %>
        var jifen= parseInt( jifenFav*OrderJson.sumprice);
       if(jifen!=""||jifen!="0")
       {
       $(".sm").html("(返"+jifen+"积分)");
       }
       else
       {
        $(".sm").remove();
       }
        function GetDateRegion(BeginDate, EndDate) {

            var aDate1, aDate2, oDate1, oDate2, iDays;
            aDate1 = BeginDate.split("-");
            oDate1 = new Date(aDate1[1] + '/' + aDate1[2] + '/' + aDate1[0]);   //转换为12/13/2008格式
            aDate2 = EndDate.split("-");
            oDate2 = new Date(aDate2[1] + '/' + aDate2[2] + '/' + aDate2[0]);
            //iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 /24)+1;   //把相差的毫秒数转换为天数
            iDays = (oDate2 - oDate1) / 1000 / 60 / 60 / 24;


            //alert(iDays);
            return iDays;
        }   
</script>
