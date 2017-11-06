<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%
    //string tel = hotel3g.Models.HotelHelper.GetHotelTel(Convert.ToInt32(ViewData["hId"])); 
    var hotel = hotel3g.Models.HotelHelper.GetMainIndexHotel(Convert.ToInt32(ViewData["hId"]), true);
    var ModuleAuthority = hotel3g.Models.DAL.AuthorityHelper.ModuleAuthority(Html.ViewData["weixinID"].ToString());
    ///var Examine = hotel3g.Models.DAL.BranchHelper.GetExamine(Html.ViewData["weixinID"].ToString());
    if (hotel == null)
    {
        hotel = new hotel3g.Models.Hotel();
    }

    string userweixinid = ViewData["uwx"].ToString();
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
%>
<%      //如果不是来自分享的链接 则显示顶部导航条    
    if (!string.IsNullOrEmpty(userweixinid) && !userweixinid.Contains(wkn_shareopenid))
    { %>
<style>
    .logo-img
    {
        width: 30px;
        height: 30px;
        margin: 0 15px;
    }
    .logo-img > img
    {
        width: 100%;
        height: 100%;
    }
</style>
<% if (!ViewData["uwx"].ToString().Contains(hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId))
   { %>
<aside class="l-side"> 
			<nav>
          
            <% if (!Html.ViewData["weixinID"].ToString().Equals("gh_669095f50cbd"))
               {%>
				<a href="/HomeA/Main/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>" class="yu-grid yu-alignc">
					<p class="ico shouye"></p>
					<p>首页</p>
				</a>
                <%} %>
			<a href="/HotelA/Info/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>" class="yu-grid yu-alignc">
					<p class="ico jianjie"></p>
					<p>酒店简介</p>
				</a>
                <% if (ModuleAuthority.module_room == 1)
                   { %>
				<a href="/HotelA/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>" class="yu-grid yu-alignc">
					<p class="ico yuding"></p>
					<p>客房预定</p>
				</a>
                <%} %>


                 <% 
               
       if (ModuleAuthority.module_meals == 1)
       { 
    %>
				<a href="/DishOrderA/DishOrderIndex/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>" class="yu-grid  yu-alignc">
					<p class="ico dingcan"></p>
					<p>酒店订餐</p>
				</a>
                <%} %>
                <% if (ModuleAuthority.module_supermarket == 1)
                   { 
    %>
				<a href="/SupermarketA/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>" class="yu-grid  yu-alignc">
					<p class="ico chaoshi"></p>
					<p>酒店超市</p>
				</a>
                <%} %>
			<a href="/ProductA/ProductList/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>" class="yu-grid  yu-alignc">
					<p class="ico youxuan"></p>
					<p>特惠优选</p>
				</a>
				<a href="/HotelA/HotelService/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>" class="yu-grid  yu-alignc">
					<p class="ico sheshi"></p>
					<p>设施服务</p>
				</a>

                <%if (ModuleAuthority.module_meeting == 1)
                  { %>
					<a href="/MeetingA/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>" class="yu-grid yu-alignc">
					<p class="ico yanhui"></p>
					<p>会议宴会</p>
				</a>
                <%} %>
				<a href="/HotelA/NewsinfoList/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>" class="yu-grid  yu-alignc">
					<p class="ico huodong"></p>
					<p>酒店活动</p>
				</a>


                <a href="/HomeA/CouPon/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>" class="yu-grid  yu-alignc">
					<p class="ico hongbao"></p>
					<p>抢红包</p>
				</a>
				<a href="/UserA/MyOrders/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>" class="yu-grid  yu-alignc">
					<p class="ico dingdan"></p>
					<p>我的订单</p>
				</a>
			</nav>

			</nav>
		</aside>
<header class="yu-grid yu-alignc yu-h40 yu-lrpad10">
				<div>
					<div class="yu-grid yu-alignc">
						<p class="nav-ico l-side-btn"></p>
						<p class="copy-bor1"></p> 
                        <% if (!string.IsNullOrEmpty(hotel.HotelLog))
                           { %>
						<p class="business-ico"><img src="<%=hotel.HotelLog %>" /></p>
                        <%} %>
					</div>
				</div>
				<div class="yu-overflow"></div>
				<div>
					<div class="yu-grid yu-alignc">
						<a href="tel:<%=hotel.Tel %>"  class="phone-ico"></a>
						<p class="copy-bor1"></p>
						<a href="/UserA/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>"><p class="person-ico"></p></a>
					</div>
				</div>
			</header>
<script>

    $(function () {


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

    });
 
</script>
<%}%>
<%}
    else
    { %>
<script>
    $(function () {

        $(".show-body").addClass("type1");
    });

</script>
<%} %>
<%
    //微信分享
    hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = Html.ViewData["WeiXinShareConfig"] as
       hotel3g.PromoterEntitys.WeiXinShareConfig;

    string openid = ViewData["uwx"].ToString();
    string hotelWeixinid = Html.ViewData["weixinID"].ToString();
    string newkey = string.Format("{0}@{1}", hotelWeixinid, openid);
    string hid = Html.ViewData["hId"].ToString();
    if (!openid.Contains(wkn_shareopenid))
    {
        //非二次分享 获取推广员信息
        var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(hotelWeixinid, openid);
        ///原链接已经是分享过的链接
        newkey = string.Format("{0}@{1}_{2}", hotelWeixinid, wkn_shareopenid, CurUser.memberid);
    }

    string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}", Request.Url.LocalPath, newkey);

    if (WeiXinShareConfig == null)
    {
        WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
       {
           title = null,
           desn = null,
           logo = null,
           debug = false,
           userweixinid = openid,
           weixinid = hotelWeixinid,
           hotelid = int.Parse(hid),
           sharelink = sharelink
       };
    }
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
    Html.RenderPartial("WeiXinShare", viewDic); 
%>
