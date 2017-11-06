<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
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
<title>订单详情</title>
<link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css"/>
<script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script src="http://css.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body class="yu-bpad60">
	<section class="yu-bgw yu-pad10 yu-bmar10 yu-grid ">
		<div class="logistics-pic yu-bor bor yu-rmar10">
			<img src="<%=ViewData["imagePath"] %>" />
			<p><%=ViewData["CommodityCount"]%>个商品</p>
		</div>
		<div class="yu-line30 yu-tpad10">
			<p>
				<span class="yu-c99 yu-rmar10">物流公司</span>
				<span><%--圆通快递--%><%=ViewData["expressCompany"] %></span>
			</p>
			<p>
				<span class="yu-c99 yu-rmar10">快递单号</span>
				<span class="yu-fontv"><%=ViewData["expressOrder"]%></span>
			</p>
		</div>
	</section>
	<section class="yu-bgw">
		<ul class="logistics-details yu-bor tbbor">
        <% hotel3g.Controllers.Express express = (hotel3g.Controllers.Express)ViewData["express"];
           if (express.nu != null)
           {
               if (express.data.Count > 0)
               {
                   for (int i = 0; i < express.data.Count; i++)
                   { %>

           <%if (i == 0)
             { %>
           <li class="finish">
				<div class="l-pad">
					<p class="border"></p>
					<p class="point"></p>
				</div>
				<div class="yu-overflow yu-bor bbor yu-tbpad20 yu-rpad10">
					<p class="yu-font16 yu-bmar5"><%=express.data[i].context%></p>
					<p class="yu-font12"><%=express.data[i].time%></p>
				</div>
			</li>
           <%}
             else
             { %>
			<li>
				<div class="l-pad">
					<p class="border"></p>
					<p class="point"></p>
				</div>
				<div class="yu-overflow yu-bor bbor yu-tbpad20 yu-rpad10">
					<p class="yu-font16 yu-bmar5"><%=express.data[i].context%></p>
					<p class="yu-font12"><%=express.data[i].time%></p>
				</div>
			</li>
           <%}
                   }
               }
               else
               { %>
           
           <li>
				<div class="l-pad">
					<p class="border"></p>
					<p class="point"></p>
				</div>
				<div class="yu-overflow yu-bor bbor yu-tbpad20 yu-rpad10">
					<p class="yu-font16 yu-bmar5">暂无物流信息</p>
					<p class="yu-font12"></p>
				</div>
			</li>
           <%}
           } %>
		</ul>
	</section>
    <!--提示-->
    <section class="mask lengthen-mask" >
			<div class="yu-bgw pay-cancel-tip">
				<p class="yu-font18 yu-bmar10">确认延长收货时间？</p>
				<p class="yu-font16 yu-bmar20">每笔订单只能延迟一次哦</p>
				<div class="yu-grid yu-bor tbor yu-h50 yu-line50 yu-font16">
					<p class="yu-overflow yu-bor rbor yu-greys cancel" >
						取消
					</p>
					<p class="yu-overflow yu-blue " onclick="DelayedOrder()">
						确定
					</p>
				</div>
		</div>
	</section>
	<!--提示2-->
	<div class="tip-row" style="display:none;position:fixed;">亲，距离结束时间3天才可以申请哦</div>
    <!--end-->
    <% if (ViewData["OrderStatus"].ToString() != "4" && ViewData["OrderStatus"].ToString() != "5" && ViewData["OrderStatus"].ToString() != "6")
       { %>
	<footer class="fix-bottom yu-pad10 yu-bgw yu-grid">
		<% if (bool.Parse(ViewData["isShowAllowDelayed"].ToString()))
     { %>
		<div class="yu-overflow2 yu-bor1 bor bottom-btn1 type2 yu-c40 lengthen-btn">延长收货</div>
        <%}
     else
     { %>
		<div class="yu-overflow yu-bor1 bor bottom-btn1 type3 yu-c99 yu-rmar10">确定延长收货</div>
		<%--<div class="yu-overflow2 yu-bor1 bor bottom-btn1 type2 yu-c40">已延长收货</div>--%>
        <%} %>
		<div class="yu-overflow2 yu-bor1 bor bottom-btn1 type2 yu-blue2 sp" onclick="FinishOrder()">确定收货</div>
	</footer>
    <%} %>
<script>
    $(function () {
        //mask操作
        $(".mask").on("click", function () {
            $(this).fadeOut();
        })
        $(".pay-cancel-tip").on("click", function (e) {
            e.stopPropagation();
        })
        $(".lengthen-btn").click(function () {
            $(".lengthen-mask").show();
        })
        $(".lengthen-mask .cancel").click(function () {
            $(".lengthen-mask").hide();
        })
    })

    function DelayedOrder() {
        $(".lengthen-mask").hide();

        if('<%=ViewData["isAllowDelayed"].ToString().ToLower() %>' == 'false'){
            $(".tip-row").fadeIn(1500);
            setTimeout(function(){$(".tip-row").fadeOut(1800);},3000);
            return;
        }

            $.post('/Supermarket/DelayedOrder?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=<%=ViewData["orderId"] %>', function (data) {

                if (data.error == 0) {
                    layer.msg(data.message);
                    return false;
                }
                layer.msg("延迟收货成功");
            location.reload();
            });
    }

    function FinishOrder() {
        $.post('/Supermarket/FinishOrder?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=<%=ViewData["orderId"] %>', function (data) {

            if (data.error == 0) {
                layer.msg(data.message);
                return false;
            }

            window.location.href = "/Supermarket/OrderDetails2/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=<%=ViewData["orderId"] %>";
        });
    }
</script>
</body>
</html>