<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    var products = ViewData["products"] as WeiXin.Models.Home.SaleProduct;

    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string hotelid = RouteData.Values["id"].ToString();

    string userWeiXinID = "";
    userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
    if (weixinID.Equals(""))
    {
        string key = HotelCloud.Common.HCRequest.GetString("key");
        string[] a = key.Split('@');
        weixinID = a[0];
        userWeiXinID = a[1];
    }
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userWeiXinID);


    double graderate = WeiXinPublic.ConvertHelper.ToDouble(ViewData["graderate"]);
    string MemberCardRuleJson = ViewData["MemberCardRuleJson"].ToString();

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();   

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
    <title>填写订单</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.1" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css?v=1.3" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <style>
        .hongbao-mask .copy
        {
            display: none;
        }
    </style>
</head>
<body>
    <article class="full-page">
	  

     <form id="form1" action='/Product/ProductPay/<%=hotelid %>?key=<%=ViewData["key"]%>' method="post">
		<section class="show-body">
			<section class="content2 yu-bpad120r">
				<div class="yu-bgw yu-bmar20r">
					<div class="yu-grid yu-tbpad40r yu-f36r yu-lrpad20r yu-alignc">
						<p class="yu-overflow"><%=   ViewData["hotelname"]%></p> 

						<a href="/Product/ProductDetail/<%=hotelid%>?key=<%=weixinID%>@<%=userWeiXinID%>&ProductId=<%=Request.QueryString["ProductId"] %>" class="close-ico type2"></a>
					</div>
					<div class="yu-lrpad20r yu-f28r yu-c99 yu-bmar40r">
						<p> <%=products.ProductName %></p>
						<p>订单金额：<span class="yu-c40 yu-f24r">￥</span>
                      <span class="yu-c40 yu-f36r"><label  id="totalprice2"></label></span></p>
					</div>
					<div class="yu-h120r yu-grid yu-alignc yu-lrpad20r yu-bor tbor">
						<p class="yu-overflow yu-f28r">购买数量</p>
						<div class="yu-f24r yu-c99 yu-rmar15r">剩余:<span id="stock"><%=Request.QueryString["stock"] %></span></div>
						<div class="ar yu-grid">
							<p class="reduce ico type3">-</p>
							<p class="food-num type3" id="buyAmount" ><%=Request.QueryString["buyAmount"] %></p>
							<p class="add ico type3">+</p>
						</div>
					</div>
				</div>
				<div class="yu-bgw yu-bmar20r yu-lpad10">

          
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 " style="<%= products.ProductType==0 ? "display:none"  : "" %> ">
									<div class="l-ico type2 yu-rmar10"></div>
									<p class="yu-w60 yu-f30r">日期</p>
									<div class="yu-overflow yu-f30r"><%=Request.QueryString["date"] %></div>
								</div>
                         
								<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
									<div class="l-ico type5 yu-rmar10"></div>
									<p class="yu-w60 yu-f30r">联系人</p>
									<div class="yu-overflow"><input type="text" class="yu-input2" placeholder="联系人姓名" name="lxr_name" id="lxr_name"></div>
								</div>
								<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
									<div class="l-ico type6 yu-rmar10"></div>
									<p class="yu-w60 yu-f30r">手机号</p>
									<div class="yu-overflow"><input type="tel" class="yu-input2 phonenum-input" placeholder="用于卖家联系您" class="phonenum-input" name="lxr_mobile" id="lxr_mobile"  maxlength="11"  /></div>
								</div>
							 
                                
                        	<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 yu-arr hongbao-btn" style="display:none">
									<div class="l-ico type8 yu-rmar10"></div>
									<p class="yu-w60 yu-f30r">红包</p>
									<div class="yu-overflow tip_youhongbao">
										<p class="yu-c40 yu-f36r"><i class="yu-font12">￥</i><label id="couponprice">0</label></p>
										<p class="yu-c66 yu-f22r">已从费用金额中扣除</p>
									</div>
                                        <p class="yu-overflow yu-f30r yu-textr yu-c99 yu-rpad30r tip_wuhongbao"  style="display:none">暂无可用</p>
								</div>

                                
								<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
									<div class="l-ico type9 yu-rmar10"></div>
									<p class="yu-w60 yu-f30r">总价</p>
									<div class="yu-overflow">
											<p class="yu-c40 yu-f36r"><i class="yu-font12">￥</i><label id="totalprice" ></label></p>
									<p class="yu-c66 yu-f22r">	 <span class="discountstr"  style="display:none"  > 已优惠<label>0</label>元</span>
                            <span class="memberpointsstr" style="display:none" >可获<i class="yu-c40 memberpoints">0</i>积分</span>
                            </p>
									</div>
								</div>
 


							</div>
					<div class="yu-bgw yu-bmar20r">
						<ul class="select-li ul-zf">
							<li class="yu-grid yu-alignc yu-h100r yu-lrpad20r yu-bor bbor zf-wx">
								<p class="pay-ico weixin yu-rmar30r"></p>
								<p class="yu-overflow yu-f28r">微信支付</p>
								<p class="radio-ico"></p>
							</li>
                
							<li class="yu-grid yu-alignc yu-h100r yu-lrpad20r  zf-card" style="display:none">
								<p class="pay-ico alipay yu-rmar30r"></p>
								<p class="yu-overflow yu-f28r">储值卡支付</p>
								<p class="radio-ico"></p>
							</li>
                    
						</ul>
					</div>
			</section>
		</section>
		<footer class="yu-grid fix-bottom yu-bor tbor yu-lpad10 sp">
				<div class="yu-overflow">
					<p class="yu-f36r  yu-c40">合计￥<label class="actualprice"></label> </p>
				</div>
			      <input type="button" value="立即支付" class="yu-btn yu-bg40  pay-btn"  />
                <input  id="single_price" type="hidden" value="<%=ViewData["singleMoney"] %>"  />
                 <input  id="card_balance" type="hidden" value="<%=ViewData["balance"] %>"  />
			</footer>
			<!--红包-->

            </form>
	 
    <section class="mask hongbao-mask">
		<div class="mask-bottom-inner yu-bgw">
			<p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">红包</p>
			<ul class="yu-lrpad10 yu-c99 hongbao-select bl">

            	<li class="yu-h120r yu-grid yu-alignc yu-bor bbor  no-usehongbao">
					<p class="yu-overflow yu-f34r">不使用红包 <i class="yu-f50r yu-fontb couponmoney"  style="display:none">0</i></p>
					<p class="copy-radio"></p>
				</li>

            

                	<li class="yu-h120r yu-grid yu-alignc yu-bor bbor copy">
					<p class="yu-rmar10 yu-l120r"><i class="yu-f25r">￥</i><i class="yu-f50r yu-fontb couponmoney">0</i></p>
					<div class="yu-overflow yu-f24r">
						<p><label  class="couponqiyong"></label>元起用</p>
					<p>有效期<span class="couponstdate"></span>-<span class="couponendate"></span></p>
					</div>
					<p class="copy-radio hongbao_gou"></p>
				</li>

         
		 
			</ul>
			<div class="yu-l100r yu-h100r yu-bgblue2 yu-white  yu-textc mask-close yu-font32r">关闭</div>
		</div>
	</section>


         <!--弹窗-->
    <section class="mask alert">
		 
		<div class="inner yu-w480r">
			<div class="yu-bgw">
				<p class="yu-lrpad40r yu-tbpad50r yu-textc yu-bor bbor yu-f30r tipmsg" >请您输入订购信息</p>
				<div class="mask-close yu-tbpad30r yu-textc yu-c40 yu-f36r">知道了</div>
			</div>
		</div>
	</section> 


	</article>
    <% ViewData["key"] = Request.QueryString["key"]; ViewData["hId"] = hotelid; %>
    <% Html.RenderPartial("QuickNavigation", null); %>
    <script>

        var memberJson = $.parseJSON('<%=MemberCardRuleJson %>');

        $(function () {

            calculatePrice();

            if ('<%=products.IsUsehongbao %>' == "1") {
                fetchcouponlist();
            }



            //选项卡
            var tabIndex;
            $(".tab-nav").children("li").on("click", function () {
                $(this).addClass("cur").siblings("li").removeClass("cur");
                tabIndex = $(this).index();
                $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
            })
            //加减餐
            var foodNum = 0;
            $(".add").on("click", function () {

                //                $(this).siblings(".food-num").text(1);
                //                return false;


                if ($(this).siblings(".food-num").text() == "") {
                    foodNum = 1;
                    $(this).siblings(".food-num").text(foodNum);
                } else {
                    foodNum = parseInt($(this).siblings(".food-num").text());

                    if ((foodNum + 1) > parseInt($("#stock").text())) {
                        return false;
                    }

                    foodNum++;
                    $(this).siblings(".food-num").text(foodNum);

                };

                calculatePrice();

            });

            $(".reduce").on("click", function () {
                foodNum = parseInt($(this).siblings(".food-num").text());
                if (foodNum > 1) {
                    foodNum--;
                    $(this).siblings(".food-num").text(foodNum);
                    calculatePrice();

                };
            });
            //套餐选择
            $(".select-li").children("li").on("click", function () {
                $(this).addClass("cur").siblings().removeClass("cur");
            })
            //红包
            $(".hongbao-select>li").on("click", function () {
                //                if (!$(this).hasClass("dis")) {
                //                    $(this).addClass("cur").siblings().removeClass("cur");

                //                }
            })
            $(".hongbao-btn").click(function () {
                $(".hongbao-mask").fadeIn();
                $(".mask-bottom-inner").addClass("shin-slide-up");
            })
            $(".mask-close").click(function () {
                $(".mask").fadeOut();
            })
            $(".mask-bottom-inner").on("click", function (e) {
                //   e.stopPropagation();
            })

            //只能输入数字
            $(".phonenum-input").keyup(function () {
                this.value = this.value.replace(/[^\d]/g, '');
            })

        })


        $(".hongbao-mask li").click(function () {

            //            if ($(this).hasClass("dis")) {
            //                return;
            //            }
            //            var couponid = $(this).attr('couponid');
            //            if (couponid == undefined) {
            //                couponid = 0;
            //            }
            //            $('#couponprice').attr('couponid', couponid);

            //            var money = $(this).find(".couponmoney").text().trim();

            //            $('#couponprice').text(money);
            //            if (money > 0) {
            //                $('#couponprice').closest('.hongbao-btn').show();
            //            }

            //            calculatePrice();

            //            $(this).parents(".mask").fadeOut();
        })



        function calculatePrice() {

            var saleprice = mul(parseFloat($("#single_price").val()), $(".food-num").text());
            ShowHongbao(saleprice);

            var couponprice = parseInt($('#couponprice').text());
            var totalprice = sub(saleprice, couponprice);

            var discountprice = couponprice;
            if (discountprice > 0) {
                $('.discountstr label').text(discountprice);
                $('.discountstr').show();
            }

            var actualprice = totalprice;
            $('.actualprice').text(actualprice);
            $('#totalprice').text(actualprice);
            $('#totalprice2').text(actualprice);


            if (memberJson["rule"]['GradePlus'] > 0) {
                var memberpoints = parseInt(totalprice * memberJson["rule"]['GradePlus'] * memberJson["rule"]['equivalence']);
                $('.memberpoints').text(memberpoints);
                if (memberpoints > 0) {
                    $('.memberpointsstr').show();
                }
            }

            if (parseFloat($("#card_balance").val()) >= actualprice) {
                $(".zf-card").css("display", "");
            }
            else {

                $(".zf-card").css("display", "none");

            }

            $(".ul-zf li").removeClass("cur");

            if ($(".zf-card").is(':hidden')) {
                $(".zf-wx").addClass("cur");
            }
        }


        function fetchcouponlist() {
            var that = $('.hongbao-mask ul');
            $('.hongbao-mask  ul  li[couponid]').remove();

            $.ajax({
                url: '/action/getCouponlist',
                type: 'post',
                data: { hotelWeixinid: '<%=weixinID %>', userWeixinid: '<%=userWeiXinID %>', key: '<%=HotelCloud.Common.HCRequest.GetString("key") %>', type: "tuan" },
                success: function (data) {
                    couponjson = $.parseJSON(data);
                    $.each(couponjson, function (k, coupon) {
                        var div = $('.hongbao-mask .copy').clone(true).removeClass('copy');
                        div.find('.couponmoney').text(coupon['Moneys']);
                        div.find('.couponstdate').text(getcoupondatestr(coupon['sTime']));
                        div.find('.couponendate').text(getcoupondatestr(coupon['ExtTime']));
                        div.find('.couponqiyong').text(coupon['AmountLimit']);
                        div.attr('couponid', coupon['Id']);
                        div.attr('amountlimit', coupon['AmountLimit']);
                        that.append(div);
                    });
                    if ($('.hongbao-mask li[couponid]').length > 0) {
                        $('#couponprice').closest('.hongbao-btn').show();
                        calculatePrice();
                        //  $('.hongbao-mask  li[couponid]:first').trigger('click');

                    }
                }
            });

        }


        function ShowHongbao(curr_price) {


            var no_hb = "";

            $('.hongbao-mask  li[couponid]').each(function (i, item) {

                if ($(this).find(".couponmoney").text().trim() >= parseFloat(curr_price) || parseFloat($(this).attr("amountlimit")) > parseFloat(curr_price)) {
                    $(this).find(".hongbao_gou").removeClass("copy-radio");
                    $(this).addClass("dis");

                    if ($(this).hasClass("cur")) {
                        $(this).removeClass("cur");
                        $('#couponprice').text("0");
                        $('#couponprice').attr('couponid', 0);
                        no_hb = "sys";
                    }
                }

                else {
                    $(this).find(".hongbao_gou").addClass("copy-radio");
                    $(this).removeClass("dis");
                }
            });


            if (($('.hongbao-mask  li.cur').length == 0 || ($(".no-usehongbao").hasClass("cur") && no_hb != "")) && $('.hongbao-mask  li[couponid]:not(".dis")').length > 0) {

                var curr_hongbao_li = $('.hongbao-mask  li[couponid]:not(".dis"):first');
                $(curr_hongbao_li).addClass("cur").siblings().removeClass("cur");
                var couponid = $(curr_hongbao_li).attr('couponid');
                $('#couponprice').attr('couponid', couponid);
                var money = $(curr_hongbao_li).find(".couponmoney").text().trim();
                $('#couponprice').text(money);
            }

            if ($('.hongbao-mask  li[couponid].dis').length > 0) {

                var curr_dis = $('.hongbao-mask  li[couponid].dis');
                $('.hongbao-mask  li[couponid].dis').remove();
                $('.hongbao-mask ul').append(curr_dis);
            }



            $(".tip_wuhongbao").hide();
            $(".tip_youhongbao").show();
            $(".tip_wuhongbao").text("暂无可用");

            if ($('.hongbao-mask  li[couponid]:not(.dis)').length == 0) {
                $(".tip_wuhongbao").show();
                $(".tip_youhongbao").hide();

            }

            if ($('.hongbao-mask  li[couponid]:not(.dis)').length > 0 && $(".no-usehongbao").hasClass("cur")) {
                $(".tip_wuhongbao").show();
                $(".tip_wuhongbao").text("请选择");
                $(".tip_youhongbao").hide();

            } 


            $('.hongbao-mask  li').unbind();
            $('.hongbao-mask  li').bind('click', function () {
                if ($(this).hasClass("dis")) {
                    return;
                }
                $(this).addClass("cur").siblings().removeClass("cur");

                var couponid = $(this).attr('couponid');
                if (couponid == undefined) {
                    couponid = 0;
                }
                $('#couponprice').attr('couponid', couponid);

                var money = 0;
                if (couponid > 0) {
                    money = couponjson['_' + couponid]['Moneys'];
                }

                $('#couponprice').text(money);
                if (money > 0) {
                    $('#couponprice').closest('.hongbao-btn').show();
                }
                calculatePrice();
                $(this).parents(".mask").fadeOut();

            });

        }


        $('.pay-btn').click(function () {

            $(".pay-btn").attr("disabled", true);

            if ($("#lxr_name").val().trim() == "") {

                $(".alert  .tipmsg").text("联系人不能为空");
                $(".alert").show();

                $(".pay-btn").attr("disabled", false);
                return false;
            }


            if (!/^1\d{10}$/.test($("#lxr_mobile").val().trim())) {

                $(".alert  .tipmsg").text("手机号码不正确");
                $(".alert").show();
                $(".pay-btn").attr("disabled", false);
                return false;

            }


            if ($(".ul-zf li.cur").length == 0) {

                $(".alert  .tipmsg").text("请选择支付方式");
                $(".alert").show();
                $(".pay-btn").attr("disabled", false);
                return false;

            }

            $(".pay-btn").attr("disabled", true);
            var saveinfo = {};

            saveinfo["lxr_name"] = $("#lxr_name").val().trim();
            saveinfo["lxr_mobile"] = $("#lxr_mobile").val().trim();
            saveinfo["traveldate"] = '<%=Request.QueryString["date"] %>';

            saveinfo["productid"] = '<%=Request.QueryString["ProductId"] %>';
            saveinfo["tcid"] = '<%=Request.QueryString["tcId"] %>';
            saveinfo["t"] = '<%=Request.QueryString["t"] %>';
            saveinfo["sign"] = '<%=Request.QueryString["sign"] %>';

            saveinfo["bookingcount"] = $("#buyAmount").text();

            var zhifutype = $(".ul-zf li.cur").hasClass("zf-card") ? "card" : "wx";
            saveinfo["zhifutype"] = zhifutype;

            var actualprice = parseFloat(($('.actualprice:eq(0)').text()));
            saveinfo['ssumprice'] = actualprice;



            saveinfo['cardno'] = memberJson["rule"]["CardNo"];
            saveinfo['memberid'] = memberJson['memberid'];

            var originalsaleprice = actualprice + parseInt($('#couponprice').text());
            saveinfo['originalsaleprice'] = originalsaleprice;
            saveinfo['couponid'] = $('#couponprice').attr('couponid');
            saveinfo['couponprice'] = parseInt($('#couponprice').text());
            saveinfo['graderate'] = memberJson["rule"]['GradeRate'];
            saveinfo['gradename'] = memberJson["rule"]['GradeName'];
            saveinfo['isvip'] = 0;

            var memberpoints = parseInt($('.memberpoints').text());
            saveinfo['jifen'] = memberpoints;

            $.ajax({
                url: '/Product/ProductPay/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>',
                type: 'post',
                data: { saveinfo: JSON.stringify(saveinfo) },
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {

                        var gohref = '/Recharge/CardPay/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>&paytype=' + zhifutype + '&orderno=' + ajaxObj.Mess;
                        window.location.href = gohref;

                    }
                    else {

                        $(".alert  .tipmsg").text(ajaxObj.Mess);
                        $(".alert").show();

                        $(".pay-btn").attr("disabled", false);
                    }

                }
            });
        });


        function add(a, b) {
            var c, d, e;
            try {
                c = a.toString().split(".")[1].length;
            } catch (f) {
                c = 0;
            }
            try {
                d = b.toString().split(".")[1].length;
            } catch (f) {
                d = 0;
            }
            return e = Math.pow(10, Math.max(c, d)), (mul(a, e) + mul(b, e)) / e;
        }

        function sub(a, b) {
            var c, d, e;
            try {
                c = a.toString().split(".")[1].length;
            } catch (f) {
                c = 0;
            }
            try {
                d = b.toString().split(".")[1].length;
            } catch (f) {
                d = 0;
            }
            return e = Math.pow(10, Math.max(c, d)), (mul(a, e) - mul(b, e)) / e;
        }

        function mul(a, b) {
            var c = 0,
        d = a.toString(),
        e = b.toString();
            try {
                c += d.split(".")[1].length;
            } catch (f) { }
            try {
                c += e.split(".")[1].length;
            } catch (f) { }
            return Number(d.replace(".", "")) * Number(e.replace(".", "")) / Math.pow(10, c);
        }

        function div(a, b) {
            var c, d, e = 0,
        f = 0;
            try {
                e = a.toString().split(".")[1].length;
            } catch (g) { }
            try {
                f = b.toString().split(".")[1].length;
            } catch (g) { }
            return c = Number(a.toString().replace(".", "")), d = Number(b.toString().replace(".", "")), mul(c / d, Math.pow(10, f - e));
        }


        //返回yyyy.MM.dd格式
        function getcoupondatestr(_date) {
            var date = new Date(_date.match(/\d+/)[0] * 1);
            var year = date.getYear() + 1900;
            var month = date.getMonth() + 1;
            var day = date.getDate();
            if (month < 10) {
                month = '0' + month;
            }
            if (day < 10) {
                day = '0' + day;
            }
            return year.toString() + '.' + month.toString() + '.' + day.toString();
        }

    </script>
</body>
</html>
