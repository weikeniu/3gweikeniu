<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    
    IList<hotel3g.Common.CouponInfo> dt = ViewData["dt"] as IList<hotel3g.Common.CouponInfo>;

    ViewDataDictionary jdata = new ViewDataDictionary();
    jdata.Add("weixinID", ViewData["weixinID"]);
    jdata.Add("hId", ViewData["hId"]);
    jdata.Add("uwx", ViewData["userWeiXinID"]);
     %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"
        name="viewport">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <!-- Mobile Devices Support @begin -->
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
    <meta content="no-cache,must-revalidate" http-equiv="Cache-Control">
    <meta content="no-cache" http-equiv="pragma">
    <meta content="0" http-equiv="expires">
    <meta content="telephone=no, address=no" name="format-detection">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!-- apple devices fullscreen -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>我的优惠券</title>
    <link href="/css/css.css" rel="stylesheet" type="text/css" />
     <%Html.RenderPartial("JSHeader"); %>
    </head>
<body>
	<div class="banner cl">
        <ul>
            <li><a href="javascript:void(0)" onclick="history.go(-1)">
                <img src="/img/left_03.png" /></a></li>
            <li class="zhong">我的优惠券 </li>
            <li><a href="/Home/Main/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                <img src="/img/home_05.png" /></a></li></ul>
    </div>
    <div class="all cl">
        <div class="youhuijuan cl">
            <%
                int sum = 0;
                foreach (var m in dt)
                {
                    if(m.State=="未使用")
                        sum += m.Moneys;
                }
                 %>
            <h1>优惠劵为您节省<%=sum%>元</h1>
            <div class="youhuijuancon cl">
                <table>
                <% foreach (hotel3g.Common.CouponInfo dr in dt)
               { %>
               <tr>
                        <td class="y1">
                        <strong><%=dr.Moneys %>元优惠劵</strong>
                        </td>
                        <td class="y2">
                        <%=dr.StartTime %><span>起</span><br />
                         <%=dr.EndTime%><span>至</span><br />
                        </td>
                       <td class="y3">
                       <strong class="<%=((dr.State=="已使用" || dr.State=="已过期")?"":"on") %>"><%=dr.State %></strong>
                        </td>
                    </tr>
            <%} %>
                </table>
            </div>
        </div>
    </div>
    <%Html.RenderPartial("Footer",jdata); %>
</body>
</html>
<%Html.RenderPartial("JS"); %>
