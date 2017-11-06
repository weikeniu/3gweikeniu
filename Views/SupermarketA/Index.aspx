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
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/font/iconfont.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/fontSize.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
    <script src="http://css.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<%
    System.Data.DataTable dt_Type = ViewData["CommodityTypeTable"] as System.Data.DataTable;
%>
<body>
    <% 
        ViewDataDictionary viewDic = new ViewDataDictionary();

        string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;

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
            title = ViewData["Address"].ToString() + " 超市",
            desn = desn,
            logo = "http://hotel.weikeniu.com/images/supermarket.jpg",
            debug = false,
            userweixinid = ViewData["userweixinid"].ToString(),
            weixinid = ViewData["weixinid"].ToString(),
            hotelid = int.Parse(ViewData["hotelId"].ToString()),
            sharelink = sharelink
        };
        ViewData["WeiXinShareConfig"] = WeiXinShareConfig;

        viewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
        Html.RenderPartial("WeiXinShare", viewDic);

        viewDic.Add("weixinID", ViewData["weixinid"]); viewDic.Add("hId", ViewData["hotelId"]);
        viewDic.Add("uwx", ViewData["userweixinid"]); %>
    <article class="full-page">
     <%Html.RenderPartial("HeaderA", viewDic); %>
            <% List<System.Data.DataRow> list_detail = (List<System.Data.DataRow>)ViewData["commodityList"];
               if (list_detail.Count > 0)
               { %>
		<section class="show-body">
			
			<section class="content2">
            
				<div class="screen-icon">
					<p class="iconfont icon-zuox screen-icon-btn"></p>
					<p class="iconfont icon-youx screen-icon-btn"></p>
					<ul>
						<li onclick="SelectAllType()">
							<p class="screen-icon-bg type1"></p>
							<p class="screen-icon-txt">全部商品</p>
						</li>
                    <%for (int i = 0; i < dt_Type.Rows.Count; i++)
                      {
                          %>
						<li onclick="SelectType(<%=dt_Type.Rows[i]["id"] %>)" data-id="<%=dt_Type.Rows[i]["id"] %>">
							<p class="screen-icon-bg type13"></p>
							<p class="screen-icon-txt"><%=dt_Type.Rows[i]["Name"]%></p>
						</li>
                              <%} %>
						<%--<li>
							<p class="screen-icon-bg type14"></p>
							<p class="screen-icon-txt">超市分类</p>
						</li>
						<li>
							<p class="screen-icon-bg type15"></p>
							<p class="screen-icon-txt">超市分类</p>
						</li>
						<li>
							<p class="screen-icon-bg type16"></p>
							<p class="screen-icon-txt">超市分类</p>
						</li>
						<li>
							<p class="screen-icon-bg type17"></p>
							<p class="screen-icon-txt">超市分类</p>
						</li>
						<li>
							<p class="screen-icon-bg type18"></p>
							<p class="screen-icon-txt">超市分类</p>
						</li>--%>
					</ul>
				</div>

				<a class="cart" style="position:fixed; display:none;top:2.3rem;" href="/SupermarketA/OrderDetails/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>">
												<p class="ico"></p>
												<p class="num"></p>
											</a>
				<ul class="booking-list">
                <%--<% foreach (System.Data.DataRow row in list_detail)
                   { 
                         %>
								<li>
									<div class="show-header">
										<div class="inner yu-h360r" onclick="javascript:toDetailView('<%=row["id"] %>')">
											<img src="<%=row["ImagePath"] %>" />
                                            <%if (row["CanPurchase"].ToString() == "1")
                                              { %>
											<div class="jf-mark">积分</div>
                                            <%}%>
											<div class="txt-bar yu-grid yu-alignc">
												<p class="yu-overflow yu-f30r CommodityName"><%=row["Name"]%></p>
											</div>
										</div>
										<div class="yu-bgw yu-h50 yu-grid yu-alignc yu-bor bbor yu-lrpad10">
											<p class="yu-f30r yu-rmar20r CommodityPrice">￥<%=row["Price"]%></p>                                        
                                            <input type="hidden" name="CommodityId" value='<%=row["id"]%>' />
                                        <input type="hidden" name="CommodityStock" value='<%=row["Stock"]%>' />
                                        <%if (row["CanPurchase"].ToString() == "1")
                                          { %>
											<div class="yu-grid yu-alignc yu-overflow">
									     		<p class="jf-ico sp yu-rmar7r"></p>
									     		<p class="yu-c40 yu-f24r"><%=row["PurchasePoints"]%>积分兑换</p>
									     	</div>
                                            <%}%>
                                        <%if (int.Parse(row["Stock"].ToString()) < 1)
                                          {  %>
                                           <p class="yu-f30r">已售完</p>
                                        <%}
                                          else
                                          { %>
											<div class="ar yu-grid">
													<p class="reduce ico type2"></p>
													<p class="food-num"><%=row["Total"]%></p>
													<p class="add ico type2"></p>
											</div>
                                             <%} %>
										</div>
									</div>
								</li>
                            <%
                                }
         %>--%>
							</ul>
			</section>
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
            没有找到宝贝</p>
        <%--<a href="#" class="re-seach yu-grid yu-bor1 bor yu-blue2 yu-alignc yu-j-c">
            <p class="ico">
            </p>
            <p>
                重新搜索看看！</p>
        </a>--%>
    </div>
    <%} %>
    
        <!--弹窗-->
     <%Html.RenderPartial("AlertMessage", viewDic); %>
	</article>
    <script>
            var Shielding;
            var type="";
            var isHaveType = false;
            //加减餐
            var foodNum = 0;
            var totalNum = 0;
            var isCanRun = true;
            var isFirst = true;
        $(function () {
            sessionStorage.SupperMarketIsBack = 0;
        

            //从数据库获取数据添加到页面
//            Shielding=layer.load();
           
            LoadData();

            
			//单色图标
			var iconLength=$(".screen-icon").find("li").length,
			    iconClick=0,
			    leftP=0.5;
			$(".screen-icon").find("li").on("click",function(){
				$(this).toggleClass("cur").siblings().removeClass("cur");
			})
			$(".screen-icon-btn.icon-youx").click(function(){
				if(iconClick<iconLength-5){
					iconClick++;
					$(".screen-icon ul").animate({left:-(1.3*iconClick-leftP)+"rem"},100);
			}
			})
			$(".screen-icon-btn.icon-zuox").click(function(){
				if(iconClick>0){
					iconClick--;
					$(".screen-icon ul").animate({left:-(1.3*iconClick-leftP)+"rem"},100);
				}
			})
        });
        
            //数据库减少商品
            function ReduceCommodity(CommodityId) {
                if (!isCanRun)
                    return false;

                isCanRun = false;

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

            
            //数据库增加商品
            function AddCommodity(CommodityId) {
                isCanRun = false;

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


            function toDetailView(id, UseRichText) { 
            if(UseRichText * 1 ==1){
                location.href = "/SupermarketA/CommodityRichText/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&CommodityID="+id;
            }else{
               location.href = "/SupermarketA/OrderDetailsAlone/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&commodityid="+id;
               }
            }

            
        //主界面显示商品信息
        function SetCommodityHtml(data){
            $(".booking-list").html("");
            var html="";

            for(var i =0;i<data.length;i++){

            var str="";
            var str2="";
            var str3="";
            var str4="";
            var imgList = data[i].ImageList.split(",");

            var dataTotal=0;
            if(data[i].CanPurchase *1 == 1){
            str='<div class="yu-grid yu-alignc yu-overflow"><p class="jf-ico sp yu-rmar7r"></p><p class="yu-c40 yu-f24r">'+data[i].PurchasePoints+'积分兑换</p></div>';
                str2='<div class="jf-mark">积分</div>';
                str3='<div class="jf-mark yu-v-h">积分</div>';
                str4="yu-f30r yu-rmar20r";
            }else{
                str2='';
                str3='';
                str4="yu-overflow yu-f30r";
            }
            if(data[i].Stock<1){
                str3='<p class="yu-f30r">已售完</p>';
            }else{
                str3=
                '<div class="ar yu-grid">'+
                '<p class="reduce ico type2"></p>'+
                '<p class="food-num">'+data[i].Total+'</p>'+
                '<p class="add ico type2"></p></div>';
            }


            html = html + "<li>"+
            '<div class="show-header">'+
            '<div class="inner yu-h360r" onclick="javascript:toDetailView('+data[i].id+','+data[i].UseRichText+')">'+
            '<img src="'+imgList[0]+'" />'+
            str2+
            '<div class="txt-bar yu-grid yu-alignc">'+
            '<p class="yu-overflow yu-f30r CommodityName">'+data[i].Name+'</p>'+
            '</div></div>'+
            '<div class="yu-bgw yu-h50 yu-grid yu-alignc yu-bor bbor yu-lrpad10">'+
            '<p class="'+str4+' CommodityPrice">￥'+toDecimal2(data[i].Price)+'</p> '+
            '<input type="hidden" name="CommodityId" value="'+data[i].id+'" />'+
            '<input type="hidden" name="CommodityStock" value="'+data[i].Stock+'" />'+
            str+str3+
            '</div></div></li>'
            }
            $(".booking-list").html(html);
//                 layer.close(Shielding);
            $(".loading-page").hide();
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

        //从数据库获取数据添加到页面
        function LoadData(){
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
                
                
            //加载后显示购物车已有数据
            $(".booking-list").find(".food-num").each(function () {
                if ($(this).text() != "" && $(this).text() != 0) {
                    $(this).fadeIn();
                    $(this).prev().fadeIn();
                    
                if(isFirst){
                    totalNum += $(this).text() * 1;
                }

                }

                //yu-arr type-up
                if (totalNum > 0) {
                    $(".cart").fadeIn().children(".num").fadeIn().text(totalNum);
                } else {
                    //                    $(".cart").children(".num").fadeOut().text(totalNum);
                    $(".cart").fadeOut();
                }
            });
                    isFirst=false;

                });
                

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


            $(document).on("click",".add", function () {
                if (!isCanRun)
                    return false;

                var total = $(this).parent().find(".food-num").html();
                var CommodityId = $(this).parent().parent().find("input[name='CommodityId']").val();
                var CommodityStock = $(this).parent().parent().find("input[name='CommodityStock']").val();

                if (total * 1 == CommodityStock * 1) {
                $("#tishi_msg").html("没有库存,不能再多了");
                    $(".alert").fadeIn();
//                    layer.msg("没有库存,不能再多了");
                    return false;
                }

                AddCommodity(CommodityId);

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
                $(".cart").fadeIn().children(".num").fadeIn().text(totalNum);

            });
            


            $(document).on("click",".reduce", function () {
                if (!isCanRun)
                    return false;

                foodNum = parseInt($(this).siblings(".food-num").text());
                if (foodNum > 0) {
                    var CommodityId = $(this).parent().parent().find("input[name='CommodityId']").val();
                    ReduceCommodity(CommodityId);
                    totalNum--;
                    foodNum--;
                    $(this).siblings(".food-num").text(foodNum);
                    $(".cart").children(".num").text(totalNum);
                    $(".gwc-ico .num").text(totalNum);
                    if (totalNum == 0) {
                        //						$(".gwc-ico .num").fadeOut();
                        $(".cart").fadeOut();
                    }
                    if (foodNum == 0) {
                        $(this).fadeOut().siblings(".food-num").fadeOut();
                    }
                };
            });
            }

    
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
    </script>
</body>
</html>
