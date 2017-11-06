<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    var shops = ViewData["shops"] as List<hotel3g.Models.Home.WxShop>;
    var wifiJson = ViewData["wifiJson"].ToString();
    var shopJson = ViewData["shopJson"].ToString();
    var passUrl = ViewData["passUrl"].ToString();
    var sucRedirctUrl =  ViewData["sucRedirctUrl"].ToString();
    var ads = ViewData["Ads"] as List<hotel3g.Models.Advertisement>;
    var shopCount = shops.Count(); 
 %>

<!DOCTYPE html>
<html lang="zh-cn">
<head>
	<meta charset="UTF-8" />
	<title>免费WIFI</title>
	<meta name="format-detection" content="telephone=no">
	<!--自动将网页中的电话号码显示为拨号的超链接-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
	<!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
	<meta name="apple-mobile-web-app-capable" content="yes">
	<!--IOS设备-->
	<meta name="apple-touch-fullscreen" content="yes">
	<!--IOS设备-->
	<meta http-equiv="Access-Control-Allow-Origin" content="*">
	<link rel="stylesheet" href="../../css/booklist/mend-reset.css" />
	<link rel="stylesheet" href="../../css/booklist/mend-weikeniu.css" />
	
	<script src="../../Scripts/jquery-1.8.0.min.js"></script>
	<script src="../../Scripts/fontSize.js"></script>
</head>
<body class="bg--ebebeb">
	
	<!-- <>一键连wifi -->
	<div class="sec__oneKey-wifi clearfix">
		<!--//大图滚动-->
		<div class="wifi__banner">
			<div class="swiper-container">
				<div class="swiper-wrapper">
                <%
                    if(ads.Count > 0){
                        foreach (var ad in ads)
	                    {%>
		 					<div class="swiper-slide"><!--推荐图片尺寸：750x750-->
						        <a class="aimg" href="<%=(string.IsNullOrEmpty(ad.LinkUrl) ? "javascript:;" : ad.LinkUrl) %>"><img src="<%=ad.ImageUrl %>" /></a>
					        </div>
	                    <%}
                    }else{%>
                        	<div class="swiper-slide"><!--推荐图片尺寸：750x750-->
						        <a class="aimg" href="javascript:;"><img src="../../images/wifi/defAd.jpg" /></a>
					        </div>
                    <%}
                     %>
				</div>
				<div class="swiper-pagination"></div>
			</div>
		</div>
		
		<div class="wifi__connection-status J__wifiConnectionStep">
			<!--步骤-->
			<div class="wifi__cnnt-panel J_step">
				<div class="wifi-step step01" data-step="1">
					<h2 class="tit">请选择所在门店</h2>
					<div class="options yScroll">
						<ul class = "J_selShop">
                           <%
                               if (shops.Count() > 0) {
                                   for (int i = 0; i < shops.Count(); i++)
                                   {
                                       var s = shops[i];
                                       %>
                                       <li class="flexbox <%=i==0?"on":"" %>" data-id='<%=s.ShopID %>'><span class="text flex1"><%=s.BusinessName+ s.BranchName %></span> <i class="radio"></i></li>
                                   <%}
                               }
                                %>
						</ul>
						<div class="align-c"><a class="btn-next" href="javascript:;">下一步</a></div>
					</div>
				</div>
				<div class="wifi-step step02" data-step="2" style="display:none;">
					<h2 class="tit">请选择Wi-Fi</h2>
					<div class="options yScroll">
						<ul class = "J_selWifi">
						</ul>
						<div class="align-c"><a class="btn-prev" href="javascript:;">上一步</a><a class="btn-next" href="javascript:;">下一步</a></div>
					</div>
				</div>
				<div class="wifi-step step03" data-step="3" style="display:none;">
					<h2 class="tit">连接Wi-Fi</h2>
					<div class="options">
						<ul>
							<!--wifi图标-->
							<li style="padding-bottom:.3rem;height:auto;" id="portalPage">
								<p class="wifi-img"><img src="../../images/wifi/icon__wifi-img.png" /></p>
								<div class="tips align-l" style="padding-left:.2rem;">
                                    <h2>第一步：连接<em class="c--f40">【WIFI】</em>WIFI!</h2>
                                    <h2>第二步：点击以下<em class="c--f40">【认证上网】</em>即可上网!</h2>
									
	<%--								<p class="c--999">正在使用移动数据</p>--%>
								</div>
								<a class="btn-cnnt" href="javascript:;" id="passNet">认证上网</a>
                                <h2 style="color:#999; font-size:.28rem; padding-top:.2rem; line-height: .4rem;">注:请确保已连接WIFI,再点击认证上网,否则无法连网!</h2>
							</li>
							
							<!--二维码图标-->
							<li style="padding-bottom:.3rem;height:auto; display:none;" id="qrCodePage">
								<p class="wifi-img wifi-qrcode align-c">
                                    <img src="#/>
                                    <a class="btn-cnnt" href="javascript:;">长按二维码扫码连接</a>
                                </p>
							</li>
							
						</ul>
					</div>
				</div>
			</div>
			
		</div>

        <!--无可用WIFI-->
        <div class="wifi__connection-status J_noWifi" style="display:none;">
			<!--步骤-->
			<div class="wifi__cnnt-panel">
				<div class="wifi-step">
					<div class="options">
						<ul>
							<!--暂无wifi-->
							<li style="margin-top:.2rem;height:auto; height:calc(100vh - 4.65rem);">
								<p class="wifi-img wifi-error" style="padding-top:2.5rem;"><img src="../../images/wifi/wifi-cnnt-error.png"></p>
								<div class="align-c" style="margin-top:.2rem;">抱歉，暂无可用WIFI！</div>
							</li>
							
						</ul>
					</div>
				</div>
			</div>
			
		</div>
	</div>
	
	<!-- 左右滑屏(导航) -->
	<link href="../../swiper/swiper-3.4.1.min.css" rel="stylesheet" />  
	<script src="../../swiper/swiper-3.4.1.jquery.min.js"></script>
   <script src="../../Scripts/layer/layer.js" type="text/javascript"></script>
	<script>
	    var mySwiper = new Swiper('.swiper-container', {
	        pagination: '.swiper-pagination',
	        paginationClickable: true,
	        autoplayDisableOnInteraction: false
	    })
	</script>
	<!-- 左右滑屏.End -->
	
	<script type="text/javascript">
	    var wifi = $.parseJSON('<%=wifiJson %>');
        var shop = $.parseJSON('<%=shopJson %>');
        var shopsCount = <%=shopCount %>;
        $(function () {
            if(shopsCount <= 0){//无可用WIFI
                $('.J_noWifi').show();
                $('.J__wifiConnectionStep').hide();
                return false;
            }
            if (wifi.ID > 0) { //只有一个门店一个WIFI，直接展示流程图
                $('.J_step .step01,.J_step .step02').hide();
                $('.J_step .step03').show();
                if (wifi.ProtocolType == 4) {
                    $('#qrCodePage').show().find('img').attr('src', wifi.LocalQRCodeUrl)
                    $('#portalPage').hide();
                } else {
                    $('#portalPage h2:eq(0) em').text('【' + wifi.SSID + '】');
                    $('#passNet').click(function () {
                        passNet('<%=passUrl %>');
                    });
                }
            } else {
                if (shop.ID > 0) {//只有一个门店则只显示选择WIFI
                    $('.J_step .step01').hide();
                    $('.J_step .step02').show();
                    getWifis(shop.ShopID);
                    $('.J_step .btn-prev').hide();
                }
                //认证
                $('#passNet').click(function () {
                    var wifiId = $('.J_selWifi li.on').data('id');
                    $.get('/hotel/GetPassUrl', { wifiId: wifiId }, function (r) {
                        if (r != '') { //可认证
                            passNet(r);
                        } else {
                            layer.msg('此WIFI配置错误,请联系管理员检查配置!');
                        }
                    })
                    passNet();
                });
                //选项选择
                $(".wifi__cnnt-panel .options").on("click", 'li', function () {
                    if (!$(this).hasClass("disabled")) {
                        $(this).addClass("on").siblings().removeClass("on");
                    }
                });
                //上一步
                $(".btn-prev").on("click", function () {
                    var step = $(this).parents(".wifi-step").attr("data-step");
                    //改变状态
                    if (step == 2) {
                        $(".wifi__cnnt-status .status").removeClass("i2").addClass("i1");
                    }
                    $(this).parents(".wifi-step").hide();
                    $(this).parents(".wifi-step").prev().show();
                });
                //下一步
                $(".btn-next").on("click", function () {
                    var step = $(this).parents(".wifi-step").attr("data-step");
                    //改变状态
                    if (step == 1) {
                        //选门店
                        var selShopId = $('.J_selShop li.on').data('id');
                        getWifis(selShopId);
                        $(".wifi__cnnt-status .status").removeClass("i1").addClass("i2");
                    } else if (step == 2) {
                        //选WIFI
                        var selWifi = $('.J_selWifi li.on');
                        var wifiId = selWifi.data('id');
                        var ssid = selWifi.find('span').text();
                        var type = selWifi.data('type') * 1;
                        var qrcode = selWifi.data('qrcode');
                        if (type == 4) { //密码型
                            $('#qrCodePage').show().find('img').attr('src', qrcode)
                            $('#portalPage').hide();
                        } else {
                            $('#portalPage h2:eq(0) em').text('【' + ssid + '】');
                            $('#portalPage').show();
                            $('#qrCodePage').hide();
                        }
                        $(".wifi__cnnt-status .status").removeClass("i2").addClass("i3");
                    }
                    $(this).parents(".wifi-step").hide();
                    $(this).parents(".wifi-step").next().show();
                });
            }
        });
        function getWifis(shopId) {
            $.get('/hotel/GetWiFiForFreeWifiPage', { shopId: shopId }, function (r) {
                var rHtml = '';
                $.each(r, function (i, m) {
                    rHtml += '<li class="flexbox ' + (i == 0 ? "on" : "") + '" data-id="' + m.ID + '" data-qrcode="' + m.LocalQRCodeUrl + '" data-type="' + m.ProtocolType + '"><span class="text flex1">' + m.SSID + '</span> <i class="radio"></i></li>'
                })
                $('.J_selWifi').html(rHtml);
            })
        }
        //认证
        function passNet(url) {
            var script = document.createElement('script');
            script.setAttribute('src', url);
            document.getElementsByTagName('head')[0].appendChild(script);
            setTimeout(function () {
                //	                        layer.msg("认证成功!");
                location.href = '<%=sucRedirctUrl %>';
            }, 1500);
        }
	</script>
</body>
</html>
