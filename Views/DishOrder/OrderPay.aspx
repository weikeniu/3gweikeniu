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
    <title>订餐支付</title>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css"/>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/Restaurant.css"/>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
     <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/drag.js" type="text/javascript"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/js.js" type="text/javascript"></script>
</head>
<body>
<% 
    hotel3g.Models.OrderInfo model = (hotel3g.Models.OrderInfo)ViewData["model"];
    int eatatstore = (int)ViewData["eatatstore"];
    int tid = model.tablenumberid; //HotelCloud.Common.HCRequest.getInt("tid");
    ViewData["tid"] = tid;
     %>
<% int TotalSeconds = (int)ViewData["TotalSeconds"];%>
	<section class="yu-grid yu-alignc time-bar">
		<p class="time-ico"></p>
		<div class="yu-white">
			<p class="yu-font30" id="time-bar"><%=ViewData["time"] %></p>
			<p class="yu-font14">支付剩余时间</p>
		</div>
	</section>
	<section class="yu-h60 yu-bgw yu-line60 yu-bmar10">
		<a class="yu-grid yu-arr yu-lrpad10" href="/DishOrder/PagePay/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&IsView=1&tid=<%=tid %>">
			<p class="yu-orange yu-rmar10">
				<i>在线支付￥</i> <%--model.amount - model.youhuiamount + model.bagging - model.CouponMoney-model.manjianmoney--%>
				<i class="yu-font20"><%=model.payamount%></i>
			</p>
			<p class="yu-grey yu-overflow">待支付</p>
			<p class="yu-font12 yu-grey yu-rpad10">订单详细</p>
		</a>
		
	</section>
	<%
        if (model.tablenumberid == Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
        {

            if (eatatstore == Convert.ToInt32(hotel3g.Models.EnumEatAtStore.外卖))
            {
	        %>
	<section class="yu-bgw yu-lpad10 yu-bmar10">
		<div class="yu-bor bbor yu-greys yu-h50 yu-line50">
			收件人信息
		</div>
		<div class="yu-tbpad10 yu-font14">
			<div class="yu-grid yu-tbpad10">
				<p class="yu-rmar10"><%=model.orderLinkMan%></p>
				<p class="yu-grey"><%=model.orderPhone%></p>
			</div>
			<div class="yu-grid yu-tbpad10 yu-grey">
				<p class="yu-rmar10"><%=model.orderAddress%></p>
				<p><%=model.orderRoomNo%></p>
			</div>
		</div>
	</section>
    <% }
            else
            { 
        %>
             <section class="yu-bgw yu-lrpad10 yu-grid yu-alignc yu-h50 yu-bmar10 get-bar">
		        <p class="yu-overflow">桌台号</p>
		        <p class="yu-blue yu-font12"><%=model.tablenumber%></p>
	        </section>
        <% }
        }
        else { 
        %>
         <section class="yu-bgw yu-lrpad10 yu-grid yu-alignc yu-h50 yu-bmar10 get-bar">
		        <p class="yu-overflow">桌台号</p>
		        <p class="yu-blue yu-font12"><%=model.tablenumber%></p>
	        </section>
        
       
       <%
        }
             %>


      <% 
           string ordertips = ViewData["ordertips"] + "";
           if (!string.IsNullOrEmpty(ordertips))
           { %>
	<div class="yu-grid yu-alignc charge-tip yu-lrpad20r yu-f22r yu-c40" style="height:30px">
			<span class="iconfont icon-gonggao y-f22r yu-rmar10r"></span>
			<span>提示：<%=ordertips%><%--如需在酒店大厅或茶皇厅就餐，服务费10%，茶位费另计。--%></span>
		</div>
        <% } %>
	<section class="yu-bgw yu-lpad10 yu-font14">
       
		<div class="yu-h50 yu-line50 yu-bor bbor yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">支付方式</p>
			<p class="yu-grey"><%=model.orderPayType+"" == "" ? "微信支付" : model.orderPayType%></p>
		</div>
		<div class="yu-h50 yu-line50 yu-bor bbor yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">订单金额</p>
			<p class="yu-grey">￥<%=model.payamount %></p>
		</div>
		<div class="yu-h50 yu-line50 yu-bor bbor yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">订单编号</p>
			<p class="yu-grey"><%=model.orderCode%></p>
		</div>
		<div class="yu-h50 yu-line50 yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">下单时间</p>
			<p class="yu-grey"><%=model.submitTime%></p>
		</div>
	</section>
	<section class="yu-grid yu-pad10" id="btn-bar">
		<div class="pay-btn1 type1 yu-bor1 bor cancel1">取消订单</div>
		<div class="pay-btn1 type2 yu-overflow" onclick="javascript:SurePay('<%=model.orderCode %>')">去支付￥<%=model.payamount%></div>
		
	</section>
	<section class="mask pay-cancel-mask" >
			<div class="yu-bgw pay-cancel-tip">
				<p class="yu-font18 yu-bmar10">提醒</p>
				<p class="yu-font16 yu-bmar20">您是否确定取消订单</p>
				<div class="yu-grid yu-bor tbor yu-h50 yu-line50 yu-font16">
					<p class="yu-overflow yu-bor rbor yu-greys" onclick="javascript:CancelOrder()">
						是
					</p>
					<p class="yu-overflow yu-blue not-cancel">
						否
					</p>
				</div>
		</div>
	</section>
      <!--快速导航-->
         <% Html.RenderPartial("QuickNavigation", null); %>
	<script type="text/javascript">
	    $(function () {
	        //
	        $(".cancel1").click(function () {
	            $(".pay-cancel-mask").show();
	        })
	        $(".not-cancel,.mask").on("click", function () {
	            $(".mask").hide();
	        })
	        $(".pay-cancel-tip").click(function (e) {
	            e.stopPropagation();
	        })
	    })
	</script>

    <script type="text/javascript">
         //取消订单
        function CancelOrder() {
            $.post("/DishOrder/CancelOrder/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&orderCode=<%=ViewData["orderCode"] %>&storeId=<%=ViewData["storeId"] %>", 
            function (data) {
              if(data.error==1)//取消成功跳回点餐首页
              { 
                window.location.href= "/DishOrder/DishOrderIndex/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&tid=<%=tid %>";
              }
              $(".mask").hide();
            });
         }
         //确定支付
         function SurePay(orderCode)
         {
            window.location.href = '/Recharge/CardPay/<%=Html.ViewData["hId"]%>?key=<%=Html.ViewData["key"] %>&orderNo=' + orderCode;
         }

         $(function(){
          function SetTime(TotalSeconds) {
         
             if(TotalSeconds>=0){
                var m=parseInt(TotalSeconds/60);
                var s=parseInt(TotalSeconds%60);
                if(m<=9){m='0'+m;}
                if(s<=9){s='0'+s;}
                var time=m+':'+s;
               $('#time-bar').html(time);
               setTimeout(function(){SetTime(TotalSeconds-1)},1000);
               }
               else //订单超时
               {
                    $('#btn-bar').hide();
                    $.post("/DishOrder/SaveOrderOverTime/?orderCode=<%=ViewData["orderCode"] %>",function(data){
                        if(data.error==0)
                        {
                            layer.msg(data.message);
                        }
                        //返回订餐首页
                        //window.location.href="/DishOrder/DishOrderIndex/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>";
                    });
                  
               }
             }
         SetTime(<%=TotalSeconds %>);
         });
       
    </script>
</body>
</html>
