<!DOCTYPE html >
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
    <title>订餐支付</title>
    <link type="text/css" rel="stylesheet" href="../../css/booklist/sale-date.css"/>
    <link type="text/css" rel="stylesheet" href="../../css/booklist/Restaurant.css"/>
    <script type="text/javascript" src="../../Scripts/jquery-1.8.0.min.js"></script>
</head>
<body>
	<section class="yu-arr yu-bgw yu-bmar10">
		<a class="yu-grid yu-alignc yu-pad20" href="javascript:;">
			<p class="gps-ico"></p>
			<div>
				<p class="yu-black yu-bmar5">
					<span>李清秋</span>
					<span>135787454</span>
				</p>
				<p class="yu-grey yu-font12">
					<span>广州桃花江豪生酒店</span>
					<span>201A房</span>
				</p>
			</div>
		</a>
		<div class="colorBorder"></div>
	</section>
	<section class="yu-bgw yu-bmar10">
		<div class="yu-h50 yu-lrpad10 yu-grey yu-line50 yu-bor bbor">
			<%=ViewData["storeName"]%>
		</div>
		<div class="yu-pad20 yu-bglgrey yu-bor bbor">
			<ul>
				<%--<li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p>干炒牛河</p>
							<div class="la-lv type0"></div>
						</div>
					</div>
					<p class="yu-grey yu-rmar20">X2</p>
					<p>￥31</p>
				</li>
				<li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p>干炒牛河</p>
							<div class="la-lv type1"></div>
						</div>
					</div>
					<p class="yu-grey yu-rmar20">X2</p>
					<p>￥31</p>
				</li>--%>
				<%
                    System.Data.DataTable dt_dish = (System.Data.DataTable)ViewData["dt_dish"];
                    foreach (System.Data.DataRow row in dt_dish.Rows) 
                    {
                      %>
                      <li class="yu-grid yu-alignc yu-bmar10">
					        <div class="yu-overflow">
						        <div class="yu-grid yu-alignc">
							        <p><%=row["dishesName"]%></p>
							        <%--<div class="la-lv type2"></div>--%>
						        </div>
					        </div>
					        <p class="yu-grey yu-rmar20">X<%=row["number"]%></p>
					        <p>￥<%=row["price"]%></p>
				        </li>
                      <%
                    }
				  %>
			</ul>
		</div>
		<%--<div class="yu-bor bbor yu-arr yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<p class="yu-black yu-rmar20">红包</p>
				<div class="yu-tpad10 yu-overflow">
					<p class="yu-orange yu-font16">￥5</p>
					<p class="yu-grey yu-font12">已从订单金额中扣减</p>
				</div>
		</div>--%>
		<div class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<p class="yu-black yu-rmar20">订单</p>
				<div class="yu-tpad10 yu-overflow">
					<p class="yu-orange yu-font16">￥<%=ViewData["price"]%></p>
                    <%if (Convert.ToDecimal(ViewData["DelMoney"]) != 0)
                      { 
                      %>
                      <p class="yu-grey yu-font12">已优惠<%=ViewData["DelMoney"]%>元<%--可获<span class="yu-blue">168</span>积分--%></p>
                      <%
                      } %>
					
				</div>
		</div>
	</section>
	
	<section class="yu-bgw yu-bmar10">
		<div class="yu-bor bbor yu-arr yu-h60 yu-grid yu-lrpad10 yu-alignc">
			<p class="yu-black yu-overflow">用餐人数</p>
			<p class="yu-grey yu-font12 yu-rpad20">便于商家带够餐具</p>
		</div>
		<div class="yu-bor bbor yu-arr yu-h60 yu-grid yu-lrpad10 yu-alignc">
			<p class="yu-black yu-overflow">订单备注</p>
			<p class="yu-grey yu-font12 yu-rpad20">口味、偏好等</p>
		</div>
	</section>
	
	<section class="mask bottomMask"></section>
	<footer class="yu-grid fix-bottom yu-bor tbor yu-lpad10 touch_action">
	<div class="food-details up-slide-ani">
		<dl>
			<dt class="yu-grid yu-bor bbor yu-h40 yu-alignc yu-lrpad10">
				<span class="ico type1"></span>
				<p class="yu-rmar10">201A</p>
				<p class="yu-font12 yu-lgrey yu-overflow">餐饮将送到此房间</p>
				<div class="yu-grid yu-alignc yu-greys clearall">
					<span class="ico type3"></span>
					清空
				</div>
			</dt>
			<dd>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc yu-lrpad10">
					<p class="yu-overflow">干炒牛河</p>
					<p class="yu-orange yu-rmar20"><i class="yu-font12">￥</i><i class="yu-font20">23</i></p>
					<div class="ar yu-grid">
												<p class="reduce ico"></p>
												<p class="food-num"></p>
												<p class="add ico"></p>
											</div>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc yu-lrpad10">
					<p class="yu-overflow">干炒牛河</p>
					<p class="yu-orange yu-rmar20"><i class="yu-font12">￥</i><i class="yu-font20">23</i></p>
					<div class="ar yu-grid">
												<p class="reduce ico"></p>
												<p class="food-num"></p>
												<p class="add ico"></p>
											</div>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc yu-lrpad10">
					<p class="yu-overflow">干炒牛河</p>
					<p class="yu-orange yu-rmar20"><i class="yu-font12">￥</i><i class="yu-font20">23</i></p>
					<div class="ar yu-grid">
												<p class="reduce ico"></p>
												<p class="food-num"></p>
												<p class="add ico"></p>
											</div>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc yu-lrpad10">
					<p class="yu-overflow">干炒牛河</p>
					<p class="yu-orange yu-rmar20"><i class="yu-font12">￥</i><i class="yu-font10">23</i></p>
					<div class="ar yu-grid">
												<p class="reduce ico"></p>
												<p class="food-num"></p>
												<p class="add ico"></p>
											</div>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc yu-lrpad10">
					<p class="yu-overflow">干炒牛河</p>
					<p class="yu-orange yu-rmar20"><i class="yu-font12">￥</i><i class="yu-font20">23</i></p>
					<div class="ar yu-grid">
												<p class="reduce ico"></p>
												<p class="food-num"></p>
												<p class="add ico"></p>
											</div>
				</div>
			</dd>
		</dl>
		<dl>
			<dt class="yu-grid yu-bor bbor yu-h40 yu-alignc yu-lrpad10">
				<span class="ico type2"></span>
				<p class="yu-overflow">201B</p>
				<i class="ico type4"></i>
				<p class="yu-font12 yu-lgrey">若需要分装长按商品拖入此房间</p>
			</dt>
		</dl>
		<div class="yu-grid yu-alignc yu-h50 yu-lrpad10">
			<p>包装费</p>
			<div class="yu-overflow yu-orange"><i class="yu-font12">￥</i><i class="yu-font10">2.5</i> </div>
		</div>
	</div>
	<div class="yu-overflow">
		<p class="yu-orange">在线支付￥<%=ViewData["price"]%></p>
		<%if (Convert.ToDecimal(ViewData["DelMoney"]) != 0)
          { 
        %>
        <p class="yu-grey yu-font12">为您优惠<%=ViewData["DelMoney"]%>元</p>
        <%}%>
	</div>
	<div class="yu-greys yu-arr type-up yu-rpad20 yu-rmar10 yu-font14">明细</div>
	<div class="yu-btn">去支付</div>
	
</footer>
<script>
    $(function () {
        //明细
        $(".fix-bottom").click(function () {
            $(".food-details").toggle();
            $(this).find(".yu-arr").toggleClass("type-up").toggleClass("type-down");
            $(".bottomMask").fadeToggle();
        })
        $(".fix-bottom .yu-btn").click(function (e) {
            e.stopPropagation();
        })
        $(".food-details").click(function (e) {
            e.stopPropagation();
        })
        $(".bottomMask").click(function () {
            $(".food-details").toggle();
            $(".fix-bottom").find(".yu-arr").toggleClass("type-up").toggleClass("type-down");
            $(".bottomMask").fadeOut();
        })
        //加减餐
        var foodNum = 0;
        var totalNum = 0;
        //	$(".add").on("click",function(){
        $(".food-list,.food-details").find("dd").on("click", ".add", function () {
            totalNum++;
            $(".yu-btn").text("选好了");
            if ($(this).siblings(".food-num").text() == "") {
                foodNum = 1;
                $(this).siblings(".food-num").text(foodNum);
            } else {
                foodNum = parseInt($(this).siblings(".food-num").text());
                foodNum++;
                $(this).siblings(".food-num").text(foodNum);
            };
            $(this).siblings().fadeIn();
            $(".gwc-ico .num").text(totalNum);
            $(".gwc-ico .num").fadeIn();
        });

        //	$(".reduce").on("click",function(){
        $(".food-list,.food-details").find("dd").on("click", ".reduce", function () {
            foodNum = parseInt($(this).siblings(".food-num").text());
            if (foodNum > 0) {
                totalNum--;
                foodNum--;
                $(this).siblings(".food-num").text(foodNum);
                $(".gwc-ico .num").text(totalNum);
                totalNum == 0 ? $(".yu-btn").text("请选择") : $(".yu-btn").text("选好了");
                if (totalNum == 0) {
                    $(".yu-btn").text("请选择");
                    $(".gwc-ico .num").fadeOut();
                }
                if (foodNum == 0 && $(this).parents("dl").hasClass("food-list")) {
                    $(this).fadeOut().siblings(".food-num").fadeOut();
                }
            };
        });
    })
</script>
</body>
</html>
