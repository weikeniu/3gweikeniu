<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string userweixinid = HotelCloud.Common.HCRequest.GetString("userweixinid");
    string hotelid = RouteData.Values["id"].ToString();
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userweixinid);
    string tmpdate = HotelCloud.Common.HCRequest.GetString("indate");
    if (!string.IsNullOrEmpty(tmpdate))
    {
        DateTime tmpd = Convert.ToDateTime(tmpdate);
        if (tmpd != null)
        {
            tmpdate = tmpd.ToString("MM月dd日");
        }
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"
        name="viewport">
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
    <link href="../../css/css.css" rel="stylesheet" type="text/css" />
    <%Html.RenderPartial("JSHeader"); %>
    <script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
</head>
<%Html.RenderPartial("JSHeader"); %>
<body>
    <div class="all">
        <div class="top cl">
            <h1>
                订单提交成功！</h1>
            <h3>
                订单结果将以微信,电话通知,请保持手机畅通。</h3>
        </div>
        <div class="cont">
            <dl>
                <dt>预订房型</dt>
                <dd id="roomtype">
                </dd>
            </dl>
            <dl>
                <dt>预订房间数</dt>
                <dd id="roomcount">
                </dd>
            </dl>
            <dl>
                <dt>房间保留到</dt>
                <dd id="lastTime">
                </dd>
            </dl>
            <dl>
                <dt>预订时间</dt>
                <dd id="booktime">
                </dd>
            </dl>
            <dl>
                <dt>手机号</dt>
                <dd id="cellphone">
                </dd>
            </dl>
            <dl>
                <dt>优惠券</dt>
                <dd>
                    <strong id="coupon">0</strong><strong>元</strong><span>已为您使用优惠券抵扣<span id="coupon2">0</span>元</span>
                </dd>
            </dl>
            <dl class="dxian">
                <dt>预定总价</dt>
                <dd>
                    <strong id="totalprice">0元</strong><%--<br />
                    <span><strong>本次预订比网络价节省<strong id="lessprice">0</strong>元</strong></span>--%>
                </dd>
            </dl>
            <p>
                如果不能在<strong id="date"></strong><strong id="time"></strong>，请联系酒店 <span id="tel">
                </span>协商房间保留事宜。以免房间被过时取消。
            </p>
            <div class="mashang cl" id="giftcoupon" style="display: none">
                酒店赠送您一张优惠券，下次预订即省<strong></strong>！</div>
        </div>
        <div class="anniu1 cl">
            <a href="/user/MyOrders/<%=hotelid %>?key=<%=weixinID %>@<%=userweixinid %>">查看订单</a>
        </div>
        <div class="anniu2 cl">
            <a href="/hotel/map/<%=hotelid %>?key=<%=weixinID %>@<%=userweixinid %>">查看酒店导航</a>
        </div>
    </div>
    <div class="cccont cl">
    </div>
    <%Html.RenderPartial("Copyright"); %>
    <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
<%Html.RenderPartial("JS"); %>
<script src="/Scripts/m.hotel.com.core.min.js" type="text/javascript"></script>
<script type="text/javascript">
    var utils = WXweb.utils;
    var OrderJson = utils.getStorage("OrderJson");

    $("#roomtype").html(OrderJson.roomname + " / " + OrderJson.realprice + "元");
    var roomcount = parseInt(OrderJson.roomnum);
    $("#roomcount").html(roomcount + "间");
    $("#booktime").html(OrderJson.indate + "入住&nbsp;&nbsp;&nbsp;&nbsp;" + OrderJson.outdate + "离店");
    $("#lastTime").html(OrderJson.lastime);
    var userNameAry = OrderJson.username.toString().split(",");
    for (var i = 1; i <= roomcount; i++) {
        var obj = '<dl><dt>房间' + i + '入住人</dt><dd>' + userNameAry[i - 1] + '</dd></dl>';
        $("#cellphone").closest("dl").before(obj);
    }
    $("#cellphone").html(OrderJson.linktel);
    $("#coupon,#coupon2").html(OrderJson.coupon);
    $("#totalprice").html(OrderJson.sumprice + "元");
    if (OrderJson.giftCouponPrice !== "0") {
        $("#giftcoupon").css("display", "block");
        $("#giftcoupon").find("strong").text(OrderJson.giftCouponPrice);
    }

    $("#date").text("<%=tmpdate %>");
    $("#time").text(OrderJson.lastime);

    if (parseInt(OrderJson.netPrice) > 0) {
        var lessprice = (parseFloat(OrderJson.netPrice) - parseFloat(OrderJson.realprice)) * parseInt(OrderJson.roomnum);
        var html = '<br /><span><strong>本次预订比网络价节省<strong>' + lessprice + '</strong>元</strong></span>';
        $("#totalprice").append(html);
    }

    $("#tel").text(OrderJson.hoteltel);
</script>
