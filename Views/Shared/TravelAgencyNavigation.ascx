<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

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
            
			<div class="yu-grid yu-alignc">
            <% if (ViewData["weixinid"].ToString() != "gh_669095f50cbd")
               { %>
				<a class="yu-overflow" href="/home/mainTravel/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type1"></p>
					<p>首页</p>
				</a>
                <%} %>
                <%if (ModuleAuthority.module_memberbasics == 1)
                  { %>
				<a class="yu-overflow"  href="/user/index/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
					<p class="ico type3"></p>
					<p>会员中心</p>
				</a>
                <%} %>
			</div>
			
		</div>
	</section>
    <%} %>
    <script>


        //快速导航
        $(".fix-btn").click(function () {
            $(this).toggleClass("cur").children(".show-hide").toggleClass("cur");
            $(".fix-right-slide").toggle();
        })
    </script>