<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="qrcode.aspx.cs" Inherits="hotel3g.WeiXinZhiFu.QRcode" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="/m2c/2/style/global.css" rel="stylesheet">
    <meta charset="utf-8">
    <title>微信扫码支付</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=on">
    <link href="http://www.leleku.cn/m2c/2/style/m-reset.css" rel="stylesheet">
    <link href="http://www.leleku.cn/m2c/2/style/global.css" rel="stylesheet">
    <link href="http://www.leleku.cn/m2c/2/style/theme/blue.css" rel="stylesheet">
</head>
<body class="bg">
	<!--头部导航-->
	<header class="top">
    	<div class="main">
        	<div class="left"><a class="goback" onclick="history.go(-1)">&lt; </a></div>
            <div class="right"></div>
            <p class="ti">订单支付</p>
        </div>
    </header>
    <!--头部导航EDN-->    
	<!--订单支付-->
    <div class="wechat-pay pay-center main">
    	<div class="info">
        	<p class="name">付款内容：<%=OrderRoom%></p>
            <p class="price">付款金额：<%=total_fee%>元</p>
        </div>
        <div class="code-box">
        	<div class="cb-top"><p>微信扫码支付</p></div>
            <p class="code-img"><img src=""></p>              
            <p class="cb-tips">支付方式：<br>长按图片→ 二维码图片保存至手机相册→打开微信扫一扫功能点击右上角【相册】→选择刚刚保存的二维码图片，就可识别成功并进入支付流程</p>       
        </div>    
        <% if (!string.IsNullOrEmpty(url)){%><p class="tips"><a href="<%=url %>">返回预订酒店到付房型</a></p><%} %>
    </div>
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.js"></script>
    <script type="text/javascript">
        $(function () {
            $.post("/WeiXinZhiFu/qrcode.aspx", { action: "code", OrderNo: "<%=OrderNo %>" }, function (data) {
                $("img").attr("src", "/WeiXinZhiFu" + data);
            });
        });
    </script>
</body>
</html>
