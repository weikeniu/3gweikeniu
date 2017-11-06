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
<title>酒店</title>
<link type="text/css" rel="stylesheet" href="../../swiper/swiper-3.4.1.min.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/travel.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/font/iconfont.css"/>
<!--<link type="text/css" rel="stylesheet" href="../../css/booklist/fontSize.css"/>-->
<script type="text/javascript" src="../../Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="../../swiper/swiper-3.4.1.jquery.min.js"></script>
<script type="text/javascript" src="../../Scripts/fontSize.js"></script>

</head>
<body>
	<section class="yu-pos-r">
		 <div class="swiper-container yu-h360r">
		    <div class="swiper-wrapper">
		      	<div class="swiper-slide full-img"><img src="../../images/114.png" /></div>
		        <div class="swiper-slide full-img"><img src="../../images/114.png" /></div>
		        <div class="swiper-slide full-img"><img src="../../images/114.png" /></div>
				</div>
		    <div class="swiper-pagination"></div>
	  	</div>
  	</section>
  	<section class="yu-lpad20r">
  		<div class="yu-grid yu-alignc yu-h90r">
  			<p class="yu-w70r yu-textc yu-f30r iconfont icon-dingwei1"></p>
  			<div class="yu-bor bbor yu-h90r yu-overflow">
  				<div class="yu-grid yu-alignc yu-h90r">
  					<a class="yu-overflow yu-arr arr1 yu-f32r yu-black" href="#">
  						广州
  					</a>
  					<a class="yu-overflow yu-arr arr1 yu-f32r yu-black" href="#">
  						<div class="yu-grid yu-alignc">
  							<p class="yu-f30r iconfont icon-jiudian1 yu-rmar20r"></p>
  							<p class="yu-f32r">附近酒店</p>
  						</div>
  					</a>
  				</div>
  			</div>
  		</div>
  		<div class="yu-grid yu-alignc yu-h137r yu-arr arr1">
  			<p class="yu-w70r yu-textc yu-f30r iconfont icon-rili1"></p>
  			<a class="yu-bor bbor yu-h137r yu-overflow" href="#">
  				<div class="yu-grid yu-alignc yu-h137r yu-rpad82r">
  					<div class="yu-overflow">
  						<div class="yu-f32r">
  							<span class="yu-f32r yu-black yu-rmar20r">5月26日</span>
  							<span class="yu-f26r yu-c77 yu-rmar10r">周五</span>
  							<span class="yu-f26r yu-c77">入住</span>
  						</div>
  						<div class="yu-f32r">
  							<span class="yu-f32r yu-black yu-rmar20r">5月27日</span>
  							<span class="yu-f26r yu-c77 yu-rmar10r">周六</span>
  							<span class="yu-f26r yu-c77">离店</span>
  						</div>
  					</div>
  					<p class="yu-f36r yu-black">共<span>1</span>晚</p>
  				</div>
  			</a>
  		</div>
  		<div class="yu-grid yu-alignc yu-h90r yu-arr arr1">
  			<p class="yu-w70r yu-textc yu-f30r iconfont icon-soushuo1"></p>
  			<div class="yu-bor bbor yu-h90r yu-overflow">
  				<div class="yu-grid yu-alignc yu-h90r yu-f32r yu-c99 yu-rpad82r">
  					<p class="yu-overflow">关键字</p>
  					<p>位置、品牌、酒店</p>
  				</div>
  			</div>
  		</div>
  		<div class="yu-grid yu-alignc yu-h90r yu-arr arr1">
  			<p class="yu-w70r yu-textc yu-f30r iconfont icon-xingji2"></p>
  			<div class="yu-bor bbor yu-h90r yu-overflow">
  				<div class="yu-grid yu-alignc yu-h90r yu-f32r yu-c99 yu-rpad82r">
  					<p class="yu-overflow">价格/星级</p>
  				</div>
  			</div>
  		</div>
  	</section>
	<section class="submit-row">
		<input type="button" value="查询"  />
	</section>

<script type="text/javascript">

    var swiper = new Swiper('.swiper-container', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        autoplay: 2500,
        autoplayDisableOnInteraction: false,
        loop: true,
        onSlideChangeStart: function (swiper) {
            $(".hotel-img-mask li").eq(swiper.activeIndex).addClass("cur").siblings().removeClass("cur");
            $(".activeIndex").text(swiper.activeIndex);
        }
    });  
		
		
 
</script>
</body>
</html>
