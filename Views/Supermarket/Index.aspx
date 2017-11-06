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
    <title>酒店超市</title>

    <%
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    ViewDataDictionary viewDic = new ViewDataDictionary();
    string openid = ViewData["userweixinid"].ToString();
    string key = string.Format("{0}@{1}", ViewData["weixinid"], openid);
    
    if (!openid.Contains(wkn_shareopenid))
    {
        //非二次分享 获取推广员信息
        var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(ViewData["weixinid"].ToString(), openid);
        ///原链接已经是分享过的链接
        key = string.Format("{0}@{1}_{2}", ViewData["weixinid"], wkn_shareopenid, CurUser.memberid);
    }
    string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}&commodityid={2}", Request.Url.LocalPath, key, ViewData["CommodityID"]);

    string desn = "新品商上架 优惠多多~";
    
    hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
    {
        title = ViewData["Address"].ToString()+" 超市",
        desn = desn,
        logo = "http://hotel.weikeniu.com/images/supermarket.jpg",
        debug = false,
        userweixinid = ViewData["userweixinid"].ToString(),
        weixinid = ViewData["weixinid"].ToString(),
        hotelid = int.Parse(ViewData["hotelId"].ToString()),
        sharelink = sharelink
    };
    ViewData["WeiXinShareConfig"] = WeiXinShareConfig;
    
    //sviewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
    //Html.RenderPartial("WeiXinShare", viewDic); 
%>


    <%--<link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/swiper/swiper-3.4.1.min.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/fontSize.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/swiper/swiper-3.4.1.jquery.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/drag.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/fontSize.js"></script>  
    <script src="http://css.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>--%>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/swiper/swiper-3.4.1.min.css" />
    <link type="text/css" rel="stylesheet" href="/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/fontSize.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/swiper/swiper-3.4.1.jquery.min.js"></script>
    <%--<script type="text/javascript" src="http://css.weikeniu.com/Scripts/drag.js"></script>--%>
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
    <%--<script type="text/javascript" src="http://css.weikeniu.com/Scripts/js.js"></script>--%>
    <script src="http://css.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>

    <style type="text/css">
	.big-food-box{background:#fff;height:4.6125rem;}
</style>
</head>
<%
    
    System.Data.DataTable dt_Type = ViewData["CommodityTypeTable"] as System.Data.DataTable;
    //System.Data.DataTable dt_Type2 = ViewData["CommodityTypeTable2"] as System.Data.DataTable;
%>

<body class="yu-bpad60">
    <%-- <% Html.RenderPartial("QuickNavigation", null); %>--%>
    <%--class="yu-bpad60"--%>
    <% List<System.Data.DataRow> list_detail = (List<System.Data.DataRow>)ViewData["commodityList"];
       if (list_detail.Count > 0)
       { %>
    <section class="yu-bgf3 yu-tpad190r">
		<%--<p class="yu-c66 yu-pad10">全部商品</p>--%>
        <%if (dt_Type.Rows.Count > 1)
          { %>
		<div class="market-top yu-bgw yu-bmar10r">
			<div class="yu-grid yu-alignc yu-h90r yu-bor bbor yu-lrpad20r">
				<%--<p class="yu-overflow yu-f30r">全部商品</p>--%>
				<ul class="pro-tab yu-overflow">
					<li class="cur" id="li_select1" onclick="SelectAllType()">全部商品</li>
                    <%for (int i = 0; i < dt_Type.Rows.Count;i++ ){
                          if (i > 1)
                              break;%>
					<li onclick="SelectType(<%=dt_Type.Rows[i]["id"] %>)" data-id="<%=dt_Type.Rows[i]["id"] %>"><%=dt_Type.Rows[i]["Name"]%></li>
					<%--<li>套票</li>--%>
                    <%} %>
				</ul>
				<div class="screen-switch yu-grid yu-alignc">
					<span class="yu-f26r yu-c66 yu-rmar10r">筛选</span><span class="screen-ico"></span>
				</div>
			</div>
			<dl class="yu-tbpad20r yu-bor bbor yu-lrpad20r yu-grid yu-alignc" style="display:none;" id="dt_tip">
				<dt class="yu-f22r yu-c99">已选标签：</dt>
				<dd class="yu-overflow2 screen-item-bar">
					<!--<div class="screen-item">积分换购<span class="xx">x</span></div>
					<div class="screen-item">积分换购<span class="xx">x</span></div>
					<div class="screen-item">积分换购<span class="xx">x</span></div>-->
				</dd>
			</dl>
			<div class="screen-box yu-bgw">
				<ul class="screen-list">
					<li class="yu-h80r yu-bor bbor yu-grid yu-alignc yu-lrpad20r all">
						<p class="yu-overflow yu-f26r screen-con">全部</p>
						<p class="copy-radio"></p>
					</li>
                    <%foreach (System.Data.DataRow dr in dt_Type.Rows)
                      { %>
					<li class="yu-h80r yu-bor bbor yu-grid yu-alignc yu-lrpad20r" data-id="<%=dr["id"] %>">
						<p class="yu-overflow yu-f26r screen-con"><%=dr["Name"]%></p>
						<p class="copy-radio"></p>
					</li>
          <%} %>
          <%--<%foreach (System.Data.DataRow dr in dt_Type2.Rows)
            { %>
					<li class="yu-h80r yu-bor bbor yu-grid yu-alignc yu-lrpad20r" data-id="<%=dr["id"] %>">
						<p class="yu-overflow yu-f26r screen-con"><%=dr["Name"] %></p>
						<p class="copy-radio"></p>
					</li>
          <%} %>--%>
					
				</ul>
				<div class="yu-grid yu-alignc screen-btn2 yu-bor tbor yu-j-c">
					<input type="button" value="重置" />
					<input type="button" value="确定" />
					
				</div>
			</div>
		</div>
        <%} %>
        <%if (dt_Type.Rows.Count > 1)
          { %>
		<ul class="product-list">
        <%}
          else
          { %>
		<ul class="product-list" style="margin-top:-70px;">
        <%} %>
             <%--  <% foreach (System.Data.DataRow row in list_detail)
                  { 
                         %>
                            <li>
				                <div class="yu-bgw">
					                <a href="javascript:;" class="product-img">
                                        <img src='<%=row["ImagePath"] %>' style=" width:100%; height:100%;" />
                                        <input type="hidden" name="Describe" value='<%=row["Describe"]%>' />
                                        <input type="hidden" name="ImageList" value='<%=row["ImageList"]%>' />
                                        <input type="hidden" name="UseRichText" value='<%=row["UseRichText"]%>' />
                                        <%if (row["CanPurchase"].ToString() == "0")
                                          { %>
                                        <div class="jf-mark yu-v-h">积分</div>
                                        <%}
                                          else
                                          { %>
                                        <div class="jf-mark">积分</div>
                                        <%} %>
					                </a>
				                <div class="yu-pad10">
					                <p class="yu-font14 yu-bmar10 text-ell"><%=row["Name"]%></p>
                                    <%if (row["CanPurchase"].ToString() == "0")
                                      { %>
                                        <div class="yu-grid yu-alignc yu-v-h">
			     		<p class="jf-ico"></p>
			     		<p class="yu-orange yu-font12"><%=row["PurchasePoints"]%>积分兑换</p>
			     	</div>
                                        <%}
                                      else
                                      { %>
                                        <div class="yu-grid yu-alignc">
			     		<p class="jf-ico"></p>
			     		<p class="yu-orange yu-font12"><%=row["PurchasePoints"]%>积分兑换</p>
			     	</div>
                                        <%} %>
					                <div class="yu-grid yu-alignc">
						                <p class="yu-orange yu-overflow"><i class="yu-font12">￥</i><i class="yu-font18 yu-fontb"><%=row["Price"]%></i></p>
                                        <input type="hidden" name="CommodityId" value='<%=row["id"]%>' />
                                        <input type="hidden" name="CommodityStock" value='<%=row["Stock"]%>' />
                                        <input type="hidden" name="CommodityCanPurchase" value='<%=row["CanPurchase"]%>' />
                                        <input type="hidden" name="CommodityPurchasePoints" value='<%=row["PurchasePoints"]%>' />
                                        <%if (int.Parse(row["Stock"].ToString()) < 1)
                                          {  %>
                                          <p class="yu-line30">已售完</p>
                                        <%}
                                          else
                                          { %>
						                <div class="ar yu-grid">
								                <p class="reduce ico reduce1"></p>
								                <p class="food-num"><%=row["Total"]%></p>
								                <p class="add ico add1"></p>
						                </div>
                                        <%} %>
					                </div>
				                </div>
				                </div>
			                </li>
                         <%
                             }
         %>--%>
		</ul>
	</section>
    <%}
       else
       { %>
    <!--查询失败-->
    <div class="faile-content">
        <section class="faile-bg">
		<img src="../../images/faile.png" />
		</section>
        <p class="yu-textc yu-font14 yu-bmar20">
            <%if (!string.IsNullOrWhiteSpace(ViewData["SupermarketSearch"].ToString()))
              { %>
            没有找到于“<%=ViewData["SupermarketSearch"]%>”相关的宝贝
            <%}
              else
              { %>
            没有找到宝贝
            <%} %>
        </p>
        <a href="/Supermarket/Search/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>"
            class="re-seach yu-grid yu-bor1 bor yu-blue2 yu-alignc yu-j-c">
            <p class="ico">
            </p>
            <p>
                重新搜索看看！</p>
        </a>
    </div>
    <%} %>
    <!--底部-->
    <section class="mask bottomMask"></section>
    <footer class="yu-grid fix-bottom yu-bor tbor yu-lpad10 touch_action">
    <!--商品展示-->
	<div class="food-details up-slide-ani">
		<dl>
			<dt class="yu-grid yu-bor bbor yu-h40 yu-alignc yu-lrpad10">
				<span class="ico type1"></span>
				<p class="yu-rmar10"><%=ViewData["Address"] %></p>
				<p class="yu-font12 yu-lgrey yu-overflow"><%--餐饮将送到此房间--%></p>
				<div class="yu-grid yu-alignc yu-greys clearall">
					<span class="ico type3"></span>
					清空
				</div>
			</dt>
			<dd id="Detailed_dd">
           <%-- <% 
                System.Data.DataTable dt_detail = (System.Data.DataTable)ViewData["commodityDataTable"];
                foreach (System.Data.DataRow row in dt_detail.Rows)
                {
                    if (!string.IsNullOrWhiteSpace(row["Total"].ToString()))
                    {
                         %>
                        <div class="yu-grid yu-bor bbor yu-h50 yu-alignc yu-lrpad10">
					        <p class="yu-overflow"><%=row["Name"]%></p>
					        <p class="yu-orange yu-rmar20"><i class="yu-font12">￥</i><i class="yu-font20"><%=row["Price"]%></i></p>
                            <input type="hidden" name="CommodityId" value="<%=row["id"]%>" />
                            <input type="hidden" name="CommodityStock" value='<%=row["Stock"]%>' />
					        <div class="ar yu-grid">
								<p class="reduce ico reduce2"></p>
								<p class="food-num"><%=row["Total"]%></p>
								<p class="add ico add2"></p>
							</div>
				        </div>
                         <%
}
                }   
         %>--%>
			</dd>
		</dl>
		<!--<dl>
			<dt class="yu-grid yu-bor bbor yu-h40 yu-alignc yu-lrpad10">
				<span class="ico type2"></span>
				<p class="yu-overflow">201B</p>
				<i class="ico type4"></i>
				<p class="yu-font12 yu-lgrey">若需要分装长按商品拖入此房间</p>
			</dt>
		</dl>-->
		<%--<div class="yu-grid yu-alignc yu-h50 yu-lrpad10">
			<p>包装费</p>
			<div class="yu-overflow yu-orange"><i class="yu-font12">￥</i><i class="yu-font20">2.5</i> </div>
		</div>--%>
	</div>
	<div class="gwc-ico"><i class="num"></i><span></span></div>
	<div class="yu-overflow yu-orange"><!--<i class="yu-font26">共</i>--><i class="yu-font14">￥</i><i class="yu-font26">0</i></div>
	<div id="bottom_detail" class="yu-greys  yu-rpad20 yu-rmar10 yu-font14">明细</div>
	<div class="yu-btn" onclick="Pay()">请选择</div>
	
</footer>
    <% Html.RenderPartial("SupermarketNavigation", null); %>
    <!--底部end-->
    <!--mask-->
    <section class="mask bigimg">
	<div class="inner">
    <div class="jf-mark" id="showScoreLogo">积分</div>
		<div class="big-food-box swiper-container2">
        <div class="swiper-wrapper" id="maskImage">
          <div class="swiper-slide"><img src="/images/114.png" /></div>
      </div>
     </div>
     <div class="big-food-details">
     	<p class="yu-font20 yu-bmar5" id="maskName">天然洗护用品一套</p>
     	<!--<p class="yu-grey yu-font12 yu-bmar10">月售186 赞99</p>-->
     	<div class="yu-grid yu-grey yu-font12 yu-bmar10">
     		<p class="yu-rmar5">商品明细:</p>
     		<p class="yu-overflow2" style="max-height:100px;overflow-y:scroll;">
     			<span id="maskDetail">洗发水一瓶500ML</span>
     		</p>
     	</div>
        <div class="yu-grid yu-alignc" id="showScore">
     		<p class="jf-ico"></p>
     		<p class="yu-orange yu-font12" id="p_showScore">50000积分兑换</p>
     	</div>
     	<div class="yu-grid">
        <input type="hidden" id="maskId" />
        <input type="hidden" id="maskStock" />
     		<p class="yu-overflow yu-orange yu-font20"><i class="yu-font12">￥</i><span id="maskPrice">31</span></p>
     		<div class="ar yu-grid" id="maskOperation">
				<p class="reduce ico  reduce3"></p>
				<p class="food-num" id="maskNum"></p>
				<p class="add ico add3"></p>
			</div>
            <p class="yu-line30" style="display:none;" id="maskSoldOut">已售完</p>
     	</div>
     </div>
	</div>
</section>
    <section class="loading-page" style="position: fixed;">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
    <script type="text/javascript">
        var shoppingCart = {};
            //加减商品
            var foodNum = 0;
            var totalNum = 0;
            var money = 0;
            var isCanRun = true;
            var Shielding;
            var type="";
            var isHaveType = false;
            var isFirst = true;
        //shoppingCart.hotelId='<%=ViewData["hotelId"] %>';
        //shoppingCart.Commditys={};
        $(function () {
                    sessionStorage.SupperMarketIsBack = 0;
            if(localStorage.SuperMarketShoppingCart != undefined)
                shoppingCart=$.parseJSON(localStorage.SuperMarketShoppingCart);

            //从数据库获取数据添加到页面
             LoadData();

        });
        
            //从数据库获取数据添加到页面
        function LoadData(){
            if("<%=dt_Type.Rows.Count %>" * 1 < 2){
                $(".product-list").css("margin-top","-70px");
            }
            else if((type == "" && "<%=dt_Type.Rows.Count %>" * 1 > 1) || !isHaveType){
                $(".product-list").css("margin-top","-30px");
            }else if( "<%=dt_Type.Rows.Count %>" * 1 > 1){
                $(".product-list").css("margin-top","12px");
            }
            $(".loading-page").show();
            setTimeout(function(){$(".loading-page").hide()},5000);
            $.ajax({
                type: "post",
                url: '/Supermarket/GetCommodityInfo/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&SupermarketSearch=<%=ViewData["SupermarketSearch"]%>&type='+type,
                dataType: 'json'
            }).done(function (data) {
                var newdata = $.parseJSON(data["data"]);
                var newdata2 = $.parseJSON(data["data2"]);
                SetCommodityHtml(newdata);
                
                if(isFirst){
                    SetBottomHtml(newdata2);
                    isFirst=false;
                }

                //加载后显示购物车已有数据
            $(".product-list").find(".food-num").each(function () {
                if ($(this).text() != "" && $(this).text() != 0) {
                    $(this).fadeIn();
                    $(this).prev().fadeIn();
                }

            });
            
            //点击出现大图
            $(".product-list li").on("click","a", function () {
            var commodity=$(this).parent().parent().find('input[name="CommodityId"]').val();
            if($(this).find('input[name="UseRichText"]').val() * 1 ==1){
                location.href = "/Supermarket/CommodityRichText/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&CommodityID="+commodity;
            }
            else{
                foodNum = $(this).parent().parent().find(".food-num").html();
                if (foodNum == 0) {
                    $(".reduce3").fadeOut().siblings(".food-num").fadeOut();
                } else {
                    $(".reduce3").fadeIn().siblings(".food-num").fadeIn();
                }

                //窗口内容赋值
                $("#maskImage").html("");//
//                $("#maskImage").append('<div class="swiper-slide"><img src="' + $(this).find("img").attr("src") + '" /></div>');
                var imgList = $(this).find('input[name="ImageList"]').val().split(",");
                for(var i =0;i<imgList.length;i++){
//                   $("#maskImage").append('<div class="swiper-slide"><img src="' + imgList[i] + '" /></div>');
                   
                   $("#maskImage").append('<div class="swiper-slide" style="background:url('+imgList[i]+') no-repeat center;background-size:contain;"></div>');
                }
                $("#maskId").val(commodity);
                $("#maskName").text($(this).parent().parent().find(".text-ell").html());

                var describe = $(this).find("input").val();
                describe = describe.replace(/\n/ig, "<br/>");
                $("#maskDetail").html(describe);
                $("#maskPrice").html($(this).parent().parent().find(".yu-fontb").html());
                $("#maskNum").text(foodNum);
                $("#maskStock").val($(this).parent().parent().find('input[name="CommodityStock"]').val());
                if(foodNum == undefined){
                $("#maskSoldOut").show();
                $("#maskOperation").hide();
                }else{
                $("#maskSoldOut").hide();
                $("#maskOperation").show();
                }
                if($(this).parent().parent().find('input[name="CommodityCanPurchase"]').val() * 1 == 0){
                    $("#showScore").addClass("yu-v-h");
                    $("#showScoreLogo").addClass("yu-v-h");
                }else{
                    $("#showScore").removeClass("yu-v-h");
                    $("#showScoreLogo").removeClass("yu-v-h");
                    $("#p_showScore").text($(this).parent().parent().find('input[name="CommodityPurchasePoints"]').val() + "积分兑换");
                }
                $(".bigimg").fadeIn();

                var swiper2 = new Swiper('.swiper-container2', {
                    paginationClickable: true,
                    autoplay: 5000,
                    autoplayDisableOnInteraction: false,
                    loop: true
                });
                //大图弹窗高度
                innerH = $(".bigimg .inner").height();
                $(".bigimg .inner").css("margin-top", -innerH / 2);
                
            }
            });

            });
        
        }
        

            //新增按钮1
            $(document).on("click",".add1", function () {
                var total = $(this).parent().find(".food-num").html();
                var CommodityId = $(this).parent().parent().find("input[name='CommodityId']").val();
                var CommodityStock = $(this).parent().parent().find("input[name='CommodityStock']").val();
                var CommodityName = $(this).parent().parent().parent().find(".yu-bmar10").html();
                var CommodityPrice = $(this).parent().parent().find(".yu-fontb").html();

                if (total * 1 == CommodityStock * 1) {
                    layer.msg("没有库存,不能再多了");
                    return false;
                }

                AddCommodity(CommodityId, CommodityName, CommodityPrice, CommodityStock);
            });

            //订单详细新增按钮
            $(".food-details").find("dd").on("click", ".add2", function () {
                var total = $(this).parent().find(".food-num").html();
                var CommodityId = $(this).parent().parent().find("input").val();
                var CommodityStock = $(this).parent().parent().find("input[name='CommodityStock']").val();
                var CommodityName = $(this).parent().parent().find(".yu-overflow").html();
                var CommodityPrice = $(this).parent().parent().find(".yu-font20").html();
                
                if (total * 1 == CommodityStock * 1) {
                    layer.msg("没有库存,不能再多了");
                    return false;
                }

                AddCommodity(CommodityId, CommodityName, CommodityPrice, CommodityStock);
            });

            $(".add3").on("click", function () {
                var total = $("#maskNum").text() == "" ? 0: $("#maskNum").text();
                var CommodityId = $("#maskId").val();
                var CommodityStock = $("#maskStock").val();
                var CommodityName = $("#maskName").text();
                var CommodityPrice = $("#maskPrice").html();
                
                if (total * 1 == CommodityStock * 1) {
                    layer.msg("没有库存,不能再多了");
                    return false;
                }

                AddCommodity(CommodityId, CommodityName, CommodityPrice, CommodityStock);
            });

            //数据库增加商品
            function AddCommodity(CommodityId, CommodityName, CommodityPrice, CommodityStock) {
                if (!isCanRun)
                    return false;

                shoppingCart[CommodityId] = shoppingCart[CommodityId] == undefined ? 1 : shoppingCart[CommodityId] * 1 + 1;
                localStorage.SuperMarketShoppingCart=JSON.stringify(shoppingCart); 

                addAllChange(CommodityId, CommodityName, CommodityPrice, CommodityStock);

                //            
                if (!$("#bottom_detail").hasClass("yu-arr"))
                    $("#bottom_detail").addClass("yu-arr").addClass("type-up");
            }

            //多个商品信息同时增加
            function addAllChange(CommodityId, CommodityName, CommodityPrice, CommodityStock) {
                money = money + CommodityPrice * 1;
                    money = parseFloat(money.toFixed(2));
                totalNum++;
                $(".yu-btn").text("选好了");

                //从主界面循环修改主界面的加减
                $(".product-list").find("input[name='CommodityId']").each(function () {
                    if ($(this).val() == CommodityId) {
                        if ($(this).parent().find(".food-num").text() == "" || $(this).parent().find(".food-num").text() == 0) {
                            foodNum = 1;
                            $(this).parent().find(".food-num").text(foodNum);
                            addDetailed(CommodityId, CommodityName, CommodityPrice, CommodityStock, foodNum);
                        } else {

                            foodNum = parseInt($(this).parent().find(".food-num").text());
                            foodNum++;
                            $(this).parent().find(".food-num").text(foodNum);

                            //循环修改详细的加减
                            $("#Detailed_dd").find("input").each(function () {
                                if ($(this).val() == CommodityId) {
                                    $(this).parent().find(".food-num").text(foodNum);
                                }
                            });
                        };
                        $(this).parent().find(".reduce").fadeIn();
                        $(this).parent().find(".food-num").fadeIn();
                    }
                });

                $(".reduce3").fadeIn().siblings(".food-num").fadeIn().text(foodNum);
                $(".gwc-ico .num").text(totalNum);
                $(".gwc-ico .num").fadeIn();
                $(".yu-font26").html(toDecimal2(money));
            }

            //减少商品按钮
            $(document).on("click",".reduce1", function () {
                var CommodityId = $(this).parent().parent().find("input").val();
                var CommodityPrice = $(this).parent().parent().find(".yu-fontb").html();
                if($(this).parent().find(".food-num").html()*1>0)
                ReduceCommodity(CommodityId, CommodityPrice);
            });

            //减少商品按钮
            $(".reduce3").on("click", function () {
                var CommodityId = $("#maskId").val();
                var CommodityPrice = $("#maskPrice").html();
                if($(this).parent().find(".food-num").html()*1>0)
                ReduceCommodity(CommodityId, CommodityPrice);
            });

            //订单详细减少按钮
            $(".food-details").find("dd").on("click", ".reduce2", function () {
                var CommodityId = $(this).parent().parent().find("input").val();
                var CommodityPrice = $(this).parent().parent().find(".yu-font20").html();
                if($(this).parent().find(".food-num").html()*1>0)
                ReduceCommodity(CommodityId, CommodityPrice);
            });

            //数据库减少商品
            function ReduceCommodity(CommodityId, CommodityPrice) {
                if (!isCanRun)
                    return false;

                shoppingCart[CommodityId] = shoppingCart[CommodityId] == undefined ? 0 : shoppingCart[CommodityId] * 1 - 1;
                localStorage.SuperMarketShoppingCart=JSON.stringify(shoppingCart); 

                ReduceAllChange(CommodityId, CommodityPrice);
            }

            //多个商品信息显示同时减少
            function ReduceAllChange(CommodityId, CommodityPrice) {
                if (money - CommodityPrice * 1 >= 0) {
                    money = money - CommodityPrice * 1;
                    money = parseFloat(money.toFixed(2));
                    $(".yu-font26").html(toDecimal2(money));
                } else {
                    return false;
                }

                //循环主界面减少
                $(".product-list").find("input[name='CommodityId']").each(function () {
                    if ($(this).val() == CommodityId) {
                        foodNum = parseInt($(this).parent().find(".food-num").text());
                        if (foodNum > 0) {
                            totalNum--;
                            foodNum--;
                            $(this).parent().find(".food-num").text(foodNum);
                            $(".gwc-ico .num").text(totalNum);
                            totalNum == 0 ? $(".yu-btn").text("请选择") : $(".yu-btn").text("选好了");


                            if ($("#bottom_detail").hasClass("yu-arr") && totalNum == 0)
                                $("#bottom_detail").removeClass("yu-arr").removeClass("type-up");

                            if (totalNum == 0) {
                                $(".yu-btn").text("请选择");
                                $(".gwc-ico .num").fadeOut();
                            }
                            if (foodNum == 0) {// && $(this).parents("dl").hasClass("food-list")
                                $(this).parent().find(".reduce").fadeOut().siblings(".food-num").fadeOut();
                                //循环修改详细的删除
                                $("#Detailed_dd").find("input").each(function () {
                                    if ($(this).val() == CommodityId) {
                                        $(this).parent().remove();
                                    }
                                });
                            } else {
                                //循环修改详细的加减
                                $("#Detailed_dd").find("input").each(function () {
                                    if ($(this).val() == CommodityId) {
                                        $(this).parent().find(".food-num").text(foodNum);
                                    }
                                });
                            }
                        };
                    }
                });

                $(".reduce3").siblings(".food-num").text(foodNum);
                if (foodNum == 0) {
                    $(".reduce3").fadeOut().siblings(".food-num").fadeOut();
                }
            }

            //明细
            $(".fix-bottom").click(function () {
                if (totalNum != 0 || $(this).find(".yu-arr").hasClass("type-down")) {
                    $(".food-details").toggle();
                    $(this).find(".yu-arr").toggleClass("type-up").toggleClass("type-down");
                    $(".bottomMask").fadeToggle();
                } else {

                }
            })
            $(".fix-bottom ").on("click",".yu-btn",function (e) {
                e.stopPropagation();
            })
            $(".food-details").click(function (e) {
                e.stopPropagation();
            })
            $(".bottomMask").click(function () {
                $(".food-details").toggle();
                $(".fix-bottom").find(".yu-arr").toggleClass("type-up").toggleClass("type-down");
                $(".bottomMask").fadeOut();
            })
            //清空
            $(".clearall").click(function () {
                var that = this;
                money=0;
                    totalNum = 0;
                    foodNum = 0;

                    if ($("#bottom_detail").hasClass("yu-arr") && totalNum == 0)
                        $("#bottom_detail").removeClass("yu-arr").removeClass("type-up");

                    $(".yu-btn").text("请选择");
                    $(".gwc-ico .num").fadeOut();
                    $(".yu-font26").html(0);
                    $(".product-list").find("input").each(function () {
                        $(this).next().find(".food-num").text(foodNum);
                        $(this).next().find(".reduce1").fadeOut().siblings(".food-num").fadeOut();
                    });
                    $("#Detailed_dd").html("");
                $.post('/Supermarket/ClearCommodityToShoppingCart/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&weixinID=<%=ViewData["weixinid"] %>&userweixinID=<%=ViewData["userweixinid"] %>', function (data) {
                });
                shoppingCart = {};
                localStorage.removeItem("SuperMarketShoppingCart");
            });

            //mask通用
            $(".mask").on("click",function () {
                $(this).fadeOut();
            });
            $(".mask").on("click",".inner",function (e) {
                e.stopPropagation();
            });
            //点击出现大图
            $(".product-list li").on("click","a", function () {
            var commodity=$(this).parent().parent().find('input[name="CommodityId"]').val();
            if($(this).find('input[name="UseRichText"]').val() * 1 ==1){
                location.href = "/Supermarket/CommodityRichText/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&CommodityID="+commodity;
            }
            else{
                foodNum = $(this).parent().parent().find(".food-num").html();
                if (foodNum == 0) {
                    $(".reduce3").fadeOut().siblings(".food-num").fadeOut();
                } else {
                    $(".reduce3").fadeIn().siblings(".food-num").fadeIn();
                }

                //窗口内容赋值
                $("#maskImage").html("");//
//                $("#maskImage").append('<div class="swiper-slide"><img src="' + $(this).find("img").attr("src") + '" /></div>');
                var imgList = $(this).find('input[name="ImageList"]').val().split(",");
                for(var i =0;i<imgList.length;i++){
                   //$("#maskImage").append('<div class="swiper-slide"><img src="' + imgList[i] + '" /></div>');
                   $("#maskImage").append('<div class="swiper-slide" style="background:url('+imgList[i]+') no-repeat center;background-size:contain;"></div>');
                }
                $("#maskId").val(commodity);
                $("#maskName").text($(this).parent().parent().find(".text-ell").html());

                var describe = $(this).find("input").val();
                describe = describe.replace(/\n/ig, "<br/>");
                $("#maskDetail").html(describe);
                $("#maskPrice").html($(this).parent().parent().find(".yu-fontb").html());
                $("#maskNum").text(foodNum);
                $("#maskStock").val($(this).parent().parent().find('input[name="CommodityStock"]').val());
                if(foodNum == undefined){
                $("#maskSoldOut").show();
                $("#maskOperation").hide();
                }else{
                $("#maskSoldOut").hide();
                $("#maskOperation").show();
                }
                if($(this).parent().parent().find('input[name="CommodityCanPurchase"]').val() * 1 == 0){
                    $("#showScore").addClass("yu-v-h");
                    $("#showScoreLogo").addClass("yu-v-h");
                }else{
                    $("#showScore").removeClass("yu-v-h");
                    $("#showScoreLogo").removeClass("yu-v-h");
                    $("#p_showScore").text($(this).parent().parent().find('input[name="CommodityPurchasePoints"]').val() + "积分兑换");
                }
                $(".bigimg").fadeIn();

                var swiper2 = new Swiper('.swiper-container2', {
                    paginationClickable: true,
                    autoplay: 5000,
                    autoplayDisableOnInteraction: false,
                    loop: true
                });
                //大图弹窗高度
                innerH = $(".bigimg .inner").height();
                $(".bigimg .inner").css("margin-top", -innerH / 2);
                
            }
            });


        function Pay() {
            var newcart = JSON.stringify(shoppingCart); 
            if ($(".yu-btn").text() == "选好了") {

                $.ajax({
                    data: { shoppingCart: newcart },
                    type: "post",
                    url: '/Supermarket/AddShoppingCart/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&weixinID',
                    dataType: 'json'
                }).done(function (data) {
                    if (data.error == 0) {
                        layer.msg(data.message);
                        return false;
                    }
                                        location.href = "/Supermarket/OrderDetails/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>";
                });

            }
        }

        //给订单详细增加控件
        function addDetailed(CommodityId, CommodityName, CommodityPrice, CommodityStock, foodnum) {
            $("#Detailed_dd").append('<div class="yu-grid yu-bor bbor yu-h50 yu-alignc yu-lrpad10">' +
				'<p class="yu-overflow">' + CommodityName + '</p>' +
				'<p class="yu-orange yu-rmar20"><i class="yu-font12">￥</i><i class="yu-font20">' + toDecimal2(CommodityPrice) + '</i></p>' +
                '<input type="hidden" name="CommodityId" value="' + CommodityId + '" />' +
                '<input type="hidden" name="CommodityStock" value='+CommodityStock+' />' +
				'<div class="ar yu-grid">' +
											'<p class="reduce ico reduce2"></p>' +
											'<p class="food-num">'+foodnum+'</p>' +
											'<p class="add ico add2"></p>' +
										'</div>' +
			'</div>');
        }

        //主界面显示商品信息
        function SetCommodityHtml(data){
            $(".product-list").html("");
            var html="";
            var isUseStorage=true;
            for(var i =0;i<data.length;i++){

            var str="";
            var str2="";
            var str3="";
            
            var imgList = data[i].ImageList.split(",");
            if(data[i].Stock<1){
                str='<p class="yu-line30">已售完</p>';
            }else{
            var dataTotal=0;
            if(shoppingCart != {}){
                for(comm in shoppingCart){
                    if(comm == data[i].id){dataTotal=shoppingCart[comm] * 1}}
            }else{
                dataTotal = data[i].Total;
            }
                str='<div class="ar yu-grid"><p class="reduce ico reduce1"></p><p class="food-num">'+dataTotal+'</p><p class="add ico add1"></p></div>';
            }
            if(data[i].CanPurchase<1){
                str2='<div class="yu-grid yu-alignc yu-v-h">';
                str3='<div class="jf-mark yu-v-h">积分</div>';
            }else{
                str2='<div class="yu-grid yu-alignc">';
                str3='<div class="jf-mark">积分</div>';
            }

            html = html + "<li>"+
            '<div class="yu-bgw">'+
            '<a href="javascript:;" class="product-img" style="background:url('+imgList[0]+') no-repeat center;background-size:cover;">'+
//            '<img src="'+data[i].ImagePath+'" style=" width:100%; height:100%;" />'+
//            '<img src="'+imgList[0]+'" style=" width:100%; height:100%;" />'+
            '<input type="hidden" name="Describe" value="'+data[i].Describe+'" />'+
            '<input type="hidden" name="ImageList" value="'+data[i].ImageList+'" />'+
            '<input type="hidden" name="UseRichText" value="'+data[i].UseRichText+'" />'+
            str3 +'</a>'+
            '<div class="yu-pad10">'+
            '<p class="yu-font14 yu-bmar10 text-ell">'+data[i].Name+'</p>'+ 
            str2 +
			     		'<p class="jf-ico"></p>'+
			     		'<p class="yu-orange yu-font12">'+data[i].PurchasePoints+'积分兑换</p>'+
			     	'</div>'+
            '<div class="yu-grid yu-alignc">'+
            '<p class="yu-orange yu-overflow"><i class="yu-font12">￥</i><i class="yu-font18 yu-fontb">'+toDecimal2(data[i].Price)+'</i></p>'+
            '<input type="hidden" name="CommodityId" value="'+data[i].id+'" />'+
            '<input type="hidden" name="CommodityStock" value="'+data[i].Stock+'" />'+
            '<input type="hidden" name="CommodityCanPurchase" value="'+data[i].CanPurchase+'" />'+
            '<input type="hidden" name="CommodityPurchasePoints" value="'+data[i].PurchasePoints+'" />'+
            str+
            '</div></div></div> </li>'
            }
            $(".product-list").html(html);

            $(".loading-page").hide();
        }

        function SetBottomHtml(data){
            if(shoppingCart != {}){
                for(var i =0;i<data.length;i++){
                   for(comm in shoppingCart){
               
                    if(comm == data[i].id && shoppingCart[comm] != 0){
                      addDetailed(data[i].id, data[i].Name, data[i].Price, data[i].Stock, shoppingCart[comm]);
                     }
                    }
                   }
            }else{
                for(var i =0;i<data.length;i++){
                    if(data[i].Total !="" && data[i].Total != "0"){
                      shoppingCart[data[i].id] = data[i].Total;
                      addDetailed(data[i].id, data[i].Name, data[i].Price, data[i].Stock, data[i].Total);
                    }
                    }
            }
            
            $("#Detailed_dd").find(".food-num").each(function () {
                if ($(this).text() != "" && $(this).text() != 0) {
                    $(".yu-btn").text("选好了");
                    var CommodityPrice = $(this).parent().parent().find(".yu-font20").html();
                    money += CommodityPrice * $(this).text();
                    money = parseFloat(money.toFixed(2));
                    totalNum += $(this).text() * 1;
                    $(".gwc-ico .num").text(totalNum);
                    $(".gwc-ico .num").fadeIn();
                    $(".yu-font26").html(toDecimal2(money));
                }
                if (!$("#bottom_detail").hasClass("yu-arr") && totalNum > 0)
                    $("#bottom_detail").addClass("yu-arr").addClass("type-up");
            });
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
    <script>
        //高度
        var s_h = $(window).height() - 210 * $("body").width() / 750;
        $(".screen-list").height(s_h)
        $(".screen-list").scroll(function (e) {
            e.preventDefault();
        });
        //	筛选
        var disLength = $(".screen-list>.dis").length,
	    allLength = $(".screen-list>li").length,
	    curLength = $(".screen-list>.cur").length,
	    allClick = 0,
	    screenSwitch = 0,
	    curTemp;
        $(".screen-list>li").on("click", function () {
            if (!$(this).hasClass("dis") && !$(this).hasClass("all")) {
                $(this).toggleClass("cur");
                $(".screen-list>.all").hasClass("cur") ? curLength = $(".screen-list>.cur").length - 1 : curLength = $(".screen-list>.cur").length;
                if (curLength == allLength - disLength - 1) {
                    $(".screen-list>.all").addClass("cur");
                    allClick = 1;
                } else if (curLength < allLength - disLength - 1) {
                    $(".screen-list>.all").removeClass("cur");
                    allClick = 0;
                };
            } else if ($(this).hasClass("all")) {
                if (allClick == 0) {
                    for (var i = 0; i < allLength; i++) {
                        if (!$(".screen-list>li").eq(i).hasClass("dis")) {
                            $(".screen-list>li").eq(i).addClass("cur");
                        }
                    };
                    allClick = 1;
                    curLength = $(".screen-list>.cur").length - 1
                } else {
                    $(".screen-list>li").removeClass("cur");
                    allClick = 0;
                    curLength = 0;
                };
            }
        })
        $(".screen-btn2").children("input").eq(0).click(function () {
            $(".screen-list>li").removeClass("cur");
            $("#dt_tip").hide();
            $(".screen-box").hide();
            allClick = 0;
            isHaveType = false;
            type = "";
            LoadData();
        })
        $(".screen-btn2").children("input").eq(1).click(function () {
            isHaveType = true;
            $("#li_select1").addClass("cur").siblings().removeClass("cur");
            $(".screen-box").hide();
            screenSwitch = 0;
            $(".screen-item-bar").children().remove();
            type = "";
            if ($(".screen-list>.cur").length > 0) {
                var i, j;
                if ($(".screen-list>.all").hasClass("cur")) {
                    i = 1;
                    curTemp = curLength + 1;
                } else {
                    i = 0;
                    curTemp = curLength;
                }
                for (i; i < curTemp; i++) {
                    j = $(".screen-list>.cur").eq(i).attr("data-id");
                    $(".screen-item-bar").append("<div class='screen-item' data-id=" + j + ">"
				+ $(".screen-list>.cur").eq(i).children(".screen-con").text()
				+ "<span class='xx'>x</span></div>");
                    type = type + $(".screen-list>.cur").eq(i).attr("data-id") + ",";
                }
                $("#dt_tip").show();
            } else {
                //                $(".screen-item-bar").children().remove();
                $("#dt_tip").hide();
                $(".screen-btn2").children("input").eq(0).click();
            }
            LoadData();

        })
        function SelectType(id) {
            isHaveType = false;
            type = id + ",";
            LoadData();
        }
        function SelectAllType() {
            isHaveType = false;
            type = "";
            LoadData();
        }
        $(".screen-switch").click(function () {
            if (screenSwitch == 0) {
                $(".screen-box").show();
                screenSwitch = 1;
            } else {
                $(".screen-box").hide();
                screenSwitch = 0;
            }
        })
        $(".screen-item-bar").on("click", ".xx", function () {
            $(this).parent(".screen-item").remove();
            var str = $(this).parent(".screen-item").get(0).innerText.substring(0, $(this).parent(".screen-item").get(0).innerText.length - 1);
            var dataId = $(this).parent().attr("data-id");
            $(".screen-list>.all").removeClass("cur");
            curLength--;
            for (var i = 0; i < allLength; i++) {
                if ($(".screen-list>li").eq(i).attr("data-id") == dataId) {
                    $(".screen-list>li").eq(i).removeClass("cur");
                    type = type.replace(dataId, "");
                }
            }
            if ($(".screen-item").length == 0) {
                type = "";
                $("#dt_tip").hide();
            }
            LoadData();
        })
        //	筛选end
        //tab
        $(".pro-tab").children("li").on("click", function () {
            $(this).addClass("cur").siblings().removeClass("cur");
        })
    </script>
</body>
</html>
