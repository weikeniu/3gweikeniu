<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%        
    string hotelid = RouteData.Values["id"].ToString();
    string key = HotelCloud.Common.HCRequest.GetString("key");
    string weixinID = "";
    string userWeiXinID = "";
    if (key.Contains("@"))
    {
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

    hotel3g.Models.Dishses model = (hotel3g.Models.Dishses)ViewData["model"];
    string[] imgArr = model.ImgList.Split(',');


    int tid = HotelCloud.Common.HCRequest.getInt("tid");
%> 

<%
    //微信分享
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    string openid = key.Split('@')[1];//ViewData["uwx"].ToString();
    string hotelWeixinid = key.Split('@')[0];//Html.ViewData["weixinID"].ToString();
    string newkey = string.Format("{0}@{1}", hotelWeixinid, openid);
    string hid = Html.ViewData["hId"].ToString();
    if (!openid.Contains(wkn_shareopenid))
    {
        //非二次分享 获取推广员信息
        var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(hotelWeixinid, openid);
        ///原链接已经是分享过的链接
        newkey = string.Format("{0}@{1}_{2}", hotelWeixinid, wkn_shareopenid, CurUser.memberid);
    }

    string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}&dishId={2}&storeId={3}", Request.Url.LocalPath, newkey, model.DishsesID, ViewData["storeId"]);

  
         hotel3g.PromoterEntitys.WeiXinShareConfig  WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
       {
           title = model.DishsesName,
           desn = model.DishsesDesc,
           logo = model.DishesImg,
           debug = false,
           userweixinid = openid,
           weixinid = hotelWeixinid,
           hotelid = int.Parse(hid),
           sharelink = sharelink
       };
    ViewData["WeiXinShareConfig"] = WeiXinShareConfig;
  
%>
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
<title></title>
<link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/swiper/swiper-3.4.1.min.css"/>
<link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css"/>
<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/swiper/swiper-3.4.1.jquery.min.js"></script>
<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>

    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/fontSize.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/swiper/swiper-3.4.1.jquery.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
    <style>
       .MsoTableGrid{width:100%!important;}
    </style>
</head>
<body class="pb__100" style="font-size: 12px;max-width:750px;">
	<article class="full-page">
    <% if (!string.IsNullOrEmpty(userWeiXinID) && !userWeiXinID.Contains(wkn_shareopenid)) //微信分享，不显示左上角菜单按钮
       {
           if (tid == Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
           {
               Html.RenderPartial("HeaderA", viewDic);
           }
       } %>
    <section class="show-body">
		<section class="content2 yu-bpad120r">
	<!--单品详情-->
	<div class="zone__goods-details">
		<!--//大图滚动-->
		<div class="g-bigImg">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					 <%foreach (var img in imgArr)
                      {
                          if (!string.IsNullOrEmpty(img))
                          {%>
                        <div class="swiper-slide">
                            <!--推荐图片尺寸：750x750-->
                            <a class="aimg" href="javascript:;">
                                <img src="<%=img %>" /></a>
                        </div>
                    <%}
                      }%>
				</div>
				<div class="swiper-pagination"></div>
			</div>
		</div>
		
		<div class="g-title bg--fff">
			<div class="inner yu-grid">
				<h2 class="yu-overflow"><%=model.DishsesName%></h2>
				<label><%=model.price %></label>
			</div>
		</div>
		
		<%--<div class="g-subinfo bg--fff mt20">
			<label><span><i class="ico i1 i1-1"></i>使用快递</span><span><i class="ico i1 i1-1"></i>到店自提</span></label>
		</div>--%>
		
		<div class="g-subinfo bg--fff mt20" onclick="javascript:toIndex()">
			<label><span><i class="ico i2 i2-2"></i>此餐品由<%=ViewData["hotelName"]%>提供</label>
		</div>
		
		<!--订购须知-->
		<div class="g-simliar bg--fff mt20">
			<h2 class="tit">订购须知</h2>
			<div class="cnt">
                <%=model.Notice%>
			</div>
		</div>
		<!--图文详情-->
		<div class="g-simliar bg--fff mt20">
			<h2 class="tit">图文详情</h2>
			<div class="cnt">
                <%=model.ITDescribe%>
			</div>
		</div>
		
		<!--地址-->
		<%--<div class="g-subinfo bg--fff mt20">
			<div class="yu-grid">
				<div class="addr yu-overflow">详细地址：广东省广州市越秀区东湖寺右新马路  广东省广州市越秀区东湖寺右新马路</div>
				<label><span style="margin-right: 0;"><i class="ico i3"></i></span></label>
			</div>
		</div>--%>
		
		<!--底部按钮-->
		<div class="g-footinfo fixed">
			<div class="inner yu-grid">
              <% if (!string.IsNullOrEmpty(userWeiXinID) && !userWeiXinID.Contains(wkn_shareopenid))
                 {
                     if (tid == Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
                     {
                     %>
				<span><a class="ico i1 i1-1" href="/homeA/main/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>"></a></span>
				<span><a class="ico i2 i2-2" href="/userA/myorders/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>"></a></span>
                <% }
                 } %>
				<span class="yu-overflow" onclick="javascript:toDishDetailView()"><button class="g-buy">￥<%=Convert.ToDecimal(model.price).ToString("f2")%>立即购买</button></span>
			</div>
		</div>
		
	</div>
       </section>
    </section>
	</article>
	<!-- 左右滑屏(导航) -->
	<link href="<%=ViewData["cssUrl"] %>/swiper/swiper-3.4.1.min.css" rel="stylesheet" />  
	<script src="<%=ViewData["jsUrl"] %>/swiper/swiper-3.4.1.jquery.min.js"></script>
	<script>
	    var mySwiper = new Swiper('.swiper-container', {
	        pagination: '.swiper-pagination',
	        paginationClickable: true,
	        autoplayDisableOnInteraction: false
	    })

        function toIndex(){
        <% if (!string.IsNullOrEmpty(userWeiXinID) && !userWeiXinID.Contains(wkn_shareopenid))
                 { %>
           window.location.href='/DishOrderA/DishOrderIndex/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>&tid=<%=tid %>';
           <% } %>
        }

        function toDishDetailView(){
            location.href = "/DishOrderA/DishDetailView/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>&dishId=<%=ViewData["dishId"] %>&storeId=<%=ViewData["storeId"] %>&tid=<%=tid %>";
        }
	</script>
	<!-- 左右滑屏.End -->
	
</body>
</html>
