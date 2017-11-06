<!DOCTYPE html>
<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

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
    <title>订单备注</title>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css"/>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/Restaurant.css"/>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
     <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/drag.js" type="text/javascript"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/js.js" type="text/javascript"></script>
</head>
<body>
<% 
    bool iszbsj =HotelCloud.Common.HCRequest.GetString("iszbsj").ToLower() == "true";
    %>
	<section class="yu-tpad10">
		<form>
			<div class="yu-bgw yu-pad20">
				<% if (!iszbsj){ %>
                <h3 class="yu-bmar10 yu-fontn">快速备注</h3>
				<div class="select-list yu-bmar10">
					<p class="yu-bor1 bor">不要香菜</p>
					<p class="yu-bor1 bor">不要洋葱</p>	
					<p class="yu-bor1 bor">不要醋</p>	
					<p class="yu-bor1 bor">不要葱</p>	
					<p class="yu-bor1 bor">不要姜</p>	
				</div>
                <%} %>
				<div class="textarea-box">
					<textarea class="textarea-type1 yu-bor bor"  placeholder="请输入备注内容" maxlength="50"><%=ViewData["remo"]%></textarea>
					<p>0/50个字</p>
				</div>
			</div>
			<div class="yu-pad10">
				<input type="button" value="确定" class="blue-sub"/>
			</div>
		</form>
	</section>
       <!--快速导航-->
        <% Html.RenderPartial("QuickNavigation", null); %>
	         
	<script>
	    $(function () {



	        $(".select-list").children("p").on("click", function () {
	            $(this).toggleClass("cur");
	            var append = $(this).text()+" ";
                if($(this).hasClass("cur"))
                {
                    var remo = $('.textarea-type1').val();
	                if (remo.length + append.length <= 50) {
	                    $('.textarea-type1').val(remo + append);
	                }
                }else{
                    var remo = $('.textarea-type1').val();
                    $('.textarea-type1').val(remo.replace(append,""));
                }
	        });

	        $('.blue-sub').on('click', function () {
	            var remo = $('.textarea-type1').val();
	            $.post('/DishOrder/SaveOrderRemo/?orderCode=<%=ViewData["orderCode"] %>&key=<%=ViewData["key"] %>&remo='+remo, function (data) {
                if (data.error == 1) {
                    window.location = "/DishOrder/PagePay/<%=Html.ViewData["hId"] %>?orderCode=<%=ViewData["orderCode"] %>&key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>";
                } else {
                    layer.msg(data.message);
                    return false;
                }
            });
	        });
	    })
	</script>
</body>
</html>
