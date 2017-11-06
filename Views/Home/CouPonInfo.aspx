<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    var dt = ViewData["dt"] as System.Data.DataTable;
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
    <title>订房红包</title>
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=1.0" rel="stylesheet"
        type="text/css" />
    <link href="/css/css.css" rel="stylesheet" type="text/css" />
    <%Html.RenderPartial("JSHeader"); %>
</head>
<body>
    <style>
        .coupons .money
        {
            clear: both;
            overflow: hidden;
            padding: 0 10px;
        }
        .coupons .money dt
        {
            font-size: 14px;
            color: #000;
            clear: both;
            overflow: hidden;
            height: 30px;
            line-height: 30px;
            text-align: left;
        }
        .coupons .money dd
        {
            float: left;
            padding: 5px 15px;
            border: solid 1px #dee1e1;
            font-family: "微软雅黑";
            font-size: 16px;
            color: #17b9e3;
            background: #f7fafb;
            margin-right: 10px;
            margin-bottom: 10px;
        }
        .coupons .money dd.cur
        {
            background: #ff4902;
            color: #FFF;
        }
        .coupons .preview
        {
            border-radius: 5px;
            background: #fae192;
            margin: 10px;
            box-shadow: 2px 2px 3px rgba(150,150,150,1);
            text-align: left;
            margin-bottom: 20px;
        }
        .coupons .preview dt
        {
            font-size: 14px;
            height: 30px;
            line-height: 30px;
            padding: 0 10px;
            color: #000;
        }
        .coupons .preview .intro
        {
            height: 57px;
            font-size: 20px;
            color: #FFF;
            text-align: center;
            background: #c86d00;
            line-height: 23px;
            padding: 8px 0 0;
            font-weight: bold;
            font-family: "微软雅黑";
            letter-spacing: 1px;
        }
        .coupons .preview .intro em
        {
            font-size: 50px;
            font-family: "微软雅黑";
            display: inline-block;
            line-height: 45px;
            margin-right: 5px;
        }
        .coupons .preview ul
        {
            padding: 7px 10px;
            overflow: hidden;
            clear: both;
        }
        .coupons .preview li
        {
            color: #cc7711;
            line-height: 1.4;
            padding-left: 60px;
            clear: both;
            overflow: hidden;
        }
        .coupons .preview li span
        {
            float: left;
        }
        .coupons .preview li .key
        {
            margin-left: -60px;
        }
        .coupons .operation
        {
            clear: both;
            overflow: hidden;
            padding: 10px;
        }
        .coupons .operation a
        {
            border-radius: 5px;
            padding: 6px 6%;
            color: #FFF;
            font-size: 16px;
            float: left;
            text-shadow: 0 0 3px #000;
        }
        .coupons .operation .touse
        {
            background: #4ea20b;
        }
        .coupons .operation .tomember
        {
            background: #17b9e3;
            float: right;
        }
        .coupons .operation .toget
        {
            float: none;
            clear: both;
            background: #17b9e3;
            width: 100%;
            padding: 6px 0;
            display: block;
            margin-top: -10px;
        }
    </style>
    <div class="banner cl">
        <ul>
            <li><a href="javascript:void(0)" onclick="history.go(-1)">
                <img src="/img/left_03.png" /></a></li>
            <li class="zhong">订房红包</li>
            <li><a href="/Home/Main/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                <img src="/img/home_05.png" /></a></li></ul>
    </div>
    <div class="all">
        <div class="contbuc">
            <div class="coupons">
                <div class="preview">
                    <dl>
                        <dt></dt>
                        <dd class="intro">
                            成功领取<br />
                            <%=dt.Rows[0]["moneys"] %>元订房红包</dd>
                        <dd>
                            <ul>
                                <li><span class="key">有效日期：</span> <span class="value">
                                    <%=Convert.ToDateTime(dt.Rows[0]["sTime"].ToString()).ToString("yyyy-MM-dd") %>至<%=Convert.ToDateTime(dt.Rows[0]["ExtTime"].ToString()).ToString("yyyy-MM-dd") %></span>
                                </li>
                                <li><span class="key">使用说明：</span> <span class="value">在订单填写页面使用该红包，即可抵消<%=dt.Rows[0]["moneys"] %>元现金。</span>
                                </li>
                            </ul>
                        </dd>
                    </dl>
                </div>
                <div class="operation">
                    <a href="/Hotel/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>"
                        class="touse">马上预订使用</a> <a href="/User/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>"
                            class="tomember">进入会员中心</a>
                </div>
            </div>
        </div>
    </div>
    <%--<div id="container">
        <div class="coupons">
            <div class="preview">
                <dl>
                    <dt></dt>
                    <dd class="intro">成功领取<br /><%=dt.Rows[0]["moneys"] %>元优惠券</dd>
                    <dd>
                        <ul>
                            <li>
                            	<span class="key">有效日期：</span>
                                <span class="value"><%=Convert.ToDateTime(dt.Rows[0]["sTime"].ToString()).ToString("yyyy-MM-dd") %>至<%=Convert.ToDateTime(dt.Rows[0]["ExtTime"].ToString()).ToString("yyyy-MM-dd") %></span>
                            </li>
                            <li>
                            	<span class="key">使用说明：</span>
                                <span class="value">在订单填写页面使用该券，即可抵消<%=dt.Rows[0]["moneys"] %>元现金。</span>
                            </li>
                        </ul>
                    </dd>
                </dl>
            </div>
            
            <div class="operation">
            	<a href="/Hotel/Index/<%=id %>?weixinID=<%=weixinID %>" class="touse">马上预订使用</a>
            	<a href="/User/Index/<%=id %>?weixinID=<%=weixinID %>" class="tomember">进入会员中心</a>
            </div>
        </div>
    </div>--%>
    <%    
        ViewDataDictionary viewDic = new ViewDataDictionary();
        viewDic.Add("weixinID", ViewData["weixinID"]);
        viewDic.Add("hId", ViewData["hId"]);
        viewDic.Add("uwx", ViewData["userWeiXinID"]);
        Html.RenderPartial("Footer", viewDic); 
    %>
</body>
</html>
<%Html.RenderPartial("JS"); %>
