<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<% 
    hotel3g.Models.HotelNews info = ViewData["HotelNewsinfo"] as hotel3g.Models.HotelNews;
    string hotelid = RouteData.Values["id"].ToString();

    var hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
    int nid = Convert.ToInt32(ViewData["HotelNewsID"]);
    int preid = Convert.ToInt32(ViewData["preid"]);
    int nextid = Convert.ToInt32(ViewData["nextid"]);

    string weixinID = string.Empty;
    if (!string.IsNullOrEmpty(hotel.WeiXinID))
    {
        weixinID = hotel.WeiXinID;
    }
    else
    {
        weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
        if (weixinID.Equals(""))
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            weixinID = key.Split('@')[0];
        }
    }
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotel.ID);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);
    ViewDataDictionary jshare = new ViewDataDictionary();
    jshare.Add("sharemsg", true);
    ViewData["title"] = info.Title;

    string openid = ViewData["userWeiXinID"].ToString();
    //分享用户
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    ViewData["NewTitle"] = info.Title;
    ViewData["NewDesn"] = hotel.SubName;
%>
<head runat="server">
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
    <title>
        <%=ViewData["title"] %></title>
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <link href="http://css.weikeniu.com/css/booklist/new-style.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <script src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <style>
        #r-result
        {
            width: 100%;
        }
        .96wx-bgc img
        {
            max-width: 100%;
        }
    </style>
    <%--    <link href="http://css.weikeniu.com/Content/default.css" rel="stylesheet" type="text/css" />--%>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/fontSize.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
</head>
<body>
    <article class="full-page">

     <%
         //微信分享
         string newkey = string.Format("{0}@{1}", weixinID, openid);
         //分享用户
         if (!openid.Contains(wkn_shareopenid))
         {
             //非二次分享 获取推广员信息
             var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(weixinID, openid);
             ///原链接已经是分享过的链接
             newkey = string.Format("{0}@{1}_{2}", weixinID, wkn_shareopenid, CurUser.memberid);
         }

         string desn = ViewData["NewDesn"].ToString();
         string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}&nid={2}", Request.Url.LocalPath, newkey, Request.QueryString["nid"]);
         hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
         {
             title = ViewData["NewTitle"].ToString(),
             desn = desn,
             logo = hotel.HotelLog,
             debug = false,
             userweixinid = openid,
             weixinid = weixinID,
             hotelid = hotel.ID,
             sharelink = sharelink
         };
         viewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
    %>

    <%Html.RenderPartial("HeaderA", viewDic);%>

		<section class="show-body">
			<section class="content2">
				<div class="yu-bgw yu-lrpad30r yu-tbpad50r">
					<hgroup class="yu-bmar65r">
						<h1 class="yu-f48r yu-fontn"><%=info.Title %></h1>
						<h2 class="yu-fontn yu-f32r">
							<span class="yu-c88 yu-f30r yu-rmar40r"><%=info.AddTime %></span>

                            <%if (!openid.Contains(wkn_shareopenid))
                              {%>
                              							<a href="/HomeA/Main/<%=hotel.ID %>?key=<%=weixinID %>@<%=ViewData["userWeiXinID"] %>" class="yu-f32r yu-c57"><%=hotel.SubName %></a><%
                                                                                                                                                                                                 }
                              else
                              { %>
                              	<a href="#" class="yu-f32r yu-c57"><%=hotel.SubName %></a>
                              <%} %>
						
						</h2>
					</hgroup>
					<div class="full-img yu-bmar60r">
                    <% if (!string.IsNullOrEmpty(info.CoverImage))
                       { %>
						<img src="<%=info.CoverImage %>" style="width:100%;"  />    <%} %>
					</div>
					<div class="yu-f30r text-block yu-l50r">
						<%=info.Content%>
					</div>
				</div>
				
			</section>
		</section>
		
	</article>
</body>
</html>
