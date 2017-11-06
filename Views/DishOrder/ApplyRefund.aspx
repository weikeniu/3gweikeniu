<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
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
<title>申请退款</title>
<link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/Restaurant.css"/>
<script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
<script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/drag.js" type="text/javascript"></script>
 <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/js.js" type="text/javascript"></script>
<script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>
	 <!--第一part-->
	<% hotel3g.Models.OrderInfo orderinfo = (hotel3g.Models.OrderInfo)ViewData["orderinfo"]; %>
	<section class="hide-page cur">
		<section class="yu-pad20 yu-bgw yu-bmar20">
			<div class="yu-grid yu-alignc yu-j-c yu-bmar10 step">
				<div class="type1">
					<div class="yuan-ico type1"></div>
					<p>提交申请</p>
				</div>
				<div class="type0">
					<div class="yuan-ico type1"></div>
					<p>申请通过</p>
				</div>
				<div class="type0">
					<div class="yuan-ico type1"></div>
					<p>退款成功</p>
				</div>
			</div>
		</section>
		<dl class="yu-bmar20">
			<dt class="yu-lpad10 yu-grey yu-bmar10">申请内容</dt>
			<dd class="yu-bgw yu-lpad10">
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-greys yu-rmar10">退款金额</p>
					<p class="yu-overflow yu-orange">￥<%=orderinfo.amount - orderinfo.youhuiamount+orderinfo.bagging%></p>
				</div>
				
				<div class="yu-grid yu-bor bbor yu-tbpad10 yu-alignc">
					<p class="yu-greys yu-rmar10">退款金额</p>
					<div class="yu-overflow">
						<p>原路退回</p>
						<p class="yu-grey yu-font12">24小时内退回您的元支付方式，无手续费</p>
					</div>
				</div>
				
				<div class="yu-grid yu-h50 yu-alignc">
					<p class="yu-greys yu-rmar10">退款原因</p>
					<p id="remo"><%=ViewData["ApplyRemo"]%></p>
				</div>
			</dd>
		</dl>
		
		
		<dl class="yu-bmar20">
			<dt class="yu-lpad10 yu-grey yu-bmar10">退款原因</dt>
			<dd class="yu-bgw yu-lpad10 slelect-reason">
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">我不想买了</p>
					<p class="select-ico"></p>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">我想重新点</p>
					<p class="select-ico"></p>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">未按时送达</p>
					<p class="select-ico"></p>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">商家菜品缺货</p>
					<p class="select-ico"></p>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">其它原因</p>
					<p class="select-ico"></p>
				</div>
			</dd>
		</dl>
		<section class="yu-bgw yu-pad20 yu-textc">
			<% 
                if (ViewData["ApplyRemo"] + "" == "")
                { %>
               <a class="re-set-btn1" onclick="javascript:SaveRefund('<%=orderinfo.orderCode %>')"/>提交</a>
               <a class="re-set-btn2" onclick="javascript:NoRefund()">先不退了</a>
            <%  }
                else {
                %>
                <a class="re-set-btn2" onclick="javascript:NoRefund()">已有申请待审核,返回订单详情</a>
                <%
                } 
                    %>
			
		</section>
	</section>
	 

	<!--第二part-->
	
	<section class="hide-page">
		<section class="yu-pad20 yu-bgw yu-bmar20">
			<div class="yu-grid yu-alignc yu-j-c yu-bmar10 step">
				<div class="type1">
					<div class="yuan-ico type1"></div>
					<p>提交申请</p>
				</div>
				<div class="type3">
					<div class="yuan-ico type1"></div>
					<p>申请通过</p>
				</div>
				<div class="type0">
					<div class="yuan-ico type1"></div>
					<p>退款成功</p>
				</div>
			</div>
		</section>
		<dl class="yu-bmar20">
			<dt class="yu-lpad10 yu-grey yu-bmar10">申请内容</dt>
			<dd class="yu-bgw yu-lpad10">
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-greys yu-rmar10">退款金额</p>
					<p class="yu-overflow yu-orange">￥347</p>
				</div>
				
				<div class="yu-grid yu-bor bbor yu-tbpad10 yu-alignc">
					<p class="yu-greys yu-rmar10">退款金额</p>
					<div class="yu-overflow">
						<p>原路退回</p>
						<p class="yu-grey yu-font12">24小时内退回您的元支付方式，无手续费</p>
					</div>
				</div>
				
				<div class="yu-grid yu-h50 yu-alignc">
					<p class="yu-greys yu-rmar10">退款原因</p>
					<p>未按时送达</p>
				</div>
			</dd>
		</dl>
		<dl class="yu-bmar20">
			<dt class="yu-lpad10 yu-grey yu-bmar10">退款原因</dt>
			<dd class="yu-bgw yu-lpad10 slelect-reason already-select">
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">我不想买了</p>
					<p class="select-ico"></p>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc  cur2">
					<p class="yu-rmar10 yu-overflow">我想重新点</p>
					<p class="select-ico"></p>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">未按时送达</p>
					<p class="select-ico"></p>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">商家菜品缺货</p>
					<p class="select-ico"></p>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">其它原因</p>
					<p class="select-ico"></p>
				</div>
			</dd>
		</dl>
		<section class="yu-bgw yu-pad20 yu-textc">
			<a href="javascript:;" class="re-set-btn1"/>提交2</a>
			<a href="javascript:;" class="re-set-btn2">先不退了</a>
		</section>
	</section>
	
	<!--第三part-->
	<section class="hide-page">
		<section class="yu-pad20 yu-bgw yu-bmar20">
			<div class="yu-grid yu-alignc yu-j-c yu-bmar10 step">
				<div class="type1">
					<div class="yuan-ico type1"></div>
					<p>提交申请</p>
				</div>
				<div class="type3">
					<div class="yuan-ico type1"></div>
					<p>申请通过</p>
				</div>
				<div class="type3">
					<div class="yuan-ico type1"></div>
					<p>退款成功</p>
				</div>
			</div>
		</section>
		<dl class="yu-bmar20">
			<dt class="yu-lpad10 yu-grey yu-bmar10">申请内容</dt>
			<dd class="yu-bgw yu-lpad10">
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-greys yu-rmar10">退款金额</p>
					<p class="yu-overflow yu-orange">￥347</p>
				</div>
				
				<div class="yu-grid yu-bor bbor yu-tbpad10 yu-alignc">
					<p class="yu-greys yu-rmar10">退款金额</p>
					<div class="yu-overflow">
						<p>原路退回</p>
						<p class="yu-grey yu-font12">24小时内退回您的元支付方式，无手续费</p>
					</div>
				</div>
				
				<div class="yu-grid yu-h50 yu-alignc">
					<p class="yu-greys yu-rmar10">退款原因</p>
					<p>未按时送达</p>
				</div>
			</dd>
		</dl>
		<dl class="yu-bmar20">
			<dt class="yu-lpad10 yu-grey yu-bmar10">退款原因</dt>
			<dd class="yu-bgw yu-lpad10 slelect-reason already-select">
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc cur2">
					<p class="yu-rmar10 yu-overflow">我不想买了</p>
					<p class="select-ico"></p>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">我想重新点</p>
					<p class="select-ico"></p>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">未按时送达</p>
					<p class="select-ico"></p>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">商家菜品缺货</p>
					<p class="select-ico"></p>
				</div>
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-rmar10 yu-overflow">其它原因</p>
					<p class="select-ico"></p>
				</div>
			</dd>
		</dl>
		<section class="yu-bgw yu-pad20 yu-textc">
			<a href="javascript:;" class="re-set-btn1"/>提交</a>
			<a href="javascript:;" class="re-set-btn2">先不退了</a>
		</section>
	</section>
	
	<!--第四part-->
	<section class="hide-page">
		<section class="yu-pad20 yu-bgw yu-bmar20">
			<div class="yu-grid yu-alignc yu-j-c yu-bmar10 step">
				<div class="type1">
					<div class="yuan-ico type1"></div>
					<p>提交申请</p>
				</div>
				<div class="type2">
					<div class="yuan-ico type1"></div>
					<p>拒绝申请</p>
				</div>
			</div>
		</section>
		<dl class="yu-bmar20">
			<dt class="yu-lpad10 yu-grey yu-bmar10">拒绝原因</dt>
			<dd class="yu-bgw">
				<div class="yu-lpad10 yu-orange yu-h50 yu-line50">订单派送中</div>
			</dd>
		</dl>
		<dl class="yu-bmar20">
			<dt class="yu-lpad10 yu-grey yu-bmar10">申请内容</dt>
			<dd class="yu-bgw yu-lpad10">
				<div class="yu-grid yu-bor bbor yu-h50 yu-alignc">
					<p class="yu-greys yu-rmar10">退款金额</p>
					<p class="yu-overflow yu-orange">￥347</p>
				</div>
				
				<div class="yu-grid yu-bor bbor yu-tbpad10 yu-alignc">
					<p class="yu-greys yu-rmar10">退款金额</p>
					<div class="yu-overflow">
						<p>原路退回</p>
						<p class="yu-grey yu-font12">24小时内退回您的原支付方式，无手续费</p>
					</div>
				</div>
				
				<div class="yu-grid yu-h50 yu-alignc">
					<p class="yu-greys yu-rmar10">退款原因</p>
					<p>未按时送达</p>
				</div>
			</dd>
		</dl>
		<section class="yu-bgw yu-pad20">
			<a href="#" class="re-set-btn1"/>重新申请</a>
		</section>
	</section>

      <!--快速导航-->
      <% Html.RenderPartial("QuickNavigation", null); %>
	           <%-- <section class="fix-right" id="drag">
		            <div class="fix-btn yu-grid yu-alignc">
			            <p class="ico"></p>
			            <p class="show-hide cur">快速<br />导航</p>
			            <p class="show-hide">收起</p>
		            </div>
		            <div class="fix-right-slide">
			            <div class="yu-grid yu-alignc">
                            <a class="yu-overflow" href="/home/main/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"] %>">
					            <p class="ico type1"></p>
					            <p>首页</p>
				            </a>
				            <a class="yu-overflow" href="/hotel/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"]%>">
					            <p class="ico type2"></p>
					            <p>订房</p>
				            </a>
				            <a class="yu-overflow"  href="/user/myorders/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"]%>">
					            <p class="ico type4"></p>
					            <p>订单</p>
				            </a>
                            <a class="yu-overflow"  href="/user/index/<%=Html.ViewData["hId"] %>?key=<%=Html.ViewData["key"] %>">
					            <p class="ico type3"></p>
					            <p>会员</p>
				            </a>
			            </div>
		            </div>
	            </section>--%>
	<script>
	    $(function () {

         

	        //退款原因
	        $(".slelect-reason>div").on("click", function () {
	            if (!$(this).parent().hasClass("already-select")) {
	                $(this).addClass("cur").siblings().removeClass("cur");
	                $('#remo').text($(this).text());
	            }
	        })


	        //页面切换
	        //	        $(".re-set-btn1").on("click", function () {
	        //	            $(this).parents(".hide-page").removeClass("cur").next(".hide-page").addClass("cur");
	        //	        })
	    })

	    function SaveRefund(orderCode) {
	        
            var remo = $('#remo').text();
            if (remo != "") {
                $.post("/DishOrder/SaveRefund/?orderCode=" + orderCode + "&remo=" + remo, function (data) {
                    if (data.error == 1) {
                        window.location.href = "/DishOrder/ViewOrderDetail/<%=ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&key=<%=ViewData["key"] %>&orderCode=<%=ViewData["orderCode"] %>";
                    } else {
                        layer.msg(data.message);
                    }

                });
            } else {
               layer.msg('请选择退款原因！');return false;
             }
         }

         function NoRefund()
         {
         window.location.href = "/DishOrder/ViewOrderDetail/<%=ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&key=<%=ViewData["key"] %>&orderCode=<%=ViewData["orderCode"] %>";
         }
	</script>
</body>
</html>
