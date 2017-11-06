<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% 
    var products = ViewData["products"] as WeiXin.Models.Home.SaleProduct;

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
    <title>填写订单</title>

   
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/productIndex.css" rel="stylesheet" type="text/css" />
      <script src="<%=ViewData["jsUrl"]%>/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/pay.css" rel="stylesheet" type="text/css" />

 
      <script src="<%=ViewData["jsUrl"]%>/Scripts/layer/layer.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" action='/Product/ProductPay/<%=hotelid %>?key=<%=ViewData["key"]%>' method="post">
        <div class="back" onclick="javascript:history.go(-1);">
        </div>
        <div class="top">
            填写订单
        </div>
    <div class="tc-info">
        <p class="row1  text-over">
            <%=products.ProductName %>
            <input type="hidden" name="productId" value='<%=Request.QueryString["ProductId"] %>' />
            <input type="hidden" name="tcId" value='<%=Request.QueryString["tcId"] %>' />
            <input type="hidden" name="bookingCount" value='<%=Request.QueryString["buyAmount"] %>' />
            <input type="hidden" name="t" value='<%=Request.QueryString["t"] %>' />
            <input type="hidden" name="sign" value='<%=Request.QueryString["sign"] %>' />
        </p>
        <% string show = products.ProductType == 0 ? "none" : ""; %>
        <p class="row2  text-over" style='display: <%=show %>'>

            出发日期：<%=Request.QueryString["date"] %>
            <input type="hidden" value='<%=Request.QueryString["date"] %>' name="traveldate" />
        </p>
        <p class="row3  text-over">
            <%=products.List_SaleProducts_TC[0].TcName %>
        </p>
    </div>
    <div class="user-info">
        <dl>
            <dt>联系人</dt>
            <dd>
                <input type="text" placeholder="联系人姓名" name="lxr_name" id="lxr_name" />
            </dd>
        </dl>
        <dl class="last">
            <dt>手机号</dt>
            <dd>
                <input type="number" placeholder="用于卖家联系您" name="lxr_mobile" id="lxr_mobile" />
            </dd>
        </dl>
    </div>
    <div class="pay-row">
        <p class="total-money">
            订单总价：<span>￥<%=ViewData["totalMoney"] %>
            </span>(共<%=Request.QueryString["buyAmount"] %>人)
        </p>
        <input type="button" value="提交" class="pay-btn" />

   

    </form>
  
       
    <script>

        $(".pay-btn").click(function () {

            $(".pay-btn").attr("disabled", true);

            if ($("#lxr_name").val().trim() == "") {

                layer.msg("联系人不能为空");  

                $(".pay-btn").attr("disabled", false);
                return false;
            }


            if ($("#lxr_mobile").val().trim() == "" || $("#lxr_mobile").val().trim().length != 11) {

                layer.msg("手机号码不正确");

                $(".pay-btn").attr("disabled", false);
                return false;
            }

            $(this).parents().filter("#form1").trigger("submit");


        });
    
    </script>
</body>
 
</html>
