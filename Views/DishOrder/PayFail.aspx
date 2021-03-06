﻿<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

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
    <title>订单支付</title>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css"/>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/Restaurant.css"/>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/drag.js" type="text/javascript"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/js.js" type="text/javascript"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <script type="text/javascript">
        function ViewOrderDetail(storeId, key, orderCode, id, tid) {
            window.location.href = "/DishOrder/ViewOrderDetail/" + id + "?storeId=" + storeId + "&key=" + key + "&orderCode=" + orderCode + '&tid=' + tid;
        }
    </script>
</head>
<body>
<% 
    hotel3g.Models.OrderInfo model = (hotel3g.Models.OrderInfo)ViewData["model"];
    int eatatstore = (int)ViewData["eatatstore"];
    int tid = model.tablenumberid;// HotelCloud.Common.HCRequest.getInt("tid");
    ViewData["tid"] = tid;
     %>
	<section class="yu-grid yu-alignc time-bar">
		<p class="s-ico"></p>
		<div class="yu-white">
			<p class="yu-font30" id="p-pay-time">00:00</p>
			<p class="yu-font14">支付剩余时间</p>
		</div>
	</section>
	<section class="yu-h60 yu-bgw yu-line60 yu-bmar10">
		<a class="yu-grid yu-arr yu-lrpad10" onclick="javascript:ViewOrderDetail('<%=model.storeID %>','<%=ViewData["key"] %>','<%=model.orderCode %>','<%=ViewData["hId"] %>','<%=tid %>')">
			<p class="yu-orange yu-rmar10">
				<i>在线支付￥</i>
				<i class="yu-font20"><%=model.payamount%></i>
			</p>
			<p class="yu-grey yu-overflow"></p>
			<p class="yu-font12 yu-grey yu-rpad10">
            订单详细</p>
		</a>
		
	</section>
    <% 
        if (tid == Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
        {

            if (eatatstore == Convert.ToInt32(hotel3g.Models.EnumEatAtStore.外卖))
            {
         %>
	<section class="yu-bgw yu-lrpad10 yu-grid yu-alignc yu-h50 yu-bmar10 get-bar">
		<p class="get-ico"></p>
		<p class="yu-overflow">送达时间</p>
		<p class="yu-blue yu-font12"><%=ViewData["songdashijian"]%></p>
	</section>
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
    <%}
            else
            { 
        %>
            <section class="yu-bgw yu-lrpad10 yu-grid yu-alignc yu-h50 yu-bmar10 get-bar">
		        <p class="yu-overflow">桌台号</p>
		        <p class="yu-blue yu-font12"><%=model.tablenumber%></p>
	        </section>
        <%
        }
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
	<section class="yu-bgw yu-lpad10 yu-font14 yu-bmar10">
		<div class="yu-h50 yu-line50 yu-bor bbor yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">支付方式</p>
			<p class="yu-grey"><%=string.IsNullOrEmpty(model.orderPayType) ? "在线支付" : model.orderPayType%></p>
		</div>
		<div class="yu-h50 yu-line50 yu-bor bbor yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">订单金额</p>
			<p class="yu-grey">￥<%=model.payamount%></p>
		</div>
        <% if (model.CouponMoney > 0)
           { %>
        <div class="yu-h50 yu-line50 yu-bor bbor yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">红包金额</p>
			<p class="yu-grey">￥<%=model.CouponMoney%></p>
		</div>
        <% } %>
		<div class="yu-h50 yu-line50 yu-bor bbor yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">订单编号</p>
			<p class="yu-grey"><%=model.orderCode %></p>
		</div>
		<div class="yu-h50 yu-line50 yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">下单时间</p>
			<p class="yu-grey"><%=model.submitTime %></p>
		</div>
	</section>
	<!--快速导航-->
    <% Html.RenderPartial("QuickNavigation", null); %>

	<!--下单5分钟内不可催单-->
	<%--<section class="yu-grid yu-bgw yu-pad20 content-btn-bar yu-bmar10">
		<div class="yu-overflow yu-rmar20 yu-bor1 bor">
			<span>催单</span>
			<span class="yu-font12 yu-grey">（剩余时间：5分钟）</span>
		</div>
		<div class="yu-overflow type2 yu-bor1 bor">
			联系送餐
		</div>
	</section>--%>
	
	<!--5分钟后变成这个状态 可催单-->
    <section class="yu-grid yu-bgw yu-pad20 content-btn-bar " style="display:none" id="div-btn-agin">
        <div class="yu-overflow yu-rmar20 yu-bor1 bor"  onclick="javascript:BuyAgain('<%=ViewData["hId"] %>','<%=ViewData["key"] %>','<%=ViewData["storeId"] %>');"> 再来一单</div>
    </section>
	<section class="yu-grid yu-bgw yu-pad20 content-btn-bar " id="div-btn-pay">
       <div class="yu-overflow yu-rmar20 yu-bor1 bor"  onclick="javascript:CancelOrder()">
			<span>取消订单</span>
		</div>
		<div class="yu-overflow"  onclick="javascript:SurePay()">
			去支付
		</div>
	</section>	
</body>
<script>

   //取消订单
        function CancelOrder() {
            layer.confirm('确认取消吗？', { btn: ['确定','取消'] }, 
            function(){
               $.post("/DishOrder/CancelOrder/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&orderCode=<%=ViewData["orderCode"] %>&storeId=<%=ViewData["storeId"] %>", 
                function (data) {
                      window.location.href="/user/myorders/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&tid=<%=tid %>";
                });
            }, 
            function(){
                 $('.layui-layer-dialog').hide();
              });
         } 

         //确定支付
         function SurePay()
         {
             //alert("暂直接跳过支付过程，到支付成功页面");
               $.post("/DishOrder/SendOrderToPay/?orderCode=<%=ViewData["orderCode"] %>&storeId=<%=ViewData["storeId"] %>",
                function(data){
                    if(data.error==1){

                    window.location.href = '/Recharge/CardPay/<%=Html.ViewData["hId"]%>?key=<%=Html.ViewData["key"] %>&orderNo=<%=ViewData["orderCode"]%>' ;

                    }else{
                       layer.msg(data.message);
                    }
                });
         }

        function BuyAgain(hId,key,storeId)
        {
            window.location.href = "/DishOrder/DishOrderIndex/"+hId+"?key=" + key + "&storeId=" + storeId;
        }

</script>

<script>
    $(function () {
        function SetTime(TotalSeconds) {

            if (TotalSeconds >= 0) {
                var m = parseInt(TotalSeconds / 60);
                var s = parseInt(TotalSeconds % 60);
                if (m <= 9) { m = '0' + m; }
                if (s <= 9) { s = '0' + s; }
                var time = m + ':' + s;
                $('#p-pay-time').html(time);
                setTimeout(function () { SetTime(TotalSeconds - 1) }, 1000);
            }
            else //订单超时
            {
                $.post("/DishOrder/SaveOrderOverTime/?orderCode=<%=ViewData["orderCode"] %>",function(data){
                    if(data.error==0)
                    {
                        //alert(data.message);
                    }
                   
                });
                $('#div-btn-pay').hide();
                $('#div-btn-agin').show();
            }
        }
        var tt = '<%=ViewData["TotalSeconds"] %>';
        SetTime(tt);

    });


</script>
</html>
