<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    
    WeiXin.Common.NormalCommon.IsLXSDoMain();
    
    var dt  = ViewData["dt"] as System.Data.DataTable;     

    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string hotelid = RouteData.Values["id"].ToString();
    string userWeiXinID = "";
    userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
    if (weixinID.Equals(""))
    {
        string key = HotelCloud.Common.HCRequest.GetString("key");
        string[] a = key.Split('@');
        weixinID = a[0];
        userWeiXinID = a[1];
    } 
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userWeiXinID);

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();

 
  
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
    <title>我的收藏</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css"/>
        <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/patch.css"/>
<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
<script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
 
</head>
<body class="yu-bgw">

   <header class="yu-bor bbor">
 	<a href="/user/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>" class="back"><div class="new-l-arr"></div></a> 	
 	我的收藏
 </header>
 
 
 <% if (dt.Rows.Count > 0)
    { %>
<section>
	<ul class="sc-list">
       <% for (int i = 0; i < dt.Rows.Count; i++)
          {%>
           
		<li class="yu-bor bbor">
			<a href="<%=dt.Rows[i]["url"].ToString() %>" class="yu-pos-r">
            <%=dt.Rows[i]["name"].ToString() %>
          	<div class="new-r-arr"></div>
			</a>
		</li>

        <%} %>
 
	</ul>
</section>

<%}
    else
    { %>


<!--没有收藏时-->
<section class="yu-tpad120r">
	<div class="no-r-ico"></div>
	<p class="yu-c77 yu-f28r yu-textc ">暂时还未有收藏的酒店</p>
</section>

<%} %>
</body>
</html>
