<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    string hotelid = RouteData.Values["id"].ToString();
    string weixinID = string.Empty;
    var hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
    var count = ViewData["pagecount"].ToString();
    var news = ViewData["news"] as List<hotel3g.Models.HotelNews>;
    if (!string.IsNullOrEmpty(hotel.WeiXinID))
    {
        weixinID = hotel.WeiXinID;
    }
    else
    {
        weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
        if (weixinID.Equals(""))
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            weixinID = key.Split('@')[0];
        }
    }

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotel.ID);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);


    string openid = ViewData["userWeiXinID"].ToString();
    //分享用户
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    ViewData["NewTitle"] = Request.QueryString["type"] == "1" ? "攻略列表" : "优惠活动列表";
    ViewData["NewDesn"] = hotel.SubName;
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
    <title>活动列表</title>
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <link href="http://css.weikeniu.com/css/booklist/new-style.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <script src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/fontSize.css?v=1.0" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
</head>
<body>
    <article class="full-page">
       <%
           //微信分享
           string newkey = string.Format("{0}@{1}", weixinID, openid);
           //分享用户
           if (!openid.Contains(wkn_shareopenid))
           {
               //非二次分享 获取推广员信息
               var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(weixinID, openid);
               ///原链接已经是分享过的链接
               newkey = string.Format("{0}@{1}_{2}", weixinID, wkn_shareopenid, CurUser.memberid);
           }

           string desn = ViewData["NewDesn"].ToString();
           string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}", Request.Url.LocalPath, newkey);
           hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
           {
               title = ViewData["NewTitle"].ToString(),
               desn = desn,
               logo = hotel.HotelLog,
               debug = false,
               userweixinid = openid,
               weixinid = weixinID,
               hotelid = hotel.ID,
               sharelink = sharelink
           };
           viewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
    %>

		<%Html.RenderPartial("HeaderA", viewDic);%>
	
		<section class="show-body">
			
			<section class="content2">
				<ul class="booking-list">

                <% List<hotel3g.Models.HotelNews> Newlist = ViewData["news"] as List<hotel3g.Models.HotelNews>;
                   if (Newlist != null && Newlist.Count > 0)
                   {
                       foreach (hotel3g.Models.HotelNews item in Newlist)
                       { %>
                       
                       	<li>
								<a href="/HotelA/NewsInfo/<%=item.HotelID %>?nid=<%=item.Id %>&key=<%=weixinID %>@<%=ViewData["userWeiXinID"] %>" class="yu-black">
										<div class="show-header">
											<div class="inner yu-h360r">
												<img src="<%=item.CoverImage %>" />
											</div>
											<div class="yu-bgw yu-h50 yu-grid yu-alignc yu-bor bbor yu-lrpad10 yu-arr">
												<p class="yu-overflow yu-f30r"><%=item.Title%></p>
											</div>
										</div>
									</a>
								</li>

                       <%}
                   }
                   else
                   { %>
                        <div class="uc__storeValCard-details">
						<div class="no-data">
							<img src="../../images/icon__no-active.png">
							<h2>现在不是活动时间</h2>
							<p>过段时间再来瞧瞧吧</p>
							<a class="back" href="javascript: history.back(-1);">返回</a>
						</div>
					</div>
                   <%} %>

							</ul>
			</section>
		</section>
		
	</article>
</body>
</html>
<script>
    $(function () {
        //左导航
        var lSideNum = 0;
        $(".l-side-btn").click(function () {
            if (lSideNum == 0) {
                $(".full-page").addClass("shin-slide-right").removeClass("shin-slide-left");
                $(".l-side").fadeIn();
                lSideNum = 1;
            } else {
                $(".full-page").removeClass("shin-slide-right").addClass("shin-slide-left");
                $(".l-side").fadeOut();
                lSideNum = 0;
            }
        })
        //选项卡
        var tabIndex;
        $(".tab-nav").children("li").on("click", function () {
            $(this).addClass("cur").siblings("li").removeClass("cur");
            tabIndex = $(this).index();
            $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
        })

        //加减餐
        var foodNum = 0;
        var totalNum = 0;
        $(".add").on("click", function () {
            //	$(".food-list,.food-details").find("dd").on("click",".add",function(){
            totalNum++;
            if ($(this).siblings(".food-num").text() == "") {
                foodNum = 1;
                $(this).siblings(".food-num").text(foodNum);
            } else {
                foodNum = parseInt($(this).siblings(".food-num").text());
                foodNum++;
                $(this).siblings(".food-num").text(foodNum);

            };
            $(this).siblings().fadeIn();
            //				$(".gwc-ico .num").text(totalNum);
            //				$(".gwc-ico .num").fadeIn();
            $(".cart").children(".num").fadeIn().text(totalNum);

        });

        $(".reduce").on("click", function () {
            //		$(".food-list,.food-details").find("dd").on("click",".reduce",function(){
            foodNum = parseInt($(this).siblings(".food-num").text());
            if (foodNum > 0) {
                totalNum--;
                foodNum--;
                $(this).siblings(".food-num").text(foodNum);
                $(".cart").children(".num").text(totalNum);
                $(".gwc-ico .num").text(totalNum);
                if (totalNum == 0) {
                    //						$(".gwc-ico .num").fadeOut();
                }
                if (foodNum == 0 && $(this).parents("dl").hasClass("food-list")) {
                    $(this).fadeOut().siblings(".food-num").fadeOut();
                }
            };
        });

    })
</script>
