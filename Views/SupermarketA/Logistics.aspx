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
<%--<link type="text/css" rel="stylesheet" href="../../css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/Restaurant.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/new-style.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/fontSize.css"/>
<!--<link type="text/css" rel="stylesheet" href="../../css/newpay.css">-->
<script type="text/javascript" src="../../Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="../../Scripts/fontSize.js"></script>--%>

    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css"/>
<link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/new-style.css"/>
<link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/fontSize.css"/>
<!--<link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/newpay.css">-->
<script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
    <script src="http://css.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body class="yu-bpad120r o-f-auto">
<article class="full-page">
    <% 
        ViewDataDictionary viewDic = new ViewDataDictionary();
        viewDic.Add("weixinID", ViewData["weixinid"]);
        viewDic.Add("hId", ViewData["hotelId"]);
        viewDic.Add("uwx", ViewData["userweixinid"]); %>
     <%Html.RenderPartial("HeaderA", viewDic); %>
		<section class="show-body">
			<section class="content2">
	<section class="yu-bgw yu-tbpad30r yu-lpad20r yu-bmar20r yu-grid yu-f30r">
		<div class="logistics-pic yu-bor bor yu-rmar10">
			<img src="<%=ViewData["imagePath"] %>" />
			<p><%=ViewData["CommodityCount"]%>个商品</p>
		</div>
		<div class="yu-l60r">
			<p>
				<span class="yu-c99 yu-rmar10">物流公司</span>
				<span><%=ViewData["expressCompany"] %></span>
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
				<div class="yu-overflow yu-bor bbor yu-tpad35r yu-bpad55r yu-rpad20r">
					<p class="yu-f28r yu-bmar10r"><%=express.data[i].context%></p>
					<p class="yu-f22r"><%=express.data[i].time%></p>
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
				<div class="yu-overflow yu-bor bbor yu-tpad35r yu-bpad55r yu-rpad20r">
					<p class="yu-f28r yu-bmar10r">
                    <%=express.data[i].context%>
					</p>
					<p class="yu-f22r"><%=express.data[i].time%></p>
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
				<div class="yu-overflow yu-bor bbor yu-tpad35r yu-bpad55r yu-rpad20r">
					<p class="yu-f28r yu-bmar10r">暂无物流信息</p>
					<p class="yu-f22r"></p>
				</div>
			</li>
           <%}
           } %><%--

			<li class="finish">
				<div class="l-pad">
					<p class="border"></p>
					<p class="point"></p>
				</div>
				<div class="yu-overflow yu-bor bbor yu-tpad35r yu-bpad55r yu-rpad20r">
					<p class="yu-f28r yu-bmar10r">[淄博市]山东淄博博山公司的派件已签收，签收人是本人，感谢试用快捷快递，期待再次为您服务</p>
					<p class="yu-f22r">2017-04-10  14：41：29</p>
				</div>
			</li>
			<li>
				<div class="l-pad">
					<p class="border"></p>
					<p class="point"></p>
				</div>
				<div class="yu-overflow yu-bor bbor yu-tpad35r yu-bpad55r yu-rpad20r">
					<p class="yu-f28r yu-bmar10r">[淄博市]山东淄博博山公司派送员：郑成刚
					<span class="yu-fontv yu-blue2">13710145754</span>正在为您派件
					</p>
					<p class="yu-f22r">2017-04-10  14：41：29</p>
				</div>
			</li>
			<li>
				<div class="l-pad">
					<p class="border"></p>
					<p class="point"></p>
				</div>
				<div class="yu-overflow yu-bor bbor yu-tpad35r yu-bpad55r yu-rpad20r">
					<p class="yu-f28r yu-bmar10r">[淄博市]山东淄博博山公司  已发出</p>
					<p class="yu-f22r">2017-04-10  14：41：29</p>
				</div>
			</li>
			<li>
				<div class="l-pad">
					<p class="border"></p>
					<p class="point"></p>
				</div>
				<div class="yu-overflow yu-tpad35r yu-bpad55r yu-rpad20r">
					<p class="yu-f28r yu-bmar10r">包裹正在等待揽收</p>
					<p class="yu-f22r">2017-04-10  14：41：29</p>
				</div>
			</li>--%>
		</ul>
	</section>
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
    <!--end-->
	<!--提示2-->
	<div class="tip-row yu-font16" style="display:none;position:fixed;">亲，距离结束时间3天才可以申请哦</div>
    <!--end-->
	<%--<footer class="fix-bottom yu-bgw yu-grid yu-h90r yu-j-c-r yu-rpad20r">
					<div class="yu-f24r">
						<a href="javascript:;" class="yu-btn6 type1">延长收货</a>
						<a href="#" class="yu-btn6 type2">确认收货</a>
					</div>
	</footer>--%>
    <% if (ViewData["OrderStatus"].ToString() != "4" && ViewData["OrderStatus"].ToString() != "5" && ViewData["OrderStatus"].ToString() != "6")
       { %>
	<footer class="fix-bottom yu-bgw yu-grid yu-h90r yu-j-c-r yu-rpad20r">
    <div class="yu-f24r">
		<% if (bool.Parse(ViewData["isShowAllowDelayed"].ToString()))
     { %>
						<a href="javascript:;" class="yu-btn6 type1 lengthen-btn">延长收货</a>
        <%}
     else
     { %>
						<a href="javascript:;" class="yu-btn6 type1">确定延长收货</a>
        <%} %>
        <a href="#" class="yu-btn6 type2" onclick="FinishOrder()">确认收货</a></div>
	</footer>
    <%} %>
    </section>
    
        <!--弹窗-->
     <%Html.RenderPartial("AlertMessage", viewDic); %>
    </article>
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
        });
    });
    
    function DelayedOrder() {
        $(".lengthen-mask").hide();

        if('<%=ViewData["isAllowDelayed"].ToString().ToLower() %>' == 'false'){
//            $(".tip-row").fadeIn(1500);
//            setTimeout(function(){$(".tip-row").fadeOut(1800);},3000);
$("#tishi_msg").html("亲，距离结束时间3天才可以申请哦");
                    $(".alert").fadeIn();
            return;
        }

            $.post('/Supermarket/DelayedOrder?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=<%=ViewData["orderId"] %>', function (data) {

                if (data.error == 0) {
                $("#tishi_msg").html(data.message);
                    $(".alert").fadeIn();
//                    layer.msg(data.message);
                    return false;
                }
                $("#tishi_msg").html("延迟收货成功");
                    $(".alert").fadeIn();
                    setTimeout(function(){location.reload();},2000);
//                layer.msg("延迟收货成功");
//            location.reload();
            });
    }

    function FinishOrder() {
        $.post('/Supermarket/FinishOrder?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=<%=ViewData["orderId"] %>', function (data) {

            if (data.error == 0) {
                $("#tishi_msg").html(data.message);
                    $(".alert").fadeIn();
//                layer.msg(data.message);
                return false;
            }

            window.location.href = "/SupermarketA/OrderDetails2/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=<%=ViewData["orderId"] %>";
        });
    }
</script>
</body>
</html>