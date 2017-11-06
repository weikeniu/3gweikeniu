<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    var order = ViewData["Order"] as WeiXin.Models.Home.SaleProducts_Orders;

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

    List<WeiXin.Models.Home.SaleProducts_OrdersTuan> list_tuan = ViewData["list_tuan"] as List<WeiXin.Models.Home.SaleProducts_OrdersTuan>;

    list_tuan = list_tuan.OrderBy(ra =>
    {
        if (ra.Status == (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.预约失败)
        {
            return ra.Status - 100;
        }

        return ra.Status;
    }).ToList();

    string statestr = string.Empty;
    string bookmessage = string.Empty;

    int toalCoupon = order.OriginalSaleprice > 0 ? Convert.ToInt32(order.OriginalSaleprice - order.OrderMoney) : 0;


    //已付款
    if (order.Ispay)
    {
        if (order.OrderStatus == (int)WeiXin.Models.Home.ProductSaleOrderStatus.待确认 || order.OrderStatus == (int)WeiXin.Models.Home.ProductSaleOrderStatus.已付款)
        {
            statestr = "已付款";
            bookmessage = "订单已成功提交，请等待商家确认，有疑问请直接联系商家";

            if (order.ProductType == 0)
            {
                statestr = "已付款";
                bookmessage = "请电话联系商家报预约码进行预约或点击下方提交预约按钮进行预约";
            }
        }

        else if (order.OrderStatus == (int)WeiXin.Models.Home.ProductSaleOrderStatus.已确认)
        {
            statestr = "已确认";
            bookmessage = "订单已成功确认，请在使用日期到店放心使用";

            if (order.ProductType == 0)
            {
                statestr = "预约成功";
                bookmessage = "订单预约成功，请在使用日期到店放心使用";
            }

        }

        else if (order.OrderStatus == (int)WeiXin.Models.Home.ProductSaleOrderStatus.确认失败)
        {
            statestr = "确认失败";
            bookmessage = "";

            if (order.ProductType == 1)
            {
                bookmessage = "请重新改订";
            }
        }

        else if (order.OrderStatus == (int)WeiXin.Models.Home.ProductSaleOrderStatus.交易成功)
        {
            statestr = "交易成功";
            bookmessage = "期待再次为您服务";

        }
    }

    //未付款
    else
    {
        statestr = "待付款";
        bookmessage = "请在30分钟内完成支付，如超时未完成支付将自动取消";
    }

    if (order.OrderStatus == (int)WeiXin.Models.Home.ProductSaleOrderStatus.取消)
    {
        statestr = "取消";
        bookmessage = "订单已取消";
    }


    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userWeiXinID);


    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;

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
    <title>订单详情</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/jquery-ui.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["cssUrl"] %>/css/booklist/jquery-ui.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <style>
        .room-num, .room-price-d
        {
            display: none;
        }
        .ui-datepicker td span, .ui-datepicker td a
        {
            line-height: 1.08rem;
        }
    </style>
</head>
<body class="o-f-auto">
    <section class="base-page">
    <section class="order-d-top yu-pos-r">
		<div class="yu-cw">
			<p class="yu-f40r yu-bmar10r statestr">  <%=statestr %></p>
			<p class="yu-f26r yu-w380r bookmessage">   <%=bookmessage %></p>
		</div>
	<div class="kd-pic">
             
                        <% if (statestr.Contains("待付款"))
                           { %>
			                  <img src="../../images/order-ico/dfk_03.jpg" />
                       <%}
                           else if(statestr.Contains("取消"))
                           { %>                         
                               <img src="  ../../images/order-ico/qx_03.jpg" />
                       <%}
                           else if (statestr.Contains("已付款"))
                           { %>                         
                               <img src="../../images/order-ico/yfk_03.jpg" />
                       <%}

                           else if (statestr.Contains("已确认") || statestr.Contains("预约成功"))
                           { %>                         
                               <img src="../../images/order-ico/yuyue_03.jpg" />
                       <%}
                               
                           else if (statestr.Contains("交易成功"))
                           { %>                         
                               <img src="../../images/order-ico/jycg_03.jpg" />
                       <%}
                           else if (statestr.Contains("确认失败"))
                           { %>                         
                               <img src="../../images/order-ico/tkcg_03.jpg" />
                       <%} %>
		</div>
	</section>
    <!--酒店方式-->
    <section class="yu-bgw yu-bmar10 ">
		<div class="yu-grid yu-alignc yu-tbpad30r yu-lpad40r">
			<a class="o-d-ico type1 yu-rmar25r" href="#"></a>
			<a class="yu-alignc yu-overflow" href="javascript:;">
				<div class="yu-f36r">
					<p class="yu-black">
						<span class="yu-f36r"><%=order.UserName %></span>
						<span class="yu-f30r yu-f-w100"></span>
						<span class="yu-f30r yu-f-w100"><%=order.UserMobile %></span>
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

      <% string currlink = string.Format("window.location.href='/productA/ProductList/{0}?key={1}@{2}'", hotelid, weixinID, userWeiXinID);
         if (userWeiXinID.Contains(wkn_shareopenid))
         {
             currlink = "void(0)";
         }  
         %>

		<div class="yu-h100r yu-lrpad10 yu-l100r yu-bor bbor yu-arr">	

 	     	<div class="yu-c99 yu-f30r yu-grid yu-alignc"  onclick="javascript:<%=currlink %>" >
                  <a class="yu-rmar20r yu-black"  href="javascript:void(0)"> <%=ViewData["hotelname"]%> </a>
				<a class="phone-ico4 a_tel" href="tel:<%=ViewData["tel"]  %>"    ></a>
			 </div>
		</div>

               <% int no_yucount = list_tuan.Where(c => c.Status == (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.未预约 || c.Status == (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.预约失败).Count(); %>
        <% if (no_yucount > 0)
           { %>
        		<!--批量预约-->
		<div class="yu-h70r yu-rpad45r yu-l70r yu-bgef yu-textr yu-bor bbor yu-arr" >
			<div class="yu-f28r align-r">
				<a class="yu-c40 yu-i-b yu-l70r J__batchAppointment" href="javascript:void(0)">批量预约</a>
			</div>
		</div>
        <%} %>

         <% string pic = string.IsNullOrEmpty(order.Pic) ? "" : order.Pic.Split(',')[0];%>
          
                 <% if (order.ProductType == 0 && list_tuan.Count > 0)
                    {
                        for (int i = 0; i < list_tuan.Count; i++)
                        {%> 
                          
		                 <div class="yu-pad20 yu-bglgrey yu-bor bbor">
		         	<ul>
                            
                        	<li class="yu-grid yu-bmar10">
					<div class="full-img order-img yu-rmar20r">

               
						<img src="<%=pic %>"  />
					</div>
					<div class="yu-overflow">
						<p class="yu-f26r yu-l40r"><%=order.ProductName%></p>
						<ul class="yu-c99 yu-f24r">
							<li>
								<span>套餐类型：</span>
								<span><%=order.TcName%></span>
							</li>
                            
                            <% if (list_tuan[i].Status != (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.未预约)
                               { %>


                                  	<li>
								<span>使用人</span>
								<span><%=list_tuan[i].UsePerson%></span>

							</li>
							<li>
								<span>使用日期：</span>
								<span><%=list_tuan[i].UseDate.ToString("yyyy-MM-dd")%></span>
							</li>
	                  
                            <%} %>

                                   <li>
								<span>状态：</span>
								<span><%=    ((WeiXin.Models.Home.ProductSaleOrderTuanStatus)list_tuan[i].Status).ToString() %></span>
							</li>
                           
						           <li>
								<span>预约码：</span>
						 <span class="yu_tuancode"><%=list_tuan[i].TuanCode%></span>
							</li>
						 
						</ul>
					</div>
				</li>


                
				<li class="yu-grid yu-alignc yu-bmar10 yu-f40r">
					<div class="yu-overflow">&nbsp;</div>
					<div>

                    
                        <% if (!order.Ispay && order.OrderStatus != (int)WeiXin.Models.Home.ProductSaleOrderStatus.取消)
                           { %>
						<a href="javascript:;" class="yu-btn6 type1 cancelbtn">取消订单</a>
                            <a href="javascript:;" class="yu-btn6 type2 prepaybtn">去支付</a>

                        <%}   %>

              
                        
                        <% if (order.Ispay && (list_tuan[i].Status == (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.未预约 || list_tuan[i].Status == (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.预约失败))
                           { %>

                        	<a href="javascript:;" class="yu-btn6 book-btn type2 btn_hexiao">提交预约</a>
                           
                            <%} %>

                                <% if (order.Ispay &&   list_tuan[i].Status == (int)WeiXin.Models.Home.ProductSaleOrderTuanStatus.预约成功  )
                           { %>

                        	<a href="javascript:;" class="yu-btn6  type2 btn_use">确认使用</a>
                           
                            <%} %>
                           
                           <% if (order.OrderStatus == (int)WeiXin.Models.Home.ProductSaleOrderStatus.取消)
                              {%>
                         	<a href="/productA/ProductDetail/<%=hotelid%>?key=<%=weixinID%>@<%=userWeiXinID%>&ProductId=<%=order.ProductId%>" class="yu-btn6   type2 ">重新购买</a>
                                <%} %>
						
					</div>
				</li>
                	</ul>
		        </div>


              	<div class="hide-row">
			<div class="yu-h80r yu-grid  yu-bgw yu-bor bbor yu-f24r">
				<div class="yu-overflow yu-bor rbor yu-grid yu-h80r yu-alignc">
					<p class="yu-c99 yu-lpad20r yu-rmar30r">使用人</p>
					<p class="yu-overflow"><input type="text" class="yu-input3 yuName" placeholder="请输入使用人" /></p>
				</div>
				<div class="yu-overflow yu-grid yu-h80r yu-alignc yu-arr">
					<p class="yu-c99 yu-lpad20r yu-rmar30r">使用日期</p>
					<p class="yu-overflow"><input type="text" class="yu-input3  data-select yuDate" placeholder="请选择使用日期" readonly/></p>
				</div>
			</div>

          
            <input  class="tuancode"   type="hidden"  value="<%=list_tuan[i].TuanCode %>" />
		</div>

                 <%}

                    }
                    else
                    {  %>

                      <div class="yu-pad20 yu-bglgrey yu-bor bbor">
			                 <ul>
				<li class="yu-grid yu-bmar10">
					<div class="full-img order-img yu-rmar20r">

               
						<img src="<%=pic%>"  />
					</div>
					<div class="yu-overflow">
						<p class="yu-f26r yu-l40r"><%=order.ProductName%></p>
						<ul class="yu-c99 yu-f24r">
							<li>
								<span>套餐类型：</span>
								<span><%=order.TcName%></span>
							</li>

 
                            <% if (order.ProductType == 1)
                               {  %>
							<li>
								<span>出发日期：</span>
								<span><%=order.CheckInTime.ToString("yyyy-MM-dd")%></span>
							</li> 
                            <%} %>

							<li>
								<span>购买数量：</span>
								<span><%=order.BookingCount%></span>
							</li>
						</ul>
					</div>
				</li>
				
				<li class="yu-grid yu-alignc yu-bmar10 yu-f40r">
					<div class="yu-overflow">&nbsp;</div>
					<div>

                    
                        <% if (!order.Ispay && order.OrderStatus != (int)WeiXin.Models.Home.ProductSaleOrderStatus.取消)
                           { %>
						<a href="javascript:;" class="yu-btn6 type1 cancelbtn">取消订单</a>
                        <a href="javascript:;" class="yu-btn6 type2 prepaybtn">去支付</a>

                        <%} %>
 
                   
                           
                           <% if (order.OrderStatus == (int)WeiXin.Models.Home.ProductSaleOrderStatus.取消 ||   order.OrderStatus == (int)WeiXin.Models.Home.ProductSaleOrderStatus.确认失败)
                              {%>
                         	<a href="/productA/ProductDetail/<%=hotelid %>?key=<%=weixinID%>@<%=userWeiXinID%>&ProductId=<%=order.ProductId%>" class="yu-btn6   type2 ">重新购买</a>
                                <%} %>
						
					</div>


   

				</li>

                </ul>
           </div>                 

                <% } %>
		
   
    
		<div class="yu-h120r yu-grid yu-lrpad20r yu-alignc ">
				<p class="yu-black yu-rmar20 yu-f30r">总价</p>
				<div class="yu-overflow">
					<p class="yu-c40 yu-f30r">￥<span class="yu-f36r"><%=order.OrderMoney %></span></p>
					<p class="yu-c99 yu-f22r">已优惠<%=toalCoupon%>元，可获<span class="yu-black"><%=order.Jifen %></span>积分</p>
				</div>
		</div>
		
	</section>
    <!--<section class="yu-bgw yu-bmar20r yu-lpad20r">
		<div class="yu-h80r yu-bor bbor yu-f30r yu-l80r">订单详情</div>
		<div class="yu-tbpad30r">
			<ul class="yu-f24r yu-c99 yu-l35r">
				<li class="yu-grid">
					<p class="yu-rmar20r">支付方式</p>
					<p>待支付</p>
				</li>
				<li class="yu-grid">
					<p class="yu-rmar20r">下单时间</p>
					<p>2017-05-10 12：16：29</p>
				</li>
			</ul>
		</div>
	</section>-->
    <section class="yu-bgw yu-bmar20r yu-lpad20r">
		<div class="yu-h80r yu-bor bbor yu-f30r yu-l80r">订单信息</div>
		<div class="yu-tbpad30r">
			<ul class="yu-f24r yu-c99 yu-l35r">

            <% if (order.Ispay)
               { %>
				<li class="yu-grid">
					<p class="yu-rmar20r">支付方式</p>
					<p><%=order.PayType %></p>
				</li>

                <%} %>

                
                <li class="yu-grid">
					<p class="yu-rmar20r">订单号</p>
					<p><%=order.OrderNo %></p>
				</li>
				<li class="yu-grid">
					<p class="yu-rmar20r">下单时间</p>
					<p><%=order.OrderAddTime.ToString("yyyy-MM-dd HH:mm:ss") %></p>
				</li>
			</ul> 
		</div>   
	</section>     
    </section>
    <section class="data-page">
			<div id="datepicker"></div>
			<div class="fix-bottom yu-bor tbor yu-grid yu-alignc yu-lrpad10 yu-h34r" style="display:none">
				<p class="yu-overflow ">选择日期</p>
				<div>
					<div class="yu-grid yu-alignc">
						<p class="data-btn cal yu-bor1 bor">取消</p>
						<p class="data-btn sub">确定</p>
					</div>
				</div>
			</div>
		</section>
    <!--日历end-->


        <!-- //批量预约弹窗.Start-->
    <section class="mask batch_appointment" style="display: none;">
		<div class="toggle-up">
			<div class="row yu-h120r yu-l120r yu-font20 yu-grid yu-textc yu-lrpad20r yu-bgef">
				<p class="yu-c40 yu-w70">批量预约</p>
				<p class="yu-overflow"></p>
				<p class="yu-grey yu-w70 cancel">取消</p>
			</div>
			
			<div class="batch__appointment-box">
				<div class="item yu-h100r yu-l100r yu-grid yu-lrpad20r yu-bor tbor">
					<span class="yu-overflow yu-font14">订购总数：<%=list_tuan.Count %></span>
					<span class="yu-overflow yu-textc yu-font14">已预约：<%=list_tuan.Count-no_yucount%></span>
					<span class="yu-overflow yu-textr yu-font14" data-num='<%=no_yucount %>' id="num_noyu" >未预约：<%= no_yucount%></span>
				</div>
				<div class="item yu-h100r yu-l100r yu-grid yu-alignc yu-lrpad20r yu-bor tbor">
					<div class="yu-overflow yu-font14">选择数量：</div>
					<div class="ar yu-grid">
							<p class="reduce ico type2 cur"></p>
							<p class="food-num cur">1</p>
							<p class="add ico type2"></p>
					</div>
				</div>
				<div class="item yu-h100r yu-grid  yu-bgw yu-bor tbor yu-f24r">
					<div class="yu-overflow yu-grid yu-h80r yu-alignc">
						<p class="yu-c33 yu-lpad20r yu-rmar20r">使用人：</p>
						<p class="yu-overflow"><input type="text" class="yu-input3 yuName" placeholder="请输入使用人"></p>
					</div>
					<div class="yu-overflow yu-grid yu-h80r yu-alignc yu-arr">
						<p class="yu-c33 yu-lpad20r yu-rmar20r">使用日期：</p>
						<p class="yu-overflow"><input type="text" class="yu-input3  data-select yuDate yuAllDate" placeholder="请选择使用日期" readonly=""></p>
					</div>
				</div>
			</div>
			<a class="yu-h100r yu-l100r yu-show yu-bg40 yu-textc yu-font20 od-top  btn_hexiao_all" href="javascript:;">确定</a>
		</div>
	</section>
    <script type="text/javascript">
        //批量预约弹窗
        $(".J__batchAppointment").on("click", function () {
            $(".batch_appointment").fadeIn();
        });
        //取消
        $(".mask .cancel").on("click", function () {
            $(".mask").fadeOut();
        });

        //数量加减
        $(".add").on("click", function () {
            if ($(this).siblings(".food-num").text() == "") {
                foodNum = 1;
                $(this).siblings(".food-num").text(foodNum);
            } else {

                foodNum = parseInt($(this).siblings(".food-num").text());

                if (parseInt($("#num_noyu").attr("data-num")) > foodNum) {
                    foodNum++;
                    $(this).siblings(".food-num").text(foodNum);
                }
            };
        });
        $(".reduce").on("click", function () {
            foodNum = parseInt($(this).siblings(".food-num").text());
            if (foodNum > 1) {
                foodNum--;
                $(this).siblings(".food-num").text(foodNum);
            };
        });
    </script>
    <!-- //批量预约弹窗.End-->

    <script>


        var minTime = '<%=ViewData["effectiveBeginTime"]%>';
        var maxTime = '<%=ViewData["effectiveEndTime"]  %>';

        var select_date = new Object();


        var speciald = new Array();
        /*日期选择初始号*/
        var __drp;
        __drp = $("#datepicker").datepicker({
            dateFormat: 'yy-mm-dd',
            dayNamesMin: ["日", "一", "二", "三", "四", "五", "六"],
            monthNames: ["1月", "2月", "3月", "4月", "5月", "6月",
         "7月", "8月", "9月", "10月", "11月", "12月"],
            yearSuffix: '年',
            showMonthAfterYear: true,
            minDate: minTime,
            numberOfMonths: 2,
            maxDate: maxTime,
            showButtonPanel: false,
            onSelect: function (date, me) {
                if (speciald.length < 1) {
                    //speciald.push(date);
                    if ($.inArray(date, speciald) == -1) {
                        speciald.push(date);
                    }

                    console.log(speciald)
                } else {
                    speciald.length = 0;
                    speciald.push(date);
                    console.log(speciald)
                }

                $(select_date).val(date);


                if ($(select_date).hasClass("yuAllDate")) {
                    $(".batch_appointment").show();
                }

                $(".base-page").show();
                $(".data-page").hide();
            },
            beforeShowDay: function (date) {
                //格式化月份、日
                function formatDate(str) {
                    return str < 10 ? ("0" + str) : str;
                }
                var m = date.getMonth();
                var d = date.getDate();
                var y = date.getFullYear();
                var formatDate = y + "-" + formatDate(m + 1) + "-" + formatDate(d); //此处日期的格式化和speciald中的格式一样
                //inArray实现数组的匹配
                if ($.inArray(formatDate, speciald) != -1) {
                    //此处要返回一个数组，specialdays是添加样式的类
                    return [true, "specialdays", formatDate];
                }
                else {
                    return [true, '', ''];
                }
            }

        });

        $(function () {
            //切换下拉
            $(".book-btn").click(function () {

            })
            //日期
            $(".data-select").on("click", function () {
                $(".base-page").hide();
                $(".data-page").show();
                select_date = $(this);

                if ($(select_date).hasClass("yuAllDate")) {
                    $(".mask").hide();
                }
            })
            $(".data-btn.cal").click(function () {
                $(".base-page").show();
                $(".data-page").hide();
            })
            $(".data-btn.sub").click(function () {
                $(".base-page").show();
                $(".data-page").hide();
                $(".data-select").val(speciald.join());
                $(".book-btn").removeClass("cur");
            })
        })


        $('.cancelbtn').click(function () {
            $.ajax({
                url: '/ProductA/cancelOrder',
                type: 'post',
                data: { orderNo: '<%=order.OrderNo %>', key: '<%=weixinID %>@<%=userWeiXinID %>', orderId: '<%=order.Id %>' },
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {
                        layer.msg(ajaxObj.Mess);
                        setTimeout("window.location.href=window.location.href", 2000);

                    }

                    else {
                        layer.msg(ajaxObj.Mess);
                    }

                }
            });

        });


        $(".a_tel").click(function (event) {
            event.stopPropagation();
        });


        $('.btn_use').click(function () {

            var yu_tuancode = $(this).parents("ul").find(".yu_tuancode").text().trim();

            $.ajax({
                url: '/Producta/UseTuanCode',
                type: 'post',
                data: { orderNo: '<%=order.OrderNo %>', key: '<%=weixinID %>@<%=userWeiXinID %>', orderId: '<%=order.Id %>', tuanCode: yu_tuancode },
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {
                        layer.msg(ajaxObj.Mess);
                        setTimeout("window.location.href=window.location.href", 2000);

                    }

                    else {
                        layer.msg(ajaxObj.Mess);
                    }

                }
            });

        });



        $(".btn_hexiao,.btn_hexiao_all").click(function () {

            var currYuName = null;
            var currYuDate = null;
            var tuanCode = "";
            var yutype = "one";
            var yunum = 1;

            if ($(this).hasClass("btn_hexiao")) {

                if (!$(this).hasClass("cur")) {
                    $(this).addClass("cur");
                    $(this).text("保存");
                    $(this).parents(".yu-bglgrey").next(".hide-row").show();

                    return false;
                }
                $(".btn_hexiao").attr("disabled", true);

                currYuName = $(this).parents(".yu-bglgrey").next(".hide-row").find(".yuName");
                currYuDate = $(this).parents(".yu-bglgrey").next(".hide-row").find(".yuDate");
                tuanCode = $(this).parents(".yu-bglgrey").next(".hide-row").find(".tuancode").val().trim();
            }

            else {

                $(".btn_hexiao_all").attr("disabled", true);

                currYuName = $(this).parent(".toggle-up").find(".yuName");
                currYuDate = $(this).parents(".toggle-up").find(".yuDate");
                tuanCode = "";
                yutype = "more";
                yunum = parseInt($(".food-num").text());

            }


            if ($(currYuName).val().trim() == "") {
                layer.msg('请输入使用人!');

                if ($(this).hasClass("btn_hexiao")) {
                    $(".btn_hexiao").attr("disabled", false);
                }
                else {
                    $(".btn_hexiao_all").attr("disabled", false);
                }

                return false;

            }


            if ($(currYuDate).val().trim() == "") {
                layer.msg('请选择使用日期!');

                if ($(this).hasClass("btn_hexiao")) {
                    $(".btn_hexiao").attr("disabled", false);
                }
                else {
                    $(".btn_hexiao_all").attr("disabled", false);
                }

                return false;
            }




            $.ajax({
                url: '/ProductA/HotelHexiaoMa',
                type: 'post',
                data: {
                    key: '<%=ViewData["key"]%>', OrderNO: '<%=Request.QueryString["OrderNo"]%>', yuName: $(currYuName).val().trim(), yuDate: $(currYuDate).val().trim(),
                    tuanCode: tuanCode, orderId: '<%=order.Id %>', yutype: yutype, yunum: yunum
                },
                dataType: 'json',
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {

                        layer.msg("提交成功");
                        setTimeout(function () { window.location.href = window.location.href; }, 1000);
                    }

                    else {

                        $(".btn_hexiao").attr("disabled", false);
                        $(".btn_hexiao_all").attr("disabled", false);

                        layer.msg(ajaxObj.Mess);
                    }
                }

            });

        });


 
        function BindData() {
        }


        $('.prepaybtn').click(function () {

            window.location.href = '/recharge/CardPay/<%=hotelid%>?key=<%=weixinID %>@<%=userWeiXinID %>&orderno=<%=order.OrderNo %>';
        });

    </script>
</body>
</html>
