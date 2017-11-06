<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<% var info = ViewData["HotelNewsinfo"] as hotel3g.Models.HotelNews;
   string hotelid = RouteData.Values["id"].ToString();
   string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
   string userWeiXinID = "";
   userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO",weixinID);
   var hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
  int nid=Convert.ToInt32(ViewData["HotelNewsID"]);
  int preid=Convert.ToInt32(ViewData["preid"]);
  int nextid=Convert.ToInt32(ViewData["nextid"]);
  if (weixinID.Equals(""))
  {
      string key = HotelCloud.Common.HCRequest.GetString("key");
      weixinID = key.Split('@')[0];
  }
   %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,target-densitydpi=medium-dpi,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-touch-fullscreen" content="yes" />
    <title><%=hotel.SubName %>官网</title>
    <link href="/css/style.css" rel="stylesheet" type="text/css" />
    <script type="application/x-javascript">addEventListener('load',function(){setTimeout(function(){scrollTo(0,1);},0);},false);</script> 
</head>
<%Html.RenderPartial("JS"); %>
<body>
	<div id="header">
    	<a href="javascript:void(0)" onclick="history.go(-1)" class="back">返回上一页</a>
        <span class="h1">优惠促销</span>
       <a href="/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>" class="home">跳转至首页</a>
    </div>
    
	<div id="container">
    	<div class="news">
            <div class="info">
                <h1><%=info.Title%></h1>
                <div class="con">
                    <%--<p><img src="public/theme/css/del/news.jpg" width="100%" /></p>--%>
                    <p><%=info.Content %></p>
                </div>
                
                <div class="operation">
                   <%-- <a href="javascript:;" class="pre">上一篇</a>--%>
                    <a <% if(nid==preid){ %> href="javascript:void(0)" <%}else{ %> href="/Hotel/Newsinfo/<%=hotelid %>?weixinID=<%=weixinID %>&id=<%=preid %>" <%} %> class="pre" >上一篇</a>
                    <a href="/Hotel/NewsInfoList/<%=hotelid %>?weixinID=<%=weixinID %>" class="back">返回列表</a>
                  <a <% if(nid==nextid){ %> href="javascript:void(0)" <%}else{ %> href="/Hotel/Newsinfo/<%=hotelid %>?weixinID=<%=weixinID %>&id=<%=nextid %>" <%} %> class="next" >下一篇</a>
                </div>
            </div>
        </div>
    </div>
    
    <div id="footer">
    	<ul class="links">
        	<li><a href="/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>">首页</a></li>
            <li><a href="/Hotel/NewsinfoList/<%=hotelid %>?weixinID=<%=weixinID %>">优惠促销</a></li>
            <li><a href="/User/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>">会员中心</a></li>
            <li><a href="/User/MyOrders/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>">我的订单</a></li>
        </ul>
        
        <p class="copyright">技术支持：<a href="http://www.weikeniu.com/">微可牛</a></p>
    </div>
</body>
</html>
<script src="../../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
<script type="text/javascript">
    (function ($) {
        //没有滚动条则固定在底部
        if ($(document.body).outerHeight(true) == $(document).height()) $("#footer").css("position", "fixed");
    })(jQuery);
</script>
