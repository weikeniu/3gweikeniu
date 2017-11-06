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
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/font/iconfont.css" />
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/swiper/swiper-3.4.1.jquery.min.js"></script>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/font/iconfont.js"></script>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/Scripts/fontSize.js"></script>
    <link href="/css/common.css" rel="stylesheet" />
    <link href="/css/list.css" rel="stylesheet" />
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
    <style type="text/css">
        .icon
        {
            width: 1em;
            height: 1em;
            vertical-align: -0.15em;
            fill: currentColor;
            overflow: hidden;
        }
    </style>
</head>
<body>
    <!--默认页-->
    <article class="base-page">
    <section class="whiteBg clearfix padL2">
    
    <%if (dt_Extension.Rows.Count > 0)
      { %>
                <%foreach (System.Data.DataRow data in dt_Extension.Rows)
                  { %>
                  <div class="swiper-wrapper">
            <div class="be_choosy-left fl">
                  <div class="V_select-good fs-24">精选</div>
                  <div class="V_select-category fs-30 c-222 marT2">
                        <p><%=data["Name"]%></p>
                        <p class="desc clamp3"><%=data["Describe"]%></p>
                        <em></em>
                  </div>
            </div>
            <div class="ShangCity_wrap swiper-container">
                      <div class="swiper-slide"><img src="<%=data["ImageList"].ToString().Split(',')[0] %>" /></div>
                  <div class="swiper-pagination"></div>
                  <div class="ca_search-row dsp_flex flex-alignc">
                        <span class="iconfont icon-soushuo1 marL2 fs-30 c-fff"></span>
                        <input type="text" value="<%=ViewData["MallSearch"] %>" class="flex1 " />
                  </div>
            </div>
                  </div>
                <%}
      }
      else
      { %>

      <div class="swiper-wrapper">
            <div class="be_choosy-left fl">
                  <div class="V_select-good fs-24">精选</div>
                  <div class="V_select-category fs-30 c-222 marT2">
                        <p> 商 城 </p>
                        <p class="desc clamp3"></p>
                        <em></em>
                  </div>
            </div>
            <div class="ShangCity_wrap swiper-container">
                      <div class="swiper-slide"><img src="/images/商城.jpg" /></div>
                  <div class="swiper-pagination"></div>
                  <div class="ca_search-row dsp_flex flex-alignc">
                        <%--<span class="iconfont icon-soushuo1 marL2 fs-30 c-fff"></span>
                        <input type="text" value="<%=ViewData["MallSearch"] %>" class="flex1 " />--%>
                  </div>
            </div>
                  </div>

        <%} %>
 </section>
    <%if (dt_Type.Rows.Count > 1)
      { %>
      <section class="whiteBg marT2 clearfix">
               <div class="sc_nav-row">
                     <ul>
                     <%foreach (System.Data.DataRow dr in dt_Type.Rows)
                       { %>
                          <li><a href="/TravelAgency/ShoppingMallByType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=<%=dr["id"] %>&MallSearch=<%=ViewData["MallSearch"] %>"><i class="iconfont icon-icon2"></i><%=dr["Name"]%></a></li>
                     <%} %>
                     </ul>
               </div>
      </section>
    <%} %>

     <section class="whiteBg marT2 clearfix">
                 <div class="hot_produce-list shop_mallList marL2 padT2">                 <ul id="show-list">                 <%foreach (var item in producdtList)
      { %>                 <li>
                                  <a href="/Product/ProductDetail/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&ProductId=<%=item.Id %>">
                                       <div class="prcImg">
                                       <img src="<%=item.MainPic %>" onload="loadedImage(this)" style="display:none;"  />
                                       <div style="background:url(/images/商品图加载.png) no-repeat center; background-size:50%; height: 100%;width:100%;"></div></div>
                                       <div class="prdName clamp2"><%=item.ProductName %></div>
                                       <div class="c-f40 prdPrice marR15 marB2">
                                            <span class="dom_group-trvl">抢购</span>
                                            <p class="fr">¥<span class="fs-30"><%=item.MenPrice%></span><p>
                                       </div>
                                  </a>
                             </li>                 <%} %></ul>
                  </div>
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
<section class="inner yu-tpad120r">
	<div class="no-r-ico"></div>
	<p class="tiptxt yu-c77 yu-f28r yu-textc">抱歉，未找到您想要的结果！</p>
</section>
</article>
    
<!--关键字弹窗-->
<article class="dig_keyWords" id="J_keyWords">
     <section class="dig_M-box">
               <div class="keyWord_page">
                     <div class="keyWord_search-top dsp_flex flex-alignc">
                           <a href="javascript:closeAllPage()" class="iconfont icon-zuox fs-26 c-999"></a>
                           <div class="search_Box flex1 dsp_flex flex-alignc">
                                 <div class="icon-soushuo1 iconfont fs-22 c-999"></div>
                                 <input type="text" placeholder="搜索商品" id="inp_search" />
                                 <div class="fs-40 c-999">×</div>
                           </div>
                           <div class="fs-26 c-blue canCel_btn sure-btn">确认</div>
                     </div>
                     <div class="digTab_menu dsp_flex">
                            <div class="tabLeft_sider">
                                  <span class="current">类别<em></em></span>
                            </div>
                            <div class="tabRight_sider flex1 marT1">
                                  <ul style="display:block;" class="tab-inner-scroll-ul">
                                        <%foreach (System.Data.DataRow dr in dt_AllType.Rows)
                   { %>
                                       <li class="fs-26">
                   <input type="hidden" value="<%=dr["id"] %>" /><%=dr["Name"] %></li>
          <%} %>
                                  </ul>
                            </div>
                     </div>
               </div>
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
                $(".dig_keyWords").hide();
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
        var isUseStorage = true;
        html = $("#show-list").html();
        for (var i = 0; i < data.length; i++) {
            var str3 = "";
            if (data[i].CanPurchase * 1 < 1) {
                if (data[i].CommodityType != "") {
                    str3 = '<span class="dom_group-trvl">' + data[i].CommodityTypeName + '</span>';
                } else {
                    str3 = '<span class="dom_group-trvl">商城</span>';
                }
            } else {
                if (data[i].PurchasePoints * 1 > 0) {
                    str3 = '<span class="dom_group-trvl">可用' + data[i].PurchasePoints + '积分兑换</span>';
                }
            }
            var imgList = data[i].ImageList.split(",");
            var rHtml = "";
            if (imgList[0] == null || imgList[0] == '') {//没有图片显示默认svg
                rHtml += '<div style="background:url(/images/商品图加载.png) no-repeat center; background-size:50%; height: 100%;width:100%;"></div>';
            } else {//有图片无法加载时也显示默认svg
                rHtml += '<img src="' + imgList[0] + '" onload="loadedImage(this)" style="display:none;" />';
                rHtml += '<div style="background:url(/images/商品图加载.png) no-repeat center; background-size:50%; height: 100%;width:100%;"></div>';
            }

            html = html + "<li>" +
            '<a href="/TravelAgency/CommodityDetail/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&CommodityID=' + data[i].id + '">' +
            '<div class="prcImg">' +
            rHtml + 
            '</div>' +
            '<div class="prdName clamp2">' + data[i].Name + '</div>' +
            '<div class="c-f40 prdPrice marR15 marB2">' +
            str3 +
            '<p class="fr">¥<span class="fs-30">' + data[i].Price + '</span><p>' +
            '</div></a></li>';
        }
        $("#show-list").html(html);
        $(".loading-page").hide();
    }
    //根据搜索条件初始化JS参数
    function Initialization() {
        $('html, body').animate({ scrollTop: 0 }, 'slow');
        html = "";
        dataCount = 0;
        curpage = 1;
        canScroll = true;
        $("#show-list").html("");
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
    $(".flex1").click(function () {
        $(".nodata-page").hide();
        $(".base-page").hide();
        $(".dig_keyWords").show();
    })
    $(".tab-nav").children("li").on("click", function () {
        $(this).addClass("cur").siblings("li").removeClass("cur");
        tabIndex = $(this).index();
        $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
    })
    $(".tab-inner-scroll-ul").children("li").on("click", function () {
        $(this).toggleClass("cur");
        var typeId = $(this).find("input").val();
        //
        window.location.href = '/TravelAgency/ShoppingMallByType/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&type=' + typeId;
    })
    $(".dig_keyWords .cal-btn").click(function () {
        $(".dig_keyWords").hide();
        $(".base-page").show();
    })
    function closeAllPage() {
        $(".dig_keyWords").hide();
        $(".base-page").show();
    }

    //清空文本框
    $(".J__iptClear").on("click", function () {
        $(this).siblings("input").val("").focus();
    })
</script>
</html>
