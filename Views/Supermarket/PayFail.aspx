﻿<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
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
<title>支付失败</title>
<link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css"/>
<script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
</head>
<body>
	<section class="yu-grid yu-alignc time-bar yu-bg40">
		<p class="f-ico"></p>
		<div class="yu-white">
			<p class="yu-font30">支付失败!</p>
			<p class="yu-font14">感谢您的购买</p>
		</div>
	</section>
	<section class="yu-bgw yu-pad20">
		<p class="yu-c33 yu-font16 yu-bmar10">订单信息</p>
		<p class="yu-c66 yu-font14">该订单会为您保留12小时（从下单之日算起），12小时之后如
果还未付款，系统将自动取消订单。</p>
	</section>
	<footer class="fix-bottom yu-pad10 yu-bgw yu-grid sp">
		<a class="yu-overflow yu-bg40 bottom-btn1 type2 yu-cw lengthen-btn" onclick="PayMoney()">重新支付</a> <%--href="0-5订单明细.html"--%>
		<a class="yu-overflow yu-bor1 bor bottom-btn1 type2 sp yu-c66" href="/Supermarket/OrderPay/<%=ViewData["HotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=<%=ViewData["orderId"] %>">查看订单</a>
	</footer>

	<script type="text/javascript">

	    function PayMoney() {

	        window.location.href = "/Recharge/CardPay/<%=ViewData["HotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderNo=" + '<%=ViewData["orderId"] %> ';
	    }
    </script>

</body>
</html>