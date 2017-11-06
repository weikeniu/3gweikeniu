<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%    
    
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string hotelid = RouteData.Values["id"].ToString();

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
    <link href="../../Content/ProductIndex/swiper-3.4.1.min.css" rel="stylesheet" type="text/css" />
    <link href="../../css/booklist/list.css" rel="stylesheet" type="text/css" />
    <link href="../../css/booklist/index.css" rel="stylesheet" type="text/css" />
    <link href="../../css/booklist/sale-date.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <script src="../../Content/ProductIndex/swiper-3.4.1.jquery.min.js" type="text/javascript"></script>
</head>
<body>
    <%
        ViewDataDictionary jdata = new ViewDataDictionary();
        jdata.Add("weixinID", ViewData["weixinID"]);
        jdata.Add("hId", ViewData["hId"]);
        jdata.Add("uwx", ViewData["userWeiXinID"]);
        IList<hotel3g.Models.Advertisement> adlist = ViewData["ad"] as List<hotel3g.Models.Advertisement>;
    %>
    <div class="base-page">
        <div id="main">
            <div class="hotel-img-box swiper-container">
                <!-- <p class="hotel-name">背景橙子时尚快捷公寓首都机场店</p> -->
                <!-- <p class="hotel-img-num"><span class="activeIndex"></span>/15</p> -->
                <div class="swiper-wrapper">
                    <% if (adlist != null && adlist.Count > 0)
                       {
                           foreach (hotel3g.Models.Advertisement ad in adlist)
                           {
                               if (!string.IsNullOrEmpty(ad.ImageUrl))
                               {
                                   if (!string.IsNullOrEmpty(ad.LinkUrl))
                                   {
                                       if (ad.LinkUrl.Contains("/Hotel/Fillorder"))
                                           ad.LinkUrl = ad.LinkUrl + "&userweixinid=" + ViewData["userWeiXinID"];
                                       else
                                           ad.LinkUrl = ad.LinkUrl.Trim() + "@" + ViewData["userWeiXinID"];
                                   }
                                   if (string.IsNullOrEmpty(ad.LinkUrl))
                                   {
                                       ad.LinkUrl = "javascript:void(0)";
                                   }
                    %>
                    <div class="swiper-slide">
                        <a href="<%=ad.LinkUrl %>">
                            <img src="<%=ad.ImageUrl %>" />
                        </a>
                    </div>
                    <%}
                           }
                       } %>
                </div>
                <div class="swiper-pagination">
                </div>
            </div>
            <!-- <div class="notice-bar yu-grid">
    <i class="icon type1"></i>
    <p class="yu-overflow ">特价大床房连住3晚送1晚，数量有限，先定先得！</p>
    <i class="icon type2 close"></i>
  </div> -->
            <div class="nav-box swiper-container2">
                <div class="swiper-wrapper">
                    <div class="swiper-slide">
                        <div class="yu-grid">
                            <a class="yu-overflow" href="/Hotel/Info/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                <div class="icobg icobg1">
                                    <div class="navico type2">
                                    </div>
                                </div>
                                <p class="yu-textc">
                                    简介
                                </p>
                            </a><a class="yu-overflow" href="/Product/ProductList/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                <div class="icobg icobg2">
                                    <div class="navico type4">
                                    </div>
                                </div>
                                <p class="yu-textc">
                                    团购</p>
                            </a><a class="yu-overflow" href="/Hotel/map/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>;">
                                <div class="icobg icobg3">
                                    <div class="navico type">
                                    </div>
                                </div>
                                <p class="yu-textc">
                                    地图</p>
                            </a>
                        </div>
                        <div class="yu-grid">
                            <a class="yu-overflow" href="/home/CouPon/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                <div class="icobg icobg4">
                                    <div class="navico type7">
                                    </div>
                                </div>
                                <p class="yu-textc">
                                    优惠</p>
                            </a><a class="yu-overflow" href="/Hotel/images/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                <div class="icobg icobg5">
                                    <div class="navico type8">
                                    </div>
                                </div>
                                <p class="yu-textc">
                                    图片</p>
                            </a><a class="yu-overflow" href="javascript:;">
                                <div class="icobg icobg6">
                                    <div class="navico type10">
                                    </div>
                                </div>
                                <p class="yu-textc">
                                    发票</p>
                            </a>
                        </div>
                        <div class="yu-grid">
                            <a class="yu-overflow" href="javascript:;">
                                <div class="icobg icobg7">
                                    <div class="navico type11">
                                    </div>
                                </div>
                                <p class="yu-textc">
                                    付款</p>
                            </a><a class="yu-overflow" href="/Hotel/prizesports/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                <div class="icobg icobg8">
                                    <div class="navico type12">
                                    </div>
                                </div>
                                <p class="yu-textc">
                                    抽奖</p>
                            </a><a class="yu-overflow" href="/membercard/membercenter/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                <div class="icobg icobg9">
                                    <div class="navico type13">
                                    </div>
                                </div>
                                <p class="yu-textc">
                                    会员卡</p>
                            </a>
                        </div>
                    </div>
                    <div class="swiper-slide">
                        <div class="yu-grid">
                            <a class="yu-overflow" href="javascript:;">
                                <div class="icobg icobg1">
                                    <div class="navico type14">
                                    </div>
                                </div>
                                <p class="yu-textc">
                                    全景
                                </p>
                            </a><a class="yu-overflow" href="/Hotel/NewsinfoList/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                <div class="icobg icobg2">
                                    <div class="navico type5">
                                    </div>
                                </div>
                                <p class="yu-textc">
                                    活动</p>
                            </a><a class="yu-overflow" href="/user/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                                <div class="icobg icobg3">
                                    <div class="navico type9">
                                    </div>
                                </div>
                                <p class="yu-textc">
                                    会员</p>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="swiper-pagination2">
                </div>
            </div>
            <%Html.RenderPartial("ProductSale", viewDic); %>
        </div>
    </div>
    <%Html.RenderPartial("Footer", viewDic); %>
    <script type="text/javascript">



        var swiper = new Swiper('.swiper-container', {
            pagination: '.swiper-pagination',
            paginationClickable: true,
            autoplay: 2500,
            autoplayDisableOnInteraction: false,
            loop: true
        });
        var swiper2 = new Swiper('.swiper-container2', {
            pagination: '.swiper-pagination2',
            paginationClickable: true,
            autoplayDisableOnInteraction: false
            // loop: true
        });




        $(function () {

            $(".notice-bar .close").click(function () {
                $(".notice-bar").hide();
            })

        })
    </script>
</body>
</html>
