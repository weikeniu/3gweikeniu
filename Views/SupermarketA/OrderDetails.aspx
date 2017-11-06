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
    <title>购物车</title>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/fontSize.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
    <script src="http://css.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
    <%--
    <link type="text/css" rel="stylesheet" href="/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="/css/booklist/fontSize.css" />
    <script type="text/javascript" src="/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="/Scripts/fontSize.js"></script>
    <script src="/Scripts/layer/layer.js" type="text/javascript"></script>--%>
</head>
<body>
    <article class="full-page">
    
    <% 
        ViewDataDictionary viewDic = new ViewDataDictionary();
        viewDic.Add("weixinID", ViewData["weixinid"]);
        viewDic.Add("hId", ViewData["hotelId"]);
        viewDic.Add("uwx", ViewData["userweixinid"]); %>
     <%Html.RenderPartial("HeaderA", viewDic); %>
		<section class="show-body">
			
    <%hotel3g.Models.OrderAddress address = (hotel3g.Models.OrderAddress)ViewData["Address"];%>
                <% System.Data.DataTable dt_detail = (System.Data.DataTable)ViewData["shoppingCarDataTable"]; %>
			<section class="content2 yu-bpad60">
				<div class="yu-bgw yu-bmar10 yu-lpad10">
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<div class="l-ico type5 yu-rmar10"></div>
						<p class="yu-w60 yu-f30r">联系人</p>
						<div class="yu-overflow"><input type="text" class="yu-input2" placeholder="请输入姓名" id="LinkMan" value='<%=address.LinkMan%>' /></div>
						<%--<div class="yu-grid sex-select yu-alignc yu-f30r">
							<label class="yu-rmar10">
								<span>先生</span><span class="ico"></span>
							</label>
							<label>
								<span>女士</span><span class="ico"></span>
							</label>
						</div>--%>
					</div>
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<div class="l-ico type6 yu-rmar10"></div>
						<p class="yu-w60 yu-f30r">手机号</p>
						<div class="yu-overflow"><input type="text" class="yu-input2" placeholder="请输入订餐人手机号码" id="LinkPhone" value='<%=address.LinkPhone%>' /></div>
					</div>
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						
						<p class="yu-overflow yu-f30r">收货地址</p>
						<!--<div class="yu-overflow"><input type="text" class="yu-input2" placeholder="请输入姓名"></div>-->
						<div class="yu-grid sex-select yu-alignc address1-select yu-f30r">
                        <% if (ViewData["addressType"].ToString() == "酒店")
                           { %>
							<label class="yu-rmar10 cur">
								<span>酒店</span><span class="ico"></span>
							</label>
							<label id="addressOther">
								<span>其它</span><span class="ico"></span>
							</label>
                            <%}
                           else
                           { %>
							<label class="yu-rmar10 ">
								<span>酒店</span><span class="ico"></span>
							</label>
							<label id="addressOther" class="cur">
								<span>其它</span><span class="ico"></span>
							</label>
                            <%} %>
						</div>
					</div>
                    <% if (ViewData["addressType"].ToString() == "酒店")
                       { %>
					<div class="address1 cur" id="div_address1">
						<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
							<div class="l-ico type10 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">房间号</p>
							<div class="yu-overflow"><input type="text" class="yu-input2" placeholder="请输入房间号" id="RoomNo" value='<%=address.RoomNo%>' /></div>
						</div>
					</div>
					<div class="address1">
						<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
							<div class="l-ico type11 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">其它</p>
							<div class="yu-overflow"><input type="text" class="yu-input2" placeholder="请输入地址" id="kuaidiAddress" value='<%=address.kuaidiAddress%>' /></div>
						</div>
					</div>
                     <%}
                       else
                       { %>
                           <div class="address1" id="div_address1">
						<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
							<div class="l-ico type10 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">房间号</p>
							<div class="yu-overflow"><input type="text" class="yu-input2" placeholder="请输入房间号" id="RoomNo" value='<%=address.RoomNo%>' /></div>
						</div>
					</div>
					<div class="address1 cur">
						<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
							<div class="l-ico type11 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">其它</p>
							<div class="yu-overflow"><input type="text" class="yu-input2" placeholder="请输入地址" id="kuaidiAddress" value='<%=address.kuaidiAddress%>' /></div>
						</div>
					</div>
                    <%} %>

					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<div class="l-ico type7 yu-rmar10"></div>
						<p class="yu-w60 yu-f30r">备注</p>
						<div class="yu-overflow"><input type="text" class="yu-input2" id="Remarks" placeholder="请输入其它要求"></div>
					</div>

                          <div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10" style="display:none" id="div_operationUseScore">
						<div class="l-ico type12 yu-rmar10"></div>
						<p class="yu-w60 yu-f30r">积分</p>
						<div class="yu-overflow yu-f30r">
							可用<span class="yu-orange"><%=ViewData["needPoints"]%></span>积分兑换
						</div>
						<div class="radio"></div>
					</div>
                      <% System.Data.DataTable couponDataTable = (System.Data.DataTable)ViewData["couponDataTable"];
                         if (couponDataTable.Rows.Count > 0)
                         { %>
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 yu-arr hongbao-btn">
						<div class="l-ico type8 yu-rmar10"></div>
						<p class="yu-w60 yu-f30r">红包</p>
						<%--<div class="yu-overflow">
							<p class="yu-c40 yu-f36r"><i class="yu-f30r">￥</i>10</p>
							<p class="yu-c66 yu-f22r">已从房费金额中扣除</p>
						</div>--%>
						<div class="yu-overflow" id="div_couponMoney1">
					        <p class="yu-f30r yu-c99">请选择优惠红包</p>
						</div>
						<div class="yu-overflow" id="div_couponMoney2" style="display:none;">
							<p class="yu-c40 yu-f36r"><i class="yu-f30r">￥</i><span id="p_couponMoney">0</span></p>
							<p class="yu-c66 yu-f22r" id="p_couponPrompt" style="display:none;">已从房费金额中扣除</p>
						</div>
					</div>
        <%} %>

					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<div class="l-ico type9 yu-rmar10"></div>
						<p class="yu-w60 yu-f30r">总价</p>
						<div class="yu-overflow">
							<p class="yu-c40 yu-f36r"><i class="yu-f30r">￥</i><span class="orderAmount" id="span_amount1"><%=ViewData["amount"]%></span></p>
							<%--<p class="yu-c66 yu-f22r">可获<i class="yu-c40 orderScore"><%=ViewData["orderScore"] %></i>积分</p>--%>
							<p class="yu-c66 yu-f22r" id="p_showUseMoney"><%--已优惠10元，--%>可获<i class="yu-c40 orderScore"><%=ViewData["orderScore"] %></i>积分</p>
                            <p class="yu-grey yu-font12" id="p_showUseScore" style="display:none;">已用<span id="span_needPoints1"><%=ViewData["needPoints"]%></span>积分兑换</p>
						</div>
					</div>
				</div>
                <%if (dt_detail.Rows.Count > 0)
                  { %>
				<div id="MultipleCommodity">
					<p class="yu-lpad10 yu-bmar10 yu-f30r">已选<%=dt_detail.Rows.Count%>件商品</p>
					<ul class="yu-bgw yu-bor tbor yu-lpad20r">
                    <% 
                        foreach (System.Data.DataRow row in dt_detail.Rows)
                        {
                         %>
						<li class="yu-grid yu-alignc yu-bor bbor yu-tbpad28r yu-rpad20r">
									<div class="food-pic"><img src="<%=row["ImageList"].ToString().Split(',')[0] %>"></div>
									<div class="yu-overflow2 yu-h123r">
										<p class="yu-f30r"><%=row["Name"]%></p>
										<div class="yu-font12 yu-grey yu-bmar5 yu-grid">&nbsp;</div>
										<div class="yu-grid yu-alignc yu-f24r">
											<p class="yu-overflow yu-c40 "><i>￥</i><i class="yu-f36r yu-fontb CommodityPrice"><%=string.Format("{0:F2}", float.Parse(row["Price"].ToString()))%></i></p>                        
                                            <input type="hidden" name="CommodityId" value='<%=row["CommodityId"]%>' />
                                        <input type="hidden" name="CommodityStock" value='<%=row["Stock"]%>' />
                                        <input type="hidden" name="CommodityCanPurchase" value='<%=row["CanPurchase"]%>' />
                                        <input type="hidden" name="CommodityPurchasePoints" value='<%=row["PurchasePoints"]%>' />
                                        <input type="hidden" name="CommodityCanCouPon" value='<%=row["CanCouPon"]%>' />
										</div>
									</div>
									<div class="ar yu-grid">
												<p class="reduce ico type2"></p>
												<p class="food-num"><%=row["Total"]%></p>
												<p class="add ico type2"></p>
											</div>
							</li>
                                 <%
                                     }   
         %>
					</ul>
				</div>
				
				<%} %>
			</section>
			<footer class="yu-grid fix-bottom yu-bor tbor yu-lpad10 sp">
	
				<div class="yu-overflow">
					<p class="yu-f34r" id="p_useMoney1">合计￥<span class="orderAmount" id="span_amount2"><%=ViewData["amount"]%></span></p>
					<p class="yu-grey yu-f26r" id="p_useMoney2">包含服务及增值税￥0</p>
					<p class="yu-f34r" id="p_useScore1" style="display:none;">总积分<span class="orderAmountScore"><%=ViewData["needPoints"]%></span></p>
					<p class="yu-grey yu-f26r" id="p_useScore2" style="display:none;">剩下<span id="span_SurplusPoints"><%=double.Parse(ViewData["myPoints"].ToString()) - double.Parse(ViewData["needPoints"].ToString())%></span>积分</p>
				</div>
				<div class="yu-btn yu-bg40" id="div_pay" onclick="CreateOrder()">立即支付</div>
				
			</footer>
		</section>
		<!--红包-->
	<section class="mask hongbao-mask">
		<div class="mask-bottom-inner yu-bgw">
			<p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">红包</p>
			<ul class="yu-lrpad10 yu-c40 hongbao-select">
				<li class="yu-h120r yu-grid yu-alignc yu-bor bbor cur" onclick="CouponHide()">
					<p class="yu-overflow yu-f34r">不使用红包</p>
					<p class="copy-radio"></p>
				</li>
            <% foreach (System.Data.DataRow data in couponDataTable.Rows)
               { %>
				<li class="yu-h120r yu-grid yu-alignc yu-bor bbor" onclick="CouponShow(this)">
                    <input type="hidden" name="CouponId" value="<%=data["id"]%>" />
                    <input type="hidden" name="amountlimit" value="<%=data["amountlimit"]%>" />
					<p class="yu-rmar10 yu-l120r"><i class="yu-f25r">￥</i><i class="yu-f50r yu-fontb"><%=data["moneys"]%></i></p>
					<div class="yu-overflow yu-f24r">
						<p><%=data["amountlimit"]%>元起用</p>
						<p>有效期<%=DateTime.Parse(data["sTime"].ToString()).ToShortDateString()%>-<%=DateTime.Parse(data["ExtTime"].ToString()).ToShortDateString()%></p>
					</div>
					<p class="copy-radio"></p>
				</li>
            <%} %>   
			</ul>
			<div class="yu-l100r yu-h100r yu-bg40 yu-white  yu-textc mask-close yu-font32r">关闭</div>
		</div>
	</section>
   <%-- <section class="mask jf-mask">
	<div class="inner jf-inner">
		<p class="yu-bor bbor">不好意思，您剩下<%=ViewData["myPoints"]%>积分，不够兑换此订单</p>
		<p class="close yu-c40">知道了</p>
	</div>
</section>--%>

        <!--弹窗-->
     <%Html.RenderPartial("AlertMessage", viewDic); %>
	</article>
    <script>
        //加减餐
        var foodNum = 0;
        var totalNum = 0;
        var isCanRun = true;
        var CouponId="";
        var couponMoney=0;
        var useCouponLimit = 0;
        var sumMoney = '<%=ViewData["amount"] %>' * 1;
        var canCouponSum = '<%=ViewData["canCouponSum"] %>' * 1;
        var score = '<%=ViewData["orderScore"] %>' * 1;
        var equivalence = '<%=ViewData["equivalence"] %>' * 1;
        var GradePlus = '<%=ViewData["GradePlus"] %>' * 1;
        var needPoints = '<%=ViewData["needPoints"] %>' * 1;
        var expressfee3 = "<%=ViewData["ExpressFee2"] %>" * 1;
            var Shielding;

        $(function () {
            if(sessionStorage.SupperMarketIsBack == 1 && sessionStorage.SupperMarketOrderId != undefined){
//                 layer.load();
                $(".loading-page").show();
                setTimeout(function(){$(".loading-page").hide()},5000);
                 window.location.href = "/SupermarketA/OrderDetails2/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=" + sessionStorage.SupperMarketOrderId;
            }
            CheckCoupon();
        
//            Shielding=layer.load();
            $(".loading-page").show();
            setTimeout(function(){$(".loading-page").hide()},5000);
            $.ajax({
                type: "post",
                url: '/Supermarket/GetShoppingCart/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>',
                dataType: 'json'
            }).done(function (data) {
                dt_detailCount=data.data;
                if(dt_detailCount * 1 == 0){
                    $("#MultipleCommodity").html("");
                    $("#Remarks").val("");
                    $(".yu-orange").html(0);
                    $("#span_amount1").html(0);
                    $("#span_amount2").html(0);
                    $(".orderScore").html(0);
                }
//                layer.close(Shielding);
                $(".loading-page").hide();
            });

            if('<%=ViewData["canPoints"] %>' == "1"){
            $("#div_operationUseScore").show();
            }
            //左导航
            var lSideNum = 0;
            $(".l-side-btn").click(function () {
                if (lSideNum == 0) {
                    $(".full-page").addClass("shin-slide-right").removeClass("shin-slide-left");
                    $(".l-side").fadeIn();
                    lSideNum = 1;
                } else {
                    $(".full-page").removeClass("shin-slide-right").addClass("shin-slide-left");
                    $(".l-side").fadeOut();
                    lSideNum = 0;
                }
            })
            //选项卡
            var tabIndex;
            $(".tab-nav").children("li").on("click", function () {
                $(this).addClass("cur").siblings("li").removeClass("cur");
                tabIndex = $(this).index();
                $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
            })

            //加载后显示购物车已有数据
            $(".food-num").each(function () {
                if ($(this).text() != "" && $(this).text() * 1 != 0) {
                    $(this).fadeIn();
                    $(this).prev().fadeIn();

                    totalNum += $(this).text() * 1;

                }

                //yu-arr type-up
                if (totalNum > 0)
                    $(".cart").children(".num").fadeIn().text(totalNum);
            });

            function isShowScoreOperation(){
                var isShow = true;
                $(".food-num").each(function () {
                    if ($(this).text() != "" && $(this).text() * 1 != 0) {
                        var CommodityCanPurchase = $(this).parent().parent().find("input[name='CommodityCanPurchase']").val();
                        if(CommodityCanPurchase * 1 == 0)
                           isShow=false;

                    }
                });
                if(isShow){
            $("#div_operationUseScore").show();
//                   UseScoreStyle();
                }else{
            $("#div_operationUseScore").hide();
            if($(".radio").hasClass("cur")){
    		$(".radio").toggleClass("cur");
            UseMoneyStyle();}
                }
            }

            $(".add").on("click", function () {
                if (!isCanRun)
                    return false;

                var total = $(this).parent().find(".food-num").html();
                var CommodityId = $(this).parent().parent().find("input[name='CommodityId']").val();
                var CommodityStock = $(this).parent().parent().find("input[name='CommodityStock']").val();
                var CommodityPrice = $(this).parent().parent().find(".CommodityPrice").html();
                var CommodityCanPurchase = $(this).parent().parent().find("input[name='CommodityCanPurchase']").val();
                var CommodityPurchasePoints = $(this).parent().parent().find("input[name='CommodityPurchasePoints']").val();
                var CanCouPon = $(this).parent().parent().find("input[name='CommodityCanCouPon']").val();

                if (total * 1 == CommodityStock * 1) {
//                    layer.msg("没有库存,不能再多了");
                $("#tishi_msg").html("没有库存,不能再多了");
                    $(".alert").fadeIn();
                    return false;
                }
                if($(".radio").hasClass("cur") && needPoints + CommodityPurchasePoints *1 > '<%=ViewData["myPoints"] %>' *1 && CommodityCanPurchase * 1 == 1){
//                    layer.msg("您的积分不足");
                $("#tishi_msg").html("您的积分不足");
                    $(".alert").fadeIn();
                    return false;
                }

                AddCommodity(CommodityId, CommodityPrice, CommodityPurchasePoints, CommodityCanPurchase);
                if(CanCouPon == "1")
                    canCouponSum += CommodityPrice * 1;
                CheckCoupon();

                totalNum++;
                if ($(this).siblings(".food-num").text() == "") {
                    foodNum = 1;
                    $(this).siblings(".food-num").text(foodNum);
                } else {
                    foodNum = parseInt($(this).siblings(".food-num").text());
                    foodNum++;
                    $(this).siblings(".food-num").text(foodNum);

                };
                $(this).siblings().fadeIn();
                isShowScoreOperation();
            });

            //数据库增加商品
            function AddCommodity(CommodityId, CommodityPrice, CommodityPurchasePoints, CommodityCanPurchase) {
                //                $("#MultipleCommodity").find("input[name='CommodityId']").each(function () {//.show-header 

                //                    totalNum++;
                //                    if ($(this).parent().parent().parent().find(".food-num").text() == "") {
                //                        foodNum = 1;
                //                        $(this).parent().parent().parent().find(".food-num").text(foodNum);
                //                    } else {
                //                        foodNum = parseInt($(this).parent().parent().parent().find(".food-num").text());
                //                        foodNum++;
                //                        $(this).parent().parent().parent().find(".food-num").text(foodNum);

                //                    };
                //                    $(this).parent().parent().parent().find(".food-num").fadeIn();
                //                });
                //                $(".show-header ").find("input[name='CommodityId']").each(function () {//

                //                    totalNum++;
                //                    if ($(this).parent().parent().find(".food-num").text() == "") {
                //                        foodNum = 1;
                //                        $(this).parent().parent().find(".food-num").text(foodNum);
                //                    } else {
                //                        foodNum = parseInt($(this).parent().parent().find(".food-num").text());
                //                        foodNum++;
                //                        $(this).parent().parent().find(".food-num").text(foodNum);

                //                    };
                //                    $(this).parent().parent().find(".food-num").fadeIn();
                //                });

                isCanRun = false;
                
                    if(CommodityCanPurchase * 1 == 1)
                    needPoints += CommodityPurchasePoints * 1;
                    sumMoney += CommodityPrice * 1;
                    sumMoney = parseFloat(sumMoney.toFixed(2));
                    ChangeMoney();
                $.post('/Supermarket/AddCommodityToShoppingCart/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&weixinID=<%=ViewData["weixinid"] %>&userweixinID=<%=ViewData["userweixinid"] %>&CommodityId=' + CommodityId, function (data) {
                    isCanRun = true;
                    if (data.error == 0) {
                $("#tishi_msg").html(data.message);
                    $(".alert").fadeIn();
//                        layer.msg(data.message);
                        return false;
                    }

                });
            }

            $(".reduce").on("click", function () {
                if (!isCanRun)
                    return false;

                var CommodityId = $(this).parent().parent().find("input[name='CommodityId']").val();
                var CommodityPrice = $(this).parent().parent().find(".CommodityPrice").html();
                var CommodityCanPurchase = $(this).parent().parent().find("input[name='CommodityCanPurchase']").val();
                var CommodityPurchasePoints = $(this).parent().parent().find("input[name='CommodityPurchasePoints']").val();
                var CanCouPon = $(this).parent().parent().find("input[name='CommodityCanCouPon']").val();
                
                foodNum = parseInt($(this).siblings(".food-num").text());
                if (foodNum > 0) {
                ReduceCommodity(CommodityId, CommodityPrice,CommodityPurchasePoints, CommodityCanPurchase);
                if(CanCouPon == "1")
                    canCouponSum -= CommodityPrice * 1;
                CheckCoupon();

                    totalNum--;
                    foodNum--;
                    $(this).siblings(".food-num").text(foodNum);
                    $(this).parents(".show-header").find(".cart").children(".num").text(foodNum);
                    if (totalNum == 0) {
                        $(".gwc-ico .num").fadeOut();
                    }
                    if (foodNum == 0) {
                        $(this).fadeOut().siblings(".food-num").fadeOut();
                    }
                };
                isShowScoreOperation();
            });

            //数据库减少商品
            function ReduceCommodity(CommodityId, CommodityPrice, CommodityPurchasePoints, CommodityCanPurchase) {
                if (!isCanRun)
                    return false;

                isCanRun = false;
                
                    if(CommodityCanPurchase * 1 == 1)
                    needPoints -= CommodityPurchasePoints * 1;
                    sumMoney -= CommodityPrice * 1;
                    sumMoney = parseFloat(sumMoney.toFixed(2));
                    ChangeMoney();
                $.post('/Supermarket/ReduceCommodityToShoppingCart/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&weixinID=<%=ViewData["weixinid"] %>&userweixinID=<%=ViewData["userweixinid"] %>&CommodityId=' + CommodityId, function (data) {
                    isCanRun = true;
                    if (data.error == 0) {
                $("#tishi_msg").html(data.message);
                    $(".alert").fadeIn();
//                        layer.msg(data.message);
                        return false;
                    }
                    
                });
            }

            //radio
//            $(".radio").on("click", function () {
//                if ($(this).hasClass("cur")) {
//                    $(this).parents(".fapiao").siblings("div").fadeOut();
//                    $(this).removeClass("cur");
//                } else {
//                    $(this).parents(".fapiao").siblings("div").fadeIn();
//                    $(this).addClass("cur");
//                }
//            })
    $(".radio").click(function(){
//    	if($(this).hasClass("dis")){
//    		$(".jf-mask").fadeIn();
//    	}else 
        if($(this).hasClass("cur")){
            $(".hongbao-select>li")[0].click();
    		$(this).toggleClass("cur");
            UseMoneyStyle();
    	}else{
                if(needPoints > '<%=ViewData["myPoints"] %>' *1){
                $("#tishi_msg").html('您的积分为<%=ViewData["myPoints"]%>，不够兑换此订单');
                    $(".alert").fadeIn();
//    		        $(".jf-mask").fadeIn();
                    return false;
                }
            $(".hongbao-select>li")[0].click();
    		$(this).toggleClass("cur");
            UseScoreStyle();
        }
    });

    function UseMoneyStyle(){
            $("#div_pay").html("立即支付");
            $("#p_useMoney1").show();
            $("#p_useMoney2").show();
            $("#p_showUseMoney").show();
            $("#p_showUseScore").hide();
            $("#p_useScore1").hide();
            $("#p_useScore2").hide();
    }
    
    function UseScoreStyle(){
            $("#div_pay").html("提交订单");
            $("#p_useMoney1").hide();
            $("#p_useMoney2").hide();
            $("#p_showUseMoney").hide();
            $("#p_showUseScore").show();
            $("#p_useScore1").show();
            $("#p_useScore2").show();
    }

            //选择
            $(".sex-select>label").on("click", function () {
            var isTrue = $(this).hasClass("cur");
                $(this).addClass("cur").siblings().removeClass("cur");
                if ($(this).parent().hasClass("address1-select")) {
                    $(".address1").eq($(this).index()).addClass("cur").siblings(".address1").removeClass("cur");
                    if($(this).hasClass("cur") != isTrue){
                        if(!$("#addressOther").hasClass("cur")){
                        sumMoney -= "<%=ViewData["ExpressFee2"] %>" * 1;
                    sumMoney = parseFloat(sumMoney.toFixed(2));
                        expressfee3 = 0;
                        ChangeMoney();
                        }else{
                        sumMoney += "<%=ViewData["ExpressFee2"] %>" * 1;
                    sumMoney = parseFloat(sumMoney.toFixed(2));
                        expressfee3 = "<%=ViewData["ExpressFee2"] %>" * 1;
                        ChangeMoney();
                        }
                    }
                }
            })
            

            //红包
            $(".hongbao-select>li").on("click", function () {
                $(this).addClass("cur").siblings().removeClass("cur");
            })
            $(".hongbao-btn").click(function () {
                if($(".radio").hasClass("cur")){
                    $("#tishi_msg").html("积分购买无需使用红包");
                    $(".alert").fadeIn();
                    return false;
                }
                $(".hongbao-mask").fadeIn();
                $(".mask-bottom-inner").addClass("shin-slide-up");
            })
            $(".mask-close,.mask").click(function () {
                $(".mask").fadeOut();
            })
            $(".mask-bottom-inner").on("click", function (e) {
                e.stopPropagation();
            })
        });
        
        //价格改变时改变显示
            function ChangeMoney() {
                score = parseInt((sumMoney * equivalence * GradePlus).toFixed(2));
                $(".orderScore").html(score);
                $(".orderAmount").each(function () {
                    $(this).html(toDecimal2(sumMoney - couponMoney));
                });
                $(".yu-orange").html(needPoints);
                $(".orderAmountScore").html(needPoints);
                $("#span_needPoints1").html(needPoints);
                $("#span_SurplusPoints").html('<%=ViewData["myPoints"] %>' *1 - needPoints);
            }

        //检查可使用红包
            function CheckCoupon(){
                var haveCoupon = 0;
                $(".hongbao-select").find("input[name='amountlimit']").each(function(){
                    if($(this).val() * 1 <= canCouponSum && canCouponSum >= 0){
                        $(this).parent().show();
                        haveCoupon++;
                    }else{
                        $(this).parent().hide();
                    }
                });
                if(haveCoupon == 0 || useCouponLimit > canCouponSum)
//                   CouponHide();
                    $(".hongbao-select>li")[0].click();
                if(haveCoupon == 0){
                    $(".hongbao-btn").hide();
                }else{
                    $(".hongbao-btn").show();
                }
            }
            //使用红包
            function CouponShow(obj){
                couponMoney = $(obj).find(".yu-fontb").html();
                useCouponLimit = $(obj).find("input[name='amountlimit']").val() * 1;
//                sumMoney = '<%=ViewData["amount"] %>' * foodNum - couponMoney * 1;
                ChangeMoney();
                CouponId = $(obj).find("input[name='CouponId']").val();
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
                useCouponLimit = 0;
                CouponId="";
//                sumMoney = '<%=ViewData["amount"] %>' * foodNum;
                ChangeMoney();
                $("#p_couponMoney").html(couponMoney);
                $("#p_couponPrompt").hide();
                $("#p_couponPrompt2").hide();
                $("#p_couponPrompt3").hide();
                $("#div_couponMoney1").show();
                $("#div_couponMoney2").hide();
            }
        
        function CreateOrder() {
        if(totalNum == 0){
//        layer.msg("请选择商品再进行支付");
                $("#tishi_msg").html("请选择商品再进行支付");
                    $(".alert").fadeIn();
        return;
        }

        var LinkMan = $.trim($("#LinkMan").val());
        var LinkPhone = $.trim($("#LinkPhone").val());
        var remark = $("#Remarks").val();
        var AddressType = "";
        var Address = "";
        if($("#addressOther").hasClass("cur")){
        AddressType = 2;
        Address= $.trim($("#kuaidiAddress").val());
        expressfee3 = "<%=ViewData["ExpressFee2"] %>" * 1;
        }else{
        AddressType = 1;
        var roomNo=$.trim($("#RoomNo").val());
        if(roomNo == ""){
//        layer.msg("请输入房间号！");
                $("#tishi_msg").html("请输入房间号！");
                    $(".alert").fadeIn();
        return false;
        }
        Address= '<%=ViewData["hotelName"] %>' + roomNo;
        }

        if(LinkPhone == "" || LinkMan == "" || Address == ""){
//        layer.msg("请填写联系人、联系电话和收货地址");
                $("#tishi_msg").html("请填写联系人、联系电话和收货地址");
                    $(".alert").fadeIn();
        return;
        }

        
            if($('#div_address1').hasClass("cur")){
                expressfee3=0;
            }
            var useScorePay=0;
            if($(".radio").hasClass("cur"))
                useScorePay=1;
        
        $.post('/DishOrder/SaveAddress/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&weixinID=<%=ViewData["weixinid"] %>&userweixinid=<%=ViewData["userweixinid"] %>&addressid=<%=address.AddressID%>&name='+LinkMan+'&phone='+LinkPhone+'&room='+$("#RoomNo").val()+'&type='+AddressType+'&address=<%=ViewData["hotelName"] %>&kdaddress='+$("#kuaidiAddress").val(), function (data) {});

        $.post('/Supermarket/CreateOrder/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&weixinID=<%=ViewData["weixinid"] %>&userweixinID=<%=ViewData["userweixinid"] %>&remark=' + remark + '&LinkMan='+LinkMan+'&LinkPhone='+LinkPhone+'&AddressType='+AddressType+'&Address='+Address+'&ExpressFee='+expressfee3+'&useScorePay='+useScorePay+'&CouponId='+CouponId+'&CouponMoney='+couponMoney, function (data) {
        
                if (data.orderId == "") {
                $("#tishi_msg").html(data.message);
                    $(".alert").fadeIn();
//                 layer.close(Shielding);
//                    layer.msg(data.message);
                    return false;
                }
                if(data.error == 2){
                $("#tishi_msg").html(data.message);
                    $(".alert").fadeIn();
//                 layer.close(Shielding);
//                    layer.msg(data.message);
                    return false;
                }
                
                sessionStorage.SupperMarketOrderId = data.orderId;
                sessionStorage.SupperMarketIsBack = 1;

               if(useScorePay == 0){
                    window.location.href = "/Recharge/CardPay/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderNo=" + data.orderId;
               }else{
                   window.location.href = "/SupermarketA/OrderDetails2/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&orderid=" + data.orderId;
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
