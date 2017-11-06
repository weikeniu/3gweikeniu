<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    hotel3g.Repository.Order info=ViewData["data"] as hotel3g.Repository.Order;
    
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string userweixinid = HotelCloud.Common.HCRequest.GetString("userweixinid");
    string hotelid = HotelCloud.Common.HCRequest.GetString("hotelId");
    if (info != null && info.Id>0)
    {
        weixinID = info.WeiXinID;
        userweixinid = info.UserWeiXinID;
        hotelid = info.HotelID.ToString();
    }
    
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
                支付成功！</h1>
            <h3>
                订单结果将以微信,电话通知,请保持手机畅通。</h3>
        </div>
        <div class="cont">
        <%
            if (info != null)
            {
             %>
            <dl>
                <dt>预订房型</dt>
                <dd id="roomtype">
                <%=info.RoomName %>(<%=info.RatePlanName %>)
                </dd>
            </dl>
            <dl>
                <dt>预订房间数</dt>
                <dd id="roomcount">
                <%=info.RoomNum %>
                </dd>
            </dl>
            <dl>
                <dt>房间保留到</dt>
                <dd id="lastTime">
                <%=info.LastTime %>
                </dd>
            </dl>
            <%--<dl>
                <dt>手机号</dt>
                <dd id="cellphone">
                <%=info.LinkTel %>
                </dd>
            </dl>--%>
            <p class="note">
                如果不能在<strong id="date"></strong><strong id="time"></strong>，请联系酒店 <span id="tel">
                </span>协商房间保留事宜。以免房间被过时取消。
            </p>
            <%} %>
        </div>
        <div class="anniu1 cl">
            <a href="/user/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userweixinid %>">进入会员中心</a>
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
</script>