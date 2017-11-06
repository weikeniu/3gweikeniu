<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<!--快速导航-->
<%
    var ModuleAuthority = hotel3g.Models.DAL.AuthorityHelper.ModuleAuthority(Html.ViewData["weixinid"].ToString()); 
    
  if (!ViewData["userweixinid"].ToString().Contains(hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId))
  { %>
<section class="fix-right" id="drag">
		<div class="fix-btn yu-grid yu-alignc">
			<p class="ico"></p>
			<p class="show-hide cur">快速<br />导航</p>
			<p class="show-hide">收起</p>
		</div>
		<div class="fix-right-slide">
			<%--<div class="yu-grid yu-alignc">
            <% if (ViewData["weixinid"].ToString() != "gh_669095f50cbd")
               { %>
				<a class="yu-overflow" href="/home/main/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type1"></p>
					<p>首页</p>
				</a>
                <%} %>

                <a class="yu-overflow" href="/hotel/index/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					            <p class="ico type2"></p>
					            <p>订房</p>
				            </a>

                            <a class="yu-overflow" href="/user/myorders/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					            <p class="ico type4"></p>
					            <p>订单</p>
				            </a>

				<a class="yu-overflow" href="/Supermarket/Search/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type2"></p>
					<p>搜索</p>
				</a>
			<a class="yu-overflow" href="/user/index/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					            <p class="ico type3"></p>
					            <p>会员</p>
				            </a>
			</div>--%>
            <%
              if (WeiXin.Common.NormalCommon.IsLXSDoMain())
              {%>
              <div class="yu-grid yu-alignc">
            <% if (ViewData["weixinid"].ToString() != "gh_669095f50cbd")
               { %>
				<a class="yu-overflow" href="/home/mainTravel/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type1"></p>
					<p>首页</p>
				</a>
                <%} %>
				<a class="yu-overflow"  href="/user/myorders/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type2"></p>
					<p>我的订单</p>
				</a>
                <%if (ModuleAuthority.module_memberbasics == 1)
                  { %>
				<a class="yu-overflow"  href="/user/index/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type3"></p>
					<p>会员中心</p>
				</a>
                <%} %>
			</div>
              <%}
              else
              { %>
			<div class="yu-grid yu-alignc">
            <% if (ViewData["weixinid"].ToString() != "gh_669095f50cbd")
               { %>
				<a class="yu-overflow" href="/home/main/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type1"></p>
					<p>首页</p>
				</a>
                <%} %>
				<a class="yu-overflow" href="/Supermarket/Search/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type2"></p>
					<p>搜索</p>
				</a>
                <%if (ModuleAuthority.module_memberbasics == 1)
                  { %>
				<a class="yu-overflow"  href="/user/index/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type3"></p>
					<p>会员中心</p>
				</a>
                <%} %>
			</div>
			<div class="yu-grid yu-alignc">
            <%if (ModuleAuthority.module_room == 1)
              { %>
				<a class="yu-overflow" href="/hotel/index/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type4"></p>
					<p>订房</p>
				</a>
                <%} %>
                <%if (ModuleAuthority.module_meals == 1)
                  { %>
				<a class="yu-overflow" href="/DishOrder/DishOrderIndex/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type5"></p>
					<p>订餐</p>
				</a>
                <%} %>
				<a class="yu-overflow"  href="/Supermarket/Index/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type6"></p>
					<p>超市</p>
				</a>
			</div>
			
		</div>
    <%}%>
	</section>
<%} %>
<script>


    //快速导航
    $(".fix-btn").click(function () {
        $(this).toggleClass("cur").children(".show-hide").toggleClass("cur");
        $(".fix-right-slide").toggle();
    })
</script>
<%
    //微信分享
    hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = Html.ViewData["WeiXinShareConfig"] as
       hotel3g.PromoterEntitys.WeiXinShareConfig;
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    string openid = ViewData["userweixinid"].ToString();
    string hotelWeixinid = Html.ViewData["weixinid"].ToString();
    string newkey = string.Format("{0}@{1}", hotelWeixinid, openid);
    string hid = Html.ViewData["hotelId"].ToString();
    if (!openid.Contains(wkn_shareopenid))
    {
        //非二次分享 获取推广员信息
        var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(hotelWeixinid, openid);
        ///原链接已经是分享过的链接
        newkey = string.Format("{0}@{1}_{2}", hotelWeixinid, wkn_shareopenid, CurUser.memberid);
    }

    string sharelink = string.Format("http://hotel.weikeniu.com", Request.Url.LocalPath, newkey);
    //string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}", Request.Url.LocalPath, newkey);
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