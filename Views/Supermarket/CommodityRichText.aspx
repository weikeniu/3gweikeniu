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
    <% System.Data.DataTable dt_detail = (System.Data.DataTable)ViewData["commodityTable"];
       System.Data.DataRow dr_detail = dt_detail.Rows[0];
       var imgArr = dr_detail["ImageList"].ToString().Split(',');
       int stock = int.Parse(dr_detail["Stock"].ToString());%>
<%
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    ViewDataDictionary viewDic = new ViewDataDictionary();
 

    string ITDescribe = dr_detail["ITDescribe"].ToString();
    string strText = System.Text.RegularExpressions.Regex.Replace(ITDescribe, "<[^>]+>", "");
    strText = System.Text.RegularExpressions.Regex.Replace(strText, "&[^;]+;", "");

    if (ITDescribe.Length > 0 && strText.Length > ITDescribe.Length)
        strText = strText.Substring(0, ITDescribe.Length);

    string openid = ViewData["userweixinid"].ToString();
    string key = string.Format("{0}@{1}", ViewData["weixinid"], openid);
    
    if (!openid.Contains(wkn_shareopenid))
    {
        //非二次分享 获取推广员信息
        var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(ViewData["weixinid"].ToString(), openid);
        ///原链接已经是分享过的链接
        key = string.Format("{0}@{1}_{2}", ViewData["weixinid"], wkn_shareopenid, CurUser.memberid);
    }
    string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}&commodityid={2}", Request.Url.LocalPath, key, ViewData["CommodityID"]);


    //string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}@{3}&commodityid={2}", Request.Url.LocalPath, ViewData["weixinid"], ViewData["CommodityID"], wkn_shareopenid);
    string desn = string.IsNullOrEmpty(strText) ? dr_detail["Name"].ToString() : strText.Replace("\n", "");
    
    hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
    {
        title = dr_detail["Name"].ToString()+"(分享)",
        desn = desn,
        logo = imgArr[0],
        debug = false,
        userweixinid = ViewData["userweixinid"].ToString(),
        weixinid = ViewData["weixinid"].ToString(),
        hotelid = int.Parse(ViewData["hotelId"].ToString()),
        sharelink = sharelink
    };
    ViewData["WeiXinShareConfig"] = WeiXinShareConfig;
    
    //sviewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
    //Html.RenderPartial("WeiXinShare", viewDic); 
%>
<body class="pb__100" style="font-size: 12px;">
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
        <div class="g-subinfo bg--fff mt20">
            <label>
                <span><i class="ico i1"></i>快递</span><span><i class="ico i1"></i>到店自提</span></label>
        </div>
        <div class="g-subinfo bg--fff mt20">
            <label>
                <span><i class="ico i2"></i>此商品由<%=ViewData["hotelName"]%>提供</label>
        </div>
        <!--订购须知-->
        <div class="g-simliar bg--fff mt20">
            <h2 class="tit">
                订购须知</h2>
            <div class="cnt">
                <%--<p>1、购买成功后联系微信客服或拨打400-0346-999</p>
				<p>2、预订成功与否以客服回复为准，不接受未预约直接到店消费</p>
				<p>3、套餐有效期为2017年4月7日-8月31日/4月29日-5月1日两卧需补差价600元/套/晚，三卧需补差价900元/套/晚，购买时选择劳动节价格即可</p>
				<p>4、购买成功后不可退，请合理安排出行时间</p>--%>
                <%=dr_detail["Notice"]%>
            </div>
        </div>
        <!--图文详情-->
        <div class="g-simliar bg--fff mt20">
            <h2 class="tit">
                图文详情</h2>
            <div class="cnt" id="xiangxi">
                <%--<p>别墅套票-翠屏雅苑两卧/三卧+自助早餐+魔术表演（逢周二停演）+4成人次日自助早餐</p>
				<p>别墅套票-翠屏雅苑两卧/三卧+自助早餐+魔术表演（逢周二停演）+4成人次日自助早餐</p>
				<p>4.29-5.1：两卧加价600元/套，三卧加价900元/套</p>
				<p><img src="../../images/booking.jpg" /></p>
				<p><img src="../../images/hotel__img-detail.jpg" /></p>
				<p><img src="../../images/hotel-bigimg.jpg" /></p>--%>
                <%=dr_detail["ITDescribe"]%>
            </div>
        </div>
        <!--地址-->
        <div class="g-subinfo bg--fff mt20">
            <div class="yu-grid" onclick="GotoMap()">
                <div class="addr yu-overflow">
                    详细地址：<%--广东省广州市越秀区东湖寺右新马路  广东省广州市越秀区东湖寺右新马路--%><%=ViewData["Address"] %></div>
                <label>
                    <span style="margin-right: 0;"><i class="ico i3"></i></span>
                </label>
            </div>
        </div>
        <!--底部按钮-->
        <div class="g-footinfo fixed">
            <div class="inner yu-grid">
            <%if (!ViewData["userweixinid"].ToString().Contains(wkn_shareopenid))
              { %>
                <span><a class="ico i1" href="/home/main/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
                </a></span><span><a class="ico i2" href="/user/myorders/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
                </a></span>
                <%} %>
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
                <!--变灰样式： <span><button class="score" disabled>差100积分可兑换</button></span>-->
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
                        ￥<%=string.Format("{0:F2}", float.Parse(dr_detail["Price"].ToString()))%>立即购买</button></span>
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
    <!--快速导航-->

    <% Html.RenderPartial("SupermarketNavigation", null); %>
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
            location.href = "/Supermarket/OrderDetailsAlone/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&commodityid=<%=ViewData["CommodityID"] %>&PayMode=score";
        }
        
        function PayByMoney(){
                    sessionStorage.SupperMarketIsBack = 0;
            location.href = "/Supermarket/OrderDetailsAlone/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&commodityid=<%=ViewData["CommodityID"] %>&PayMode=money";
        }
    </script>
    <!-- 左右滑屏.End -->
</body>
</html>