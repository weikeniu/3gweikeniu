<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    DateTime indate = Convert.ToDateTime(Peer._128uu.Public.Sessions.GetSession("indate", DateTime.Now.AddDays(1).ToString("yyyy-MM-dd")));
    DateTime outdate = Convert.ToDateTime(Peer._128uu.Public.Sessions.GetSession("outdate", DateTime.Now.AddDays(2).ToString("yyyy-MM-dd")));
    string indatestr = "";
    string outdatestr = "";
    if (indate.Date == DateTime.Now.Date) { indatestr = "(今天)"; }
    if (indate.Date == DateTime.Now.AddDays(1).Date) { indatestr = "(明天)"; }
    if (outdate.Date == DateTime.Now.AddDays(1).Date) { outdatestr = "(明天)"; }
    if (outdate.Date == DateTime.Now.AddDays(2).Date) { outdatestr = "(后天)"; }
    string hotelid = RouteData.Values["id"].ToString();
    var hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
    string pos = HotelCloud.Common.HCRequest.GetString("pos");
    var rooms = ViewData["rooms"] as List<hotel3g.Models.Room>;
    string[] arr = { "满房", "预订", "部分满" };
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string userWeiXinID = "";
    string key = "";
    userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO",weixinID);
    if (weixinID.Equals(""))
    {
        key = HotelCloud.Common.HCRequest.GetString("key");
        string[] a = key.Split('@');
        weixinID = a[0];
        userWeiXinID = a[1];
    }
    string temp = ViewData["temp"] as string;
    string[] Day = new string[] { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" };
    string inweek = Day[Convert.ToInt32(indate.DayOfWeek.ToString("d"))].ToString();
    string outweek = Day[Convert.ToInt32(outdate.DayOfWeek.ToString("d"))].ToString();
    var Imgs = ViewData["Imgs"] as List<WeiXin.Models.Img>;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,target-densitydpi=medium-dpi,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-touch-fullscreen" content="yes" />
    <title>
        <%=hotel.SubName %>官网</title>
    <link href="/css/style.css" rel="stylesheet" type="text/css" />
    <script type="application/x-javascript">addEventListener('load',function(){setTimeout(function(){scrollTo(0,1);},0);},false);</script>
</head>
<%Html.RenderPartial("JS"); %>
<body>
    <div class="hotel">
        <dl class="attr">
            <dd class="img">
                <a href="/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%= userWeiXinID %>">
                    <img id="img" src="<%=hotel.HotelLog %>" width="80" height="60" />
                </a>
            </dd>
            <dd class="service">
                <ul>
                    <li <% if (hotel.FuWu.IndexOf("停车场") >= 0)
                                               { %>class="park" <%}
                                               else
                                               { %>class="dispark" <%} %>>停车场 </li>
                    <li <% if (hotel.FuWu.IndexOf("餐厅") >= 0)
                                               { %>class="restaurant" <%}
                                               else
                                               { %>class="disrestaurant" <%} %>>餐厅 </li>
                    <li <% if (hotel.FuWu.IndexOf("无线上网") >= 0)
                                               { %>class="wifi" <%}
                                               else
                                               { %>class="diswifi" <%} %>>无线上网 </li>
                    <li <% if (hotel.FuWu.IndexOf("免费宽带") >= 0)
                                               { %>class="net" <%}
                                               else
                                               { %>class="disnet" <%} %>>免费宽带</li>
                    <li <% if (hotel.FuWu.IndexOf("游泳") >= 0)
                                               { %>class="swim" <%}
                                               else
                                               { %>class="disswim" <%} %>>游泳</li>
                    <%--  <li class="printing">打印</li>--%>
                    <%--  <li class="gym">室内运动场</li>--%>
                    <li <% if (hotel.FuWu.IndexOf("会议厅") >= 0)
                                               { %>class="meeting" <%}
                                               else
                                               { %>class="dismeeting" <%} %>>会议厅</li>
                </ul>
            </dd>
            <dd class="addr">
                <span class="dot"></span>
                <%=hotel.Address %></dd>
            <dd class="tel">
                <span class="dot"></span>电话：<a href="tel:<%=hotel.Tel %>"><%=hotel.Tel %></a></dd>
        </dl>
        <%
            var mindate = DateTime.Now.ToString("yyyy-MM-dd");
            if (DateTime.Now.Hour < 5)
            {
                mindate = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd");
            }
        %>
        <input type="text" class="hiddeninput" name="today" id="today" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>"
            style="display: none" />
        <input type="text" class="hiddeninput" name="minDate" id="mindate" value="<%=mindate %>"
            style="display: none" />
        <div class="filter">
            <ul>
                <li class="intime" id="selectCKI" t="<%=temp %>"><span class="key">入住：</span> <span
                    class="value">
                    <%=indate.ToString("MM月dd日") %>
                    <%=inweek %></span> <span class="dot_right"></span></li>
                <li class="outtime" id="selectCKO"><span class="key">离店：</span> <span class="value">
                    <%=outdate.ToString("MM月dd日")%>
                    <%=outweek %></span> <span class="dot_right"></span></li>
            </ul>
            <input type="text" class="hiddeninput" name="CheckInDate" id="CheckInDate" value="<%=indate.ToString("yyyy-MM-dd") %>" />
            <input type="text" class="hiddeninput" name="CheckOutDate" id="CheckOutDate" value="<%=outdate.ToString("yyyy-MM-dd") %>" />
        </div>
        <article id="artLivedate" data-type="0" style="display: none">
            <ul class="calendar_head">
                <li id="calckil">入住</li>
                <li id="calckol">离店</li>
            </ul>
            <div class="calendar" id="calcki">
            </div>
            <div class="calendar" id="calcko">
            </div>
        </article>
        <div class="rooms">
            <dl class="th">
                <dt>房型</dt>
                <dd class="menprice">
                    网络价</dd>
                <dd class="price">
                    微信会员价</dd>
            </dl>
            <% foreach (var room in rooms)
               {
                   string imgurl = "";
                   if (Imgs != null)
                   {
                       var im = Imgs.FirstOrDefault(i => i.Title.Equals(room.RoomName));
                       if (im != null)
                       {
                           imgurl = im.Url;
                       }
                   }
                   foreach (var r in room.RatePlans)
                   {
            %>
            <dl>
                <dt>
                    <% if (!imgurl.Equals(""))
                       {%><img src="<%=imgurl %>" class="showimg" style="max-width: 50px; max-height: 50px" /><%} %></dt>
                <dt style="margin-top: 2px; margin-left: 2px;">
                    <%=room.RoomName %><span><%=string.Format("({1}){0}", r.ZaoCan, r.RatePlanName)%>
                    </span></dt>
                <dd class="menprice">
                    <em>¥</em><%=r.AvgNonMemPrice %></dd>
                <dd class="price">
                    <span class="shiprice"><em>¥</em><%=r.AvgPrice %></span> <span class="jifen">
                        <%if ((r.AvgPrice * hotel.JifenFav).ToString() != "0")
                          {%>
                        返<%=r.AvgPrice * hotel.JifenFav%>积分
                        <%} %>
                    </span>
                </dd>
                <dd class="book">
                    <a name="yd" <% if(r.State!=1) {%> class="dis" href="javascript:void(0)" <%}else{ %>
                        class="c" <%} %> sumprice="<%=r.SumPrice %>" roomid="<%=room.ID %>" rateplanid="<%=r.ID %>"
                        roomname="<%=room.RoomName %>" rateplanname="<%=r.RatePlanName %>" ishourroom="<%=r.IsHourRoom %>">
                        <%=arr[r.State] %></a></dd>
                <dd class="more">
                    <span></span><span></span>
                    <ul>
                        <li>床型：<%=r.BedType %>（<%=room.BedArea %>）</li>
                        <li>上网：<%=room.NetType %>[<%=r.NetInfo %>]</li>
                        <li>楼层：<%=room.Floor  %></li>
                        <li>面积：<%=room.Area %>平方米</li>
                    </ul>
                </dd>
            </dl>
            <%}
               } %>
        </div>
    </div>
    <div id="navigation">
        <ul>
            <li class="cur"><a href="/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>">
                预订</a></li>
            <li><a href="/Hotel/Info/<%=hotelid %>?weixinID=<%=weixinID %>">简介</a></li>
            <li><a href="/Hotel/Images/<%=hotelid %>?weixinID=<%=weixinID %>">图片</a></li>
            <li><a href="/Hotel/Map/<%=hotelid %>?weixinID=<%=weixinID %>">地图</a></li>
        </ul>
    </div>
    <div id="footer">
        <ul class="links">
            <li><a href='/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>'>首页</a></li>
            <li><a href="/Hotel/NewsinfoList/<%=hotelid %>?weixinID=<%=weixinID %>">优惠促销</a></li>
            <li><a href="/User/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>">会员中心</a></li>
            <li><a href="/User/MyOrders/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>">我的订单</a></li>
        </ul>
        <p class="copyright">
            技术支持：<a href="http://www.weikeniu.com/">微可牛</a></p>
    </div>
</body>
</html>
<script src="/Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
<script src="/content/hobbit.fx.js" type="text/javascript"></script>
<script src="/content/load.js" type="text/javascript"></script>
<script src="/content/Detail.js" type="text/javascript"></script>
<script src="/content/hobbit/plugin/calendar/calendar.js" type="text/javascript"></script>
<script type="text/javascript">
    //底部滚动效果
    function footerScroll() {
        var d = Math.round($("#footer").offset().top) + $("#footer").outerHeight(true) - (document.documentElement.scrollTop + document.body.clientHeight);
        d = d < 0 ? $("#footer").outerHeight(true) : (d <= $("#footer").outerHeight(true) ? $("#footer").outerHeight(true) - d : 0);
        $("#navigation ul").css("bottom", d + "px");
    }

    (function ($) {
        footerScroll();
        $(window).scroll(function () { footerScroll(); });

        //没有滚动条则固定在底部
        if ($(document.body).outerHeight(true) == $(document).height()) $("#footer").css("position", "fixed");
    })(jQuery);

    $(function () {
        $("[name='yd'].c").click(function (event) {
            //alert("1");
            window.location.href = "/Hotel/Fillorder/<%=hotelid %>?weixinID=<%=weixinID %>&hotelName=<%=Server.UrlEncode(hotel.SubName) %>&roomID=" + $(this).attr("roomID") + "&RatePlanID=" + $(this).attr("RatePlanID") + "&roomName=" + escape($(this).attr("roomName")) + "&RatePlanName=" + escape($(this).attr("RatePlanName")) + "&isHourRoom=" + $(this).attr("isHourRoom") + "&hoteltel=<%=Server.UrlEncode(hotel.SmsMobile) %>&indate=" + $("#CheckInDate").val() + "&outdate=" + $("#CheckOutDate").val() + "&tel=<%=hotel.Tel %>&sumprice=" + $(this).attr("sumprice") + "&userweixinid=<%=userWeiXinID %>"; event.stopPropagation();
        });
    });
</script>
