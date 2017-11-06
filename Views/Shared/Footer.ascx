<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<% 
    string userweixinid = ViewData["uwx"].ToString();
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    //如果不是来自分享的链接 则显示底部导航条   旅行社不显示底部导航条
    if (!string.IsNullOrEmpty(userweixinid) && !userweixinid.Contains(wkn_shareopenid) && !WeiXin.Common.NormalCommon.IsLXSDoMain())
    {
        var ModuleAuthority = hotel3g.Models.DAL.AuthorityHelper.ModuleAuthority(Html.ViewData["weixinID"].ToString()); 
%>
<div class="foot-nav yu-grid yu-font12">
    <% if (!Html.ViewData["weixinID"].ToString().Equals("gh_669095f50cbd"))
       {%>
    <a href="/home/main/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>">
        <span class="type1"></span>
        <p>
            首页</p>
    </a>
    <%} %>
    <% if (ModuleAuthority.module_room == 1)
       { %>
    <a href="/hotel/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>">
        <span class="type2"></span>
        <p>
            订房</p>
    </a>
    <%} %>
    <% 

        if (ModuleAuthority.module_meals == 1)
        { 
    %>
    <a href="/DishOrder/DishOrderIndex/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>">
        <span class="type7"></span>
        <p>
            订餐</p>
    </a>
    <%}%>
    <% if (ModuleAuthority.module_supermarket == 1)
       { 
    %>
    <a href="/Supermarket/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>">
        <span class="type8"></span>
        <p>
            超市</p>
    </a>
    <%
       } %>
    <a href="/user/myorders/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>">
        <span class="type6"></span>
        <p>
            订单</p>
    </a>
    <% if (ModuleAuthority.module_memberbasics == 1)
       { %>
    <a href="/user/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>">
        <span class="type5"></span>
        <p>
            会员</p>
        <%} %>
    </a>
</div>
<script>


    if (window.location.href.toLowerCase().indexOf("/home/main") > 0) {

        $(".foot-nav a[href^='/home/main']").addClass("cur");

    }

    else if (window.location.href.toLowerCase().indexOf("/hotel/index") > 0) {

        $(".foot-nav a[href^='/hotel/index']").addClass("cur");

    }

    else if (window.location.href.toLowerCase().indexOf("/user/myorders") > 0) {

        $(".foot-nav a[href^='/user/myorders']").addClass("cur");

    }

    else if (window.location.href.toLowerCase().indexOf("/user/index") > 0) {

        $(".foot-nav a[href^='/user/index']").addClass("cur");

    } 

</script>
<%}
    else
    {%>
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

    string openid = userweixinid;
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