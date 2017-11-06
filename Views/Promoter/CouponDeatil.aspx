<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--%>
<!DOCTYPE html>
<%
    hotel3g.Repository.HotelInfoItem HotelInfo = ViewData["HotelInfo"] as hotel3g.Repository.HotelInfoItem;
    
%>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8" />
    <title>红包信息</title>
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <link rel="stylesheet" href="../../css/booklist/mend-reset.css" />
    <link rel="stylesheet" href="../../css/booklist/mend-weikeniu.css" />
    <script src="../../Scripts/jquery-1.8.0.min.js"></script>
    <script src="../../Scripts/fontSize.js"></script>
    <script>
        //        var useragent = navigator.userAgent;
        //        if (useragent.match(/MicroMessenger/i) != 'MicroMessenger') {
        //            // 这里警告框会阻塞当前页面继续加载  
        //            alert('已禁止本次访问：您必须使用微信内置浏览器访问本页面！');
        //            // 以下代码是用javascript强行关闭当前页面  
        //            var opened = window.open('about:blank', '_self');
        //            opened.opener = null;
        //            opened.close();
        //        } 
    </script>
</head>
<body class="bg--6b0cae">
    <!-- <>红包推广 -->
    <div class="pg__hbPromotion clearfix">
        <!-- //二维码 -->
        <div class="hb__qrcode">
            <!--<img src="../images/icon__hb-qrcode.png" />-->
            <div class="qrcode">
                <div class="bg">
                    <h5>
                        关注酒店，更多优惠</h5>
                    <img src="<%=ViewData["Logo"] %>">
                </div>
            </div>
            <h2 class="tit2">
                <em>
                    <%=HotelInfo.SubName %></em>
            </h2>
            <h3 class="desc2">
                <em>
                    <%=ViewData["info"] %></em>
            </h3>
        </div>
        <!--//优惠券-->
        <div class="hb__coupons clearfix">
            <div class="cp-box">
                <h2 class="amount fl">
                    <b>
                        <%=ViewData["money"] %></b>￥</h2>
                <div class="info fr">
                    <label>
                        订房红包</label>
                    <label>
                        满<%=ViewData["zuiDiXiaoFei"] %>元起用</label>
                    <label class="date">
                        <%--有效期 2017.01.01-2017.01.15--%></label>
                    <a class="btn-use" href="/Promoter/HotelQRCode?hid=<%=ViewData["hid"] %>&weixinid=<%=ViewData["weixinid"] %>&id=<%=ViewData["id"] %>">
                        去使用</a>
                </div>
            </div>
        </div>
        <div class="hb__lgbtn">
            <a class="btn-send" href="/Promoter/HotelQRCode?hid=<%=ViewData["hid"] %>&weixinid=<%=ViewData["weixinid"] %>&id=<%=ViewData["id"] %>">
                送好友红包，奖励拿不停</a>
        </div>
        <% 
            Dictionary<string, string> scopeList = new Dictionary<string, string>();
            scopeList.Add("0", "酒店订房");
            scopeList.Add("1", "自营餐饮");
            scopeList.Add("2", "团购预售");
            scopeList.Add("3", "酒店超市");
            scopeList.Add("4", "周边商家");

            string scopelimitStr = ViewData["scopelimit"] as string;
            string[] scopelimit = scopelimitStr.Split(',');
            string limits = string.Empty;
            for (int i = 0; i < scopelimit.Length; i++)
            {
                limits += i > 0 ? "、" : "";
                if (scopeList.ContainsKey(scopelimit[i]))
                {
                    limits += scopeList[scopelimit[i]];
                }
                else
                {
                    limits += "酒店订房";
                }
            }
            if (string.IsNullOrEmpty(limits)) {
                limits = "酒店订房";
            }
        %>
        <!--//活动规则-->
        <div class="hb__rules">
            <div class="rule-inner">
                <h2>
                    活动规则</h2>
                <div class="list">
                    <ul class="clearfix">
                        <li class="flexbox">1、<span class="flex1">红包可用于<%=HotelInfo.SubName %>上的 <%=limits %>使用，使用此红包下单立减<%=ViewData["money"]%>元</span></li>
                        <li class="flexbox">2、<span class="flex1">此红包仅限首次领取的用户</span></li>
                        <li class="flexbox">3、<span class="flex1">下单途径仅支持 <%=HotelInfo.SubName %> 微官网</span></li>
                        <li class="flexbox">4、<span class="flex1">该红包优惠不与其他活动优惠同时使用</span></li>
                        <li class="flexbox">5、<span class="flex1">关注<%=HotelInfo.SubName %>后，需领取成为会员，才可使用此红包</span></li><li class="flexbox">6、<span class="flex1">该红包不可提现</span></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
