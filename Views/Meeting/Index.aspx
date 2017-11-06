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


    var meetingList = ViewData["meetingList"] as List<hotel3g.Models.Home.Meeting>;
    var picList = ViewData["picList"] as List<WeiXin.Common.RoomTypeImgEntity>;
    string strdate = Convert.ToDateTime(ViewData["date"]).ToString("yyyy-MM-dd");


    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();        
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta name="keywords" content="关键词1,关键词2,关键词3" />
    <meta name="description" content="对网站的描述" />
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <title>会议宴会</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>

        <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/patch.css" />
</head>
<body>
    <article class="full-page">
         
     <section class="show-body">			
			<section class="content2">

              <% if (meetingList.Count > 0)
                   { %>
            	<ul class="booking-list">

                <% foreach (var item in meetingList)
                   {
                       string img = "../../images/defaultRoomImg.jpg";
                       var pic = picList.Where(c => c.RoomId == item.Id).FirstOrDefault();
                       if (pic != null)
                       {
                           img = pic.Url;
                           if (!string.IsNullOrEmpty(pic.Big_url))
                           {
                               img = pic.Big_url;
                           }
                       }

                       double price = 0;
                       string time = "am";
                       if (item.PayType == 0)
                       {
                           if (item.AMPrice > 0)
                           {
                               price = item.AMPrice;
                           }
                           else if (item.PMPrice > 0)
                           {
                               price = item.PMPrice;
                               time = "pm";
                           }
                           else if (item.NightPrice > 0)
                           {
                               price = item.NightPrice;
                               time = "nt";
                           }
                           else if (item.DayPrice > 0)
                           {
                               price = item.DayPrice;
                               time = "apm";
                           }
                       }
                       string href = string.Format("/meeting/Detail/{0}?key={1}&meetingId={2}&date={3}&time={4}", hotelid, weixinID + "@" + userWeiXinID, item.Id, strdate,time);                     
                        %>                     
                    
            
								<li onclick="javascript:window.location.href='<%=href %>'" >
									<div class="show-header">
										<div class="inner yu-h360r">
											<img src="<%=img %>" />
											
                                            <% if (item.PayType == 0)
                                               { %>
											<div class="txt-bar yu-grid yu-alignc">
												<p class="yu-overflow yu-f30r"><%=item.Name%></p>
											</div>
                                            <%} %>
										</div>

                                               <% if (item.PayType == 0)
                                                  { %>
										<div class="yu-bgw yu-h50 yu-grid yu-alignc yu-bor bbor yu-lrpad10">
											<p class="yu-overflow yu-f30r">￥<%=price%></p>
											<a href="<%=href %>" class="book-btn2"> 预订</a>
										</div>
                                        <%}
                                                  else
                                                  { %>
                                                  	<a class="yu-bgw yu-h50 yu-grid yu-alignc yu-bor bbor yu-lrpad10 yu-arr" href="<%=href%>">
											<p class="yu-overflow yu-f30r yu-black"><%=item.Name %></p>										
										</a>

                                        <%} %>
									 </div>
								</li>
							       <%  } %>
							</ul>
                            

   <%}
                   else  {%>
                          <section class="yu-tpad120r">
	<div class="no-r-ico"></div>
	<p class="yu-c77 yu-f28r  yu-textc ">暂无会议记录</p>
</section>


             <%} %>


            </section>
            </section>
     </article>

           <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
