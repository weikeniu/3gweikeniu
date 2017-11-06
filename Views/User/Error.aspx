<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string id = RouteData.Values["id"].ToString();

    string[] keys = ViewData["keys"] as string[];
     %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,target-densitydpi=medium-dpi,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-touch-fullscreen" content="yes" />
    <title>温馨提示</title>
    <link href="/Content/style2.css" rel="stylesheet" type="text/css" />
    <script type="application/x-javascript">addEventListener('load',function(){setTimeout(function(){scrollTo(0,1);},0);},false);</script> 
</head>
<%Html.RenderPartial("JS"); %>
<body>
	<div id="header">
    	<a href="javascript:void(0)" onclick="history.go(-1)" class="back">返回上一页</a>
        <h1>温馨提示</h1>
         <% if (keys != null && keys.Length == 2)
            { %><a href="javascript:void(0)" class="home">跳转至首页</a><%} %>
    </div>
    
	<div id="container">
    	<div class="order">
            <div class="nolist">
            	<p>暂无该活动！</p>
                <% if (keys!=null&&keys.Length == 2)
                   { %>
                <a href="/Hotel/Index/<%=id %>?key=<%=keys[0] %>@<%=keys[1] %>">马上去订酒店</a>
                <%} %>
            </div>
        </div>
    </div>
</body>
</html>
