<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="resultNotifyPage.aspx.cs" Inherits="hotel3g.WeiXinZhiFu.resultNotifyPage" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
    <meta content="no-cache,must-revalidate" http-equiv="Cache-Control">
    <meta content="no-cache" http-equiv="pragma">
    <meta content="0" http-equiv="expires">
    <meta content="telephone=no, address=no" name="format-detection">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>订单信息</title>
    <link href="/css/css.css" rel="stylesheet" type="text/css" />
    <script src="/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
</head>
<body>
<%
    if (order != null)
    {        
        string payresult = "订单未支付！";
        string message = "请在30分钟内完成支付，否则系统自动取消。";        
        int night = (Convert.ToDateTime(order.LeaveDate) - Convert.ToDateTime(order.ComeDate)).Days;
        if (error == "cancel") { payresult = "支付过程中用户取消！"; }
        if (error == "fail") { payresult = "支付失败！"; }
        if (order.TradeAlipayAmount > 0 && order.TradeStatus=="TRADE_FINISHED")
        {
            payresult = "订单支付成功！";
            string mt = string.Empty;
            if (!string.IsNullOrEmpty(order.LinkTel) && order.LinkTel.Length>=11)
                mt =order.LinkTel.Substring(0, 3) + "******" + order.LinkTel.Substring(9, 2);
            message = "请保持"+mt+"手机通讯，稍后您将受到酒店确认短信，请注意查收。";
        }                
    %>
    <div class="all">
        <div class="top cl">
            <h1>
                <%=payresult %></h1>
            <h3>
                <%=message %></h3>
        </div>
        <div class="cont">

            <dl>
                <dt>预订房型</dt>
                <dd id="roomtype">
                     <%=order.RoomName %>(<%=order.RatePlanName %>)
                </dd>
            </dl>
            <dl>
                <dt>预订房间数</dt>
                <dd id="roomcount">
                    <%=order.RoomNum %>
                </dd>
            </dl>
            <dl>
                <dt>入住日期</dt>
                <dd id="Dd1">
                    <%=order.ComeDate%>
                </dd>
            </dl>
            <dl>
                <dt>退房日期</dt>
                <dd id="Dd2">
                    <%=order.LeaveDate%>
                </dd>
            </dl>
            <dl>
                <dt>入住人姓名</dt>
                <dd id="Dd3">
                    <%=order.UserName%>
                </dd>
            </dl>
        </div>
        <div class="anniu1 cl">
            <a href="/user/MyOrders/<%=order.HotelID %>?key=<%=order.WeiXinID  %>@<%=order.UserWeiXinID %>">查看订单</a>
        </div>
        <div class="anniu2 cl">
            <a href="/hotel/map/<%=order.HotelID %>?key=<%=order.WeiXinID  %>@<%=order.UserWeiXinID %>">查看酒店导航</a>
        </div>
    </div>
    <div class="cccont cl"></div>
    <%} %>
</body>
</html>