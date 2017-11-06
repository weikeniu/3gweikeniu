<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%--<%
    string weixinID = ViewData["weixinid"] as string;
    string id = ViewData["id"] as string;
     %>
 <div id="footer">
    	<ul class="links">
        	<li><a href="/Hotel/Index/<%=id %>?weixinID=<%=weixinID %>">客房预订</a></li>
            <li><a href="/Hotel/NewsInfoList/<%=id %>?weixinID=<%=weixinID %>">优惠促销</a></li>
            <li><a href="/User/Index/<%=id %>?weixinID=<%=weixinID %>">会员中心</a></li>
            <li><a href="/Hotel/Info/<%=id %>?weixinID=<%=weixinID %>">酒店介绍</a></li>
        </ul>
        
        <p class="copyright">技术支持：<a href="http://www.weikeniu.com/">微可牛</a></p>
</div>--%>
<div class="bottom cl">
    <div class="yda" id="ft_first">
        <ul>
            <li class="fir"><a href="/Hotel/Index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>" data-cu="touch">
                客房预订</a></li>
            <li class="las"><a href="/Hotel/HotelService/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=ViewData["uwx"] %>" data-cu="touch">
                设施服务</a><span></span></li>
        </ul>
    </div>
    <div class="ydb" id="ft_two">
        <ul>
            <li class="fir"><a href="/Hotel/Info/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=Html.ViewData["uwx"] %>" data-cu="touch">
                酒店简介</a></li>
            <li><a href="/Hotel/Images/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=Html.ViewData["uwx"] %>" data-cu="touch">
                酒店图片</a></li>
            <li class="las"><a href="/Hotel/Map/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=Html.ViewData["uwx"] %>" data-cu="touch">
                酒店地图</a><span></span></li>
        </ul>
    </div>
    <div class="ydc" id="ft_third">
        <ul>
            <li class="fir"><a href="/Home/CouPon/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=Html.ViewData["uwx"] %>" data-cu="touch">
                抢优惠券</a></li>
            <li><a href="/Hotel/NewsinfoList/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=Html.ViewData["uwx"] %>" data-cu="touch">
                优惠活动</a></li>
            <li class="las"><a href="/User/Index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=Html.ViewData["uwx"] %>" data-cu="touch">
                会员中心</a><span></span></li>
        </ul>
    </div>
    <ul class="ls" id="ft_leader">
        <li><a href="/Home/Main/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"].ToString().Replace("@","") %>@<%=Html.ViewData["uwx"] %>" data-cu="touch">
            首页</a></li>
        <li><a style="display: block"  class="yudingkf ft" href="javascript:void(0)" data-cu="ft_first">客房预订</a></li>
        <li><a style="display: block"  class="jiudianjj ft" href="javascript:void(0)" data-cu="ft_two">
            酒店简介</a></li>
        <li><a style="display: block"  class="qiangjuanyou ft" href="javascript:void(0)" data-cu="ft_third">
            抢优惠券</a></li>
    </ul>
</div>
