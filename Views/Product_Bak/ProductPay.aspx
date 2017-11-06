<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% 
    var order = ViewData["order"] as WeiXin.Models.Home.SaleProducts_Orders;


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
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
    <title>付款详情</title>
    <link href="<%=ViewData["cssUrl"]%>/css/booklist/sale-date.css?v=1.0" rel="stylesheet"
        type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/productIndex.css" rel="stylesheet"
        type="text/css" />
    <script src="<%=ViewData["jsUrl"]%>/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/pay.css" rel="stylesheet"
        type="text/css" />
</head>
<body>
    <div class="top">
        付款详情</div>
    <div class="user-info">
        <dl>
            <dt>订单信息</dt>
            <dd>
                <p class="info-text text-over">
                    <%= order.ProductName %>
                    -
                    <%=order.TcName %></p>
            </dd>
        </dl>
        <dl class="last">
            <dt>需付款</dt>
            <dd>
                <p class="info-text text-over orange">
                    <%=order.OrderMoney %></p>
            </dd>
        </dl>
    </div>
    <div class="pay-box">
        <input type="button" value="确认付款" class="pay" /></div>
    <%Html.RenderPartial("Footer", viewDic); %>
    <script>

        $(".pay").click(function () {

            $(".pay").attr("disabled", true);
            var message = '<%=Request.QueryString["OrderNo"] %>';

            window.location.href = '/Recharge/CardPay/<%=hotelid%>?key=<%=weixinID %>@<%=userWeiXinID %>&orderNo=' + message;

            //            window.location.href = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx4231803400779997&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fwxOAuthRedirect.aspx&response_type=code&scope=snsapi_base&state=" + message + "#wechat_redirect";

        });

        
    </script>
</body>
</html>
