<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% var producdtList = ViewData["products"] as List<WeiXin.Common.ProductEntity>;
   int page = Convert.ToInt32(ViewData["page"]);
   int pagesum = Convert.ToInt32(ViewData["pagesum"]);

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
    <title>特惠优选</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css?v=1.1" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css?v=1.0" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/patch.css" />
</head>
<body>
    <article class="full-page">

 
            		<section class="show-body">
			
			<section class="content2">
				
                <%
                    string title = null, desn = null, logo=null;
                     %>
                <% if (producdtList.Count > 0)
                   { %>
				<ul class="booking-list">
                     <% foreach (var item in producdtList)
                        {
                            if (string.IsNullOrEmpty(title))
                            {
                                title = item.ProductName;
                                desn = item.EndTime + " 结束";
                                logo = item.MainPic;
                                
                              
                            }
                              %>
                    
								<li>
                              <a href="/Product/ProductDetail/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>&ProductId=<%=item.Id %>">
									<div class="show-header">
										<div class="inner yu-h360r">
											<img src="<%=  !string.IsNullOrEmpty(item.BigMainPic) ?  item.BigMainPic :item.MainPic %>" />
											
											<div class="txt-bar yu-grid yu-alignc">
												<div class="clock-ico">
													<p></p>
												</div>

                                               <%  if (Convert.ToDateTime(item.BeginTime) <= DateTime.Now)
                                                   {%>
												<p class="yu-overflow yu-f30r"><%=item.EndTime%> 结束</p>

                                                <%} %>

                                                <% else
                                                   { %>
                                                	<p class="yu-overflow yu-f30r"> <%=item.BeginTime%> 开抢</p>
                                                <%} %>
                                          	</div>
										</div>
										<div class="yu-bgw yu-bor bbor th-text-bar">
												<p class="yu-f30r yu-bmar20r yu-black"><%=item.ProductName%></p>
												<div class="yu-grid yu-alignc yu-h65r">


                                                <% if (item.ProductType == "0")
                                                   { %>
													<div class="th-mark type1">   
                                                    限量购													
													</div>
                                                    <%}
                                                   else
                                                   { %>
													<div class="th-mark type1">   
                                                    限时购													
													</div>
                                                    <%} %>

                                                    <p class="yu-overflow yu-f24r yu-c66">
                                                    	<% if (item.ProductType == "0" && item.List_SaleProducts_TC.Min(c => c.ProductNum) < 50)
                                                        { %>
                                                        	剩余<%=item.List_SaleProducts_TC.Min(c => c.ProductNum)%>份
                                                        <%} %>
												</p>
													
                                                    <% double minPrice = 0; %>
                                                    <% if (item.ProductType == "0")
                                                       {
                                                           minPrice = Convert.ToDouble(item.List_SaleProducts_TC.Min(c => c.ProductPrice));
                                                        %>                                   
                                                    <%}
                                                       else
                                                       {
                                                           var t_price = new List<WeiXin.Models.Home.SaleProducts_TC_Price>();
                                                           item.List_SaleProducts_TC.ForEach(r => { t_price.AddRange(r.List_SaleProducts_TC_Price); });
                                                           minPrice = Convert.ToDouble(t_price.Min(c => c.Price));
                                                              %>
                                                    <%} %>

                                                        <p class="yu-f26r yu-linethrough yu-rmar10r  yu-c66">￥<%= item.MenPrice%></p>
                                                        <div class="yu-btn4">￥<%=minPrice%></div>

												</div>
											</div>
									</div>

                                    </a>
								</li>


                                <%} %>


  
							</ul>
             <%}
                   else
                   {%>
                          <section class="yu-tpad120r">
	<div class="no-r-ico"></div>
	<p class="yu-c77 yu-f28r  yu-textc ">暂无特惠记录</p>
</section>


             <%} %>

			</section>
		</section>

      
        </article>
    <%

        //微信分享
        string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
        string openid = userWeiXinID;
        string hotelWeixinid = weixinID;
        string newkey = string.Format("{0}@{1}", hotelWeixinid, openid);

        if (!openid.Contains(wkn_shareopenid))
        {
            //非二次分享 获取推广员信息
            var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(hotelWeixinid, openid);
            ///原链接已经是分享过的链接
            newkey = string.Format("{0}@{1}_{2}", hotelWeixinid, wkn_shareopenid, CurUser.memberid);
        }

        string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}", Request.Url.LocalPath, newkey);
        hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
        {
            title = title+"(分享)",
            desn = desn,
            logo = logo,
            debug = false,
            userweixinid = openid,
            weixinid = hotelWeixinid,
            hotelid = int.Parse(hotelid),
            sharelink = sharelink
        };
        viewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
    %>
    <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
