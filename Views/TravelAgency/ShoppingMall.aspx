<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    var producdtList = ViewData["products"] as List<WeiXin.Common.ProductEntity>;
    System.Data.DataTable dt_Type = ViewData["CommodityTypeTable"] as System.Data.DataTable;
    System.Data.DataTable dt_AllType = ViewData["CommodityAllTypeTable"] as System.Data.DataTable;
    System.Data.DataTable dt_Extension = ViewData["CommodityExtensionTable"] as System.Data.DataTable;
%>
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
    <title>商城</title>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/swiper/swiper-3.4.1.min.css" />
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/travel.css" />
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/font/iconfont.css" />
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/swiper/swiper-3.4.1.jquery.min.js"></script>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/font/iconfont.js"></script>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/Scripts/fontSize.js"></script>
    <style type="text/css">
            
            /*loading效果*/
            @-webkit-keyframes scale {
                0% {-webkit-transform: scale(1);transform: scale(1);opacity: 1; }
                45% {-webkit-transform: scale(0.1);transform: scale(0.1);opacity: 0.7; }
                80% {-webkit-transform: scale(1);transform: scale(1);opacity: 1; }
            }
            @keyframes scale {
                0% {-webkit-transform: scale(1);transform: scale(1);opacity: 1; }
                45% {-webkit-transform: scale(0.1);transform: scale(0.1);opacity: 0.7; }
                80% {-webkit-transform: scale(1);transform: scale(1);opacity: 1; }
            }
            
            .ball-pulse > div:nth-child(1) {
                -webkit-animation: scale 0.75s 0.12s infinite cubic-bezier(.2, .68, .18, 1.08);
                animation: scale 0.75s 0.12s infinite cubic-bezier(.2, .68, .18, 1.08); }
            .ball-pulse > div:nth-child(2) {
                -webkit-animation: scale 0.75s 0.24s infinite cubic-bezier(.2, .68, .18, 1.08);
                animation: scale 0.75s 0.24s infinite cubic-bezier(.2, .68, .18, 1.08); }
            .ball-pulse > div:nth-child(3) {
                -webkit-animation: scale 0.75s 0.36s infinite cubic-bezier(.2, .68, .18, 1.08);
                animation: scale 0.75s 0.36s infinite cubic-bezier(.2, .68, .18, 1.08); }
            .ball-pulse > div {
                background-color: #aaa;
                width: 7px;
                height: 7px;
                border-radius: 100%;
                margin: 2px;
                display: inline-block; }
            .ball-pulse{text-align: center;color:#aaa;background:#EDF4F4; font-size:16px;}<%--height:1.5rem;line-height: 1rem;--%>
            .icon{background:none;display:inline-block;overflow:hidden;fill:currentColor;margin-top:0;vertical-align:-.4em;height:1.4em;width:1.4em;}
        </style>
</head>
<body>
    <!--默认页-->
    <article class="base-page">
    <section class="yu-pos-r">
		<div class="yu-grid search-row sp">
		 	<div class="search-bg  yu-grid yu-alignc yu-lpad20r">
		 		<p class="iconfont icon-soushuo1 yu-cw yu-f30r yu-rmar20r"></p>
		 		<input type="text" class="keyword-btn" value="<%=ViewData["MallSearch"] %>" />
		 	</div>
		 </div>
    <%if (dt_Extension.Rows.Count > 0)
      { %>
		 <div class="swiper-container yu-h400r">
		    <div class="swiper-wrapper">
                <%foreach (System.Data.DataRow data in dt_Extension.Rows)
                  { %>
		        <div class="swiper-slide full-img">
		        	<img src="<%=data["ImageList"].ToString().Split(',')[0] %>" />
		        	<%--<div style="background:url(/images/商品图加载.png) no-repeat center; background-size:50%; height: 100%;width:100%;"></div>--%>
		        	<div class="edit-box">
				  		<div class="inner yu-textc text-ell">
				  			<p class="yu-f40r yu-tpad40r"><%=data["Name"]%></p>
				  			<div class="yu-grid yu-alignc yu-j-c yu-bmar15r">
				  				<div class="border-copy"></div>
				  				<div class="point-copy"></div>
				  				<div class="border-copy"></div>
				  			</div>
				  			<div class="yu-textc yu-lrpad10r yu-f22r yu-bmar25r text-ell"><%=data["Describe"]%></div>
				  			<a href="/TravelAgency/CommodityDetail/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&CommodityID=<%=data["CommodityId"]%>" class="yu-grid ljqg-btn yu-alignc yu-j-c">
				  				<p class="yu-f20r">立即抢购</p>
				  				<p class="arr"></p>
				  			</a>
				  		</div>
				  	</div>
		        </div>
                <%} %>
				</div>
		    <div class="swiper-pagination"></div>
	  	</div>
        <%}
      else
      { %>

		 <div class="swiper-container yu-h400r">
		    <div>
		        <div class="swiper-slide full-img">
		        	<img src="/images/商城.jpg" />
		        </div>
				</div>
		    <div class="swiper-pagination"></div>
	  	</div>

        <%} %>
 </section>
    <%if (dt_Type.Rows.Count > 1)
      { %>
    <section class="x-nav-row">
	 <nav class="scroll-nav">
	 	<%--<a href="/TravelAgency/ShoppingMallByType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=温泉">
	 		<div class="ico iconfont icon-wenquan"></div>
	 		<p class="yu-f24r yu-c55">温泉</p>
	 	</a>
	 	<a href="/TravelAgency/ShoppingMallByType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=自助餐">
	 		<div class="ico iconfont icon-zhizhucan1"></div>
	 		<p class="yu-f24r yu-c55">自助餐</p>
	 	</a>
	 	<a href="/TravelAgency/ShoppingMallByType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=自由行">
	 		<div class="ico iconfont icon-zhiyouxing1"></div>
	 		<p class="yu-f24r yu-c55">自由行</p>
	 	</a>
	 	<a href="/TravelAgency/ShoppingMallByType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=跟团游">
	 		<div class="ico iconfont icon-gentuanyou1"></div>
	 		<p class="yu-f24r yu-c55">跟团游</p>
	 	</a>
	 	<a href="/TravelAgency/ShoppingMallByType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=大促">
	 		<div class="ico iconfont icon-dachu1"></div>
	 		<p class="yu-f24r yu-c55">大促</p>
	 	</a>--%>
        <%foreach (System.Data.DataRow dr in dt_Type.Rows)
          { %>
	 	<a href="/TravelAgency/ShoppingMallByType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=<%=dr["id"] %>&MallSearch=<%=ViewData["MallSearch"] %>">
        <%if (dr["Name"].ToString() == "温泉")
          { %>
          <div class="ico iconfont icon-wenquan"></div>
        <%}
          else if (dr["Name"].ToString() == "自助餐")
          { %>
          <div class="ico iconfont icon-zhizhucan1"></div>
          <%}
          else if (dr["Name"].ToString() == "线路")
          { %>
          <div class="ico iconfont icon-zhiyouxing1"></div>
          <%}
          else if (dr["Name"].ToString() == "签证")
          { %>
          <div class="ico iconfont icon-gentuanyou1"></div>
          <%}
          else if (dr["Name"].ToString() == "门票")
          { %>
          <div class="ico iconfont icon-dachu1"></div>
          <%}
          else if (dr["Name"].ToString() == "租车")
          { %>
          <div class="ico iconfont icon-zuche1"></div>
          <%}
          else
          { %>
	 		<div class="ico iconfont icon-zhiding1"></div>
            <%} %>
	 		<p class="yu-f24r yu-c55"><%=dr["Name"]%></p>
	 	</a>
        <%} %>
	 </nav>
 </section>
    <%} %>
    <section class="yu-lpad10r">
 	<ul class="show-list">
    <%foreach (var item in producdtList)
      { %>
      <li>
 			<a href="/Product/ProductDetail/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&ProductId=<%=item.Id %>">
 				<div class="img">
 					<img src="<%=item.MainPic %>" onload="loadedImage(this)" style="display:none;"  />
		        	<div style="background:url(/images/商品图加载.png) no-repeat center; background-size:50%; height: 100%;width:100%;"></div>
 					
                    <% if (item.ProductType == "0")
                       { %>
                       <div class="xs-mark yu-f16r">限量<br />抢购</div>
                       <%}
                       else
                       { %><div class="xs-mark yu-f16r">限时<br />抢购</div><%} %>
                    
                    <%if (!string.IsNullOrWhiteSpace(item.city))
                      { %>
 					<div class="add-mark"><%=item.city%></div>
                    <%} %>
 					<%--<div class="txt"><%=item.SubName%></div>--%>
 				</div>
 				<div class="yu-bgw yu-h105r yu-lrpad20r">
 						<p class="text-ell yu-f24r yu-l55r yu-black"><%=item.ProductName %></p>
 						<div class="yu-grid yu-alignc">
 							<div class="mark yu-rmar10r">抢购</div>
 							<div class="yu-overflow yu-c40 yu-f20r">￥<span class="yu-f26r"><%=item.MenPrice%></span></div>
 						</div>
 					
 				</div>
 			</a>
 		</li>
    <%} %>
 		<%--<li>
 			<a href="#">
 				<div class="img">
 					<img src="/images/hotel__img-detail.jpg"  />
 					<div class="xs-mark yu-f16r">限时<br />抢购</div>
 					<div class="add-mark">安徽</div>
 					<div class="txt">黄山自然风景区</div>
 				</div>
 				<div class="yu-bgw yu-h105r yu-lrpad20r">
 						<p class="text-ell yu-f24r yu-l55r yu-black">端午观看龙舟赛、品竹筒海端午观看龙舟赛、品竹筒海</p>
 						<div class="yu-grid yu-alignc">
 							<div class="mark yu-rmar10r">国内跟团游</div>
 							<div class="yu-overflow yu-c40 yu-f20r">￥<span class="yu-f26r">699</span></div>
 						</div>
 					
 				</div>
 			</a>
 		</li>
 		<li>
 			<a href="#">
 				<div class="img">
 					<img src="/images/hotel__img-detail.jpg"  />
 					<div class="add-mark">安徽</div>
 					<div class="txt">黄山自然风景区</div>
 				</div>
 				<div class="yu-bgw yu-h105r yu-lrpad20r">
 						<p class="text-ell yu-f24r yu-l55r yu-black">端午观看龙舟赛、品竹筒海端午观看龙舟赛、品竹筒海</p>
 						<div class="yu-grid yu-alignc">
 							<div class="mark yu-rmar10r">国内跟团游</div>
 							<div class="yu-overflow yu-c40 yu-f20r">￥<span class="yu-f26r">699</span></div>
 						</div>
 					
 				</div>
 			</a>
 		</li>
 		<li>
 			<a href="#">
 				<div class="img">
 					<img src="/images/hotel__img-detail.jpg"  />
 					<div class="add-mark">安徽</div>
 					<div class="txt">黄山自然风景区</div>
 				</div>
 				<div class="yu-bgw yu-h105r yu-lrpad20r">
 						<p class="text-ell yu-f24r yu-l55r yu-black">端午观看龙舟赛、品竹筒海端午观看龙舟赛、品竹筒海</p>
 						<div class="yu-grid yu-alignc">
 							<div class="mark yu-rmar10r">国内跟团游</div>
 							<div class="yu-overflow yu-c40 yu-f20r">￥<span class="yu-f26r">699</span></div>
 						</div>
 					
 				</div>
 			</a>
 		</li>
 		<li>
 			<a href="#">
 				<div class="img">
 					<img src="/images/hotel__img-detail.jpg"  />
 					<div class="add-mark">安徽</div>
 					<div class="txt">黄山自然风景区</div>
 				</div>
 				<div class="yu-bgw yu-h105r yu-lrpad20r">
 						<p class="text-ell yu-f24r yu-l55r yu-black">端午观看龙舟赛、品竹筒海端午观看龙舟赛、品竹筒海</p>
 						<div class="yu-grid yu-alignc">
 							<div class="mark yu-rmar10r">国内跟团游</div>
 							<div class="yu-overflow yu-c40 yu-f20r">￥<span class="yu-f26r">699</span></div>
 						</div>
 					
 				</div>
 			</a>
 		</li>--%>
 	</ul>
 </section>
    <section class="loading-page" style="position: fixed;">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
    <div class='ball-pulse'>
        加载中</div>
</article>
    <!--默认页end-->
    
    <article class="nodata-page" style="display: none;">
<section class="yu-tpad120r">
	<div class="no-r-ico"></div>
	<p class="yu-c77 yu-f28r yu-textc">抱歉，未找到您想要的结果！</p>
</section>
 </article>

    <!--关键字-->
    <article class="keyword-page">
	<section class="yu-h80r yu-bgw yu-bor bbor yu-grid yu-alignc yu-lpad20r ">
		<a class="yu-back-arr" href="javascript:closeAllPage()"></a>
		<div class="yu-overflow">
			<div class="search-bg2 yu-grid yu-alignc">
				<span class="iconfont icon-soushuo1 yu-rmar10r yu-c99"></span>
				<input type="text" class="yu-overflow" placeholder="搜索商品" id="inp_search" /> <%--onchange="ChangeName(this)"--%>
				<i class="ico-close J__iptClear">×</i>
			</div>
		</div>
		<%--<a class="yu-f26r yu-blue2 yu-lrpad20r cal-btn">取消</a>--%>
		<a class="yu-f26r yu-blue2 yu-lrpad20r sure-btn">确认</a>
</section>
<section class="tab-con type2 yu-grid yu-bgw">
	<ul class="tab-nav type3 yu-f28r ">
		<li class="cur">类别</li>
		<%--<li>商圈</li>
		<li>行政区</li>--%>
	</ul>
	<ul class="tab-inner yu-overflow yu-lrpad20r">
		<li class="cur">
			<ul class="tab-inner-scroll type2 yu-f26r">
                 <%foreach (System.Data.DataRow dr in dt_AllType.Rows)
                   { %>
                   <li>
                   <input type="hidden" value="<%=dr["id"] %>" />
                   <%=dr["Name"] %>
          </li>
          <%} %>
			</ul>
		</li>
		<%--<li>
			<ul class="tab-inner-scroll type2 yu-f26r ">
				<li>7天</li>
				<li>7天</li>
				<li>7天</li>
				<li>7天</li>
				<li>7天</li>
				<li>7天</li>
				<li>7天</li>
				<li>7天</li>
				<li>7天</li>
				<li>7天</li>
			</ul>
		</li>
		<li>
			<ul class="tab-inner-scroll type2 yu-f26r ">
				<li>汉庭</li>
				<li>汉庭</li>
				<li>汉庭</li>
				<li>汉庭</li>
				<li>汉庭</li>
				<li>汉庭</li>
				<li>汉庭</li>
				<li>汉庭</li>
				
			</ul>
		</li>--%>
	</ul>
</section>
</article>
    <!--关键字end-->
</body>
<script type="text/javascript">

    var swiper = new Swiper('.swiper-container', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        autoplay: 5000,
        autoplayDisableOnInteraction: false,
        loop: true,
        onSlideChangeStart: function (swiper) {
            $(".hotel-img-mask li").eq(swiper.activeIndex).addClass("cur").siblings().removeClass("cur");
            $(".activeIndex").text(swiper.activeIndex);
        }
    });
    var curpage = 1;
    var dataCount = 0;
    var pagesize = 6;
    var canScroll = true;
    var SearchName = "";
    var isLoading = false;
    $(".loading-page").show();
    setTimeout(function () { $(".loading-page").hide() }, 5000);
    //获取商品信息
    function GetCommodityInfo() {
        isLoading = true;
        if (curpage == 1 && "<%=producdtList.Count %>" * 1 % 2 == 1) {
            pagesize = 5;
        }
        $(".loading-page").show();
        $.ajax({
            type: "post",
            url: '/TravelAgency/GetCommodityInfoMain/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&MallSearch=<%=ViewData["MallSearch"] %>&curpage=' + curpage + '&pagesize=' + pagesize + '&dataCount=' + dataCount,
            dataType: 'json'
        }).done(function (data) {
            dataCount = data.dataCount * 1;
            var newdata = $.parseJSON(data["data"]);
            if (newdata.length == 0) {
                canScroll = false;
                //                $(".ball-pulse").html("没有更多的数据");
                $(".ball-pulse").hide();
                $(".loading-page").hide();
            } else {
                $(".keyword-page").hide();
                $(".base-page").show();
                SetCommodityHtml(newdata);
                if (newdata.length < pagesize)
                    $(".ball-pulse").hide();
                $(".loading-page").hide();
            }
            if (curpage == 1 && newdata.length == 0 && "<%=producdtList.Count %>" * 1 < 1) {
                $(".nodata-page").show();
            }
            pagesize = 6;
            isLoading = false;
        });
        setTimeout(function () { $(".loading-page").hide(); }, 5000);
    }
    GetCommodityInfo();

    //下拉加载
    $(function () {
        /****************** 滚动上拉下拉加载 ***************/
        $(document).on("scroll", function () {
            var scrollTop = $(this).scrollTop();
            var scrollHeight = $(document).height();
            var windowHeight = $(window).height();
            if (9 == 10) {
                $(".ball-pulse").html("已经到底了！")
            } else {
                if (scrollTop + windowHeight == scrollHeight && $(".ball-pulse").css('display') != 'none' && !isLoading) {
                    if (!canScroll) return false;
                    $(".ball-pulse").html("加载中...")
                    setTimeout(function () {
                        curpage++;
                        GetCommodityInfo();
                    }, 500)
                }
            }
        });
    });

    //根据名称搜索
    function ChangeName(obj) {
//        location.reload();
//        Initialization();
        SearchName = $(obj).val();
        window.location.href = '/TravelAgency/ShoppingMall/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&MallSearch=' + SearchName;
//        GetCommodityInfo();
    }
    $(".sure-btn").click(function () {
        SearchName = $('#inp_search').val();
        window.location.href = '/TravelAgency/ShoppingMallByType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&MallSearch=' + SearchName;
    })

    $('#inp_search').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            SearchName = $(this).val();
            window.location.href = '/TravelAgency/ShoppingMallByType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&MallSearch=' + SearchName;
        }
    });

    //主界面显示商品信息
    var html = "";
    function SetCommodityHtml(data) {
        //        $(".show-list").html("");
        var isUseStorage = true;
        html = $(".show-list").html();
        for (var i = 0; i < data.length; i++) {
            var str1 = "";
            var str2 = "";
            var str3 = "";
            if (data[i].city != "") {
                str1 = '<div class="add-mark">' + data[i].city + '</div>';
            }
            if (data[i].SubName != "") {
                str2 = '<div class="txt">' + data[i].SubName + '</div>';
            }
            if (data[i].CanPurchase * 1 < 1) {
                if (data[i].CommodityType != "") {
                    str3 = '<div class="mark yu-rmar10r">' + data[i].CommodityTypeName + '</div>';
                } else {
                    str3 = '<div class="mark yu-rmar10r">商城</div>';
                }
            } else {
                if (data[i].PurchasePoints * 1 > 0) {
                    str3 = '<div class="mark yu-rmar10r">可用' + data[i].PurchasePoints + '积分兑换</div>';
                }
            }
            var imgList = data[i].ImageList.split(",");
            var rHtml = "";
            if (imgList[0] == null || imgList[0] == '') {//没有图片显示默认svg
                //                rHtml += '<svg class="icon" aria-hidden="true" style="height:100%;width:100%;"><use xlink:href="#icon-tongyonmorentu"></use></svg>';
                rHtml += '<div style="background:url(/images/商品图加载.png) no-repeat center; background-size:50%; height: 100%;width:100%;"></div>';
            } else {//有图片无法加载时也显示默认svg
                rHtml += '<img src="' + imgList[0] + '" onload="loadedImage(this)" style="display:none;" />';
                rHtml += '<div style="background:url(/images/商品图加载.png) no-repeat center; background-size:50%; height: 100%;width:100%;"></div>';
            }

            html = html + "<li>" +
            '<a href="/TravelAgency/CommodityDetail/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&CommodityID=' + data[i].id + '">' +
            '<div class="img">' +
            //            '<img src="' + imgList[0] + '"  />' + str1 + str2 +
            rHtml + str1 + str2 +
            '</div>' +
            '<div class="yu-bgw yu-h105r yu-lrpad20r">' +
            '<p class="text-ell yu-f24r yu-l55r yu-black">' + data[i].Name + '</p>' +
            '<div class="yu-grid yu-alignc">' +
            str3 +
            '<div class="yu-overflow yu-c40 yu-f20r">￥<span class="yu-f26r">' + data[i].Price + '</span></div>' +
            '</div></div></a></li>';
        }
        $(".show-list").html(html);
        $(".loading-page").hide();
    }
    //根据搜索条件初始化JS参数
    function Initialization() {
        $('html, body').animate({ scrollTop: 0 }, 'slow');
        html = "";
        dataCount = 0;
        curpage = 1;
        canScroll = true;
        $(".show-list").html("");
        $(".ball-pulse").show();
        $(".nodata-page").hide();
    }

    function loadedImage(t) {
        var that = $(t);
        that.show().next().hide();
        that.error(function () {
            that.hide().next().show();
        });
    }


    //关键字
    $(".keyword-btn").click(function () {
        $(".nodata-page").hide();
        $(".base-page").hide();
        $(".keyword-page").show();
    })
    $(".tab-nav").children("li").on("click", function () {
        $(this).addClass("cur").siblings("li").removeClass("cur");
        tabIndex = $(this).index();
        $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
    })
    $(".tab-inner-scroll").children("li").on("click", function () {
        $(this).toggleClass("cur");
        var typeId=$(this).find("input").val();
        //
        window.location.href = '/TravelAgency/ShoppingMallByType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=' + typeId;
    })
    $(".keyword-page .cal-btn").click(function () {
        $(".keyword-page").hide();
        $(".base-page").show();
    })
    function closeAllPage() {
        $(".keyword-page").hide();
        $(".base-page").show();
    }

    //清空文本框
    $(".J__iptClear").on("click", function () {
        $(this).siblings("input").val("").focus();
    })
</script>
</html>
