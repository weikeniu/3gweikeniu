<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<% var dt = ViewData["HotelPictures"] as System.Data.DataTable;
   string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
   string userweixinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO",weixinID);
   string hotelid = RouteData.Values["id"].ToString();
   var hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
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
    <link href="../../css/style.css" rel="stylesheet" type="text/css" />
    <script type="application/x-javascript">addEventListener('load',function(){setTimeout(function(){scrollTo(0,1);},0);},false);</script> 
</head>
<%Html.RenderPartial("JS"); %>
<body class="hotel_pic"> 
    <div class="wrap">
        <dl class="list">
        <%for (int i = 0; i < dt.Rows.Count; i++)
          { %>
        	<dt><%=dt.Rows[i]["title"] %></dt>
            <%var s = dt.Rows[i]["hobby"].ToString().Split(',');
              foreach (var item in s)
              {
               %>
             <%--  <dd><a href="pic_info.html"><img src="public/theme/css/del/hotel_pic.jpg" /></a></dd>--%>

           <dd><a href='/Hotel/PicInfo/<%=hotelid %>?surl=<%=item %>@<%=weixinID %>'><img src=<%=item %> /></a></dd>
            <%} %>
         
           <%} %>
        </dl>
    </div>
    
    <div id="navigation">
        <ul>
            <li><a href='/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userweixinID %>'>预订</a></li>
            <li><a href="/Hotel/Info/<%=hotelid %>?weixinID=<%=weixinID %>">简介</a></li>
            <li class="cur"><a href="/Hotel/Images/<%=hotelid %>?weixinID=<%=weixinID %>">图片</a></li>
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
