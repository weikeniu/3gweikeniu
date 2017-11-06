<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
string hotelid = RouteData.Values["id"].ToString();
  var hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
  string pos = HotelCloud.Common.HCRequest.GetString("pos");
  string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
  string userweixinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO",weixinID);
  string key = "";
  if (weixinID.Equals(""))
  {
      key = HotelCloud.Common.HCRequest.GetString("key");
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
	<div class="hotel_info">
		<h2>基本信息</h2>
        <ul class="attr base">
        	<li><span class="key">开业：</span><span class="value"><%=hotel.openDate %></span></li>
             <% if (hotel.xiuDate != "")
                { %>
            <li><span class="key">装修：</span><span class="value"><%=hotel.xiuDate %></span></li>
            <%} %>
            <li><span class="key">电话：</span><span class="value"><%=hotel.Tel %></span></li>
            <li><span class="key">地址：</span><span class="value"><%=hotel.StarName[hotel.Star] %></span></li>
        </ul>
        
        <h2>设施服务</h2>
        <ul class="attr service">
        	<li><span class="key">房间设施</span><span class="value"><%=hotel.KeFang.Replace(";", "；")%></span></li>
            <% if (!hotel.CanYin.Equals(""))
               { %>
            <li><span class="key">餐饮设施</span><span class="value"><%=hotel.CanYin.Replace(";", "；")%></span></li>
            <%} %>
             <% if (!hotel.YuLe.Equals(""))
                { %>
            <li><span class="key">娱乐设施</span><span class="value"><%=hotel.YuLe.Replace(";", "；")%></span></li>
            <%} %>
             <% if (!hotel.HuiYi.Equals(""))
                { %>
            <li><span class="key">会议服务</span><span class="value"><%=hotel.HuiYi.Replace(";", "；")%></span></li>
            <%} %>
            <% if (!hotel.AddBedPrice.Equals(""))
               { %>
            <li><span class="key">加床价格</span><span class="value"><%=hotel.AddBedPrice.Replace(";", "；")%></span></li>
            <%} %>
        </ul>
         <%
            var roundValue = hotel.RoundValue;
            List<Dictionary<string, string>> c = new List<Dictionary<string, string>>();
            if (!string.IsNullOrEmpty(roundValue))
            {
                c = (List<Dictionary<string, string>>)Newtonsoft.Json.JsonConvert.DeserializeObject(roundValue, typeof(List<Dictionary<string, string>>));
            }
             %>
        <h2>交通位置</h2>
        <ul class="traffic">
        <%foreach (var dic in c)
          { %>
        	<li><span class="key">距离<%=dic["name"]%><%=dic["juli"] %>公里</span><span class="value"><em></em></span></li>
           <%} %>
        </ul>
        
        <h2>酒店简介</h2>
        <div class="intro">
        	<%=hotel.Content.Replace(";","；") %>
        </div>
    </div>
    
    <div id="navigation">
        <ul>
            <li><a href='/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userweixinID %>'>预订</a></li>
            <li class="cur"><a href="/Hotel/Info/<%=hotelid %>?weixinID=<%=weixinID %>">简介</a></li>
            <li><a href="/Hotel/Images/<%=hotelid %>?weixinID=<%=weixinID %>">图片</a></li>
            <li><a href="/Hotel/Map/<%=hotelid %>?weixinID=<%=weixinID %>">地图</a></li>
        </ul>
    </div>
</body>
</html>
<script src="../../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
<script type="text/javascript">
    (function ($) {
        /*菜单导航*/
        $("#navigation>ul>li").each(function () {
            $(this).click(function () {
                $(this).attr("class", "cur").siblings("li").removeClass();
            });
        });
    })(jQuery);
</script>
