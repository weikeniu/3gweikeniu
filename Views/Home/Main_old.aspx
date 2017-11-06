<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"
        name="viewport">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <!-- Mobile Devices Support @begin -->
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
    <meta content="no-cache,must-revalidate" http-equiv="Cache-Control">
    <meta content="no-cache" http-equiv="pragma">
    <meta content="0" http-equiv="expires">
    <meta content="telephone=no, address=no" name="format-detection">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!-- apple devices fullscreen -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>
        <%=ViewData["hotel"]%></title>
    <link href="/css/css.css" rel="stylesheet" type="text/css" />
    <%Html.RenderPartial("JSHeader"); %>
</head>
<body>
    <%
        ViewDataDictionary jdata = new ViewDataDictionary();
        jdata.Add("weixinID", ViewData["weixinID"]);
        jdata.Add("hId", ViewData["hId"]);
        jdata.Add("uwx", ViewData["userWeiXinID"]);
        IList<hotel3g.Models.Advertisement> adlist = ViewData["ad"] as List<hotel3g.Models.Advertisement>;
        if (adlist != null && adlist.Count > 0)
        {%>
    <div class="yuding cl">
        <div style="-webkit-transform: translate3d(0,0,0);">
            <div style="visibility: visible;" id="banner_box" class="box_swipe">
                <ul style="list-style: none outside none; width: 3200px; transition-duration: 0ms;
                    transform: translate3d(-640px, 0px, 0px); height: 200px">
                    <%
int i = 0;
foreach (hotel3g.Models.Advertisement ad in adlist)
{
    if (!string.IsNullOrEmpty(ad.ImageUrl))
    {
        if (!string.IsNullOrEmpty(ad.LinkUrl))
        {
            if (ad.LinkUrl.Contains("/Hotel/Fillorder"))
                ad.LinkUrl = ad.LinkUrl + "&userweixinid=" + ViewData["userWeiXinID"];
            else
                ad.LinkUrl = ad.LinkUrl.Trim() + "@" + ViewData["userWeiXinID"];
        }
        if (string.IsNullOrEmpty(ad.LinkUrl))
        {
            ad.LinkUrl = "javascript:void(0)";
        }
                    %>
                    <li style="width: 640px; display: table-cell; vertical-align: top;"><a href="<%=ad.LinkUrl %>">
                        <img src="<%=ad.ImageUrl %>" alt="<%=i+1 %>" style="width: 100%; height: 200px" /></a>
                    </li>
                    <% i++;
    }
}    
                    %>
                </ul>
                <ol>
                    <%
                        for (int j = 1; j <= i; j++)
                        {
                            if (j == 1)
                            { %>
                    <li class="on"></li>
                    <%}
                            else
                            { %>
                    <li class=""></li>
                    <%}
                        }
                    %>
                </ol>
            </div>
        </div>
    </div>
    <%}
    %>
    <div class="all">
        <div class="sy">
            <ul class="fl">
                <li class="yud1"><a href="/Hotel/Index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                    <span>客房预订</span><img src="/img/syok_03.png" /></a> </li>
                <li class="yud2"><a href="/Hotel/HotelService/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                    <span>设施服务</span><img src="/img/shouyeok_10.png" /></a></li>
                <li class="yud3"><a href="/Home/CouPon/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                    <span>抢优惠券</span><img src="/img/syok_13.png" /></a></li>
                <li class="yud4"><a href="/Hotel/NewsinfoList/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                    <span>优惠活动</span><img src="/img/shouyeok_18.png" /></a></li>
                <li class="yud41"><a href="/User/Index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                    <span>会员中心</span><img src="/img/shouyeok_16.png" /></a></li>


    <li class="yud41"><a href="/hotel/map/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                    <span>酒店地图</span><img src="/img/hotelmap.jpg" /></a></li>
                  
            </ul>
            <ul class="fl erf">
                <li class="yud11"><a href="/Hotel/Info/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                    <span>酒店简介</span><img src="/img/syok_05.png" /></a></li>
                <li class="yud21"><a href="/Hotel/Images/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                    <span>酒店图片</span><img src="/img/syok_08.png" /></a></li>
                <li class="yud31"><a href="/Hotel/PrizeSports/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                    <span>抽奖活动</span><img src="/img/syok_14.png" /></a></li>
                <li class="yud41"><a href="/User/MyOrders/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                    <span>会员订单</span><img src="/img/shouyeok_16.png" /></a></li>
                <li class="yud41"><a href="/MemberCard/MemberCenter/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                    <span>领取会员卡</span><img src="../../images/member/card2.png" /></a></li>

  
                         <li class="yud41" ><a href="/Product/ProductList/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                    <span>团购预售</span><img src="../../images/member/yusale.png"    style="height:60%"  /></a></li>
                
            </ul>
         
          
        </div>
    </div>
    <%--<%Html.RenderPartial("Footer", jdata); %>--%>
</body>
</html>
<%Html.RenderPartial("JS"); %>
<script type="text/javascript" src="/Scripts/swipe.js"></script>
<script type="text/javascript">
    $(function () {
        new Swipe(document.getElementById('banner_box'), {
            speed: 500,
            auto: 3000,
            callback: function () {
                var lis = $(this.element).next("ol").children();
                lis.removeClass("on").eq(this.index).addClass("on");
            }
        });
    });
</script>
