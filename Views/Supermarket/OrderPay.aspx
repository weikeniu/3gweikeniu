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
    <title>支付</title>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script src="http://css.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>
    <section class="yu-grid yu-alignc time-bar">
		<p class="time-ico" id="statusIco"></p>
		<div class="yu-white">
    <%  int OrderStatus = Convert.ToInt32(ViewData["OrderStatus"]); %>
        <% if (OrderStatus != Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Cancel))
           { %>
			<p class="yu-font30"><%--25:05--%></p>
			<p class="yu-font14"><%--支付剩余时间--%></p>
            <%}
           else
           { %>
			<p class="yu-font30">订单取消</p>
			<p class="yu-font14">欢迎您重新下订</p>
            <%} %>
		</div>
	</section>
    <section class="yu-h60 yu-bgw yu-line60 yu-bmar10">
		<a href="/Supermarket/OrderDetails2/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=<%=ViewData["orderId"] %>" class="yu-grid yu-arr yu-lrpad10">
			<p class="yu-orange yu-rmar10">
				<i>在线支付￥</i>
				<i class="yu-font20"><%=string.Format("{0:F2}", float.Parse(ViewData["Money"].ToString()))%></i>
			</p>
			<p class="yu-grey yu-overflow"><%=ViewData["PayStatus"]%></p>
			<p class="yu-font12 yu-grey yu-rpad10">订单详情</p>
		</a>
		
	</section>
    <section class="yu-bgw yu-lpad10 yu-bmar10">
		<div class="yu-bor bbor yu-greys yu-h50 yu-line50">
			收件人信息
		</div>
		<div class="yu-tbpad10 yu-font14">
			<div class="yu-grid yu-tbpad10">
				<p class="yu-rmar10"><%=ViewData["Linkman"]%></p>
				<p class="yu-grey"><%=ViewData["LinkPhone"]%></p>
			</div>
			<div class="yu-grid yu-tbpad10 yu-grey">
				<p class="yu-rmar10"><%=ViewData["Address"]%></p>
				<%--<p>201A房</p>--%>
			</div>
		</div>
	</section>
    <section class="yu-bgw yu-lpad10 yu-font14">
		<div class="yu-h50 yu-line50 yu-bor bbor yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">支付方式</p>
			<p class="yu-grey"><%=ViewData["PayMethod"]%></p>
		</div>
        <%if (ViewData["PayMethod"].ToString() != "积分支付")
          { %>
		<div class="yu-h50 yu-line50 yu-bor bbor yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">订单金额</p>
			<p class="yu-grey">￥<%=string.Format("{0:F2}", float.Parse(ViewData["Money"].ToString()))%></p>
		</div>
        <%} %>
        <%if (ViewData["PayMethod"].ToString() == "积分支付")
          { %>
		<div class="yu-h50 yu-line50 yu-bor bbor yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">所用积分</p>
			<p class="yu-grey"><%=ViewData["PurchasePoints"]%></p>
		</div>
        <%} %>
		<div class="yu-h50 yu-line50 yu-bor bbor yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">订单编号</p>
			<p class="yu-grey"><%=ViewData["orderId"]%></p>
		</div>
		<div class="yu-h50 yu-line50 yu-rpad10 yu-grid">
			<p class="yu-overflow yu-greys">下单时间</p>
			<p class="yu-grey"><%=DateTime.Parse(ViewData["CreateTime"].ToString()).ToString("g")%></p>
		</div>
	</section>
    <% if (ViewData["PayStatus"] == "待支付" && OrderStatus != Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Cancel))
       { %>
    <section class="yu-grid yu-pad10" id="paying_section">
		<div class="pay-btn1 type1 yu-bor1 bor cancel1">取消订单</div>
		<div class="pay-btn1 type2 yu-overflow" onclick="PayMoney()">去支付￥<%=string.Format("{0:F2}", float.Parse(ViewData["Money"].ToString()))%></div>
		
	</section>
    <%} %>
    <% if (ViewData["PayStatus"] == "支付完成" && OrderStatus != Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Cancel))
       { %>
    <section class="yu-grid yu-bgw yu-pad10 content-btn-bar " id="paySuccess_section">
			<a href="tel:<%=ViewData["hotelPhone"] %>" style="display:none;"><span id="call_phone"></span>联系卖家</a>
		<div class="contact-btn yu-overflow" onclick="CallPhone()">
			联系卖家
		</div>
	</section>
    <section class="yu-grid yu-bgw yu-pad10 content-btn-bar ">
		<div class="contact-btn yu-overflow" onclick="javascript:BuyAgain('<%=ViewData["HotelId"] %>','<%=ViewData["weixinid"] %>','<%=ViewData["userweixinid"] %>');">
			<a style="color:White">再来一单</a>
		</div>
	</section>
    <%} %>
    <% if (ViewData["PayStatus"].ToString() == "部分退款" || ViewData["PayStatus"].ToString() == "全额退款" || OrderStatus == Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Cancel))
       { %>
    <%--<footer class="fix-bottom yu-pad10 yu-bgw yu-grid">
         <div class="yu-overflow yu-bor1 bor bottom-btn1 type2" id="div3" onclick="javascript:BuyAgain('<%=ViewData["HotelId"] %>','<%=ViewData["weixinid"] %>','<%=ViewData["userweixinid"] %>');" >
           再来一单</div>
         <div class="yu-btn yu-overflow" id="div4">已取消</div>
	</footer>--%>
    
    <section class="yu-grid yu-bgw yu-pad10 content-btn-bar ">
		<div class="contact-btn yu-overflow" onclick="javascript:BuyAgain('<%=ViewData["HotelId"] %>','<%=ViewData["weixinid"] %>','<%=ViewData["userweixinid"] %>');">
			<a style="color:White">再来一单</a>
		</div>
	</section>
    <%} %>
    <section class="mask pay-cancel-mask">
			<div class="yu-bgw pay-cancel-tip">
				<p class="yu-font18 yu-bmar10">提醒</p>
				<p class="yu-font16 yu-bmar20">您是否确定取消订单</p>
				<div class="yu-grid yu-bor tbor yu-h50 yu-line50 yu-font16">
					<p class="yu-overflow yu-bor rbor yu-greys" onclick="Cancel('客户')">
						是
					</p>
					<p class="yu-overflow yu-blue not-cancel">
						否
					</p>
				</div>
		</div>
	</section>
    <script>
	    $(function () {
            if('<%=ViewData["PayStatus"] %>' == "待支付" && 'True' == '<%=(OrderStatus != Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Cancel)) %>'){
                setInterval(GetRTime,500);
                }
            
            else if('<%=ViewData["PayStatus"] %>' == "支付完成" && '<%=OrderStatus %>' == '<%=Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Finish) %>'){
              $("#statusIco").attr("class", "s-ico");
              $(".yu-font30").text("交易成功");
              $(".yu-white").find(".yu-font14").text("感谢您的购买");
            }
            else if('<%=ViewData["PayStatus"] %>' == "支付完成"){
              $("#statusIco").attr("class", "s-ico");
              $(".yu-font30").text("支付成功");
              $(".yu-white").find(".yu-font14").text("感谢您的购买");
            }

            else if('<%=ViewData["PayStatus"] %>' == "部分退款" || '<%=ViewData["PayStatus"] %>' == "全额退款"){
              $("#statusIco").attr("class", "f-ico");
              $(".yu-font30").text("订单已<%=ViewData["PayStatus"] %>");
              $(".yu-white").find(".yu-font14").text("感谢您的购买");
            }
            
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
	    });

        //支付倒计时
        function GetRTime(){
            var orderTime = "<%=ViewData["CreateTime"].ToString() %>";

            var EndTime= new Date(orderTime);
            EndTime.setMinutes(EndTime.getMinutes() + 30, EndTime.getSeconds(), 0);
            var NowTime = new Date();
            var t =(EndTime.getTime() - NowTime.getTime()) /1000;
            var d=0;
            var h=0;
            var m=0;
            var s=0;
            if(t>=0){
              d=Math.floor(t/60/60/24);
              h=Math.floor(t/60/60%24);
              m=Math.floor(t/60%60);
              s=Math.floor(t%60);

              if(s < 10)
              s= "0" + s;
              if(m<10)
              m = "0" + m;

              $("#statusIco").attr("class", "time-ico");
              $(".yu-font30").text(m+":"+s);
              $(".yu-white").find(".yu-font14").text("支付剩余时间");
            }else{
            Cancel("系统");
              $("#statusIco").attr("class", "f-ico");
              $(".yu-font30").text("订单支付失败");
              $(".yu-white").find(".yu-font14").text("欢迎您重新下订");
            }
        }

        function PayMoney(){
        window.location.href = "/Recharge/CardPay/<%=ViewData["HotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderNo=" + '<%=ViewData["orderId"] %> ';
        }
        
        function Cancel(str){
            $.post('/Supermarket/CancelOrder?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=<%=ViewData["orderId"] %>&createUser='+str, function (data) {

                if (data.error == 0) {
                    layer.msg(data.message);
                    return false;
                }
                
            location.reload();
            });
        }
        
    function BuyAgain(hId,key,storeId)
    {
      window.location.href = "/Supermarket/Index/"+hId+"?key=" + key + "@" + storeId;
    }
    
    function CallPhone(){
    $("#call_phone").click();
    }
    </script>
</body>
</html>
