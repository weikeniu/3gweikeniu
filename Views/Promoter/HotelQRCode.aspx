﻿<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
    hotel3g.Repository.HotelInfoItem HotelInfo = ViewData["HotelInfo"] as hotel3g.Repository.HotelInfoItem;
     %>

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
<title>分享二维码</title>
<link type="text/css" rel="stylesheet" href="../../css/booklist/sale-date.css"/>
<script type="text/javascript" src="../../Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="../../Scripts/fontSize.js"></script>
</head>
<body >
	<article class="wx-page">
		<section class="wx-box">
			<div class="wx-logo full-img"><img src="<%=HotelInfo.hotelLog %>" /></div>
			<div class="yu-tpad120r yu-bpad20r yu-textc wx-shadow yu-bmar60r">
				<p class="yu-f36r"><%=HotelInfo.SubName %></p>
				<p class="yu-f20r">微信号：<%=ViewData["WeiXinNO"]%></p>
			</div>
			<div class="wx-ewm full-img yu-bmar30r"><img src="<%=ViewData["QR_Code"]  %>" /></div>
			<p class="yu-f26r yu-textc yu-bmar30r">扫描二维码访问</p>
			<div class="yu-grid yu-alignc yu-lpad135r">
				<p class="sm-ico full-img yu-rmar10r"><img src="../../images/saomiao.png" /></p>
				<p class="yu-overflow yu-c77 yu-f22r">打开微信，扫一扫二维码访问</p>
			</div>
		</section>
	</article>
</body>
</html>
