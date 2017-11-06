<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<div class="foot-nav yu-grid yu-font12">
    <%
      
        string userweixinid = ViewData["uwx"].ToString();
        string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
        //如果不是来自分享的链接 则显示底部导航条
        if (!string.IsNullOrEmpty(userweixinid) && userweixinid.IndexOf(wkn_shareopenid) < 0)
        {
            var ModuleAuthority = hotel3g.Models.DAL.AuthorityHelper.ModuleAuthority(Html.ViewData["weixinID"].ToString()); 
            
    %>
    <% if (!Html.ViewData["weixinID"].ToString().Equals("gh_669095f50cbd"))
       {%>
    <a href="/homea/main/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>">
        <span class="type1"></span>
        <p>
            首页</p>
    </a>
    <%} %>
    <% if (ModuleAuthority.module_room == 1)
       { %>
    <a href="/hotela/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>">
        <span class="type2"></span>
        <p>
            订房</p>
    </a>
    <%} %>
    <% 

            if (ModuleAuthority.module_meals == 1)
            { 
    %>
    <a href="/DishOrdera/DishOrderIndex/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>">
        <span class="type7"></span>
        <p>
            订餐</p>
    </a>
    <%}%>
    <% if (ModuleAuthority.module_supermarket == 1)
       { 
    %>
    <a href="/Supermarketa/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>">
        <span class="type8"></span>
        <p>
            超市</p>
    </a>
    <%
       } %>
    <a href="/usera/myorders/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>">
        <span class="type6"></span>
        <p>
            订单</p>
    </a>
    <% if (ModuleAuthority.module_memberbasics == 1)
       { %>
    <a href="/usera/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>">
        <span class="type5"></span>
        <p>
            会员</p>
        <%} %>
    </a>
</div>
<script>


    if (window.location.href.toLowerCase().indexOf("/homea/main") > 0) {

        $(".foot-nav a[href^='/homea/main']").addClass("cur");

    }

    else if (window.location.href.toLowerCase().indexOf("/hotela/index") > 0) {

        $(".foot-nav a[href^='/hotela/index']").addClass("cur");

    }

    else if (window.location.href.toLowerCase().indexOf("/usera/myorders") > 0) {

        $(".foot-nav a[href^='/usera/myorders']").addClass("cur");

    }

    else if (window.location.href.toLowerCase().indexOf("/usera/index") > 0) {

        $(".foot-nav a[href^='/usera/index']").addClass("cur");

    } 

</script>
<%} %>