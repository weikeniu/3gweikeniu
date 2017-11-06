<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%    
    
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string hotelid = RouteData.Values["id"].ToString();
    string quanjing = ViewData["quanjing"] == null ? "" : ViewData["quanjing"].ToString();

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

    //bool IsBranch = (bool)ViewData["IsBranch"];


    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();

    hotel3g.Models.Hotel HotelInfo =
            ViewData["HotelInfo"] as hotel3g.Models.Hotel;
    if (HotelInfo == null)
    {
        HotelInfo = new hotel3g.Models.Hotel();
    }

    List<hotel3g.Models.MenuDictionaryResponse> MenuBarList = ViewData["MenuBarList"] as List<hotel3g.Models.MenuDictionaryResponse>;
    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>
        <%=ViewData["hotel"]%>
        微官网</title>
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
        <link href="<%=ViewData["cssUrl"]%>/css/booklist/sale-date.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/css/booklist/new-style.css?v=2.0" rel="stylesheet"
        type="text/css" />

    <link rel="stylesheet" href="<%=ViewData["cssUrl"]%>/css/booklist/mend-reset.css" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"]%>/css/booklist/mend-weikeniu.css" />
    <script src="<%=ViewData["cssUrl"]%>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=ViewData["cssUrl"]%>/Scripts/fontSize.js"></script>
</head>
<body>
    <article class="full-page">

     <%Html.RenderPartial("HeaderA", viewDic);%>

		<section class="show-body">	
			<section class="content" >
	<!-- <>酒店首页 -->
	<div class="hotel__panel-index clearfix">
		<!-- //背景轮播图 -->

        <% 
            string[] covers = { };
            if (!string.IsNullOrEmpty(HotelInfo.MainPic))
            {
                covers = HotelInfo.MainPic.Split(';');
            } 
            %>
		<div class="zone__slider">
			<div class="swiper-container">
				<div class="swiper-wrapper">
                <% for (int i = 0; i < covers.Length; i++)
                   { %>
                <div class="swiper-slide">
						<div class="bg-img" style="background: url('<%=covers[i] %>'); background-size: 100% 100%;"></div>
					</div>
                <%} %>
				</div>
				<div class="swiper-pagination"></div>
			</div>
		</div>
		
		<!-- //链接导航 -->
		<div class="zone__menuLink<%=(ViewData["weixinID"].ToString().Equals("gh_94f9be27c20a")?" sp":"") %>" style="margin-top:.5rem">
			<div class="logo">
				<div class="inner h-bg">
					<span><img style="display:inline-block" src="<%=HotelInfo.HotelLog %>" /></span>
				</div>
			</div>
			<div class="grid">
				<div class="tel h-bg">
					<h2><%=ViewData["hotel"]%></h2>
					<p><a href="tel:<%=HotelInfo.Tel %>"><%=HotelInfo.Tel %></a></p>
				</div>
				<ul class="link clearfix">
                 <% string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
                       //如果不是来自分享的链接 则显示底部导航条   旅行社不显示底部导航条
                    if (!userWeiXinID.Contains(wkn_shareopenid))
                    { %>
					<li><a class="h-bg" href="/userA/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">会员中心</a></li>
					<%} %>
                    <li><a class="h-bg" href="/HotelA/Info/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">酒店介绍</a></li>
					<li><a class="h-bg" href="/HotelA/Map/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">酒店导航</a></li>
					<li><a class="h-bg" href="/HotelA/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">客房预订</a></li>
				</ul>
			</div>
		</div>
		
	</div>
    </section>
    </section>
	</article>
    <!-- 左右滑屏(导航) -->
    <link href="http://css.weikeniu.com/swiper/swiper-3.4.1.min.css" rel="stylesheet" />
    <script src="http://css.weikeniu.com/swiper/swiper-3.4.1.jquery.min.js"></script>
    <script>
        var mySwiper = new Swiper('.swiper-container', {
            //pagination: '.swiper-pagination',
            pagination: false,
            paginationClickable: true,
            autoplayDisableOnInteraction: false,
                autoplay: 3000,//可选选项，自动滑动
        });
	</script>
    <!-- 左右滑屏.End -->
</body>
</html>
<%
    //微信分享

    string openid = userWeiXinID;
    string newkey = string.Format("{0}@{1}", weixinID, openid);

    if (!openid.Contains(wkn_shareopenid))
    {
        //非二次分享 获取推广员信息
        var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(weixinID, openid);
        ///原链接已经是分享过的链接
        newkey = string.Format("{0}@{1}_{2}", weixinID, wkn_shareopenid, CurUser.memberid);
    }

    string desn = HotelInfo.Address;
    string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}", Request.Url.LocalPath, newkey);
    hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
    {
        title = ViewData["hotel"] + "(分享)",
        desn = desn,
        logo = HotelInfo.HotelLog,
        debug = false,
        userweixinid = openid,
        weixinid = weixinID,
        hotelid = int.Parse(hotelid),
        sharelink = sharelink
    };
    viewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
    Html.RenderPartial("WeiXinShare", viewDic);
%>