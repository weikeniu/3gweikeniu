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
    <%--<link type="text/css" rel="stylesheet" href="../../css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="../../css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="../../css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="../../css/booklist/fontSize.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="../../Scripts/fontSize.js"></script>--%>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/fontSize.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
    <script src="http://css.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body class="o-f-auto">
    <article class="full-page">
    <% 
        ViewDataDictionary viewDic = new ViewDataDictionary();
        viewDic.Add("weixinID", ViewData["weixinid"]);
        viewDic.Add("hId", ViewData["hotelId"]);
        viewDic.Add("uwx", ViewData["userweixinid"]); %>
     <%Html.RenderPartial("HeaderA", viewDic); %>
		<section class="show-body">
			<section class="content2">
    <%System.Data.DataTable list_ordersLog = (System.Data.DataTable)ViewData["list_ordersLog"]; %>
    <% hotel3g.Controllers.ExpressData ed = (hotel3g.Controllers.ExpressData)ViewData["express"];%>
    <section class="order-d-top yu-pos-r bl">
     <% int OrderStatus = Convert.ToInt32(ViewData["OrderStatus"]);%>
     <% int PayStatus = Convert.ToInt32(ViewData["PayStatus"]);%>
     <%if (PayStatus != Convert.ToInt32(hotel3g.Models.EnumSupermarketPayStatus.AllReturn))
       {
           if (OrderStatus == Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.WaitPay))
           { %>
		<div class="yu-cw">
			<p class="yu-f40r">待付款</p>
			<%--<p class="yu-f26r">等待买家付款</p>--%>
			<p class="yu-f26r yu-w380r">剩下<span class="yu-ffd57a">25:05</span>时间，如超市未支付订单将自动取消。</p>
		</div>
		<div class="kd-pic">
			<img src="../../images/order-ico/dfkb_03.jpg" />
		</div>
        <%} %>
     <% if (OrderStatus == Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.WaitDeliver))
        { %>
		<div class="yu-cw">
			<p class="yu-f40r">已付款</p>
			<p class="yu-f26r">等待商家发货</p>
		</div>
		<div class="kd-pic">
			<img src="../../images/order-ico/yfkb_03.jpg" />
		</div>
        <%} %>
        <% if (OrderStatus == Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Delivered))
           { %>
		<div class="yu-cw">
			<p class="yu-f40r">已发货</p>
			<p class="yu-f26r" id="autoInfo"></p>
		</div>
		<div class="kd-pic">
			<img src="../../images/order-ico/wuliub_03.jpg" />
		</div>
        <%} %>
        <% if (OrderStatus == Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Finish))
           { %>
		<div class="yu-cw">
			<p class="yu-f40r">交易成功</p>
		</div>
		<div class="kd-pic">
			<img src="../../images/order-ico/jycgb_03.jpg" />
		</div>
        <%} %>
        <% if (OrderStatus == Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Cancel))
           { %>
		<div class="yu-cw">
			<p class="yu-f40r">取消</p>
			<p class="yu-f26r">买家取消订单</p>
		</div>
		<div class="kd-pic">
			<img src="../../images/order-ico/qxb_03.jpg" />
		</div>
        <%} %>
        <%}
       else
       { %>
		<div class="yu-cw">
			<p class="yu-f40r">退款成功</p>
			<p class="yu-f26r">商家已退款成功</p>
		</div>
		<div class="kd-pic">
			<img src="../../images/order-ico/tkcgb_03.jpg" />
		</div>
        <%} %>
	</section>
    <!--酒店方式-->
    <section class="yu-bgw yu-bmar10 ">
    <%--<% if (ViewData["AddressType"].ToString() != "酒店" && OrderStatus != Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.WaitPay) && OrderStatus != Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.WaitDeliver) && OrderStatus != Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Cancel))
           { %>
		<div class="yu-grid yu-alignc yu-tbpad30r yu-lpad40r yu-bor bbor">
			<a class="o-d-ico type2 yu-rmar25r" href="#"></a>
			<a class="yu-overflow yu-c40 yu-f30r" href="1-订单详情模板-超市-1-3物流详细.html">
				暂无物流信息！
			</a>
		</div>
        <%} %>--%>
        
    <%  if (ViewData["AddressType"].ToString() != "酒店" && OrderStatus != Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.WaitPay) && OrderStatus != Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.WaitDeliver) && OrderStatus != Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Cancel))
        {%>
            <% if (!string.IsNullOrWhiteSpace(ed.context))
               { %>
              <div class="yu-grid yu-alignc yu-tbpad30r yu-lpad40r yu-bor bbor yu-arr">
			<a class="o-d-ico type2 yu-rmar25r" href="#"></a>
			<a class="yu-alignc yu-overflow" href="/SupermarketA/Logistics/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=<%=ViewData["orderId"] %>">
				<div class="yu-f30r">
					<p class="yu-blue2 yu-bmar10r">
						<%=ed.context%>
					</p>
					<div class="yu-grid yu-alignc">
						<p class="yu-c99 yu-f26r text-ell yu-overflow yu-f-w100"><%=ed.time%></p>
					</div>
				</div>
			</a>
		</div>
            <%}
               else
               { %>
		<div class="yu-grid yu-alignc yu-tbpad30r yu-lpad40r yu-bor bbor">
			<a class="o-d-ico type2 yu-rmar25r" href="#"></a>
			<a class="yu-overflow yu-blue2 yu-f30r" href="#">
				暂无物流信息！
			</a>
		</div>
            <%} %>
    <%  
        } %>
		<div class="yu-grid yu-alignc yu-tbpad30r yu-lpad40r">
			<a class="o-d-ico type1 yu-rmar25r" href="#"></a>
			<a class="yu-alignc yu-overflow" href="javascript:;">
				<div class="yu-f36r">
					<p class="yu-black yu-bmar5">
						<span class="yu-f36r"><%=ViewData["Linkman"]%></span>
						<%--<span class="yu-f30r yu-f-w100">女士</span>--%>
						<span class="yu-f30r yu-f-w100"><%=ViewData["LinkPhone"]%></span>
					</p>
					<div class="yu-grid yu-alignc">
						<p class="address-type-ico bl yu-rmar5"><%=ViewData["addressType"] %></p>
						<p class="yu-c99 yu-f26r text-ell yu-overflow yu-f-w100"><%=ViewData["addressName"]%></p>
					</div>
				</div>
			</a>
		</div>
		<div class="colorBorder"></div>
	</section>
    <!--end-->
    <section class="yu-bgw yu-bmar20r">
		<div class="yu-h100r yu-lrpad10 yu-l100r yu-bor bbor yu-arr">
			<%--<a href="/Hotel/Index/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>" class="yu-c99 yu-f30r yu-grid yu-alignc">--%>
			<%--<a href="tel:<%=ViewData["hotelPhone"] %>" class="yu-c99 yu-f30r yu-grid yu-alignc">--%>
			<a href="javascript:onclick(GoToHotel())" class="yu-c99 yu-f30r yu-grid yu-alignc">
				<p class="yu-rmar20r"><%=ViewData["hotelName"]%></p>
				<p class="phone-ico4" onclick="CallPhone()"></p>
			<a href="tel:<%=ViewData["hotelPhone"] %>" style="display:none;"><span id="call_phone"></span>联系卖家</a>
			</a>
		</div>
		<div class="yu-pad20 yu-bglgrey yu-bor bbor">
			<ul>
				<%--<li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p class="yu-f24r">干炒牛河</p>
							
						</div>
					</div>
					<p class="yu-grey yu-rmar20 yu-f22r">X2</p>
					<p class="yu-f26r">￥31</p>
				</li>
				<li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p class="yu-f24r">干炒牛河</p>
							
						</div>
					</div>
					<p class="yu-grey yu-rmar20 yu-f22r">X2</p>
					<p class="yu-f26r">￥31</p>
				</li>--%>
                
            <% 
                System.Data.DataTable dt_detail = (System.Data.DataTable)ViewData["shoppingCarDataTable"];
                foreach (System.Data.DataRow row in dt_detail.Rows)
                {
                         %>
                         <li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p class="yu-f24r"><%=row["Name"]%></p>
							
						</div>
					</div>
					<p class="yu-grey yu-rmar20 yu-f22r">X<%=row["Total"]%></p>
					<p class="yu-f26r yu-w120r yu-textr">￥<%=string.Format("{0:F2}", float.Parse(row["Price"].ToString()))%></p>
				</li>

                         <%
}   
         %>
				<%--<li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p class="yu-f24r">打包费</p>
							
						</div>
					</div>
					<!--<p class="yu-grey yu-rmar20 yu-f22r">X2</p>-->
					<p class="yu-f26r">￥2</p>
				</li>--%>
                
                <%if (ViewData["ExpressFee"] != null)
                  {
                      if (!string.IsNullOrWhiteSpace(ViewData["ExpressFee"].ToString()) && ViewData["ExpressFee"].ToString() != "0")
                      { %>
                      <li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p class="yu-f24r">快递费</p>
							
						</div>
					</div>
					<!--<p class="yu-grey yu-rmar20 yu-f22r">X2</p>-->
					<p class="yu-f26r">￥<%=string.Format("{0:F2}", float.Parse(ViewData["ExpressFee"].ToString()))%></p>
				</li>
                      <%}
                  } %>
				<li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p class="yu-f24r">备注</p>
							
						</div>
					</div>
					<!--<p class="yu-grey yu-rmar20 yu-f22r">X2</p>-->
					<p class="yu-f26r" id="p_remark"><%--帮我加急，派送前电话联系--%></p>
				</li>
                
                <%--<%if (OrderStatus != Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.WaitDeliver) || ViewData["PayMethod"].ToString() == "积分支付"){ %>--%>
                <li class="yu-grid yu-alignc yu-bmar10 yu-f40r" id="li_btnShow">
					<div class="yu-overflow">&nbsp;</div>
					<div id="div_btnShow">
                <% if (OrderStatus == Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Finish))
                   { %>
                   <% if (!string.IsNullOrWhiteSpace(ed.context))
                      { %>
						<a href="/SupermarketA/Logistics/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=<%=ViewData["orderId"] %>" class="yu-btn6 type1">查看物流</a>
                 <%}
                   } %>
                <%if (ViewData["PayMethod"].ToString() == "积分支付")
                  { %>
						<a href="javascript:;" class="yu-btn6 type1">积分换购</a>
                <%}
                  else
                  { %>
                <% if (OrderStatus == Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.WaitPay))
                   { %>
						<a href="javascript:;" class="yu-btn6 type1" id="div-btn-cancel">取消订单</a>
						<a href="#" class="yu-btn6 type2" onclick="javascript:PayMoney()">去支付</a>
						
                <%} %>
                
                <%} %>
                <% if (OrderStatus == Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Delivered))
                   { %>
                    <% if (bool.Parse(ViewData["isShowAllowDelayed"].ToString()))
                       { %>
						<a href="javascript:;" class="yu-btn6 type1 lengthen-btn">延长收货</a>
                         <%}
                       else
                       { %>
						<a href="javascript:;" class="yu-btn6 type1">确定延长收货</a>
        <%} %>
						<a href="#" class="yu-btn6 type2" onclick="FinishOrder()">确认收货</a>
                <%} %>
                <% if (OrderStatus == Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Cancel) || PayStatus == Convert.ToInt32(hotel3g.Models.EnumSupermarketPayStatus.AllReturn))
                   { %>
						<a href="javascript:BuyAgain('<%=ViewData["HotelId"] %>','<%=ViewData["weixinid"] %>','<%=ViewData["userweixinid"] %>');" class="yu-btn6 type2">重新购买</a>
					
                <%} %>
					</div>
				</li>
                <%--<%} %>--%>
			</ul>
		</div>
        <%if (ViewData["PayMethod"].ToString() != "积分支付")
          { %>
		<div class="yu-h120r yu-grid yu-lrpad20r yu-alignc ">
				<p class="yu-black yu-rmar20 yu-f30r">总价</p>
				<div class="yu-overflow">
					<p class="yu-c40 yu-f30r">￥<span class="yu-f36r"><%=string.Format("{0:F2}", float.Parse(ViewData["amount"].ToString()))%></span></p>
                    <%if (PayStatus == Convert.ToInt32(hotel3g.Models.EnumSupermarketPayStatus.AllReturn))
                      { %>
					<p class="yu-c99 yu-f22r">已原路退回</p>
                    <%}
                      else if (ViewData["refundfee"].ToString() != "0")
                      { %>
					<p class="yu-c99 yu-f22r">已退回<%=ViewData["refundfee"]%>元</p>
                      <%}
                      else
                      { %>
					<p class="yu-c99 yu-f22r">
                    
        <%if (!string.IsNullOrWhiteSpace(ViewData["CouponId"].ToString()))
          { %>
        已优惠<%=string.Format("{0:F2}", float.Parse(ViewData["CouponMoney"].ToString()))%>元，<%} %>可获<span class="yu-blue2"><%=ViewData["orderScore"]%></span>积分</p>
                    <%} %>
				</div>
		</div>
        <%} %>
        <%if (ViewData["PayMethod"].ToString() == "积分支付")
          { %>
		<div class="yu-h120r yu-grid yu-lrpad20r yu-alignc ">
				<p class="yu-black yu-rmar20 yu-f30r">积分</p>
				<div class="yu-overflow">
					<p class="yu-c40 yu-f30r"><%=ViewData["PurchasePoints"]%></p>
				</div>
		</div>
		 <%} %>
	</section>
    <section class="yu-bgw yu-bmar20r yu-lpad20r">
		<div class="yu-h80r yu-bor bbor yu-f30r yu-l80r">订单详情</div>
		<div class="yu-tbpad30r">
			<ul class="yu-f24r yu-c99 yu-l35r">
				<li class="yu-grid">
					<p class="yu-rmar20r">支付方式</p>
					<p><%=ViewData["PayMethod"]%></p>
				</li>
				<li class="yu-grid">
					<p class="yu-rmar20r">订单编号</p>
					<p><%=ViewData["orderId"]%></p>
				</li>
				<%--<li class="yu-grid">
					<p class="yu-rmar20r">下单时间</p>
					<p>2017-05-10 12：16：29</p>
				</li>
				<li class="yu-grid">
					<p class="yu-rmar20r">付款时间</p>
					<p>2017-05-10 12：16：29</p>
				</li>--%>
                <% for (int i = 0; i < list_ordersLog.Rows.Count; i++)
                   { %>
                <li class="yu-grid">
					<p class="yu-rmar20r"><%=list_ordersLog.Rows[i]["Context"]%></p>
					<p><%=DateTime.Parse(list_ordersLog.Rows[i]["CreateTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss")%></p>
				</li>
                <%} %>
			</ul>
		</div>
	</section>
    <section class="yu-bgw yu-bmar20r yu-lpad20r">
		<div class="yu-h80r yu-bor bbor yu-f30r yu-l80r">发票信息</div>
		<div class="yu-tbpad30r">
			<ul class="yu-f24r yu-c99 yu-l35r">
				<li class="yu-grid">
					<p>发票金额：</p>
					<p><span>￥<%=string.Format("{0:F2}", float.Parse(ViewData["amount"].ToString()))%></span>（票面金额）</p>
				</li>
				<li class="yu-grid">
					<p>发票抬头：</p>
					<p><%=ViewData["Linkman"]%></p>
				</li>
			</ul>
		</div>
	</section>
    </section>
    </section>
    <!--end-->
    <section class="mask pay-cancel-mask">
			<div class="yu-bgw pay-cancel-tip">
				<p class="yu-font18 yu-bmar10">提醒</p>
				<p class="yu-font16 yu-bmar20">您是否确定取消订单</p>
				<div class="yu-grid yu-bor tbor yu-h50 yu-line50 yu-font16">
					<p class="yu-overflow yu-bor rbor yu-greys" onclick="Cancel('用户')">
						是
					</p>
					<p class="yu-overflow yu-blue not-cancel">
						否
					</p>
				</div>
		</div>
	</section>
    <!--提示-->
    <section class="mask lengthen-mask">
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
    <div class="tip-row yu-font16" style="display: none; position: fixed;">
        亲，距离结束时间3天才可以申请哦</div>
    <!--end-->
    
        <!--弹窗-->
     <%Html.RenderPartial("AlertMessage", viewDic); %>
	</article>
    <script>
        $(function () {
            var remark = '<%=ViewData["remark"] %>';
            if (remark != undefined && remark != "") {
                if (remark.length > 20) {
                    remark = remark.substring(0, 20) + "...";
                }
                $("#p_remark").text(remark);
            }

            var btnIsShow=$.trim($("#div_btnShow").html());
            if(btnIsShow == "")
            $("#li_btnShow").hide();
            
            if('<%=ViewData["PayStatus"] %>' == '<%=Convert.ToInt32(hotel3g.Models.EnumSupermarketPayStatus.WaitPay) %>' && '<%=ViewData["OrderStatus"] %>' != '<%=Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Cancel) %>'){
                setInterval(GetRTime,500);
                }
            if('<%=ViewData["OrderStatus"] %>' == "<%=Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.WaitDeliver) %>" || '<%=ViewData["OrderStatus"] %>' == "<%=Convert.ToInt32(hotel3g.Models.EnumSupermarketOrderStatus.Delivered) %>" ){
                setInterval(GetFinishRTime,500);
                }
        })

        //mask操作
        $("#div-btn-cancel").click(function () {
            $(".pay-cancel-mask").show();
        })
        $(".not-cancel").click(function () {
            $(".pay-cancel-mask").hide();
        });
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

        function Cancel(str) {
            $.post('/Supermarket/CancelOrder?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=<%=ViewData["orderId"] %>&createUser=' + str, function (data) {

                if (data.error == 0) {
                $("#tishi_msg").html(data.message);
                    $(".alert").fadeIn();
//                    layer.msg(data.message);
                    return false;
                }

                location.reload();
            });
        }
        
        function PayMoney(){
        window.location.href = "/Recharge/CardPay/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderNo=" + '<%=ViewData["orderId"] %> ';
        }
        
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
//                layer.msg("延迟收货成功");
//            location.reload();
                    setTimeout(function(){location.reload();},2000);
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


              $(".yu-ffd57a").text(m+":"+s);
            }else{
            Cancel("系统");
            }
        }
        
        //收货倒计时
        function GetFinishRTime(){
            var orderTime = "<%=ViewData["CreateTime"].ToString() %>";

            var EndTime= new Date(orderTime);
//            EndTime.setMinutes(EndTime.getMinutes() + 30, EndTime.getSeconds(), 0);
            var days=0;

            if('<%=ViewData["AddressType"].ToString() %>' != "酒店"){
            days = 15;
            }else{
            days = 7;
            }
            
            EndTime.setDate(EndTime.getDate()+days + ('<%=ViewData["DelayedTake"] %>' * 1)); 
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

              if(d>0){
              $("#autoInfo").html("还剩下"+d+"天"+h+"时自动确认");
              }else{
              $("#autoInfo").html("还剩下"+h+"时自动确认");
              }
            }
        }

    function BuyAgain(hId,key,storeId)
    {
      window.location.href = "/SupermarketA/Index/"+hId+"?key=" + key + "@" + storeId;
    }

    function CallPhone(){
    $("#call_phone").click();event.preventDefault(); }
    function GoToHotel(){
    window.location.href = '/HotelA/Index/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>';
    }
    </script>
</body>
</html>
