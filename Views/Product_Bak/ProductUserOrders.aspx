<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    var orders = ViewData["Orders"] as List<WeiXin.Models.Home.SaleProducts_Orders>;   
 

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
<head runat="server">
<meta http-equiv="content-type" content="text/html;charset=utf-8" /> 
<meta name="format-detection" content="telephone=no">
<!--自动将网页中的电话号码显示为拨号的超链接-->
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
<!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
<meta name="apple-mobile-web-app-capable" content="yes">
<!--IOS设备-->
<meta name="apple-touch-fullscreen" content="yes">
<!--IOS设备-->
<meta http-equiv="Access-Control-Allow-Origin" content="*">
    <title>团购预售订单</title>
           <link href="<%=ViewData["cssUrl"]%>/css/css.css" rel="stylesheet" type="text/css" /> 
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/productIndex.css" rel="stylesheet" type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/ProductList.css" rel="stylesheet" type="text/css" />
</head>
<body>

   <div class="banner cl">
        <ul>
            <li><a href="javascript:void(0)" onclick="history.go(-1)">
                <img src="/img/left_03.png" /></a></li>
            <li class="zhong">团购预售订单 </li>
            <li><a href="/home/main/<%=hotelid%>?key=<%=weixinID %>@<%=userWeiXinID %>">
                <img src="/img/home_05.png" /></a></li></ul>
 
 
    </div>
    <div class="base-page list2">
        <div class="back">
        </div>
      
        <ul class="rooms-list sp">
            <% if (orders != null && orders.Count > 0)
               {
                   foreach (var item in orders)
                   {

                       string classtuan = item.ProductType == 0 ? "tuan" : "yu";
		 
            %>
            <li>
                <div class="room-content-head yu-grid">
                    <div class="room-pic <%=classtuan %>">
                        <img src="../../images/room_03.png" />
                    </div>
                    <div class="yu-overflow">
                        <div class="room-name yu-bmar10">
                            <%=item.ProductName%></div>
                    </div>
                    <div>  
                        <p class="yu-font14 yu-orange yu-textr yu-bmar10">
                            ￥<%=item.OrderMoney%></p>  
                        <a href='/Product/ProductUserOrderDetail/<%=hotelid %>?key=<%=ViewData["key"]%>&OrderNO=<%=item.OrderNo %>' class="yu-del">查看订单</a>
                    </div>
                </div>
            </li>
            <%}
               } %>
            <% else
                { %>
            <div class="no-more-row">
                <div class="border">
                </div>
                <p>
                    没有订单</p>
            </div>
            <%} %>
        </ul>
    </div>
</body>
</html>
