<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    var cardList = ViewData["list"] as List<hotel3g.Models.Home.MemberCardCustom>;
    cardList = cardList.Where(c => c.IncreaseType == 1 || c.IncreaseType == 2).OrderByDescending(c => c.CardLevel).ToList();

    string hotelName = ViewData["hotelName"] == null ? string.Empty : ViewData["hotelName"].ToString();
    string cardPic = ViewData["cardPic"] == null ? string.Empty : ViewData["cardPic"].ToString();
    string cardLogo = ViewData["cardLogo"] == null ? string.Empty : ViewData["cardLogo"].ToString();

    cardPic = cardPic.Replace("html/images", "images/cards");

    int maxCardLevel = Convert.ToInt32(ViewData["maxCardLevel"]);


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
    <title>会员卡售卖</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
</head>
<body>
    <article class="full-page">
   	
		 	<section class="show-body">
			<section class="content2">
				
				<div class="pg__ucenter">
					<!--//广告图-->
					<p><img class="max__img" src="../../images/ad-img002.jpg" /></p>
			 
					<!--//会员卡售卖(列表)-->
					<div class="uc__memberCard-sale">
						<ul class="clearfix">

                        <%foreach (var item in cardList)
                          { %>
                          	<li>
								<div class="card-cnt">

                               <% if (!string.IsNullOrEmpty(cardPic))
                                  { %>
                          
									<img class="card-img" src="<%=cardPic%>" />
                                    <%} %>


									<div class="hd">
                                    <% if (!string.IsNullOrEmpty(cardLogo))
                                       { %>
										<img class="logo fl" src="<%=cardLogo %>" />
                                        <%} %>
										<div class="name">
											<h2><%=hotelName%></h2>
											<p><%=item.CardName %></p>
										</div>
										<label class="type">终身卡</label>
									</div>
									<div class="ct">
										<div class="inner clearfix">

                                        <%if (item.CouponType == 0)
                                          { %>
											<div class="discount fl"><em><%=Convert.ToDouble( item.Discount) %></em> 折</div>
                                            	<div class="tips fl">
												<p>开卡即享预订酒店折扣</p>
												<p>超值会员价</p>
											</div>
                                               
                                            <%}
                                          else
                                          { %>                                
                                           <div class="discount fl">立减 <em><%=Convert.ToDouble(item.Reduce )%></em> 元</div>     

                                           <div class="tips fl">
												<p>开卡即享预订酒店现金立减</p>
												<p>超值会员价</p>
											</div>
                                           <%} %>
                                           
											
										</div>
									</div>

                                     
									<div class="ft">
										<p>有效期：长期有效</p>
									</div>
								</div>

                                <%if (item.CardLevel > maxCardLevel)
                                  { %>
								<div class="card-btn clearfix">
									<em class="price fl">￥<%=Convert.ToDouble(item.BuyMoney)%></em>
									<a class="btn-buy fr  style2" href="/MemberCard/CardBuy/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>&CardId=<%=item.Id %>">购买</a>
								</div>
                                <%} %>
							</li>

                              
                        <%   } %>
						
					 
						</ul>
					</div>
				</div>
			</section>
		</section>
        </article>
    <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
