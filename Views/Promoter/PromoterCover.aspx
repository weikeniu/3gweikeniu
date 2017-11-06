<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    hotel3g.Repository.MemberCard CurUser = ViewData["CurUser"] as hotel3g.Repository.MemberCard;
    hotel3g.Repository.HotelInfoItem HotelInfo = ViewData["HotelInfo"] as hotel3g.Repository.HotelInfoItem;
%>







<html lang="zh-cn">
<head>
	<meta charset="UTF-8" />
	<title></title>
	<meta name="format-detection" content="telephone=no">
	<!--自动将网页中的电话号码显示为拨号的超链接-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
	<!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
	<meta name="apple-mobile-web-app-capable" content="yes">
	<!--IOS设备-->
	<meta name="apple-touch-fullscreen" content="yes">
	<!--IOS设备-->
	<meta http-equiv="Access-Control-Allow-Origin" content="*">
	
</head>
<body style="background: #8700e6;>
	
	<!-- <>我的推广(会员中心) -->
	<div class="pg__myPromotion clearfix">
		<style type="text/css">
			html{font-size: 50px;}
			body{
				background-color:#f8f8f8;font:12px/1.5 "Microsoft Yahei", Arial, Helvetica, Tahoma, sans-serif;margin: 0 auto; padding:0; min-width: 320px; max-width: 750px; height: 100%; width: 100%;}
			p, ul, ol, dl, dd, h1, h2, h3, h4, h5, h6, img, label, input, button, textarea, select, form {margin: 0; padding:0;}
			.clearfix {_zoom:1;}
			.clearfix:after {content: "";clear: both;display: block;}
			* html .clearfix {display: inline-block;}
			* + html .clearfix {display: inline-block;}
			
			.flexbox {
				display: -webkit-box; display: -moz-box; display: -webkit-flex; display: flex; -webkit-box-orient: horizontal; -webkit-flex-flow: row nowrap; flex-flow: row nowrap;
			}
			.flex1 {
				-webkit-box-flex: 1; -moz-box-flex: 1; -webkit-flex: 1; flex: 1; width: auto!important;
			}
			.flex2 {
				-webkit-box-flex: 2; -moz-box-flex: 2; -webkit-flex: 2;flex: 2; width: auto!important;
			}
			
			/*大图卡片区域*/
			.zone__bigImg-panel{padding: .1rem .2rem .2rem;}
			.zone__bigImg-panel .bigImg-inner{position: relative;}
			.zone__bigImg-panel .img__card{background: #ff4274; border-radius: .3rem; padding: .1rem; position: relative;}
			.img__card .head{padding: .2rem .1rem;}
			.img__card .head .uimg{border-radius: 50%; display: block; margin-right: .2rem; height: 1rem; width: 1rem;}
			.img__card .head .intro p{color: #fff; font-size: .26rem; line-height: .44rem;}
			.img__card .head .intro p .yellow{color: #ffff00;}
			.img__card .main{padding-top: .8rem; padding-bottom: .3rem; position: relative;}
			.img__card .main .logo{text-align: center; width: 100%; position: absolute;top: 0;}
			.img__card .main .logo img{
				background: rgba(255,255,255,.95); border-radius: 50%; display: inline-block; height: 1.6rem; width: 1.6rem;
			}
			.img__card .main .bigimg{vertical-align: top; height: 6.9rem; max-width: 100%; width: 6.9rem;}
			.img__card .main .foot{text-align: center; width: 100%; position: absolute; bottom: .2rem;}
			.img__card .main .foot .qrcode{background: #ff4274; display: inline-block; padding: .1rem;}
			.img__card .main .foot .qrcode .bg{background: #fff; padding: 0 .15rem .15rem;}
			.img__card .main .foot .qrcode h5{color: #ff4274; font-size: .21rem; font-weight: 700; padding: .15rem 0 .2rem; line-height: .21rem;}
			.img__card .main .foot .qrcode img{display: block; margin: 0 auto; height: 2.1rem; width: 2.1rem;}
			/*标题*/
			.img__card .main .foot .tit{height: .7rem; position: relative; z-index: 10;}
			.img__card .main .foot .tit .shadow{-webkit-text-stroke-width: 15px; -webkit-text-stroke-color: #ff4274; -webkit-text-fill-color: #ffff00;}
			.img__card .main .foot .tit em{color: #ffff00; font-size: .4rem; font-weight: 700; font-style: normal; padding: .1rem 0; width: 100%; position: absolute; bottom: 0; left: 0;}
			/*描叙*/
			.img__card .main .foot .desc{height: .3rem; position: relative; z-index: 11;}
			.img__card .main .foot .desc .shadow{-webkit-text-stroke-width: 10px; -webkit-text-stroke-color: #ff4274; -webkit-text-fill-color: #ffff00;}
			.img__card .main .foot .desc em{color: #fff; font-size: .3rem; font-weight: 700; font-style: normal; padding-top: .1rem; width: 100%; position: absolute; bottom: 0; left: 0;}
			/*按钮*/
			.zone__bigImg-panel .foot__btn{background: #ff4274; border-bottom-left-radius: .3rem; border-bottom-right-radius: .3rem; text-align: center; padding: .3rem 0 .2rem; margin-top: -.26rem; position: relative;}
			.zone__bigImg-panel .foot__btn a{background: #cc355d; border-radius: .1rem; color: #fff; display: inline-block; font-size: .22rem; text-decoration: none; line-height: .6rem; width: 2.7rem;}
			/*阴影*/
			.zone__bigImg-panel .box__shadow{
				border-radius: .3rem; height: 100%; width: 100%; position: absolute; left: 0; top: 0; z-index: -1;
				box-shadow: .05rem .1rem .15rem rgba(0,0,0,.8);
			}
		</style>
		<!--//大图区域-->
		<div class="zone__bigImg-panel">
			<div class="bigImg-inner">
				<!--//卡片区域-->
				<div class="img__card">
					<div class="head flexbox">
						<img class="uimg" src="<%=CurUser.photo %>" />
						<div class="intro flex1">
							<p>我是<b class="yellow"><%=CurUser.nickname %></b>，</p>
							<p>我代<%=HotelInfo.SubName %><b class="yellow">为您发放<%=ViewData["money"] %>元红包！</b></p>
							<p>长按图片，识别图中二维码关注领取。</p>
						</div>
					</div>
					<div class="main">
						<div class="logo">
							<img src="<%=HotelInfo.hotelLog %>" />
						</div>
						<!--<img class="bigimg" src="../images/hotel-bigimg.jpg" />-->
						<img class="bigimg" src="<%=ViewData["background"] %>" />
						
						<!--//二维码-标题-->
						<div class="foot">
							<div class="qrcode">
								<div class="bg">
									<h5>关注酒店，领取红包</h5>
									<img src=""<%=ViewData["Logo"] %>" />
								</div>
							</div>
							<h2 class="tit">
								<em class="shadow"><%=HotelInfo.SubName %></em>
								<em><%=HotelInfo.SubName %></em>
							</h2>
							<h3 class="desc">
								<em class="shadow"><%=ViewData["info"] %></em>
								<em><%=ViewData["info"] %></em>
							</h3>
						</div>
					</div>
				</div>
				
				<div class="foot__btn">
					<a href="#">点击复制二维码地址</a>
				</div>
				<div class="box__shadow"></div>
			</div>
		</div>
	</div>
	
</body>
</html>
