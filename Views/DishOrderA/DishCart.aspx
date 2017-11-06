<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%        
    string hotelid = RouteData.Values["id"].ToString();
    string key = HotelCloud.Common.HCRequest.GetString("key");
    string weixinID = "";
    string userWeiXinID = "";
    if (key.Contains("@"))
    {
        
        string[] a = key.Split('@');
        weixinID = a[0];
        userWeiXinID = a[1];
    }
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userWeiXinID);

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();

    string ordertips = ViewData["ordertips"] + "";

    hotel3g.Models.Youhui manjian_model = (hotel3g.Models.Youhui)ViewData["manjian_model"];//消费满减


    int eatatstore = (int)ViewData["eatatstore"]; //默认0：外卖 1堂食
    int openaddress = (int)ViewData["openaddress"];//默认0:开启地址 1:关闭
    int tid = HotelCloud.Common.HCRequest.getInt("tid");
    
    
%>
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
    <title>购物车</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.1"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css?v=1.1"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css?v=1.1"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mobileSelect.css">
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css?v=1.1"/>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js?v=1.1"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/mobileSelect.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js?v=1.1"></script>
</head>
<body >
	<article class="full-page">
    <% if (tid == Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
       { %>
		 <%Html.RenderPartial("HeaderA", viewDic);%>
         <%} %>
		<section class="show-body">
			<% 
		        System.Data.DataTable dt = (System.Data.DataTable)ViewData["dishCart"];
                hotel3g.Models.OrderAddress oAddress = (hotel3g.Models.OrderAddress)ViewData["address"];
                hotel3g.Repository.MemberCardIntegralRule rule = ViewData["hasRule"] as hotel3g.Repository.MemberCardIntegralRule;//优惠政策
                decimal Amount = (decimal)ViewData["Amount"];
			    decimal total = (decimal)ViewData["total"];
			    decimal YouHuiMoney = 0;
                decimal MealGradeRate = 0;
                int MealCouponType = -1;

                string strDiscountID ="0";	    	    	    
                if (rule != null)
                {
                    MealCouponType = rule.MealCouponType;
                    if (rule.MealCouponType == 1) //立减
                    {
                        YouHuiMoney = rule.MealReduce;
                    }
                    if (rule.MealCouponType == 0) //折扣
                    {
                        //YouHuiMoney = Amount * (10 - rule.MealGradeRate) / 10;
                        MealGradeRate = rule.MealGradeRate;
                        foreach (System.Data.DataRow row in dt.Rows)
                        {
                            YouHuiMoney += (decimal.Parse(row["price"] + "") - decimal.Parse(row["discountprice"] + "")) * Convert.ToInt32(row["number"]);
                            if (decimal.Parse(row["discount"]+"") > 0)
                            {
                                strDiscountID += "," + row["DishsesID"];
                            }
                        }
                    }
                }	    
			    	     %>
			<section class="content2 yu-bpad60">
                <% if (!string.IsNullOrEmpty(ordertips))
                   { %>
                <div class="yu-grid yu-alignc charge-tip yu-lrpad20r yu-f22r yu-c40">
					<span class="iconfont icon-gonggao y-f22r yu-rmar10r"></span>
					<span>提示：<%=ordertips %></span>
				</div>
                <% } %>
				<div class="yu-bgw yu-bmar10 yu-lpad10 yu-f30r">
					<% 
                        if (tid == Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
                        {
                            if (eatatstore == Convert.ToInt32(hotel3g.Models.EnumEatAtStore.外卖))
                            { %>
                    <div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<div class="l-ico type5 yu-rmar10"></div>
						<p class="yu-w60">联系人</p>
						<div class="yu-overflow">
                        <input type="hidden" id="addressid" value="<%=oAddress.AddressID %>" />
                        <input id="linkMan" type="text" class="yu-input2" placeholder="请输入姓名" value="<%=oAddress.LinkMan %>"></div>
					</div>
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<div class="l-ico type6 yu-rmar10"></div>
						<p class="yu-w60 yu-f30r">手机号</p>
						<div class="yu-overflow"><input id="linkPhone" type="number" class="yu-input2" maxlength="11" placeholder="请输入订餐人手机号码" value="<%=oAddress.LinkPhone %>"/></div>
					</div>
                    
                    <% if (openaddress == Convert.ToInt32(hotel3g.Models.EnumStoreOpenAddress.开启))
                       { %>
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 yu-f30r">
						
						<p class="yu-overflow ">收货地址</p>
						<div class="yu-grid sex-select yu-alignc address1-select">
                            <input type="hidden" value="<%=oAddress.addressType == 2 ? 2 : 1 %>" id="addressType" />
							<label class="yu-rmar10 <%=oAddress.addressType != 2 ? "cur" : "" %>" onclick="$('#addressType').val(1);$(this).addClass('cur').siblings().removeClass('cur');$('#ad1').addClass('cur');$('#ad2').removeClass('cur');">
								<span>酒店</span><span class="ico"></span>
							</label>
							<label <%=oAddress.addressType == 2 ? "class='cur'" : "" %> onclick="$('#addressType').val(2);$(this).addClass('cur').siblings().removeClass('cur');$('#ad2').addClass('cur');$('#ad1').removeClass('cur');">
								<span>其它</span><span class="ico"></span>
							</label>
						</div>
					</div>
					<div class="address1 <%=oAddress.addressType != 2 ? "cur" : "" %>" id="ad1">
						<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
							<div class="l-ico type10 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">房间号</p>
							<div class="yu-overflow"><input type="text" id="roomno" class="yu-input2" placeholder="" value="<%=oAddress.RoomNo %>"></div>
						</div>
					</div>
					<div class="address1 <%=oAddress.addressType == 2 ? "cur" : "" %>" id="ad2">
						<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
							<div class="l-ico type11 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">其它</p>
							<div class="yu-overflow"><input type="text" id="other" class="yu-input2" placeholder="" value="<%=oAddress.kuaidiAddress %>"></div>
						</div>
					</div>
                    <%}
                            }
                            else  //堂食[只需桌号]
                            { %>
                        <div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						    <div class="l-ico type5 yu-rmar10"></div>
						    <p class="yu-w60">取餐方式</p>
						    <div class="yu-overflow">送餐到桌</div>
					    </div>
                        <div class="yu-h50 yu-bor bbor yu-grid yu-alignc ">
						    <div class="l-ico type10 yu-rmar10"></div>
						    <p class="yu-w60">桌台号</p>
						    <div class="yu-overflow"><input type="text" class="yu-input2" id="select-desk" placeholder="请选择桌台或输入餐台号" value="<%=ViewData["tablenumber"] %>"></div>
						    <div class="yu-arr" id="trigger2"></div>
					    </div>
                    <%
                        }
                        }
                        else { 
                        %>
                        <div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						    <div class="l-ico type5 yu-rmar10"></div>
						    <p class="yu-w60">取餐方式</p>
						    <div class="yu-overflow">送餐到桌</div>
					    </div>
                        <div class="yu-h50 yu-bor bbor yu-grid yu-alignc ">
						    <div class="l-ico type10 yu-rmar10"></div>
						    <p class="yu-w60">桌台号</p>
						    <div class="yu-overflow"><input type="text" class="yu-input2" id="select-desk" placeholder="请选择桌台或输入餐台号" value="<%=ViewData["tablenumber"] %>"></div>
						    <div class="yu-arr" id="trigger2"></div>
					    </div>
                       <%
                        }
                        %>

                   
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<div class="l-ico type7 yu-rmar10"></div>
						<p class="yu-w60 yu-f30r">备注</p>
						<div class="yu-overflow"><input type="text" id="remo" class="yu-input2" placeholder="请输入其它要求"></div>
					</div>
                    <div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 timeselect">
						<div class="l-ico type7 yu-rmar10"></div>
						<p class="yu-w60 yu-f30r">用餐时间</p>
						<div class="yu-overflow yu-f30r selecttime">实时<%--<%=DateTime.Now.ToString("HH:mm")+"-"+DateTime.Now.AddHours(1).ToString("HH:mm") %>--%></div>
					</div>

					<%  System.Data.DataTable couponDataTable = (System.Data.DataTable)ViewData["couponDataTable"]; %>
                    <div style="display:<%=couponDataTable.Rows.Count>0?"block":"none" %>" id="div_hongbao_id">
                    <input type="hidden" id="couponMoneyIsBiggerAmount" value="0" />
                    <div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 yu-arr hongbao-btn">
						<div class="l-ico type8 yu-rmar10"></div>
						<p class="yu-w60">红包</p>
                       <div class="yu-overflow" id="div_couponMoney1">
					        <p class="yu-f30r yu-c99">请选择优惠红包</p>
						</div>
						<div class="yu-overflow" id="div_couponMoney2" style="display:none;">
							<p class="yu-c40 yu-f36r"><i class="yu-f30r">￥</i><span id="p_couponMoney">0</span></p>
							<p class="yu-c66 yu-f22r" id="p_couponPrompt" style="display:none;">已从商品金额中扣除</p>
						</div>
					</div>
                    </div>
                    
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<div class="l-ico type9 yu-rmar10"></div>
						<p class="yu-w60">总价</p>
						<div class="yu-overflow">
							<p class="yu-c40 yu-font22"><i class="yu-font12">￥</i><span id="span-total-amount"><%=(Amount-YouHuiMoney).ToString("f2")%></span></p>
							<p class="yu-c66 yu-font12">
                            <% if (YouHuiMoney>0)
                               { %>
                               会员优惠<span id="id_youhui"><%=YouHuiMoney.ToString("f2")%></span>元,
                            <% } %>
                            可获<i class="yu-c40" id="id_jifen"><%=ViewData["orderScore"]%></i>积分</p>
						</div>
					</div>
                    
				</div>

               
				<div>
					<p class="yu-lpad10 yu-bmar10 yu-f30r">已选<label id="lbl_dishCount"><%=dt.Rows.Count%></label>件商品</p>
					<ul class="yu-bgw yu-bor tbor yu-lpad10">
						<% 
                            decimal bagging = 0;
                            decimal canCouponTotalMoney = 0; //可使用红包菜品的总金额			    			    
                            foreach (System.Data.DataRow row in dt.Rows)
                            {
                                if (row["canCoupon"] + "" == "1") { canCouponTotalMoney += decimal.Parse(row["price"]+"") * Convert.ToInt32(row["number"]); }
                                %>
                        <li class="yu-grid yu-alignc yu-bor bbor yu-tbpad10 yu-rpad10">
							<div class="food-pic"><img src="<%=row["DishesImg"] %>"></div>
							<div class="yu-overflow">
								<p class="yu-font14"><%=row["dishesName"]%></p>
								<div class="yu-font12 yu-grey yu-bmar5 yu-grid"><%if (Convert.ToDouble(row["discount"]) > 0){ %>会员<%=Convert.ToDouble(row["discount"])%>折<%} %></div>
								<div class="yu-grid yu-alignc">
									<p class="yu-overflow yu-c40"><i class="yu-font12">￥</i><i class="yu-font18" id="price_<%=row["DishsesID"]%>"><%=row["price"]%></i></p>
											
								</div>
							</div>
							<div class="ar yu-grid">
                                <input type="hidden" class="dish-id" value='<%=row["DishsesID"]%>' id="hid_dish_<%=row["DishsesID"]%>" />
								<p class="reduce ico type2" style="display:block"></p>
								<p class="food-num"  style="display:block" id="foodnum_<%=row["DishsesID"]%>"><%=row["number"] %></p>
								<p class="add ico type2"></p>
							</div>
						</li>
                        <% } %>
						
					</ul>
				</div>
				
			</section>
			<footer class="yu-grid fix-bottom yu-bor tbor yu-lpad10 sp">
	            <input type="hidden" id="hid_amount" value="<%=Amount %>" /><!--未打折的金额--->
                <input type="hidden" id="hid_hongbaoid" value="0" />
				<div class="yu-overflow">
					<p id="p_amount" class=" yu-f30r">合计￥<%=(Amount - YouHuiMoney - manjian_model.DelMoney).ToString("f2")%></p>
					<p class="yu-grey yu-font12"  id="manjianremoID"><%=manjian_model.Remo %></p>
                    <p class="yu-grey yu-font12">包含服务及增值税￥0</p>
				</div>
				<div class="yu-btn yu-bg40" onclick="javascript:toPay()">立即支付</div>
				<input type="hidden" id="canCouponTotalMoneyId" value="<%=canCouponTotalMoney %>" /><!--可使用红包菜品总金额--->
                <input type="hidden" id="hid_manjianmoney" value="<%=manjian_model.DelMoney %>" />
			</footer>
		</section>
        <!--弹窗-->
	    <section class="mask alert">
		    <div class="inner yu-w480r">
			    <div class="yu-bgw">
				    <p class="yu-lrpad40r yu-tbpad50r yu-textc yu-bor bbor yu-f30r" id="tishi_msg">请您输入必填信息</p>
				    <div class="yu-h80r yu-l80r yu-textc yu-c40 yu-f36r yu-grid">
					    <%--<p class="yu-overflow yu-bor rbor yu-c99">确定</p>--%>
					    <p class="yu-overflow mask-close" id="tishi_close">好的，知道了</p>
					
				    </div>
			    </div>
		    </div>
	    </section>
		<!--红包-->
	<section class="mask hongbao-mask">
		<div class="mask-bottom-inner yu-bgw">
			<p class="yu-h60 yu-line60 yu-textc yu-bor bbor">红包</p>
			<ul class="yu-lrpad10 yu-c40 hongbao-select">
				<li class="yu-h60 yu-grid yu-alignc yu-bor bbor cur"  onclick="CouponHide()">
					<p class="yu-overflow">不使用红包</p>
					<p class="copy-radio"></p>
				</li>
                <% foreach (System.Data.DataRow data in couponDataTable.Rows)
                   { %>
				<li class="yu-h60 yu-grid yu-alignc yu-bor bbor"  onclick="CouponShow(this)">
                    <input type="hidden" name="CouponId" value="<%=data["id"]%>" />
                    <input type="hidden" name="amountlimit" value="<%=data["amountlimit"]%>" />
					<p class="yu-rmar10"><i class="yu-font12">￥</i><i class="yu-font26 yu-fontb"><%=data["moneys"]%></i></p>
					<div class="yu-overflow yu-font12">
						<p><%=data["amountlimit"]%>元起用</p>
						<p>有效期<%=DateTime.Parse(data["sTime"].ToString()).ToShortDateString()%>-<%=DateTime.Parse(data["ExtTime"].ToString()).ToShortDateString()%></p>
					</div>
					<p class="copy-radio"></p>
				</li>
                <% } %>

                <%--<li class="yu-h60 yu-grid yu-alignc yu-bor bbor"  onclick="CouponShow(this)">
                    <input type="hidden" name="CouponId" value="333" />
                    <input type="hidden" name="amountlimit" value="500" />
					<p class="yu-rmar10"><i class="yu-font12">￥</i><i class="yu-font26 yu-fontb">30</i></p>
					<div class="yu-overflow yu-font12">
						<p>500元起用</p>
						<p></p>
					</div>
					<p class="copy-radio"></p>
				</li>--%>
			</ul>
			<div class="yu-h60 yu-bg40 yu-white yu-line60 yu-textc mask-close">关闭</div>
		</div>
	</section>
    <!--时间--> 
	<section class="mask lasttime-mask">
		<div class="mask-bottom-inner yu-bgw">
			<p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">预计用餐时间</p>
			<ul class="yu-lrpad10 yu-c99 usetime-select" id="ul-time">
                  <li class="yu-h120r yu-grid yu-alignc yu-bor bbor">
					<div class="yu-overflow yu-f30r timelist">实时</div>
					<p class="copy-radio"></p>
				</li>
                 <% 
                    var dd = DateTime.Now.Hour;
                    int count = 50- 2*dd;
                    for (int k = 1; k < count; k++)
                   {
                       int mins = k*30;
                     %>
                <li class="yu-h120r yu-grid yu-alignc yu-bor bbor">
					<div class="yu-overflow yu-f30r timelist"><%=DateTime.Now.AddMinutes(mins).ToString("HH:mm") + "-" + DateTime.Now.AddMinutes(mins + 30).ToString("HH:mm")%></div>
					<p class="copy-radio"></p>
				</li>
               <% } %>
			</ul>
			<div class="yu-l100r yu-h100r yu-bg40 yu-white  yu-textc mask-close yu-font32r" style="display:none">关闭</div>
		</div>
	</section>
	</article>
     <%  hotel3g.Repository.MemberCardIntegralRule IntegralRule = (hotel3g.Repository.MemberCardIntegralRule)ViewData["IntegralRule"]; %>
	<script>
        var e ='<%=IntegralRule.equivalence%>' * 1;
        var g = '<%=IntegralRule.GradePlus%>' * 1;
        function changeJifen(paytotal) {
            console.log(paytotal);
            var jifen = 0;
            if (e > 0 && g==0) {
                jifen = parseInt(paytotal *equivalence);//
            }
            if (g > 0 && e==0) {
                jifen = parseInt(paytotal *GradePlus );//
            }
            if(e>0 && g>0){
            jifen = parseInt(paytotal *equivalence*GradePlus);
            }
            $('#id_jifen').html(jifen);
        }
	    $(function () {
            var orn='<%=ViewData["orderCode"] %>';
	        if(sessionStorage.IsDishABack == 1 &&sessionStorage.orderNo==orn){
             window.location.href = "/DishOrderA/ViewOrderDetail/<%=ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&key=<%=ViewData["key"] %>&orderCode=<%=ViewData["orderCode"] %>&tid=<%=tid %>";
            }

	        //选项卡
	        var tabIndex;
	        $(".tab-nav").children("li").on("click", function () {
	            $(this).addClass("cur").siblings("li").removeClass("cur");
	            tabIndex = $(this).index();
	            $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
	        })
             
	        //加餐
	        $(".add").on("click", function () {
	            var dishId = $(this).siblings(".dish-id").val();
	            addDish(dishId, this); //点餐
	        });

	        //减餐
	        $(".reduce").on("click", function () {
	            var foodNum = parseInt($(this).siblings(".food-num").text());
	            if (foodNum > 0) {
	                var dishId = $(this).siblings(".dish-id").val();
	                reduceDish(dishId, this);
	            };
	        });

	        //红包
	        $(".hongbao-select>li").on("click", function () {
	            if (!$(this).hasClass("dis")) {
	                $(this).addClass("cur").siblings().removeClass("cur");
	            }
	        })
	        $(".hongbao-btn").click(function () {
	            CheckCoupon(1);
	            $(".hongbao-mask").fadeIn();
	            $(".mask-bottom-inner").addClass("shin-slide-up");
	        })
	        $(".mask-close,.mask").click(function () {
	            $(".mask").fadeOut();
	        })
	        $(".mask-bottom-inner").on("click", function (e) {
	            e.stopPropagation();
	        });

            //时间
		    $(".timeselect").click(function(){
			    $(".lasttime-mask").fadeIn();
			    $(".mask-bottom-inner").addClass("shin-slide-up");
		    })
            //时间sel
	        $(".usetime-select>li").on("click", function () {
                $(this).addClass("cur").siblings().removeClass("cur");
	            $(".lasttime-mask").fadeOut();
                var selecttime = $(this).find(".timelist").text();
                $(".selecttime").text(selecttime);
                $(".mask").fadeOut();
	        });

            //选择桌台
            <% if(tid != Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码)||eatatstore == Convert.ToInt32(hotel3g.Models.EnumEatAtStore.堂食)){ %>
		    var UplinkData = [<%=ViewData["data"] %>];
            //只有trigger 和 wheels 是必要参数  其他都是选填参数
            if(UplinkData.length>0){
                var mobileSelect2 = new MobileSelect({
                    trigger: '#trigger2',
                    title: '选择桌台',
                    wheels: [
	                    { data: UplinkData }
	                ],
                    transitionEnd: function (indexArr, data) {
                        //console.log(data);
                    },
                    callback: function (indexArr, data) {
                        //console.log(data);
                    }
                });
            }
            <%} %>

	    })
	</script>

    <script type="text/javascript">
        var MealCouponType = '<%=MealCouponType %>' * 1;
        var MealGradeRate = '<%=MealGradeRate %>' * 1;
        var YouHuiMoney = '<%=YouHuiMoney %>' * 1;
        var equivalence = '<%=ViewData["equivalence"] %>' * 1;
        var GradePlus = '<%=ViewData["GradePlus"] %>' * 1;

        var discount='<%=strDiscountID %>';
        //检查可使用红包
        function CheckCoupon(op) {
            var canCouponSum = $("#canCouponTotalMoneyId").val() * 1; //可使用红包菜品总金额
            var haveCoupon = 0;
            $(".hongbao-select").find("input[name='amountlimit']").each(function () {
                //console.log($(this).val() * 1);
                if ($(this).val() * 1 <= canCouponSum && canCouponSum >= 0) {
                    $(this).parent().show();
                    haveCoupon++;
                } else {
                    $(this).parent().hide();
                }
            });
            if (haveCoupon == 0 && op == "-1") {
                $(".hongbao-select>li")[0].click();
                $("#div_hongbao_id").hide();
            } else {
                if (haveCoupon > 0) {
                    $("#div_hongbao_id").show();
                    if ($("#couponMoneyIsBiggerAmount").val() == 1) { //红包金额大于订单金额
                        $("#couponMoneyIsBiggerAmount").val(0);
                        $(".hongbao-select>li")[0].click();
                     }
                } else {
                    $("#div_hongbao_id").hide(); 
                }
            }
        }
        //使用红包
        function CouponShow(obj) {
            var couponMoney = $(obj).find(".yu-fontb").html() * 1; //选中的红包金额
            var amount = $("#hid_amount").val() * 1; //订单金额
            if (amount >= couponMoney) {
                var YouHuiMoney = $('#id_youhui').html() == undefined ? 0 : $('#id_youhui').html() * 1;
                var paytotal = amount - couponMoney - YouHuiMoney; //订单金额-红包金额-优惠金额

                changeJifen(paytotal);

                $("#span-total-amount").html(paytotal);
                $("#p_amount").html("合计￥" + paytotal);

                $("#hid_hongbaoid").val($(obj).find("input[name='CouponId']").val());
                $("#p_couponMoney").html(couponMoney); //红包金额
                $("#p_couponPrompt").show();
                $("#div_couponMoney1").hide();
                $("#div_couponMoney2").show();
            } else {
                $("#tishi_msg").html("红包金额不能大于订单金额！");
                $(".alert").fadeIn();
                $("#couponMoneyIsBiggerAmount").val(1);
                return false;
            }
            JiSuanManJian();
        }
        //取消红包
        function CouponHide() {
            var amount = $("#hid_amount").val(); //订单金额
            var YouHuiMoney = $('#id_youhui').html() == undefined ? 0 : $('#id_youhui').html() * 1;
            var paytotal = amount - YouHuiMoney; //订单金额-红包金额-优惠金额
            
            changeJifen(paytotal);
            $("#span-total-amount").html(paytotal);
            $("#p_amount").html("合计￥" + paytotal);

            $("#hid_hongbaoid").val(0);
            $("#p_couponMoney").html(0);
            $("#p_couponPrompt").hide();
            $("#div_couponMoney1").show();
            $("#div_couponMoney2").hide();

            JiSuanManJian();
        }
        CheckCoupon(1);

        //加餐
        function addDish(dishId, that) {
            var bagging = '<%=bagging %>';
            var Hot = 0;
            $.post('/DishOrderA/AddDishOrder/<%=ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&key=<%=ViewData["key"] %>&Hot=' + Hot + '&dishId=' + dishId, function (data) {
                if (data.error == 0) {
                    $("#tishi_msg").html(data.message);
                    $(".alert").fadeIn();
                    return false;
                } else { //添加成功
                    var foodNum = $(that).siblings(".food-num").text();
                    if (foodNum == "") {
                        foodNum = 1;
                        $(that).siblings(".food-num").text(foodNum);
                    } else {
                        foodNum++;
                        $(that).siblings(".food-num").text(foodNum);
                    };
                    //赋值红包总金额
                    $("#canCouponTotalMoneyId").val(data.couponTotalMoney);
                    //计算折扣优惠
                    var total = data.amount * 1;
                    if (MealGradeRate > 0 && MealCouponType == 0 && discount.indexOf(',' + dishId) > -1) {
                        var canyh = 0;
                        var strs = discount.split(',');
                        for (var i = 0; i < strs.length; i++) {
                            if (strs[i] != '0') {
                                canyh += $('#foodnum_' + strs[i]).text() * 1 * $('#price_' + strs[i]).html();
                            }
                        }
                        YouHuiMoney = canyh * (10 - MealGradeRate) / 10;
                        $('#id_youhui').html(YouHuiMoney.toFixed(2));
                    }
                    var hongbao = $("#p_couponMoney").html() * 1; //红包金额
                    var paytotal = total - hongbao - YouHuiMoney; //订单金额-红包金额-优惠金额

                    changeJifen(paytotal);

                    $("#span-total-amount").html(paytotal);
                    $("#p_amount").html("合计￥" + paytotal); //订单金额-红包金额
                    $("#hid_amount").val(total); //订单金额
                    CheckCoupon(1);

                    JiSuanManJian();
                    
                }
            });
        }

        //减餐
        function reduceDish(dishId,that) {
            var bagging = '<%=bagging %>';
            $.post('/DishOrderA/ReduceDishOrder/<%=ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&userWeiXinID=<%=ViewData["userWeiXinID"] %>&dishId=' + dishId, function (data) {
                if (data.error == 0) {
                    $("#tishi_msg").html(data.message);
                    $(".alert").fadeIn();
                    return false;
                } else {//成功
                    var foodNum = parseInt($(that).siblings(".food-num").text());
                    foodNum--;
                    $(that).siblings(".food-num").text(foodNum);
                    if (foodNum == 0) {
                        $(that).parent().parent().hide();
                        var c = parseInt($("#lbl_dishCount").text() - 1);
                        $("#lbl_dishCount").text(c)
                    }
                    //赋值红包总金额
                    $("#canCouponTotalMoneyId").val(data.couponTotalMoney);

                    //计算折扣优惠
                    var total = data.amount * 1;
                    if (MealGradeRate > 0 && MealCouponType == 0 && discount.indexOf(',' + dishId) > -1) {
                        var canyh = 0;
                        var strs = discount.split(',');
                        for (var i = 0; i < strs.length; i++) {
                            if (strs[i] != '0') {
                                canyh += $('#foodnum_' + strs[i]).text() * 1 * $('#price_' + strs[i]).html();
                            }
                        }
                        YouHuiMoney = canyh * (10 - MealGradeRate) / 10;
                        $('#id_youhui').html(YouHuiMoney.toFixed(2));
                    }

                    var hongbao = $("#p_couponMoney").html() * 1; //红包金额
                    var paytotal = total - hongbao - YouHuiMoney; //订单金额-红包金额-优惠金额

                    changeJifen(paytotal);

                    $("#span-total-amount").html(paytotal);
                    $("#p_amount").html("合计￥" + paytotal.toString()); //订单金额-红包金额
                    $("#hid_amount").val(total); //订单金额
                    CheckCoupon(-1);

                    JiSuanManJian();
                    
                }
            });
        }

        ///begin 201708112 
        function JiSuanManJian() {
            var payamount = $("#span-total-amount").html() * 1;
            var youhuiids = '<%=ViewData["youhuiids"] %>';
            $.post('/DishOrder/GetYouhuiAmount/?pamount=' + payamount + '&ids=' + youhuiids, function (data) {
                var m = payamount - data.money * 1;
                $("#p_amount").html("合计￥" + m);
                $("#manjianremoID").html(data.msg);
                $("#hid_manjianmoney").val(data.money);
            });
        }

        ///end
        var eatatstore = '<%=eatatstore %>'; //默认0：外卖 1堂食
        var openaddress = '<%=openaddress %>'; //默认0:开启地址 1:关闭
        var tid='<%=tid %>';

        function toPay() {
            if (validate()) {
                var linkMan = $('#linkMan').val();
                var linkPhone = $('#linkPhone').val();
                var addressType = $('#addressType').val();
                var roomno = $('#roomno').val();
                var other = $('#other').val();
                var remo = $('#remo').val();
                var addressid = $("#addressid").val();

                var couponId = $("#hid_hongbaoid").val();
                var couponMoney = $("#p_couponMoney").html() * 1;

                var usetime = $('.selecttime').text(); //用餐时间
                var jifen = $('#id_jifen').html();
                var yhamount = $('#id_youhui').html() == undefined ? "0" : $('#id_youhui').html();

                var manjianmoney = $("#hid_manjianmoney").val(); //消费满减金额
                var manjianremo = $("#manjianremoID").html(); //消费满减信息

                var tbenumber = $("#select-desk").val();


                if (tid == '<%=Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码) %>') {
                    if (eatatstore == '<%=Convert.ToInt32(hotel3g.Models.EnumEatAtStore.堂食) %>') {
                        tid = '999999991';
                    } 
                }


                var data = { addressid: addressid, linkMan: linkMan, linkPhone: linkPhone, roomno: roomno, other: other, remo: remo, type: addressType,
                    couponId: couponId, couponMoney: couponMoney, usetime: usetime, jifen: jifen, yhamount: yhamount, manjianmoney: manjianmoney, manjianremo: manjianremo,
                    key: '<%=ViewData["key"] %>', orderCode: '<%=ViewData["orderCode"] %>', storeId: '<%=ViewData["storeId"] %>',
                    tablenumber: tbenumber, openaddress: openaddress, eatatstore: eatatstore, tid: tid
                };

                $.post('/DishOrderA/toPay/<%=ViewData["hId"] %>',data, function (data) {
                    if (data.error == 1) { //成功
                        sessionStorage.IsDishABack = 1;
                        sessionStorage.orderNo= '<%=ViewData["orderCode"] %>';
                        //跳转支付 
                        window.location.href = '/Recharge/CardPay/<%=Html.ViewData["hId"]%>?key=<%=Html.ViewData["key"] %>&orderNo=<%=ViewData["orderCode"] %>';
                    } else {
                        $("#tishi_msg").html(data.message);
                        $(".alert").fadeIn();
                    }
                });

             }
        }
        
        function validate() {
            var c = $("#lbl_dishCount").text(); //商品数
            if (c == "" || c == '0') {
                $("#tishi_msg").html("您还没选择任何商品！");
                $(".alert").fadeIn();
                return false;
            }


            if (tid == '<%=Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码) %>') {
                if (eatatstore == '<%=Convert.ToInt32(hotel3g.Models.EnumEatAtStore.外卖) %>') { //外卖

                    var linkMan = $('#linkMan').val();
                    var linkPhone = $('#linkPhone').val();
                    var addressType = $('#addressType').val();
                    var roomno = $('#roomno').val();
                    var other = $('#other').val();
                    var remo = $('#remo').val();
                    if (linkMan == "" || linkPhone == "") {//姓名，电话
                        $("#tishi_msg").html("请输入联系人/手机号！");
                        $(".alert").fadeIn();
                        return false;
                    }
                    //var a = '/^((//(//d{3}//))|(//d{3}//-))?13//d{9}|15[89]//d{8}$/' ;
                    if (linkPhone.length != 11) {
                        $("#tishi_msg").html("请输入正确的手机号！");
                        $(".alert").fadeIn();
                        $('#linkPhone').focus();
                        return false;
                    }

                } else {
                    var tablenumber = $("#select-desk").val();
                    if (tablenumber == '') {
                        $("#tishi_msg").html("请输入桌台号！");
                        $(".alert").fadeIn();
                        $('#select-desk').focus();
                        return false;
                    }
                }

            } else {

                var tablenumber = $("#select-desk").val();
                if (tablenumber == '') {
                    $("#tishi_msg").html("请输入桌台号！");
                    $(".alert").fadeIn();
                    $('#select-desk').focus();
                    return false;
                }
            
            }


            return true;
        }

    </script>
</body>
</html>
