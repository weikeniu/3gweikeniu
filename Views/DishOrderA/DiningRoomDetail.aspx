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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
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
    <title>订单详情</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.1"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css?v=1.1"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css?v=1.1"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css?v=1.1"/>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js?v=1.1"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js?v=1.1"></script>
</head>
<body class="o-f-auto">
<article class="full-page">
     <%Html.RenderPartial("HeaderA", viewDic) ;%>
	<section class="order-d-top yu-pos-r">
		<div class="yu-cw">
			<p class="yu-f40r yu-bmar10r"><%=ViewData["StatusName"]%></p>
			<p class="yu-f26r yu-w380r"><%=ViewData["cue"]%></p>
		</div>
		<div class="kd-pic">
			<!--<img src="../images/kd1.png" />-->
		</div>
	</section>
	<!--酒店方式-->
	<section class="yu-bgw yu-bmar10 ">
		<div class="yu-grid yu-alignc yu-tbpad30r yu-lpad40r">
			<a class="o-d-ico type1 yu-rmar25r" href="#"></a>
			<a class="yu-alignc yu-overflow" href="tel:<%=ViewData["LinkTel"]%>">
				<div class="yu-f36r">
					<p class="yu-black">
						<span class="yu-f36r"><%=ViewData["UserName"]%></span>
						<span class="yu-f30r yu-f-w100"><%=ViewData["sex"]%></span>
						<span class="yu-f30r yu-f-w100"><%=ViewData["LinkTel"]%></span>
					</p>
					<!--<div class="yu-grid yu-alignc">
						<p class="address-type-ico yu-rmar5">酒店</p>
						<p class="yu-c99 yu-f26r text-ell yu-overflow yu-f-w100">广州桃花江豪生酒店201A房</p>
					</div>-->
				</div>
			</a>
		</div>
		<div class="colorBorder"></div>
	</section>
	<!--end-->
	<section class="yu-bgw yu-bmar20r">
		<div class="yu-h100r yu-lrpad10 yu-l100r yu-bor bbor yu-arr">
            <div class="yu-c99 yu-f30r yu-grid yu-alignc" onclick="window.location.href='/DishOrderA/DishOrderIndex/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>'">
				<p class="yu-rmar20r"><%=ViewData["HotelName"]%></p>
				<a class="phone-ico4 yu-d-b" href="tel:<%=ViewData["HotelTel"]%>" id="telid"></a>
			</div>
		</div>
		<div class="yu-pad20 yu-bglgrey yu-bor bbor">
				<div>
						<p class="yu-f26r yu-l40r yu-bmar10r"><%=ViewData["RoomName"]%></p>
						<ul class="yu-c99 yu-f24r">
							<li>
								<span>用餐人数：</span>
								<span><%=ViewData["usernumber"]%></span>
							</li>
                            <li>
								<span>用餐日期：</span>
								<span><%=Convert.ToDateTime(ViewData["usedate"]).ToString("yyyy-MM-dd")%></span>
							</li>
							<li>
								<span>到达时间：</span>
								<span><%=ViewData["usetime"]%></span>
							</li>
							
							<li>
								<span>备注：</span>
								<span><%=ViewData["remark"]%></span>
							</li>
						</ul>
				</div>
				<%
                    int status = (int)ViewData["Status"];
                    if (status == Convert.ToInt32(hotel3g.Models.EnumDiningRoomOrderStatus.待跟进))
                    {
				    %>
				<%--<div class="yu-grid yu-alignc yu-bmar10 yu-f40r">
					<div class="yu-overflow">&nbsp;</div>
					<div>
						<a onclick="javascript:TishiKuang('确定取消订单吗？')" href="javascript:;" class="yu-btn6 type1">取消订单</a>
					</div>
				</div>--%>
                <% } %>
                
		</div>
	</section>
	
	<section class="yu-bgw yu-bmar20r yu-lpad20r">
		<div class="yu-h80r yu-bor bbor yu-f30r yu-l80r">订单信息</div>
		<div class="yu-tbpad30r">
			<ul class="yu-f24r yu-c99 yu-l35r">
				<li class="yu-grid">
					<p class="yu-rmar20r">订单编号</p>
					<p><%=ViewData["orderCode"]%></p>
				</li>
				<li class="yu-grid">
					<p class="yu-rmar20r">下单时间</p>
					<p><%=ViewData["Ordertime"]%></p>
				</li>
			</ul>
		</div>
	</section>

     <!--弹窗-->
        <input type="hidden" id="optype" />
	    <section class="mask alert">
		    <div class="inner yu-w480r">
			    <div class="yu-bgw">
				    <p class="yu-lrpad40r yu-tbpad50r yu-textc yu-bor bbor yu-f30r" id="tishi_msg">提示信息</p>
				    <div class="yu-h80r yu-l80r yu-textc yu-c40 yu-f36r yu-grid">
					    <p class="yu-overflow yu-bor rbor yu-c99" id="tishi_sure">确定</p>
					    <p class="yu-overflow mask-close" id="tishi_close">取消</p>
				    </div>
			    </div>
		    </div>
	    </section>
</article>
    <!--end-->
<script>
    $(function () {
        document.getElementById('telid').addEventListener('click', function (e) { e.stopPropagation() }, false);
    })

//    $(".mask-close,.mask").click(function () {
//        $(".mask").fadeOut();
//    })
//    function TishiKuang(msg) {
//        $("#tishi_msg").html(msg);
//        $(".alert").fadeIn();
//    }
//    $("#tishi_sure").click(function () {
//	        CancelOrder();
//	    });

//    //取消订单
//    function CancelOrder() {
//        $.post("/DishOrderA/CancelDiningRoomOrder/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&orderCode=<%=ViewData["orderCode"] %>", 
//                function (data) {
//                    if(data.error==1)//取消成功跳回点餐首页
//                    { 
//                      window.location.href= "/DishOrderA/DishOrderIndex/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>";
//                    }else{
//                        $("#tishi_sure").hide();
//                        $("#tishi_msg").html(data.message);
//                        $("#tishi_close").html("好的，知道了");
//                        $(".alert").fadeIn();
//                    }
//                });
//        }
</script>
</body>
</html>
