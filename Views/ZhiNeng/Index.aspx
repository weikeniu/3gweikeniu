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

    var ModuleAuthority = hotel3g.Models.DAL.AuthorityHelper.ModuleAuthority(weixinID);


    if (ModuleAuthority.module_zhineng != 1)
    {
        Response.Redirect(string.Format("/home/Default/{0}?key={1}@{2}&msg={3}", hotelid, weixinID, userWeiXinID, "您的权限不足!请联系微可牛相关人员"));
    }


    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userWeiXinID);

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();

    IList<hotel3g.Models.Advertisement> adlist = ViewData["ad"] as List<hotel3g.Models.Advertisement>;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <title>
        <%=ViewData["hotel"]%>智能服务</title>
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <link href="<%=ViewData["jsUrl"] %>/swiper/swiper-3.4.1.min.css" rel="stylesheet" />
    <script src="<%=ViewData["jsUrl"] %>/swiper/swiper-3.4.1.jquery.min.js"></script>
</head>
<body class="ca-overflow">
    <div class="ca-slide-show">
        <div class="swiper-container">
            <div class="swiper-wrapper">
                <% if (adlist != null && adlist.Count > 0)
                   {
                       foreach (hotel3g.Models.Advertisement ad in adlist)
                       {
                           string href = "javascript:void(0)";

                           if (!string.IsNullOrEmpty(ad.ImageUrl))
                           {
                               if (!string.IsNullOrEmpty(ad.LinkUrl))
                               {
                                   if (ad.LinkUrl.Contains("/Hotel/Fillorder"))
                                       href = ad.LinkUrl + "&userweixinid=" + ViewData["userWeiXinID"];
                                   else
                                       href = ad.LinkUrl.Trim() + "@" + ViewData["userWeiXinID"];


                                   href = href.Replace("@{{userweixinID}}", "");
                               }
                                 
                %>
                <div class="swiper-slide">
                    <a href="<%=href %>">
                        <img src="<%=ad.ImageUrl %>" />
                    </a>
                </div>
                <%}
                       }
                   } %>
            </div>
            <!-- 如果需要分页器 -->
            <div class="swiper-pagination">
            </div>
            <!-- 如果需要导航按钮 -->
            <div class="swiper-button-prev swiper-button-white">
            </div>
            <div class="swiper-button-next swiper-button-white">
            </div>
        </div>
        <!--swiper-container end-->
    </div>
    <!--ca-slide-show end-->
    <div class="ca-apt-service">
        <div class="ca-service-title">
            <ul>
                <li class="ca-line fl left-line"><em></em></li>
                <li><span>便</span><i>/</i><span>捷</span><i>/</i>服<i>/</i>务</li>
                <li class="ca-line fr right-line"><em></em></li>
            </ul>
        </div>
        <div class="ca-service-menu">
            <div class="ca-displayfx">
                <a href="/hotel/ToFreeWifiPage/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>&v=0"
                    class="one-wifi flex1"><em class="dl-incon1"></em><span class="dl-color1">一键连WiFi</span>
                </a><a href="/product/productList/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>"
                    class="one-wifi flex1"><em class="dl-incon2"></em><span class="dl-color2">抢购</span>
                </a>
            </div>
            <!--ca-displayfx end-->
            <ul class="ca-displayfx ca-sup-market">
                <%   if (ModuleAuthority.module_supermarket == 1)
                     { %>
                <li class="flex1"><a href="/Supermarket/Index/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>">
                    <em class="ul-incon1"></em><span class="ul-color1">超市</span></a></li>
                <%} %>
                <li class="flex1"><a href="http://hotel.weikeniu.com/WeiXinZhiFu/pay.aspx?id=<%=ViewData["userId"] %>&type=yajin">
                    <em class="ul-incon2"></em><span class="ul-color2">交押金</span></a></li>
                <%   if (ModuleAuthority.module_meals == 1)
                     { %>
                <li class="flex1"><a href="/DishOrder/DishOrderIndex/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>">
                    <em class="ul-incon3"></em><span class="ul-color3">美食</span></a></li>
                <%} %>
            </ul>
            <div class="ca-displayfx">
                <a href="/zhineng/FaPiaoService/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>&s=1"
                    class="one-wifi flex1"><em class="dl-incon3"></em><span class="dl-color3">预约发票</span>
                </a><a href="http://hotel.weikeniu.com/WeiXinZhiFu/pay.aspx?id=<%=ViewData["userId"] %>"
                    class="one-wifi flex1"><em class="dl-incon4"></em><span class="dl-color4">买单</span>
                </a>
            </div>
            <!--ca-displayfx end-->
        </div>
        <!--ca-service-menu end-->
        <div class="ca-service-title">
            <ul>
                <li class="ca-line fl left-line"><em></em></li>
                <li><span>管</span><i>/</i><span>家</span><i>/</i>服<i>/</i>务</li>
                <li class="ca-line fr right-line"><em></em></li>
            </ul>
        </div>
        <div class="ca-service-menu">
            <div class="ca-displayfx">
                <a href="/zhineng/CleanService/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>"
                    class="one-wifi flex1"><em class="dl-incon5"></em><span class="dl-color5">清洁</span>
                </a><a href="/zhineng/GoodsService/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>"
                    class="one-wifi flex1"><em class="dl-incon6"></em><span class="dl-color6">物品借用</span>
                </a>
            </div>
            <!--ca-displayfx end-->
            <div class="ca-displayfx">
                <a href="/zhineng/WakeService/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>"
                    class="one-wifi flex1"><em class="dl-incon7"></em><span class="dl-color7">叫醒服务</span>
                </a><a href="/zhineng/FrontService/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>"
                    class="one-wifi flex1"><em class="dl-incon8"></em><span class="dl-color8">前台服务</span>
                </a>
            </div>
            <!--ca-displayfx end-->
            <div class="ca-displayfx">
                <a href="/zhineng/WaterClothesService/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>"
                    class="one-wifi flex1"><em class="dl-incon9"></em><span class="dl-color9">洗衣服务</span>
                </a><a href="tel:<%=ViewData["tel"] %>" class="one-wifi flex1"><em class="dl-incon10">
                </em><span class="dl-color10">呼叫服务员</span> </a>
            </div>
            <!--ca-displayfx end-->
        </div>
        <!--ca-service-menu end-->
        <div class="ca-service-title">
            <ul>
                <li class="ca-line fl left-line"><em></em></li>
                <li><span>礼</span><i>/</i><span>宾</span><i>/</i>服<i>/</i>务</li>
                <li class="ca-line fr right-line"><em></em></li>
            </ul>
        </div>
        <div class="ca-service-menu">
            <div class="ca-displayfx">
                <a href="/zhineng/FeedbackService/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>"
                    class="one-wifi flex1"><em class="dl-incon11"></em><span class="dl-color11">宾客反馈</span>
                </a><a href="/zhineng/BaggageService/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>"
                    class="one-wifi flex1"><em class="dl-incon12"></em><span class="dl-color12">行李寄运</span>
                </a>
            </div>
            <%    string gourl = System.Configuration.ConfigurationManager.AppSettings["gourl"].ToString(); %>
            <!--ca-displayfx end-->
            <ul class="ca-displayfx ca-sup-market">
                <li class="flex1"><a href="/zhineng/AirportService/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>">
                    <em class="ul-incon4"></em><span class="ul-color4">机场接送</span></a></li>
                <li class="flex1"><a href="/zhineng/fanyi/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>">
                    <em class="ul-incon5"></em><span class="ul-color5">翻译</span></a></li>
                <li class="flex1"><a href="/zhineng/dache/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>">
                    <em class="ul-incon6"></em><span class="ul-color6">打车</span></a></li>
            </ul>
        </div>
        <!--ca-service-menu end-->


              <div class="ca-service-title">
            <ul>
                <li class="ca-line fl left-line"><em></em></li>
                <li><span>会</span><i>/</i><span>员</span><i>/</i>服<i>/</i>务</li>
                <li class="ca-line fr right-line"><em></em></li>
            </ul>
        </div>
        <div class="ca-service-menu">
            <ul class="ca-displayfx ca-sup-market">
                <li class="flex1"><a href="/MemberCard/MemberCenter/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>">
                    <em class="ul-incon10"></em><span class="ul-color10">会员卡</span></a></li>
                <li class="flex1"><a href="/User/Index/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>">
                    <em class="ul-incon11"></em><span class="ul-color11">会员中心</span></a></li>
                <li class="flex1"><a href="/Home/CouPon/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>">
                    <em class="ul-incon12"></em><span class="ul-color12">红包</span></a></li>
            </ul>
            <div class="ca-displayfx">
                <a href="/Hotel/PrizeSports/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>" class="one-wifi flex1">
                    <em class="dl-incon17"></em><span class="dl-color17">抽奖活动</span> </a><a href="/Promoter/Generalize/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>"
                        class="one-wifi flex1"><em class="dl-incon18"></em><span class="dl-color18">推广员</span>
                    </a>
            </div>
            <!--ca-displayfx end-->
        </div>
        <!--ca-service-menu end-->

        <div class="ca-service-title">
            <ul>
                <li class="ca-line fl left-line"><em></em></li>
                <li><span>酒</span><i>/</i><span>店</span><i>/</i>服<i>/</i>务</li>
                <li class="ca-line fr right-line"><em></em></li>
            </ul>
        </div>
        <div class="ca-service-menu">
            <div class="ca-displayfx">
                <a href="/Hotel/Info/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>" class="one-wifi flex1">
                    <em class="dl-incon13"></em><span class="dl-color13">酒店介绍</span> </a><a href="/Hotel/HotelService/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>"
                        class="one-wifi flex1"><em class="dl-incon14"></em><span class="dl-color14">设施</span>
                    </a>
            </div>
            <!--ca-displayfx end-->
            <ul class="ca-displayfx ca-sup-market">
                <li class="flex1"><a href="/Hotel/NewsinfoList/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>">
                    <em class="ul-incon7"></em><span class="ul-color7">活动</span></a></li>
                <li class="flex1"><a href="/Meeting/Index/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>">
                    <em class="ul-incon8"></em><span class="ul-color8">会议厅</span></a></li>
                <li class="flex1"><a href="/Hotel/Images/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>">
                    <em class="ul-incon9"></em><span class="ul-color9">图片</span></a></li>
            </ul>
            <div class="ca-displayfx">
                <a href="/Hotel/QuanJing/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>" class="one-wifi flex1">
                    <em class="dl-incon15"></em><span class="dl-color15">全景</span> </a><a href="/Hotel/Map/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>"
                        class="one-wifi flex1"><em class="dl-incon16"></em><span class="dl-color16">导航</span>
                    </a>
            </div>
            <!--ca-displayfx end-->
        </div>
        <!--ca-service-menu end-->
  
    </div>
    <!--ca-apt-service end-->
    <%Html.RenderPartial("Footer", viewDic); %>
</body>
<script type="text/javascript">
      
	     var mySwiper = new Swiper('.swiper-container',{
			pagination: '.swiper-pagination',
			paginationClickable: true,
			autoplayDisableOnInteraction: false,
			prevButton:'.swiper-button-prev',
            nextButton:'.swiper-button-next',
			autoplay : 3000,
            speed:350,
		})
        
</script>
</html>
