<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    if (weixinID.Equals(""))
    {
        string key = HotelCloud.Common.HCRequest.GetString("key");
        weixinID = key.Split('@')[0];
    }
    string id = RouteData.Values["id"].ToString();
    ViewData["weixinid"] = weixinID;
    ViewData["id"] = id;
    System.Data.DataTable dt = ViewData["dt"] as System.Data.DataTable;
     %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,target-densitydpi=medium-dpi,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-touch-fullscreen" content="yes" />
    <title>我的积分</title>
    <link href="/Content/style2.css" rel="stylesheet" type="text/css" />
    <script type="application/x-javascript">addEventListener('load',function(){setTimeout(function(){scrollTo(0,1);},0);},false);</script> 
</head>
<%Html.RenderPartial("JS"); %>
<body>
	<div id="header">
    	<a href="javascript:void(0)" onclick="history.go(-1)" class="back">返回上一页</a>
        <h1>我的积分</h1>
        <a href="javascript:void(0)" class="home">跳转至首页</a>
    </div>
    
	<div id="container">
    	<div class="jifen">
            <% if (dt.Rows.Count > 0)
               { %>
            <div class="table list">
            <% foreach (System.Data.DataRow dr in dt.Rows)
               { %>
                <ul class="tr">
                	<li class="td1"><%=dr["remark"].ToString()%></li>
                    <li class="td2"><%=dr["JIFen"].ToString()%>积分</li>
                    <li class="td3">
                    	<%=Convert.ToDateTime(dr["addTime"].ToString()).ToString("yyyy-MM-dd")%>
                    </li>
                </ul>
             <%} %>
            </div>
            <%}
               else
               { %>
            
            <div class="nolist">
            	<p>亲，这里神马积分记录都木有哦！</p>
                <a href="/Hotel/Index/<%=id %>?weixinID=<%=weixinID %>">马上去订酒店</a>
            </div>
            <%} %>
        </div>
    </div>
</body>
</html>
