<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
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
    <title>酒店分店</title>
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css" rel="stylesheet" type="text/css" />
</head>

    <%   
    List<hotel3g.Common.Branch.HotelResponse> BranchHotel = ViewData["BranchHotel"] as List<hotel3g.Common.Branch.HotelResponse>;
    %>
<body>
       <section class="base-page yu-bgw">
    	<ul>
        <% for (int i = 0; i < BranchHotel.Count; i++) { 
               hotel3g.Common.Branch.HotelResponse Item=BranchHotel[i];
               %>
        <li>
    			<a class="yu-grid yu-pad20" hid="<%=Item.id %>" url="<%=ViewData["fromurl"] %>/<%=Item.id %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>" href="javascript:void(0);">
    				<div class="img-box">
    					<img src="<%=string.IsNullOrEmpty(Item.hotelLog)?Item.small_url:Item.hotelLog %>" />
                        
    				</div>
       
    				<div class="yu-overflow">
    					<p class="yu-greys yu-font20 yu-bmar10"><%=Item.SubName %></p>
    					<p class="yu-font12 yu-greys">
    						<%=Item.address %>
    					</p>
    				</div>
    				<div class="yu-textr">
    					<p class="yu-orange">
    						<i class="yu-font12">￥</i>
    						<i class="yu-font20"><%=Item.minprice>0?Item.minprice.ToString():"--" %></i>
    					</p>
    					<p class="yu-grey yu-font14">起</p>
    				</div>
    			</a>
    		</li>
        <%} %>
    	</ul>
    </section>
</body>
</html>
<script src="http://js.weikeniu.com/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
<script>
    $(function () {
        $("ul li a").click(function () {
            var url = $(this).attr("url");
            var hid = $(this).attr("hid");
            var weixinid = '<%=ViewData["weixinid"] %>';
            var prem = { hid: hid, weixinid: weixinid };
            var url = "/BranchA/CurHotel/";

            var fromurl = $(this).attr("url");
            $.post(url, prem, null);
            window.location.href = fromurl;
        });
    })
</script>
