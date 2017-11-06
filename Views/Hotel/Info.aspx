<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%   
    hotel3g.Models.Hotel hotel = ViewData["hotel"] as hotel3g.Models.Hotel;

    IList<WeiXin.Models.Img> mlist = ViewData["image"] as IList<WeiXin.Models.Img>;

    string skipPic = "../../images/hotelDefaultPic.png";

    if (mlist != null && mlist.Count > 0)
    {
        skipPic = !string.IsNullOrEmpty(mlist[0].BigUrl) ? mlist[0].BigUrl : mlist[0].Url;
    }

    string weixinID = string.Empty;
    if (hotel != null && !string.IsNullOrEmpty(hotel.WeiXinID))
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
    string userweixinid = ViewData["userWeiXinID"] as string;

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotel.ID);
    viewDic.Add("uwx", userweixinid);   
    
    
    
%>
<head>
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"
        name="viewport">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <!-- Mobile Devices Support @begin -->
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
    <meta content="no-cache,must-revalidate" http-equiv="Cache-Control">
    <meta content="no-cache" http-equiv="pragma">
    <meta content="0" http-equiv="expires">
    <meta content="telephone=no, address=no" name="format-detection">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!-- apple devices fullscreen -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>
        <%=hotel.SubName %>简介</title>
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <script src="http://js.weikeniu.com/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
</head>
<body>
    <section class="jdjj-head">
	<img src="<%=skipPic %>" />
	<div class="yu-grid shadow">
		<div class="jd-hendimg">
	 	<img src="<%=hotel.HotelLog %>" />
		</div>
		<div class="yu-overflow">
       	<h3>  <%=hotel.SubName %></h3>
			<p class="yu-lgrey yu-font12">开业时间：<%=hotel.openDate %></p>
			<p class="yu-lgrey yu-font12">最近装修：<%=hotel.xiuDate %></p>    
            	<a href="tel:<%=hotel.Tel%>" class="yu-lgrey yu-font12">电话：<%=hotel.Tel%></a>

		</div>
	</div>
</section>
    <section class="yu-bgw yu-pad10 yu-arr yu-bmar10">
	<a href="/Hotel/Map/<%=hotel.ID %>?key=<%=weixinID %>@<%=userweixinid %>" class="yu-grid yu-alignc ">
		<p class="yu-overflow yu-grey yu-rmar20"> <%=hotel.Address %></p>
		<p class="yu-blue yu-rpad10">地图</p>
	</a>
	
</section>
    <section class="jdjj-content">
	<h3>酒店简介</h3>
	<div class="yu-greys yu-font14 yu-bmar10" style="text-indent:2em; line-height:22px;" ><%=hotel.Content.Replace("\n","<br />") %></div>
	<div class="jdjjpic">
    
     <%
              
         if (mlist != null)
         {
             foreach (WeiXin.Models.Img g in mlist)
             { %>
            <img src="<%=!string.IsNullOrEmpty(g.BigUrl) ?  g.BigUrl :g.Url %>" />

           
            <%}
         }
            %>
    
    </div>
</section>
    <section class="yu-bgw yu-pad10 yu-arr yu-bmar10">
    	<a href="/Hotel/Images/<%=hotel.ID %>?key=<%=weixinID %>@<%=userweixinid %>" class="yu-grid yu-alignc ">
		<span class="morepicico"></span>
		<p class="yu-overflow yu-black">更多酒店图片</p>
	</a>
	
</section>
    <%    
        Html.RenderPartial("Footer", viewDic); 
    %>
</body>
</html>
<script type="text/javascript">
    $(function () {
        $('#openmap').on('click', function () {
            location.href = "/Hotel/Map/<%=hotel.ID %>?key=<%=weixinID %>@<%=userweixinid %>";
        });
    });
</script>
