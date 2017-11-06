<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%string hotelid = RouteData.Values["id"].ToString();
  string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
  var hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
  var count = ViewData["pagecount"].ToString();
  var news = ViewData["news"] as List<hotel3g.Models.HotelNews>;
  string userWeiXinID = "";
  userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO",weixinID);
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
        <h1>优惠促销</h1>
        <a href="/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>" class="home">跳转至首页</a>
    </div>
    
	<div id="container">
    	<div class="news">
            <ul class="list">
            <% foreach (var n in news)
               { %>
                <li>
                    <a href="/Hotel/NewsInfo/<%=hotelid %>?id=<%=n.Id %>&weixinID=<%=weixinID %>"><%=n.Title%></a>
                    <span class="time"><%=n.AddTime%><% if (n.Content.Equals("1"))
                                                        { %><em>NEW</em></span>
                                                                                                                                                                  <%} %>
                </li>
                <%} %>
                <%--<li>
                    <a href="news_info.html">广州金顺九鼎专属鲁行产婆特惠</a>
                    <span class="time">08-15</span>
                </li>
                <li>
                    <a href="news_info.html">广州金顺九鼎专属鲁行产婆特惠</a>
                    <span class="time">08-15</span>
                </li>
                <li>
                    <a href="news_info.html">广州金顺九鼎专属鲁行产婆特惠</a>
                    <span class="time">08-15</span>
                </li>
                <li>
                    <a href="news_info.html">广州金顺九鼎专属鲁行产婆特惠</a>
                    <span class="time">08-15</span>
                </li>--%>
            </ul>
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
        var pagecount=<%=count %>;
        var page=1;
        $.load = function (page) {
            $.get("/Hotel/GetNewsList/<%=hotelid %>?r" + Math.random(), { page: page, weixinID: "<%=weixinID %>" }, function (data) {
                data = eval("(" + data + ")");
                if (data.data) {
                    var obj = data.data;
                    var html = "";
                    if (obj.length > 0) {
                        for (var i = 0; i < obj.length; i++) {
                            html += "<li><a  href='/Hotel/NewsInfo/<%=hotelid %>?id="+obj[i].Id+"&weixinID=<%=weixinID %>'>" + obj[i].Title+"["+obj[i].AddTime+"]" + "</a>" + (obj[i].Content == "1" ? "<span class='new'>new</span>" : "") + "</li>";
                        }
                    }
                    $("#newslist").html($("#newslist").html() + html);
                }
            });
        }
        $(document).scroll(function(){
            if($(document).scrollTop()+30>=$(document).height()-$(window).height()){
                if(page<pagecount){
                    page++;
                    $.load(page);
                }
            }
        });                  
 

</script>
