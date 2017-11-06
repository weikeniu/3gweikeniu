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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="zh-cn">
<head>
    <meta charset="UTF-8" />
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
    <script src="<%=ViewData["jsUrl"]%>/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="<%=ViewData["cssUrl"]%>/css/booklist/mend-reset.css" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"]%>/css/booklist/mend-weikeniu.css#1" />
    <script src="<%=ViewData["cssUrl"]%>/Scripts/fontSize.js"></script>
</head>
<body>
<%      string backbg = string.Empty;
       string[] covers = { };
       if (!string.IsNullOrEmpty(HotelInfo.MainPic))
       {
           covers = HotelInfo.MainPic.Split(';');
           backbg = covers.Length > 0 ? covers[0] : "";
       }  %>
<article class="full-page">

     <%Html.RenderPartial("HeaderA", viewDic);%>

		<section class="show-body">	
 

			<section class="content" >
   <% int min = 0; int max = 0; string hid = hotelid; %>
    <!-- <>微官网首页 -->
    <div class="wei__panel-index clearfix">
        <div class="wei__bg" id="J__wei-bg" style="background: url('<%=backbg %>');
            background-size: 100% 100%;">
        </div>
        <!-- //导航区域 -->
        <div class="zone__navition">
            <!--//导航1-->
            <div class="nav__pagination">
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <%            min = 4;
                                      if (MenuBarList.Count > min)
                                      {
                                          max = MenuBarList.Count > min + 5 ? min + 5 : MenuBarList.Count;
                               
                        %>
                        <div class="swiper-slide">
                            <ul class="nav-list flexbox clearfix">
                                <% for (int i = min; i < max; i++)
                                   {
                                       hid = MenuBarList[i].MenuName.Equals("分店") ? "0" : hotelid;
                                       %>
                                <li class="flex1"><a href="<%=MenuBarList[i].Link %><%=hid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                    <i class="ico <%=MenuBarList[i].IcoClass %>"></i>
                                    <h2 class="txt">
                                        <%=MenuBarList[i].MenuName%></h2>
                                </a></li>
                                <%}%>
                            </ul>
                        </div>
                        <%} %>
                        <%            min = 9;
                                      if (MenuBarList.Count > min)
                                      {
                                          max = MenuBarList.Count > min + 5 ? min + 5 : MenuBarList.Count;
                               
                        %>
                        <div class="swiper-slide">
                            <ul class="nav-list flexbox clearfix">
                                <% for (int i = min; i < max; i++)
                                   {
                                       hid = MenuBarList[i].MenuName.Equals("分店") ? "0" : hotelid;
                                       %>
                                <li class="flex1"><a href="<%=MenuBarList[i].Link %><%=hid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                    <i class="ico <%=MenuBarList[i].IcoClass %>"></i>
                                    <h2 class="txt">
                                        <%=MenuBarList[i].MenuName %></h2>
                                </a></li>
                                <%} %>
                            </ul>
                        </div>
                        <%} %>
                        <%            min = 14;
                                      if (MenuBarList.Count > min)
                                      {
                                          max = MenuBarList.Count > min + 5 ? min + 5 : MenuBarList.Count;
                               
                        %>
                        <div class="swiper-slide">
                            <ul class="nav-list flexbox clearfix">
                                <% for (int i = min; i < max; i++)
                                   {
                                       hid = MenuBarList[i].MenuName.Equals("分店") ? "0" : hotelid;
                                        %>
                                <li class="flex1"><a href="<%=MenuBarList[i].Link %><%=hid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                    <i class="ico <%=MenuBarList[i].IcoClass %>"></i>
                                    <h2 class="txt">
                                        <%=MenuBarList[i].MenuName %></h2>
                                </a></li>
                                <%} %>
                            </ul>
                        </div>
                        <%} %>
                    </div>
                    <div class="swiper-pagination">
                    </div>
                </div>
            </div>
            <!--//导航2-->
            <div class="nav__normal">
                <ul class="nav-item flexbox clearfix">
                    <%            min = 0;
                                  if (MenuBarList.Count > min)
                                  {
                                      max = MenuBarList.Count > min + 4 ? min + 4 : MenuBarList.Count;
                               
                    %>
                    <% for (int i = min; i < max; i++)
                       {
                           hid = MenuBarList[i].MenuName.Equals("分店") ? "0" : hotelid;
                            %>
                    <li class="flex1"><a href="<%=MenuBarList[i].Link %><%=hid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                        <i class="ico <%=MenuBarList[i].IcoClass %>"></i>
                        <h2 class="txt">
                            <%=MenuBarList[i].MenuName%></h2>
                    </a></li>
                    <%} %>
                    <%} %>
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
            pagination: '.swiper-pagination',
            paginationClickable: true,
            autoplayDisableOnInteraction: false
        })
	</script>
    <!-- 左右滑屏.End -->
    <script type="text/javascript">
        /** __公共函数 */
        $(function () {
            //TODO...
        });

        /** __自定函数 */
        $(function () {
            //TODO...
        });
	</script>
</body>
</html>
