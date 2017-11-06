<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    System.Data.DataTable dt = ViewData["dt"] as System.Data.DataTable;

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
    <title>中奖记录</title>
    <link href="../../css/css.css" rel="stylesheet" type="text/css" />
    <%Html.RenderPartial("JSHeader"); %>
</head>
<body>
    <div class="banner cl">
        <ul>
            <li><a href="javascript:void(0)" onclick="history.go(-1)">
                <img src="/img/left_03.png" /></a></li>
            <li class="zhong">中奖记录 </li>
            <li><a href="/Home/Main/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                <img src="/img/home_05.png" /></a></li></ul>
    </div>
    <div class="all cl">
        <div class="youhuijuan cl">
            <div class="youhuijuancon cl">
                <table>
                    <% foreach (System.Data.DataRow dr in dt.Rows)
                       { %>
                    <tr>
                        <td class="y1">
                            <strong>
                                <%=dr["Result"].ToString() %></strong>
                        </td>
                        <td class="y2">
                            <%=Convert.ToDateTime(dr["Choujiangtime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss") %>
                            中奖
                        </td>
                        <td class="y3">
                            <strong class=""></strong>
                        </td>
                    </tr>
                    <%} %>
                </table>
            </div>
        </div>
    </div>
    <%Html.RenderPartial("Copyright"); %>
    <%Html.RenderPartial("Footer", jdata); %>
</body>
</html>
<%Html.RenderPartial("JS"); %>