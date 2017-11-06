<!--餐饮快速导航-->
<%
    var key = Html.ViewData["key"] + "";
    bool F = false;

    string weixinid = "";
    string userweixinid = string.Empty;
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;

    if (key.Contains('@'))
    {
        F = key.Split('@')[0].ToLower() == "gh_669095f50cbd";
        userweixinid = key.Split('@')[1];
        weixinid = key.Split('@')[0];
    }
    var ModuleAuthority = hotel3g.Models.DAL.AuthorityHelper.ModuleAuthority(weixinid);


    int tid = 0;//扫码来的桌台号id
    int.TryParse(ViewData["tid"] + "", out tid) ;
    if (tid == 0) 
    {
        tid = HotelCloud.Common.HCRequest.getInt("tid");
    }
%>
<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%  if (tid == Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
    { %>

<% if (!string.IsNullOrEmpty(userweixinid) && !userweixinid.Contains(wkn_shareopenid))
   {
%>
<section class="fix-right" id="drag">
		<div class="fix-btn yu-grid yu-alignc">
			<p class="ico"></p>
			<p class="show-hide cur">快速<br />导航</p>
			<p class="show-hide">收起</p>
		</div>
		<div class="fix-right-slide towrow">

        <% if (!WeiXin.Common.NormalCommon.IsLXSDoMain())
           { %>
            <% if (F)
               {
               %>
               <div class="yu-grid yu-alignc">
                 <% if (ModuleAuthority.module_room == 1)
                    { %>
                <a class="yu-overflow" href="/hotel/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"]%>">
					<p class="ico type4"></p>
					<p>订房</p>
				</a>
                <%}
                    if (ModuleAuthority.module_meals == 1)
                    { %>
               <a class="yu-overflow"  href="/DishOrder/DishOrderIndex/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"]%>">
					<p class="ico type5"></p>
					<p>订餐</p>
				</a>
                <%}
                    if (ModuleAuthority.module_supermarket == 1)
                    { %>
               <a class="yu-overflow"  href="/Supermarket/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"] %>">
					<p class="ico type6"></p>
					<p>超市</p>
				</a>
                <%} %>
			</div>
            <div class="yu-grid yu-alignc">
				<a class="yu-overflow"  href="/user/myorders/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"]%>">
					<p class="ico type2"></p>
					<p>订单</p>
				</a>
                <% if (ModuleAuthority.module_memberbasics == 1)
                   { %>
                <a class="yu-overflow"  href="/user/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"] %>">
					<p class="ico type3"></p>
					<p>会员中心</p>
				</a>
                <%} %>
			</div>
               <%
    }
               else
               { %>
			<div class="yu-grid yu-alignc">
                <a class="yu-overflow" href="/home/main/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"] %>">
					<p class="ico type1"></p>
					<p>首页</p>
				</a>
				<a class="yu-overflow"  href="/user/myorders/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"]%>">
					<p class="ico type2"></p>
					<p>订单</p>
				</a>
                <% if (ModuleAuthority.module_memberbasics == 1)
                   { %>
                <a class="yu-overflow"  href="/user/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"] %>">
					<p class="ico type3"></p>
					<p>会员中心</p>
				</a>
                <%} %>
			</div>
            <div class="yu-grid yu-alignc">
               <% if (ModuleAuthority.module_room == 1)
                  { %>
               <a class="yu-overflow" href="/hotel/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"]%>">
					<p class="ico type4"></p>
					<p>订房</p>
				</a>
                <%}
                  if (ModuleAuthority.module_meals == 1)
                  { %>
               <a class="yu-overflow"  href="/DishOrder/DishOrderIndex/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"]%>">
					<p class="ico type5"></p>
					<p>订餐</p>
				</a>
                <%}
                  if (ModuleAuthority.module_supermarket == 1)
                  { %>
               <a class="yu-overflow"  href="/Supermarket/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"] %>">
					<p class="ico type6"></p>
					<p>超市</p>
				</a>
                <%} %>
			</div>
            <% } %>
            <%}
           else
           { %>

                     <div class="yu-grid yu-alignc">
            
		         <a class="yu-overflow" href="/home/mainTravel/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"] %>">
					<p class="ico type1"></p>
					<p>首页</p>
				</a>

                	<a class="yu-overflow"  href="/user/myorders/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"]%>">
					<p class="ico type2"></p>
					<p>订单</p>
				</a>
			    <% if (ModuleAuthority.module_memberbasics == 1){ %>
                <a class="yu-overflow"  href="/user/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"] %>">
					<p class="ico type3"></p>
					<p>会员中心</p>
				</a>
                <%} %>
			</div>
            <%} %>
        </div>
        
</section>

<% }
   else
   { 
%>
<section class="fix-right" id="drag"></section>
<%
    }  %>

<%  }
    else 
    { %>
    <section class="fix-right" id="drag">
        <div class="fix-btn yu-grid yu-alignc">
			<p class="ico"></p>
			<p class="show-hide cur">快速<br />导航</p>
			<p class="show-hide">收起</p>
		</div>
        <div class="fix-right-slide towrow">
          <div class="yu-grid yu-alignc">
				<a class="yu-overflow"  href="/user/myorders/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"]%>&tid=<%=tid %>">
					<p class="ico type2"></p>
					<p>订单</p>
				</a>
			</div>
        </div>
    </section>

<% } %>

<%
    //微信分享
    hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = Html.ViewData["WeiXinShareConfig"] as hotel3g.PromoterEntitys.WeiXinShareConfig;

    string openid = userweixinid;// ViewData["userweixinid"].ToString();
    string hotelWeixinid = weixinid;// Html.ViewData["weixinid"].ToString();
    string newkey = string.Format("{0}@{1}", hotelWeixinid, openid);
    string hid = ViewData["hId"] + "";//Html.ViewData["hotelId"].ToString();
    if (!openid.Contains(wkn_shareopenid))
    {
        //非二次分享 获取推广员信息
        var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(hotelWeixinid, openid);
        ///原链接已经是分享过的链接
        newkey = string.Format("{0}@{1}_{2}", hotelWeixinid, wkn_shareopenid, CurUser.memberid);
    }

    string sharelink = string.Format("http://hotel.weikeniu.com ", Request.Url.LocalPath, newkey);
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

<script>
    $(function () {
        //快速导航
        $(".fix-btn").click(function () {
            $(this).toggleClass("cur").children(".show-hide").toggleClass("cur");
            $(".fix-right-slide").toggle();
        });


    });


</script>