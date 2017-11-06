<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%  
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
    
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
    <title>友情提示</title>
    <link href="http://css.weikeniu.com/Content/ProductIndex/productIndex.css" rel="stylesheet"
        type="text/css" />
    <link href="http://css.weikeniu.com/Content/ProductIndex/pay.css" rel="stylesheet"
        type="text/css" />
    <link href="../../css/booklist/iconfont/iconfont.css?v=1.0" rel="stylesheet" type="text/css" />
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=1.0" rel="stylesheet"
        type="text/css" />
    <style>
        .err-icon
        {
            font-size: 100px !important; /* color: #ffbc4b; */
            color: #00a0e9;
            text-align: center;
            top: -50px;
            width: 100%;
            left: 0;
        }
        .err-page > p
        {
            font-family: Microsoft yahei,simhei;
            line-height: 30px;
        }
        .exit-btn
        {
            width: 100px;
            height: 30px;
            border-radius: 5px;
            color: #fff;
            margin: 0 auto;
            cursor: pointer;
        }
        .yu-bgblue
        {
            background: #00a0e9;
        }
    </style>
</head>
<body>
    <div class="err-page">
        <div class="iconfont err-icon">
            </div>
        <p class="yu-textc yu-font24 yu-bmar10">
            <%=Request.QueryString["errmsg"] %></p>
        <!-- <p class="yu-textc yu-font14 yu-grey">服务器开了个小差</p> -->
    </div>
    <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
