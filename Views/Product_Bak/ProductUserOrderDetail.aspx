<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    var order = ViewData["Order"] as WeiXin.Models.Home.SaleProducts_Orders;

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
    <title>订单详情</title>
    <link href="<%=ViewData["cssUrl"]%>/css/css.css" rel="stylesheet" type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/productIndex.css" rel="stylesheet" type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/ProductList.css" rel="stylesheet" type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/ProductOrder.css" rel="stylesheet" type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/css/booklist/sale-date.css?v=1.0" rel="stylesheet"
        type="text/css" />

</head>
<body>
    <div class="banner cl">
        <ul>
            <li><a href="javascript:void(0)" onclick="history.go(-1)">
                <img src="/img/left_03.png" /></a></li>
            <li class="zhong">订单详情 </li>
            <li style="display: none"><a href="/User/MyOrders/<%=hotelid%>?key=<%=weixinID %>@<%=userWeiXinID %>">
                <img src="/img/home_05.png" /></a></li></ul>
    </div>
    <div class="base-page list2">
   
        <div class="order-info-box">
            <ul>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        订单编号：</p>
                    <p class="yu-overflow">
                        <%=order.OrderNo %></p>
                </li>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        下单时间：</p>
                    <p class="yu-overflow">
                        <%=order.OrderAddTime%></p>
                </li>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        订单金额：</p>
                    <p class="yu-overflow">
                        ￥<%=order.OrderMoney %></p>
                </li>
            </ul>
        </div>
        <div class="order-info-box">
            <ul>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        产品类型：</p>
                    <p class="yu-overflow">
                        <%=order.ProductType == 0 ? "团购产品" : "预售产品" %></p>
                </li>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        产品名称：</p>
                    <p class="yu-overflow">
                        <%=order.ProductName %></p>
                </li>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        套餐名称：</p>
                    <p class="yu-overflow">
                        <%=order.TcName %></p>
                </li>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        预定数量：</p>
                    <p class="yu-overflow">
                        <%=order.BookingCount %></p>
                </li>
                <%if (order.ProductType == 1)
                  { %>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        出游日期：</p>
                    <p class="yu-overflow">
                        <%=order.CheckInTime.ToString("yyyy-MM-dd")%></p>
                </li>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        订单状态：</p>
                    <p class="yu-overflow">
                        <%= ((WeiXin.Models.Home.ProductSaleOrderStatus)order.OrderStatus).ToString() %></p>
                </li>
                <%} %>
                <% if (order.Ispay)
                   { %>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        付款日期：</p>
                    <p class="yu-overflow">
                        <%=order.PayTime %></p>
                </li>
                <%} %>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        联系人：</p>
                    <p class="yu-overflow">
                        <%=order.LinkName %></p>
                </li>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        联系手机：</p>
                    <p class="yu-overflow">
                        <%=order.UserMobile %></p>
                </li>
                <% if (order.ProductType == 0)
                   {
                       if (order.Ispay)
                       { %>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        预约状态：</p>
                    <% if (order.HexiaoStatus == (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.未预约)
                       { %>
                    <p class="yu-overflow">
                        <%=WeiXin.Models.Home.ProductSaleOrderTuanStatus.未预约.ToString()%>
                    </p>
                    <a href='/Product/ProductUserHexiao/<%=hotelid %>?key=<%=ViewData["key"]%>&OrderNO=<%=order.OrderNo %> '
                        class="hx-btn">预 约</a>
                    <%} %>
                    <% else if (order.HexiaoStatus == (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.预约中)
                        { %>
                    <p class="yu-overflow">
                        <%=WeiXin.Models.Home.ProductSaleOrderTuanStatus.预约中.ToString()%>
                    </p>
                    <%} %>
                    <% else if (order.HexiaoStatus == (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.预约成功)
                        { %>
                    <p class="yu-overflow">
                        <%=WeiXin.Models.Home.ProductSaleOrderTuanStatus.预约成功.ToString()%>
                    </p>
                    <%} %>
                    <% else if (order.HexiaoStatus == (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.已使用)
                        { %>
                    <p class="yu-overflow">
                        <%=WeiXin.Models.Home.ProductSaleOrderTuanStatus.已使用.ToString()%>
                    </p>
                    <%} %>
                    <% else if (order.HexiaoStatus == (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.预约失败)
                        { %>
                    <p class="yu-overflow">
                        <%=WeiXin.Models.Home.ProductSaleOrderTuanStatus.预约失败.ToString()%>
                    </p>
                    <a href='/Product/ProductUserHexiao/<%=hotelid %>?key=<%=ViewData["key"]%>&OrderNO=<%=order.OrderNo %> '
                        class="hx-btn">重新预约</a>
                    <%} %>
                </li>
                <% if (order.HexiaoStatus != (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.未预约)
                   { %>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        使用人：</p>
                    <p class="yu-overflow">
                        <%=order.UserName%></p>
                </li>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        使用日期：</p>
                    <p class="yu-overflow">
                        <%=order.CheckInTime.ToString("yyyy-MM-dd")%></p>
                </li>
                <%} %>
                <%} %>
                <% else
{ %>
                <li class="yu-grid yu-line30">
                    <p class="yu-grey yu-font14 yu-dt">
                        状态：</p>
                    <p class="yu-overflow">
                        <%=  (int)WeiXin.Models.Home.ProductSaleOrderStatus.待支付==order.OrderStatus ?  WeiXin.Models.Home.ProductSaleOrderStatus.待支付.ToString() :
                      WeiXin.Models.Home.ProductSaleOrderStatus.取消.ToString()
                        %>
                    </p>
                </li>
                <%} %>
                <%} %>
            </ul>
        </div>
        <%if (order.OrderStatus == (int)WeiXin.Models.Home.ProductSaleOrderStatus.待支付)
          { %>
        <div class="order-info-box yu-grid">
            <button class="continue-btn" onclick="javascript:window.location='/Product/ProductPay/<%=hotelid%>?key=<%=ViewData["key"]%>&OrderNo=<%=order.OrderNo %>' ">
                支付</button>
        </div>
        <%} %>
        <div class="order-info-box yu-grid">
            <%    string buylink = "/product/ProductIndex/" + hotelid + "?key=" + ViewData["key"] + "&Id=" + order.ProductId; %>
            <% if (order.ProductType == 0)
               {
                   buylink = "/product/ProductIndexGroup/" + hotelid + "?key=" + ViewData["key"] + "&Id=" + order.ProductId; %>
            <%} %>
            <button class="continue-btn" onclick="javascript:window.location='<%=buylink %>'">
                继续预订</button>
        </div>
    </div>

    <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
