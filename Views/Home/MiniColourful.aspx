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
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/mend-reset.css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/mend-weikeniu.css" />
    <script src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
</head>
<body>
    <% int min = 0; int max = 0; string hid = hotelid;
       string backbg = string.Empty;
       string[] covers = { };
       if (!string.IsNullOrEmpty(HotelInfo.MainPic))
       {
           covers = HotelInfo.MainPic.Split(';');
           backbg = covers.Length > 0 ? covers[0] : "";
       } 
         %>
    <!-- <>顶部导航 -->
    <div class="cal__header-nav">
        <div class="ca_wec-bg" style="background: url('<%=backbg %>') top no-repeat;
            background-size: 100% 100%;">
            <div class="ca-gredient-bg">
                <div class="ca_navbar">
                    <!-- //导航1-->
                    <div class="swiper-container swiper-container-horizontal">
                        <div class="swiper-wrapper">
                            <%            min = 0;
                                          if (MenuBarList.Count > min)
                                          {
                                              max = MenuBarList.Count > min + 5 ? min + 5 : MenuBarList.Count;
                               
                            %>
                            <div class="swiper-slide swiper-slide-active">
                                <div class="ca_wrap-pht">
                                    <ul class="flexbox">
                                        <% for (int i = min; i < max; i++)
                                           {

                                               hid = MenuBarList[i].MenuName.Equals("分店") ? "0" : hotelid;
                                                %>
                                        <li><a href="<%=MenuBarList[i].Link %><%=hid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                            <i class="<%=MenuBarList[i].IcoClass %>"></i>
                                            <h2 class="txt">
                                                <%=MenuBarList[i].MenuName %></h2>
                                        </a></li>
                                        <%} %>
                                    </ul>
                                </div>
                                <!--ca_wrap-pht end-->
                            </div>
                            <%} %>
                            <!--swiper-slide end-->
                            <div class="swiper-slide">
                                <div class="ca_wrap-pht">
                                    <ul class="flexbox">
                                        <%            min = 5;
                                                      if (MenuBarList.Count > min)
                                                      {
                                                          max = MenuBarList.Count > min + 5 ? min + 5 : MenuBarList.Count;
                                        %>
                                        <div class="swiper-slide">
                                            <div class="ca_wrap-pht">
                                                <ul class="flexbox">
                                                    <% for (int i = min; i < max; i++)
                                                       {
                                                           hid = MenuBarList[i].MenuName.Equals("分店") ? "0" : hotelid;
                                                           %>
                                                    <li><a href="<%=MenuBarList[i].Link %><%=hid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                                        <i class="<%=MenuBarList[i].IcoClass %>"></i>
                                                        <h2 class="txt">
                                                            <%=MenuBarList[i].MenuName %></h2>
                                                    </a></li>
                                                    <%} %>
                                                </ul>
                                            </div>
                                            <!--ca_wrap-pht end-->
                                        </div>
                                        <%} %>
                                    </ul>
                                </div>
                                <!--ca_wrap-pht end-->
                            </div>

                            <!--swiper-slide end-->
                            <div class="swiper-slide">
                                <div class="ca_wrap-pht">
                                    <ul class="flexbox">
                                        <%           min = 10;
                                                     if (MenuBarList.Count > min)
                                                     {
                                                         max = MenuBarList.Count > min + 5 ? min + 5 : MenuBarList.Count;
                                        %>
                                        <div class="swiper-slide">
                                            <div class="ca_wrap-pht">
                                                <ul class="flexbox">
                                                    <% for (int i = min; i < max; i++)
                                                       {
                                                           hid = MenuBarList[i].MenuName.Equals("分店") ? "0" : hotelid;
                                                           %>
                                                    <li><a href="<%=MenuBarList[i].Link %><%=hid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                                        <i class="<%=MenuBarList[i].IcoClass %>"></i>
                                                        <h2 class="txt">
                                                            <%=MenuBarList[i].MenuName %></h2>
                                                    </a></li>
                                                    <%} %>
                                                </ul>
                                            </div>
                                            <!--ca_wrap-pht end-->
                                        </div>
                                        <%} %>
                                    </ul>
                                </div>
                                <!--ca_wrap-pht end-->
                            </div>
                            <!--swiper-slide end-->
                  <% 
                                            min = 15;
                                            if (MenuBarList.Count > min)
                                           {
                                                max = MenuBarList.Count > min + 5 ? min + 5 : MenuBarList.Count;
                 
                                        %>
                            <div class="swiper-slide">
                                <div class="ca_wrap-pht">
                                    <ul class="flexbox">
                                    
                                        <div class="swiper-slide">
                                            <div class="ca_wrap-pht">
                                                <ul class="flexbox">
                                                    <% for (int i = min; i < max; i++)
                                                       {
                                                           hid = MenuBarList[i].MenuName.Equals("分店") ? "0" : hotelid;
                                                            %>
                                                    <li><a href="<%=MenuBarList[i].Link %><%=hotelid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                                        <i class="<%=MenuBarList[i].IcoClass %>"></i>
                                                        <h2 class="txt">
                                                            <%=MenuBarList[i].MenuName %></h2>
                                                    </a></li>
                                                    <%} %>
                                                </ul>
                                            </div>
                                            <!--ca_wrap-pht end-->
                                        </div>
                            
                                    </ul>
                                </div>
                                <!--ca_wrap-pht end-->
                            </div>
                            <%} %>
                            <!--swiper-slide end-->
                        </div>
                        <!--swiper-wrapper end-->
                        <div class="swiper-pagination">
                        </div>
                    </div>
             
                </div>
            </div>
            <!--ca_navbar end-->
        </div>
        <!--ca_wec-bg end-->
    </div>
    <!--cal__header-nav end-->
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
<%
    //微信分享

    string openid = userWeiXinID;
    string newkey = string.Format("{0}@{1}", weixinID, openid);
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    if (!openid.Contains(wkn_shareopenid))
    {
        //非二次分享 获取推广员信息
        var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(weixinID, openid);
        ///原链接已经是分享过的链接
        newkey = string.Format("{0}@{1}_{2}", weixinID, wkn_shareopenid, CurUser.memberid);
    }

    string desn = HotelInfo.Address;
    string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}", Request.Url.LocalPath, newkey);
    hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
    {
        title = ViewData["hotel"] + "(分享)",
        desn = desn,
        logo = HotelInfo.HotelLog,
        debug = false,
        userweixinid = openid,
        weixinid = weixinID,
        hotelid = int.Parse(hotelid),
        sharelink = sharelink
    };
    viewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
    Html.RenderPartial("WeiXinShare", viewDic);
%>