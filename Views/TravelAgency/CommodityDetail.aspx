<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
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
    <title>商品详情</title>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/swiper/swiper-3.4.1.min.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/swiper/swiper-3.4.1.jquery.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/drag.js"></script>
    <%--<link type="text/css" rel="stylesheet" href="/swiper/swiper-3.4.1.min.css" />
    <link type="text/css" rel="stylesheet" href="/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="/css/booklist/Restaurant.css" />
    <script type="text/javascript" src="/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="/swiper/swiper-3.4.1.jquery.min.js"></script>
    <script type="text/javascript" src="/Scripts/fontSize.js"></script>
    <script type="text/javascript" src="/Scripts/drag.js"></script>--%>
    <style>
        #xiangxi img
        {
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body class="pb__100" style="font-size: 12px;">
    <% System.Data.DataTable dt_detail = (System.Data.DataTable)ViewData["commodityTable"];
       System.Data.DataRow dr_detail = dt_detail.Rows[0];
       var imgArr = dr_detail["ImageList"].ToString().Split(',');
       int stock = int.Parse(dr_detail["Stock"].ToString());%>
    <!--单品详情-->
    <div class="zone__goods-details">
        <!--//大图滚动-->
        <div class="g-bigImg">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <%foreach (var img in imgArr)
                      { %>
                    <div class="swiper-slide">
                        <!--推荐图片尺寸：750x750-->
                        <a class="aimg" href="javascript:;">
                            <img src="<%=img %>" /></a>
                    </div>
                    <%} %>
                </div>
                <div class="swiper-pagination">
                </div>
            </div>
        </div>
        <div class="g-title bg--fff">
            <div class="inner yu-grid">
                <h2 class="yu-overflow">
                    <%--别墅套票-超值礼包【微可牛酒店-翠屏雅苑两卧/三卧+自助早餐+魔术表演（逢周二停演）】--%><%=dr_detail["Name"]%></h2>
                <label>
                    已售<%if (string.IsNullOrWhiteSpace(ViewData["soldCount"].ToString()))
                        { %>
                    0
                    <%}
                        else
                        { %>
                    <%=ViewData["soldCount"]%>
                    <%} %></label>
            </div>
        </div>
        <!--订购须知-->
        <div class="g-simliar bg--fff mt20">
            <h2 class="tit">
                订购须知</h2>
            <div class="cnt">
                <%=dr_detail["Notice"]%>
            </div>
        </div>
        <!--图文详情-->
        <div class="g-simliar bg--fff mt20">
            <h2 class="tit">
                图文详情</h2>
            <div class="cnt" id="xiangxi">
                <%if (!string.IsNullOrWhiteSpace(dr_detail["ITDescribe"].ToString()))
                  { %>
                <%=dr_detail["ITDescribe"]%>
                <%}
                  else
                  { %>
                <%=dr_detail["Describe"]%>
                <%} %>
            </div>
        </div>
        <!--底部按钮-->
        <div class="g-footinfo fixed">
            <div class="inner yu-grid">
                <span><a class="ico i1" href="/home/mainTravel/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
                </a></span><span><a class="ico i2" href="/user/myorders/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
                </a></span>
                <%if (stock > 0)
                  { %>
                <%  var PurchasePoints = double.Parse(dr_detail["PurchasePoints"].ToString());
                    var myPoints = double.Parse(ViewData["myPoints"].ToString());
                    if (dr_detail["CanPurchase"].ToString() == "1")
                    {
                        if (PurchasePoints - myPoints <= 0)
                        { %>
                <span onclick="PayByScore()" class="jifen">
                    <button class="score">
                        用<%=dr_detail["PurchasePoints"]%>积分兑换</button></span>
                <%}
                        else
                        { %>
                <span class="jifen">
                    <button class="score" disabled>
                        差<%=PurchasePoints - myPoints%>积分可兑换</button></span>
                <%}
                    }
                    else
                    { %>
                <span style="display: none;" class="jifen">
                    <button class="score" disabled>
                        差<%=PurchasePoints - myPoints%>积分可兑换</button></span>
                <%  } %>
                <span onclick="PayByMoney()" class="yu-overflow">
                    <button class="g-buy">
                        ￥<%=double.Parse(dr_detail["Price"].ToString())%>立即购买</button></span>
                <%}
                  else
                  { %>
                <span class="yu-overflow">
                    <button class="g-buy">
                        售罄</button></span>
                <%} %>
            </div>
        </div>
    </div>
    <%--<!--快速导航-->
     <% Html.RenderPartial("SupermarketNavigation", null); %>--%>
    <!-- 左右滑屏(导航) -->
    <link href="http://css.weikeniu.com/swiper/swiper-3.4.1.min.css" rel="stylesheet" />
    <script src="http://css.weikeniu.com/swiper/swiper-3.4.1.jquery.min.js"></script>
    <script>
    $(function(){
                sessionStorage.SupperMarketAloneFoodNum = 1;
    });

	    var mySwiper = new Swiper('.swiper-container', {
	        pagination: '.swiper-pagination',
            autoplay: 5000,
	        paginationClickable: true,
	        autoplayDisableOnInteraction: false
	    })

	    function GotoMap() { 
            location.href = "/hotel/map/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>";
        }

        function PayByScore(){
                    sessionStorage.SupperMarketIsBack = 0;
            location.href = "/Supermarket/OrderDetailsAlone/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&commodityid=<%=ViewData["CommodityID"] %>&PayMode=score&isComeTravel=1";
        }
        
        function PayByMoney(){
                    sessionStorage.SupperMarketIsBack = 0;
            location.href = "/Supermarket/OrderDetailsAlone/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&commodityid=<%=ViewData["CommodityID"] %>&PayMode=money&isComeTravel=1";
        }
    </script>
    <!-- 左右滑屏.End -->
</body>
</html>
