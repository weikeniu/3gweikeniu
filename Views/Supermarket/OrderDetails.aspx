﻿<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

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
    <title>订单预订</title>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/newpay.css">
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/drag.js"></script>
    <script src="http://css.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
    <%--<link type="text/css" rel="stylesheet" href="/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="/css/newpay.css">
    <script type="text/javascript" src="/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="/Scripts/drag.js"></script>
    <script src="/Scripts/layer/layer.js" type="text/javascript"></script>--%>
</head>
<%string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId; %>
<body>
    <!--酒店方式-->
    <%hotel3g.Models.OrderAddress address = (hotel3g.Models.OrderAddress)ViewData["Address"];%>
    <section class="yu-arr yu-bgw yu-bmar10 ">
		<div class="yu-grid yu-alignc">
			<a class="gps-ico" href="#"></a>
            <%if (!ViewData["userweixinid"].ToString().Contains(wkn_shareopenid))
              { %>
			<a class="yu-alignc yu-pad20 yu-overflow" href="/Supermarket/EditAddress/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
				<div>
					<p class="yu-black yu-bmar5">
						<span><%=address.LinkMan%></span>
						<span class="yu-fontv"><%=address.LinkPhone%></span>
					</p>
					<div class="yu-grid yu-alignc">
						<p class="address-type-ico yu-rmar5"><%=ViewData["addressType"]%></p>
						<p class="yu-grey yu-font14 text-ell yu-overflow"><%=ViewData["addressName"]%></p>
					</div>
				</div>
			</a>
            <%}
              else
              { %>
			<a class="yu-alignc yu-pad20 yu-overflow" href="/Supermarket/EditAddress2/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
				<div>
					<p class="yu-black yu-bmar5">
						<span id="LinkMan2"></span>
						<span class="yu-fontv" id="LinkPhone2"></span>
					</p>
					<div class="yu-grid yu-alignc">
						<p class="address-type-ico yu-rmar5" id="addressType2"><%=ViewData["addressType"]%></p>
						<p class="yu-grey yu-font14 text-ell yu-overflow" id="addressName2"><%=ViewData["addressName"]%></p>
					</div>
				</div>
			</a>
            <%} %>
		</div>
		<div class="colorBorder"></div>
	</section>
    <!--end-->
    <!--快速导航-->
    <% Html.RenderPartial("SupermarketNavigation", null); %>
    <section class="yu-bgw yu-bmar10">
		<div class="yu-h50 yu-lrpad10 yu-line50 yu-bor bbor yu-arr">
			<a href="/Hotel/Index/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>" class="yu-grey yu-d-b"><%=ViewData["hotelName"]%></a>
		</div>
		<div class="yu-pad20 yu-bglgrey yu-bor bbor">
			<ul id="ul_commodityshow">
            <% 
                System.Data.DataTable dt_detail = (System.Data.DataTable)ViewData["shoppingCarDataTable"];
                foreach (System.Data.DataRow row in dt_detail.Rows)
                {
                         %>
                <li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p><%=row["Name"]%></p>
							
						</div>
					</div>
					<p class="yu-grey yu-rmar20">X<%=row["Total"]%></p>
					<p>￥<%=string.Format("{0:F2}", float.Parse(row["Price"].ToString()))%></p>
				</li>
                         <%
}   
         %>
         <%if (ViewData["ExpressFee"] != null)
           {
               if (!string.IsNullOrWhiteSpace(ViewData["ExpressFee"].ToString()) && ViewData["ExpressFee"].ToString() != "0")
               { %>
				<li id="li_ExpressFee" class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p>快递费</p>
							
						</div>
					</div>
					<p>￥<%=string.Format("{0:F2}", float.Parse(ViewData["ExpressFee"].ToString()))%></p>
				</li>
                <%}
           } %>
			</ul>
		</div>

                    <%if (ViewData["canPoints"].ToString() == "1")
                      {
                          if (int.Parse(ViewData["myPoints"].ToString()) >= int.Parse(ViewData["needPoints"].ToString()))
                          {%>
              <div class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc ">
				<p class="yu-black yu-rmar20">积分</p>
				<div class="yu-overflow">
					可用<span class="yu-orange"><%=ViewData["needPoints"]%></span>积分兑换
				</div>
				<div class="radio"></div>
		</div>
        <%}
                          else
                          { %>
		<div class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc ">
				<p class="yu-black yu-rmar20">积分</p>
				<div class="yu-overflow">
					可用<span class="yu-orange"><%=ViewData["needPoints"]%></span>积分兑换
				</div>
				<div class="radio dis"></div>
		</div>
        <%}
                      } %>
<% System.Data.DataTable couponDataTable = (System.Data.DataTable)ViewData["couponDataTable"];
   if (couponDataTable.Rows.Count > 0)
   { %>
		<div class="yu-bor bbor yu-arr yu-h60 yu-grid yu-lrpad10 yu-alignc usehb">
				<p class="yu-black yu-rmar20">红包</p>
				<div class="yu-overflow" id="div_couponMoney1">
					<p class="yu-c99">选择红包</p>
				</div>
				<div class="yu-overflow" id="div_couponMoney2" style="display:none;">
					<p class="yu-orange yu-font16">￥<span id="p_couponMoney">0</span></p>
					<p class="yu-grey yu-font12" id="p_couponPrompt" style="display:none;">已从订单金额中扣减</p>
				</div>
		</div>
        <%} %>
		<div class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<p class="yu-black yu-rmar20">总额</p>
				<div class="yu-overflow">
					<p class="yu-orange yu-font16">￥<span class="span_amount" id="span_amount1"><%=string.Format("{0:F2}", float.Parse(ViewData["amount"].ToString()))%></span></p>
					<p class="yu-grey yu-font12" id="p_showGetScore"><span id="p_couponPrompt3" style="display:none;">已优惠<span id="p_couponMoney3">0</span>元，</span>可获<span class="yu-blue2"><%=ViewData["orderScore"]%></span>积分</p>
                    <p class="yu-grey yu-font12" id="p_showUseScore" style="display:none;">已用<%=ViewData["needPoints"]%>积分兑换</p>
				</div>
		</div>
	</section>
    <section class="yu-bgw yu-bmar10">
		<div>
			<a href="/Supermarket/OrderRemark/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>" class="yu-bor bbor yu-arr yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<p class="yu-black yu-overflow">订单备注</p>
				<p class="yu-grey yu-font12 yu-rpad20" id="p_remark"></p>
			</a>
			
		</div>
	</section>
    <%--<section class="yu-grid yu-bgw yu-pad10 content-btn-bar " id="paySuccess_section">
		<div class="contact-btn yu-overflow">
			<a href="tel:<%=ViewData["hotelPhone"] %>" style="color:White">联系酒店</a>
		</div>
	</section>--%>
    <!--红包-->
    <section class="mask hb-mask">
    <div class="mask-inner">
            <div class="row yu-line60 yu-h60 yu-font20 yu-grid yu-bmar10">
                        <p class="yu-grey yu-w70 cancel">取消</p>
                        <p class="yu-overflow">选择红包</p>
                        <p class="yu-blue yu-w70 yhq-over">完成</p>
                     </div>   

            <div class="yhq-box select-box">
            <% foreach (System.Data.DataRow data in couponDataTable.Rows)
               { %>
              <div class="row">
                <div class="hongbao type1 yu-grid">
                    <div class="yu-overflow yu-textl">
                    <input type="hidden" name="CouponId" value="<%=data["id"]%>" />
                      <p class="yu-bmar10"><i class="yu-font14">￥</i><i class="yu-font30"><%=data["moneys"]%></i></p>
                      <p class="yu-font14">超市红包</p>
                      <p class="yu-font14">有效期<%=DateTime.Parse(data["sTime"].ToString()).ToShortDateString()%>-<%=DateTime.Parse(data["ExtTime"].ToString()).ToShortDateString()%></p>
                      <p class="yu-font14">满<%=data["amountlimit"]%>元起用</p>
                    </div>
                    <p class="hongbao-state"><span class="type1">未选用</span><span class="type2">已选用</span></p>
                </div>
              </div>
            <%} %>               

            </div>          
         </div>
         </section>
    <!--end-->
    <footer class="yu-grid fix-bottom yu-bor tbor yu-lpad10 touch_action">
	
	<div class="yu-overflow">
		<p class="yu-orange" id="p_useMoney">在线支付￥<span class="span_amount" id="span_amount2"><%=string.Format("{0:F2}", float.Parse(ViewData["amount"].ToString()))%></span></p>
		<p class="yu-grey yu-font12" id="p_couponPrompt2" style="display:none;">为您优惠<span id="p_couponMoney2">0</span>元</p>
        <p class="yu-c40" id="p_useScore1" style="display:none;">总积分：<%=ViewData["needPoints"]%></p>
        <p class="yu-grey yu-font12" id="p_useScore2" style="display:none;">剩下<%=double.Parse(ViewData["myPoints"].ToString()) - double.Parse(ViewData["needPoints"].ToString())%>积分</p>
	</div>
	<div class="yu-btn" onclick="CreateOrder()">去支付</div>
	
</footer>
    <section class="mask jf-mask">
	<div class="inner jf-inner">
		<p class="yu-bor bbor">您的积分为<%=ViewData["myPoints"]%>，不够兑换此订单</p>
		<p class="close yu-c40">知道了</p>
	</div>
</section>
    <script type="text/javascript">
        var dt_detailCount=0;
        var couponMoney=0;
        var CouponId="";
        var amount = '<%=ViewData["amount"]%>' * 1;
            var Shielding;
    $(function () {
//        if(sessionStorage.UseShoppingCart == undefined || sessionStorage.UseShoppingCart == "false"){
//           window.location.href = "/Supermarket/index/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>";
//        }
//            window.onpageshow=function(e){
//                var a=e||window.event;
////                alert(a.persisted);
//                if(a.persisted){
////                    window.location.refresh();
//                    window.location.href = "/Supermarket/OrderDetails2/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=" + sessionStorage.SupperMarketOrderId;
//                }
//            }
            if(sessionStorage.SupperMarketIsBack == 1 && sessionStorage.SupperMarketOrderId != undefined){
                layer.load();
                window.location.href = "/Supermarket/OrderDetails2/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=" + sessionStorage.SupperMarketOrderId;
            }
            
            //判断缓存是否有物流信息
        if(('<%=ViewData["userweixinid"] %>').indexOf("<%=wkn_shareopenid %>")>-1){
            $("#LinkMan2").html(localStorage.supermarkAddressLinkMan);
            $("#LinkPhone2").html(localStorage.supermarkAddressLinkPhone);
            $("#addressType2").html(localStorage.supermarkAddresstypeName);
            if(localStorage.supermarkAddresstype * 1 == 1){
                $("#addressName2").html(localStorage.supermarkAddressAddress + localStorage.supermarkAddressRoomNo);
            }else{
                $("#addressName2").html(localStorage.supermarkAddresskdaddress);
            }
        }
            
//          获取购物车信息
            $(".loading-page").show();
            setTimeout(function(){$(".loading-page").hide()},5000);
            $.ajax({
                type: "post",
                url: '/Supermarket/GetShoppingCart/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>',
                dataType: 'json'
            }).done(function (data) {
                dt_detailCount=data.data;
                if(dt_detailCount * 1 == 0){
                    $("#ul_commodityshow").html("");
                    $("#p_remark").text("");
                    $("#span_amount1").html(0);
                    $("#span_amount2").html(0);
                    $(".span_amount").each(function(){
                       $(this).html(0);
                    });
                }
//                layer.close(Shielding);
            $(".loading-page").hide();
            });

            //获取备注信息
        var remark = sessionStorage.SupermarketOrderRemark;
        if (remark != undefined && remark != "") {
            if (remark.length > 20) {
                remark = remark.substring(0, 20) + "...";
            }
            $("#p_remark").text(remark);
        }
        //mask操作
        $(".mask").on("click", function () {
            $(this).fadeOut();
        });
        $(".mask-inner").on("click", function (e) {
            e.stopPropagation();
        });

        if (window.history && window.history.pushState) {
                        $(window).on('popstate', function () {
//                        alert(1);
                        });
                    }

    //radio
    $(".radio").click(function(){
    	if($(this).hasClass("dis")){
    		$(".jf-mask").fadeIn();
    	}else if($(this).hasClass("cur")){
            $(".hb-mask").find(".cur").click();
    		$(this).toggleClass("cur");
            $("#p_useMoney").show();
            $("#p_showGetScore").show();
            $("#p_showUseScore").hide();
            $("#p_useScore1").hide();
            $("#p_useScore2").hide();
            $(".yu-btn").html("去支付");
//            $("#li_ExpressFee").show();
//            $(".span_amount").each(function(){
//            $(this).html('<%=ViewData["amount"] %>');
//            });
    	}else{
            $(".hb-mask").find(".cur").click();
    		$(this).toggleClass("cur");
            $("#p_useMoney").hide();
            $("#p_showGetScore").hide();
            $("#p_showUseScore").show();
            $("#p_useScore1").show();
            $("#p_useScore2").show();
            $(".yu-btn").html("提交订单");
//            $("#li_ExpressFee").hide();
//            $(".span_amount").each(function(){
//            $(this).html('<%=ViewData["NoExpressAmount"] %>');
//            });
        }
    });
        var lasttime,
              yhqNum,
              tsyqTxt;
        $(".select-box .row").on("click", function () {
            $(this).toggleClass("cur").siblings(".row").removeClass("cur");
            ChangeCoupon();
            if ($(this).parent(".select-box").hasClass("time-box")) {//最晚时间
                lasttime = $(this).children("p").eq(1).text();
                $(".lasttimeselect").text(lasttime);
                $(this).parents(".mask").fadeOut();
            } else if ($(this).parent(".select-box").hasClass("yhq-box")) {//优惠券
                $(this).find(".txt").removeClass("yu-orange");
                $(this).siblings().find(".txt").addClass("yu-orange");
                yhqNum = $(this).index() + 1;
                return yhqNum;
            } else if ($(this).parent(".select-box").hasClass("tsyq-box")) {//特殊要求      
                tsyqTxt = $(this).children("p").eq(1).text();
                return tsyqTxt;
            }
        });
        //红包
        $(".usehb").click(function () {
            if($(".radio").hasClass("cur")){
                layer.msg("积分购买无需使用红包");
                return false;
            }
            $(".hb-mask").fadeIn();
        });
        $(".cancel").click(function () {
            $(".mask").fadeOut();
        });
        $(".yhq-over").click(function () {
            $(".mask").fadeOut();
            //          $(".yhq-type").text("￥"+yhqNum+"0");
        });
        
    
            if(sessionStorage.SupperMarketCouponId != undefined && sessionStorage.SupperMarketCouponId != ""){
                $(".select-box").find("input[name='CouponId']").each(function(){
                    if($(this).val() == sessionStorage.SupperMarketCouponId){
                        $(this).parent().click();
                    }
                });
            }
    });

    function ChangeCoupon(){
        if($(".hb-mask").find(".cur").length > 0){
           CouponShow();
        }else{
           CouponHide();
        }
    }

    //使用红包
    function CouponShow(){
        couponMoney = $(".hb-mask").find(".cur").find(".yu-font30").html();
        amount = '<%=ViewData["amount"]%>' * 1 - couponMoney * 1;
        $("#span_amount2").html(toDecimal2(amount));
        CouponId = $(".hb-mask").find(".cur").find("input[name='CouponId']").val();
        sessionStorage.SupperMarketCouponId = CouponId;
        $("#p_couponMoney").html(toDecimal2(couponMoney));
        $("#p_couponMoney2").html(toDecimal2(couponMoney));
        $("#p_couponMoney3").html(toDecimal2(couponMoney));
        $("#p_couponPrompt").show();
        $("#p_couponPrompt2").show();
        $("#p_couponPrompt3").show();
        $("#div_couponMoney1").hide();
        $("#div_couponMoney2").show();
    }
    //取消红包
    function CouponHide(){
        couponMoney=0;
        CouponId="";
        sessionStorage.SupperMarketCouponId = "";
        amount = '<%=ViewData["amount"]%>';
        $("#span_amount2").html(toDecimal2('<%=ViewData["amount"]%>'));
        $("#p_couponMoney").html(toDecimal2(couponMoney));
        $("#p_couponPrompt").hide();
        $("#p_couponPrompt2").hide();
        $("#p_couponPrompt3").hide();
        $("#div_couponMoney1").show();
        $("#div_couponMoney2").hide();
    }

    //创建工单
    function CreateOrder() {
        if(dt_detailCount * 1 == 0){
            layer.msg("请前往超市选购商品或从订单处支付订单");
            return;
        }
        var useScorePay=0;
        
//            Shielding=layer.load();
        if($(".radio").hasClass("cur")){
            useScorePay=1;
            CouponId = "";
            couponMoney=0;
        }

        var remark = sessionStorage.SupermarketOrderRemark;
        if(remark == undefined)
        remark="";
        var LinkMan="";
        var LinkPhone="";
        var AddressType="";
        var Address="";
        if(('<%=ViewData["userweixinid"] %>').indexOf("<%=wkn_shareopenid %>") < 0){
            LinkMan='<%=address.LinkMan%>';
            LinkPhone='<%=address.LinkPhone%>';
            AddressType='<%=ViewData["OriginAddressType"]%>';
            Address='<%=ViewData["addressName"]%>';
        }else{
            LinkMan=localStorage.supermarkAddressLinkMan;
            LinkPhone=localStorage.supermarkAddressLinkPhone;
            AddressType=localStorage.supermarkAddresstype;
            if(AddressType * 1 == 1){
                Address=localStorage.supermarkAddressAddress + localStorage.supermarkAddressRoomNo;
            }else{
                Address=localStorage.supermarkAddresskdaddress;
            }
        }
        if(LinkMan == "" || LinkPhone == ""){
            layer.msg("请填写联系人和联系电话");
            return;
        }

        $.post('/Supermarket/CreateOrder/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&weixinID=<%=ViewData["weixinid"] %>&userweixinID=<%=ViewData["userweixinid"] %>&remark=' + remark + '&LinkMan='+LinkMan+'&LinkPhone='+LinkPhone+'&AddressType='+AddressType+'&Address='+Address+'&ExpressFee=<%=ViewData["ExpressFee"]%>&useScorePay='+useScorePay+'&CouponId='+CouponId+'&CouponMoney='+couponMoney, function (data) {

            if (data.orderId == "") {
//                    layer.msg(data.message);
               localStorage.removeItem("SuperMarketShoppingCart");
//                    setTimeout(function(){location.reload();},500);
                $.post('/Supermarket/ClearShoppingCart/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>', function (data2) {
                    if (data2.error == "1") {layer.msg(data2.message);setTimeout(function(){location.reload();},3000);return false;}
                    else{layer.msg(data.message);return false;}
                });
//                 layer.close(Shielding);
                return false;
            }
            if(data.error == 2){
                layer.msg(data.message);
//                 layer.close(Shielding);
                return false;
            }
           localStorage.removeItem("SuperMarketShoppingCart");
                sessionStorage.UseShoppingCart = "false";
                sessionStorage.SupperMarketOrderId = data.orderId;
                sessionStorage.SupperMarketIsBack = 1;

            if(useScorePay == 0){
                window.location.href = "/Recharge/CardPay/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderNo=" + data.orderId;
           }else{
               window.location.href = "/Supermarket/OrderDetails2/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=" + data.orderId;
           }
        });
//                 layer.close(Shielding);
    }
    
        function toDecimal2(x) {    
        var f = parseFloat(x);    
        if (isNaN(f)) {    
            return false;    
        }    
        var f = Math.round(x*100)/100;    
        var s = f.toString();    
        var rs = s.indexOf('.');    
        if (rs < 0) {    
            rs = s.length;    
            s += '.';    
        }    
        while (s.length <= rs + 2) {    
            s += '0';    
        }    
        return s;    
    }  
    </script>
</body>
</html>
