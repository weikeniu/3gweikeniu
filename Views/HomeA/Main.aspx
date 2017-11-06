<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

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
    var Examine = hotel3g.Models.DAL.BranchHelper.GetExamine(weixinID);
    bool IsBranch = (bool)ViewData["IsBranch"];

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta name="keywords" content="微可牛" />
    <meta name="description" content="微可牛首页" />
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <title>
        <%=ViewData["hotel"]%></title>
    <link type="text/css" rel="stylesheet" href="../../css/booklist/font/iconfont.css" />
    <link href="<%=ViewData["cssUrl"]%>/css/booklist/sale-date.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/css/booklist/new-style.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <script src="<%=ViewData["jsUrl"]%>/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
</head>
<body>
<%    
    string MainPic=ViewData["MainPic"] as string;
    string backbg = string.Empty;
       string[] covers = { };
       if (!string.IsNullOrEmpty(MainPic))
       {
           covers = MainPic.Split(';');
           backbg = covers.Length > 0 ? covers[0] : "";
       }
       else {
           backbg = "http://admin.weikeniu.com/img/28291/20170505151445_4676.jpg";
       } %>
    <article class="full-page">

     <%Html.RenderPartial("HeaderA", viewDic);%>


     	<section class="loading-page">
			<div class="inner">
				<img src="../../images/loading-w.png" class="type1" />
				<img src="../../images/loading-n.png" />
			</div>
		</section>


		<section class="show-body">	
			<section class="content" >

         	<img src="<%=backbg %>" class="content-bg"/>

				<div class="q-nav type1 yu-grid yu-alignc"  onclick="javascript:window.location.href='/HotelA/Map/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>'" >
					<p class="iconfont icon-daohang yu-rmar10"></p>
					<p>一键导航</p>
				</div>
                  <%if (!string.IsNullOrEmpty(quanjing))
                    { %>
				<div class="q-nav type2 yu-grid yu-alignc" onclick="javascript:window.location.href='/HotelA/quanjing/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>' " >
					<p class="iconfont icon-quanjing- yu-rmar10"></p>
					<p>查看全景</p>
				</div>
                <%} %>
			</section>
			<footer>
			<div class="yu-grid fix-bottom-nav">
				<a href="/HotelA/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>" class="yu-overflow">
					<%--<p class="ico type1"></p>--%>
                    <p class="iconfont icon-dingfang1"></p>
					<p>客房预订</p>
				</a>

                <% if (Examine.canyin == 1)
                   { %>
				<a href="/DishOrderA/DishOrderIndex/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>" class="yu-overflow">
					<%--<p class="ico type2"></p>--%>
                    <p class="iconfont icon-dingcan1"></p>
					<p>酒店餐饮</p>
				</a>
                <%} %>
				<a href="/HotelA/NewsinfoList/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>" class="yu-overflow">
				<%--	<p class="ico type3"></p>--%>
<p class="iconfont icon-huodong"></p>
					<p>酒店活动</p>
				</a>
				<a href="/HotelA/HotelService/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>" class="yu-overflow">
				<%--	<p class="ico type4"></p>--%>
                    <p class="iconfont icon-sheshi1"></p>
					<p>设施服务</p>
				</a>
				<a href="/MeetingA/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>" class="yu-overflow">
				<%--	<p class="ico type5"></p>--%>
                    <p class="iconfont icon-huiyiting"></p>
					<p>会议宴会</p>
				</a>
			</div>
		</footer>

		</section>
		
	</article>
</body>
</html>
<script>
    $(".loading-page").hide();
</script>
