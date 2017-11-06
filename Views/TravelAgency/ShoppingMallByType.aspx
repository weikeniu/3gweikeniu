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
    <title></title>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/swiper/swiper-3.4.1.min.css" />
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/travel.css" />
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/font/iconfont.css" />
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/swiper/swiper-3.4.1.jquery.min.js"></script>
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
            .ball-pulse{text-align: center;color:#aaa;background:#EDF4F4; font-size:16px;}
        </style>
</head>
<body class="yu-bpad90r">
    <article class="base-page">
	<section class="yu-h80r yu-bgw yu-bor bbor yu-grid yu-alignc yu-lpad20r yu-bmar10r">
		<%--<a href="/TravelAgency/ShoppingMallByNearby/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=<%=ViewData["type"]%>&MallSearch=<%=ViewData["MallSearch"] %>" class="yu-blue2 yu-f26r">--%>
		<a href="javascript:GoToNearby()" class="yu-blue2 yu-f26r">
			<span class="iconfont icon-dingwei1 yu-f26r"></span>
			<span>附近</span>
		</a>
		<div class="yu-overflow yu-lrpad20r">
			<div class="search-bg2 yu-grid yu-alignc">
				<span class="iconfont icon-soushuo1 yu-rmar10r yu-f20r"></span>
				<input type="text" class="yu-overflow" placeholder="搜索商品" onchange="ChangeName(this)" value="<%=ViewData["MallSearch"] %>" />
                <i class="ico-close J__iptClear">×</i>
			</div>
		</div>
	</section>
 <section class="yu-lpad10r">
 	<ul class="show-list">
 	</ul>
        <div class='ball-pulse'>加载中</div>
 </section>
 <footer class="screen-bottom yu-grid yu-alignc yu-f26r yu-c22">
 	<div class="yu-overflow" ><%--onclick="window.location='/TravelAgency/SelectCity/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>'"--%>
 		<div class="yu-grid yu-alignc yu-j-c local-btn2">
 			<p class="yu-rmar10r nav-btn1">城市</p>
 			<p class="arr"></p>
 		</div>
 	</div>
 	<div class="yu-overflow">
 		<div class="yu-grid yu-alignc yu-j-c sort-btn">
 			<p class="yu-rmar10r" id="sortName">推荐排序</p>
 			<p class="arr"></p>
 		</div>
 	</div>
 	<div class="yu-overflow">
 		<div class="yu-grid yu-alignc yu-j-c screen-btn">
 			<p class="yu-rmar10r">筛选</p>
 			<p class="arr"></p>
 		</div>
 	</div>
 </footer>
 <!--排序-->
 <div class="mask sort-mask">
 	<div class="mask-inner ">
 		<ul class="yu-f26r sort-list">
 			<li class="yu-grid yu-alignc yu-blue" onclick="ChangeSort('推荐排序')">
 				<p class="iconfont icon-gouxuan yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">推荐排序</p>
 			</li>
 			<li class="yu-grid yu-alignc" onclick="ChangeSort('距离优先')">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">距离优先</p>
 			</li>
 			<li class="yu-grid yu-alignc" onclick="ChangeSort('低价优先')">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">低价优先</p>
 			</li>
 			<li class="yu-grid yu-alignc" onclick="ChangeSort('高价优先')">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">高价优先</p>
 			</li>
 			<%--<li class="yu-grid yu-alignc" onclick="ChangeSort('星级优先')">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">星级优先</p>
 			</li>--%>
 		</ul>
 	</div>
 </div>
 <!--筛选-->
 <div class="mask screen-mask">
 	<div class="mask-inner yu-lrpad20r">
 		<div class="yu-grid yu-h90r yu-f32r yu-alignc yu-bor bbor yu-textc yu-j-s  yu-bmar60r">
 			<p class="yu-w120r cancel-btn2">取消</p>
 			<p class="yu-w120r yu-blue2  cancel-btn2">完成</p>
 		</div>
 		<dl class="yu-bor bbor yu-bmar60r">
 			<dt class="yu-f26r yu-c99 yu-bmar30r">价格筛选</dt>
	 		<dd class="yu-grid yu-j-s price-screen">
	 			<div class="cur" onclick="ChangePrice('')">不限</div>
	 			<div onclick="ChangePrice('0,150')">0-150</div>
	 			<div onclick="ChangePrice('150,300')">150-300</div>
	 			<div onclick="ChangePrice('300,600')">300-600</div>
	 			<div onclick="ChangePrice('600,1000')">600-1000</div>
	 			<div onclick="ChangePrice('1000,999999999999')">1000+</div>
	 			
	 		</dd>
	 	</dl>
                <%--<%
                    System.Data.DataTable dt_Type = ViewData["CommodityTypeSubitemTable"] as System.Data.DataTable;
%>
        <%if (dt_Type.Rows.Count > 1)
          { %>
	 	<dl class="">
 			<dt class="yu-f26r yu-c99 yu-bmar30r">类别筛选(复选)</dt>
	 		<dd class="yu-grid yu-j-s type-screen">
	 			<div class="cur" onclick="ChangeSubitem('')">不限</div>
                <%foreach (System.Data.DataRow dr in dt_Type.Rows)
                  { %>
	 			<div onclick="ChangeSubitem('<%=dr["id"] %>')"><%=dr["Name"] %></div>
          <%} %>
	 			
	 			
	 		</dd>
	 	</dl>
        <%} %>--%>
        <dl class="" id="dl_type">
 			<dt class="yu-f26r yu-c99 yu-bmar30r">类别筛选(复选)</dt>
	 		<dd class="yu-grid yu-j-s type-screen">
	 			<%--<div class="cur" onclick="ChangeSubitem('')" data-id="">不限</div>--%>
	 			<div class="cur" data-id="">不限</div>
	 		</dd>
	 	</dl>
 	</div>
 	
 </div>
 </article>
    <article class="nodata-page" style="display: none;">
<section class="yu-tpad120r">
	<div class="no-r-ico"></div>
	<p class="yu-c77 yu-f28r yu-textc">抱歉，未找到您想要的结果！</p>
</section>
 </article>
    <%Html.RenderPartial("SelectLocat"); %>
    <section class="loading-page" style="position: fixed;">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
    <script type="text/javascript">
        $(function () {
            $(".screen-bottom>div").on("click", function () {
                $(this).toggleClass("cur").siblings().removeClass("cur");
            })
        })
        //mask通用
        $(".mask").click(function () {
            $(this).fadeOut();
            $(".screen-bottom>div").removeClass("cur");

        })
        $(".mask-inner").click(function (e) {
            e.stopPropagation();
        })
        //清空文本框
        $(".J__iptClear").on("click", function () {
            $(this).siblings("input").val("").focus();
            SearchName = "";
            Initialization();
            GetCommodityInfo();
        })
        //排序
        $(".sort-btn").click(function () {
            $(".sort-mask").fadeIn();
        })
        $(".sort-list>li").on("click", function () {
            $(this).addClass("yu-blue").siblings().removeClass("yu-blue");
            $(this).children(".iconfont").addClass("icon-gouxuan").parent().siblings().children(".iconfont").removeClass("icon-gouxuan");
            $(".sort-mask").fadeOut();
            $(".screen-bottom>div").removeClass("cur");
        })

        //筛选
        $(".price-screen>div").on("click", function () {
            $(this).addClass("cur").siblings().removeClass("cur");
        })
        $(".type-screen").on("click", "div", function () {
            if(!isLoading){
                if($(this).attr("data-id") == "" && $(this).hasClass("cur"))
                return;
                $(this).toggleClass("cur");
                ChangeSubitem($(this).attr("data-id"));
            }
        })
        $(".cancel-btn2").on("click", function () {
            $(".mask").fadeOut();
            $(".screen-bottom>div").removeClass("cur");
        })
        $(".screen-btn").click(function () {
            $(".screen-mask").fadeIn();
        })
        $(".local-btn2").click(function () {
            $(".base-page").hide();
            $(".local-page").show();
        })

        var curpage = 1;
        var dataCount = 0;
        var pagesize = 6;
        var canScroll = true;
        var html = "";
        var productsHtml="";
        var typeHtml = "";
        var price = "";
        var subitem = "";
        var isChangePrice = false;
        var sort = "推荐排序";
        var selectCity = "";
        var SearchName = "<%=ViewData["MallSearch"] %>";
        var CommodityTypeName = "";
        var cityName = "";
        var hasDataCityName="";
        var hasDataCityName2="";
        var productCount = 0;
        var isLoading = false;
        //获取商品信息
        function GetCommodityInfo() {
            isLoading = true;
            if (curpage == 1 && productCount * 1 % 2 == 1) {
                pagesize = 5;
            }
            $(".loading-page").show();
            $.ajax({
                type: "post",
                url: '/TravelAgency/GetCommodityInfoMain/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&MallSearch=' + SearchName + '&type=<%=ViewData["type"]%>&curpage=' + curpage + '&pagesize=' + pagesize + '&dataCount=' + dataCount + '&price=' + price + '&selectCity=' + selectCity + '&cityName=' + cityName + '&sort=' + sort + '&subitem=' + subitem,
                dataType: 'json'
            }).done(function (data) {
                isLoading = false;
                dataCount = data.dataCount * 1;
                var newdata = $.parseJSON(data["data"]);
                if (newdata.length == 0) {
                    canScroll = false;
                    //                $(".ball-pulse").html("没有更多的数据");
                    $(".ball-pulse").hide();
                    if (isChangePrice) {
                        $(".show-list").html(productsHtml + html);
                        isChangePrice = false;
                    }
                    $(".loading-page").hide()
                } else {
                    if (CommodityTypeName == "" && '<%=ViewData["type"]%>' != "") {
                        CommodityTypeName = newdata[0].CommodityTypeName;
                    }

                    $("title").html(CommodityTypeName + SearchName); 
                    SetCommodityHtml(newdata);
                    if (newdata.length < pagesize)
                        $(".ball-pulse").hide();
                    $(".loading-page").hide();
                }
                if (curpage == 1 && newdata.length == 0) {
                    if (price == "" && selectCity == "" && subitem == "")
                        $("footer").hide();
                    if (SearchName != "" && cityName == "")
                        $("footer").hide();
                    if(productCount == 0){
                        $(".nodata-page").show();
                    }else{
                        $(".nodata-page").hide();
                    }
                }
                pagesize = 6;
            });
            setTimeout(function () { $(".loading-page").hide(); }, 5000);
        }
        //    GetCommodityInfo();
        
        //获取促销商品信息
        function GetProductsInfo() {
            $(".loading-page").show();
            if('<%=ViewData["type"]%>' == ""){
            $.ajax({
                type: "post",
                url: '/TravelAgency/GetSaleProductsListToList/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&MallSearch=' + SearchName + '&cityName=' + cityName + '&price=' + price,
                dataType: 'json'
            }).done(function (data) {
                var newdata = $.parseJSON(data["data"]);
                productCount = newdata.length;
                SetProductsHtml(newdata);
                GetCommodityInfo();
            });
            }else{
                GetCommodityInfo();
            }
            setTimeout(function () { $(".loading-page").hide(); }, 5000);
        }

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

        //获取旅行社商品地址
        function GetDataTravelAgencyCommdityLocat(){
        hasDataCityName="";
        hasDataCityName2="";
            $.ajax({
                type: "post",
                url: '/TravelAgency/GetDataTravelAgencyCommdityLocat/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=<%=ViewData["type"]%>&MallSearch=' + SearchName,
                dataType: 'json'
            }).done(function (data) {
            var newdata = $.parseJSON(data["data"]);
                if (newdata.length == 0) {
                } else {

                    //控制地址显示
                    for(var i =0 ;i<newdata.length;i++){
                        hasDataCityName = hasDataCityName + newdata[i].city + ",";
                        hasDataCityName2 = hasDataCityName2 + newdata[i].city2 + ",";
                    }
                }
                    ClearCur();
                    HideLocat();

                    HideAll();
                    ShowLocal(hasDataCityName,hasDataCityName2);
            });
        }
        
        //获取搜索结果类型选项
        function GetSearchCommdityType(){
            $("#dl_type").hide();
            $.ajax({
                type: "post",
                url: '/TravelAgency/GetSearchCommdityType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=<%=ViewData["type"]%>&MallSearch=' + SearchName+'&cityName=' + cityName,
                dataType: 'json'
            }).done(function (data) {
            var newdata = $.parseJSON(data["data"]);
                if (newdata.length == 0) {
                } else {
                if(newdata.length>1){
                    $("#dl_type").show();
                    SetTypeHtml(newdata);
                    }
                }
            });
        }
        GetDataTravelAgencyCommdityLocat();
        GetProductsInfo();
//        GetCommodityInfo();
        GetSearchCommdityType();

        //根据价格搜索
        function ChangePrice(money) {
            Initialization();
            price = money;
//            GetCommodityInfo();
            GetProductsInfo();
        }
        //根据子类搜索
        function ChangeSubitem(str) {
            Initialization();
            productCount = 0;
            if (str == "") {
                subitem = "";
                $(".type-screen").find("div").each(function (index, e) {
//                    if (index != 0 && !$($(".type-screen").find("div")[0]).hasClass("cur")) {
                    if (index != 0) {
                        $(this).removeClass("cur");
                    }
                });
                GetProductsInfo();
            }
            else if (subitem.indexOf(str) > -1) {
                $($(".type-screen").find("div")[0]).removeClass("cur");
                subitem = subitem.replace(str, "");
                productsHtml="";
                GetCommodityInfo();

            } else {
                $($(".type-screen").find("div")[0]).removeClass("cur");
                subitem = subitem + "," + str;
                productsHtml="";
                GetCommodityInfo();
            }
//            GetCommodityInfo();
//            GetProductsInfo();
        }
        //根据位置搜索
        function ChangeLocat(locat,locatName) {
            Initialization();
            selectCity = locat;
            cityName = locatName;
            GetProductsInfo();
//            GetCommodityInfo();
            GetSearchCommdityType();
        }
        //根据名称搜索
        function ChangeName(obj) {
            Initialization();
            price="";
            subitem="";
            cityName="";
            SearchName = $(obj).val();
            GetDataTravelAgencyCommdityLocat();
//            GetCommodityInfo();
            GetProductsInfo();
            GetSearchCommdityType();
//            window.location.href = '/TravelAgency/ShoppingMallByType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=<%=ViewData["type"]%>&MallSearch=' + $(obj).val();

        }
        //修改排序
        function ChangeSort(str) {
            Initialization();
            sort = str;
            $("#sortName").text(str);
            GetCommodityInfo();
        }
        //根据搜索条件初始化JS参数
        function Initialization() {
            $('html, body').animate({ scrollTop: 0 }, 'slow');
            html = "";
            dataCount = 0;
            curpage = 1;
            canScroll = true;
            isChangePrice = true;
            $(".ball-pulse").show();
            $("footer").show();
            $(".nodata-page").hide();
        }

        //主界面显示商品信息
        function SetCommodityHtml(data) {
            //        $(".show-list").html("");
            var isUseStorage = true;
            for (var i = 0; i < data.length; i++) {
                var str = "";
//                if (data[i].CanPurchase * 1 < 1) {
//                    str = '<div class="yu-blue2 yu-overflow yu-f20r"></div>';
//                } else {
//                    str = '<div class="yu-blue2 yu-overflow yu-f20r">可用' + data[i].PurchasePoints + '积分兑换</div>';
//                }
                if (data[i].CanPurchase * 1 < 1) {
                    if (data[i].CommodityType != "") {
                        str = '<div class="yu-blue2 yu-overflow yu-f20r">' + data[i].CommodityTypeName + '</div>';
                    } else {
                        str = '<div class="yu-blue2 yu-overflow yu-f20r">商城</div>';
                    }
                } else {
                    str = '<div class="yu-blue2 yu-overflow yu-f20r">可用' + data[i].PurchasePoints + '积分兑换</div>';
                }
                var str1 = "";
                var str2 = "";
                if (data[i].city != "") {
                    str1 = '<div class="add-mark">' + data[i].city + '</div>';
                }
                if (data[i].SubName != "") {
                    str2 = '<div class="txt">' + data[i].SubName + '</div>';
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
            rHtml + str1 + str2 +
//            '<img src="' + imgList[0] + '"  />' + str1 + str2 +
                //            '<div class="add-mark">安徽</div>'+
                //            '<div class="txt">黄山自然风景区</div>'+
            '</div>' +
            '<div class="yu-bgw yu-h105r yu-lrpad20r">' +
            '<p class="text-ell yu-f24r yu-l55r yu-black">' + data[i].Name + '</p>' +
            '<div class="yu-grid yu-alignc">' +
            str +
            '<div class="yu-c40 yu-f20r">￥<span class="yu-f26r">' + data[i].Price + '</span></div>' +
            '</div></div></a></li>';

            }
            $(".show-list").html(productsHtml + html);
            $(".loading-page").hide();
        }

        //主界面促销商品展示
        function SetProductsHtml(data){
            productsHtml="";
            for (var i = 0; i < data.length; i++) {
            var thisProHtml="";
            var str1 = "";
            var str2 = "";
            if(data[i].ProductType == "0"){
                str1 = '<div class="xs-mark yu-f16r">限量<br />抢购</div>';
            }else{
                str1 = '<div class="xs-mark yu-f16r">限时<br />抢购</div>';
            }
            if(data[i].city != ""){
                str2='<div class="add-mark">'+data[i].city+'</div>';
            }

            thisProHtml = "<li>" +
            '<a href="/Product/ProductDetail/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&ProductId='+data[i].Id+'">'+
            '<div class="img">'+
            '<img src="'+data[i].MainPic+'" onload="loadedImage(this)" style="display:none;"  />'+
            '<div style="background:url(/images/商品图加载.png) no-repeat center; background-size:50%; height: 100%;width:100%;"></div>'+
            str1 + str2 + '</div>' +
            '<div class="yu-bgw yu-h105r yu-lrpad20r">' + 
            '<p class="text-ell yu-f24r yu-l55r yu-black">'+data[i].ProductName+'</p>' +
            '<div class="yu-grid yu-alignc">' + 
            '<div class="mark yu-rmar10r">抢购</div>' +
            '<div class="yu-overflow yu-c40 yu-f20r">￥<span class="yu-f26r">'+data[i].MenPrice+'</span></div>' +
            '</div>'+
            '</div>'+'</a>'+'</li>';

            productsHtml = productsHtml + thisProHtml;
            }
            
            $(".show-list").html(productsHtml);
        }

    function SetTypeHtml(data){
//            typeHtml='<div class="cur" onclick="ChangeSubitem(\'\')">不限</div>';
            typeHtml='<div class="cur" data-id="">不限</div>';
            for (var i = 0; i < data.length; i++) {
//            typeHtml = typeHtml + '<div class="" onclick="ChangeSubitem('+data[i].id+')">'+data[i].Name+'</div>';
            typeHtml = typeHtml + '<div class="" data-id="'+data[i].id+'">'+data[i].Name+'</div>';
            }
            $(".type-screen").html(typeHtml);
    }

    function loadedImage(t) {
        var that = $(t);
        that.show().next().hide();
        that.error(function () {
            that.hide().next().show();
        });
    }

    function GoToNearby(){
            window.location.href = '/TravelAgency/ShoppingMallByNearby/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=<%=ViewData["type"]%>&MallSearch=' + SearchName;
    }
    </script>
    <%--<script src="http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js"></script>
    <script>
        var city = remote_ip_info['city'];
        $(".sp").find(".sp_lab").html(city);
        $(".letter dd>p").each(function () {
            if ($(this).find(".sp_lab").html().indexOf(city) > -1) {
                $(".sp").find(".sp_hid").val($(this).find(".sp_hid").val());
                selectCity = $(this).find(".sp_hid").val();
            }
        });

        GetCommodityInfo();
        $(".nav-btn1").html(city);


    </script>--%>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=Y4ofkWPl6nHN41oFEZj39HPA"></script>
    <script>
        new BMap.LocalCity().get(function (res) {
            //获取当前用户所在城市,酒店有该城市数据则替换默认城市。
            var city = res.name
            //            cityName = city;

            //            var city = remote_ip_info['city'];
            $(".sp").find(".sp_lab").html(city);
            $(".letter dd>p").each(function () {
                if (city.indexOf($(this).find(".sp_lab").html()) > -1) {
                    $(".sp").find(".sp_hid").val($(this).find(".sp_hid").val());
                    selectCity = $(this).find(".sp_hid").val();
                }
            });

        });
    </script>
</body>
</html>
