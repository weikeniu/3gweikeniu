<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    string hid = ViewData["hid"].ToString();
    string key = HotelCloud.Common.HCRequest.GetString("key");
    string hotelweixinid = string.Empty;
    string userweixinid = string.Empty;
    if (!string.IsNullOrEmpty(key) && key.Contains("@"))
    {
        List<string> keylist = key.Split(new string[] { "@" }, StringSplitOptions.RemoveEmptyEntries).ToList();
        hotelweixinid = keylist[0];
        userweixinid = keylist[1];
    }
    string orderid = HotelCloud.Common.HCRequest.GetString("id");

    hotel3g.Models.HotelOrder order = ViewData["order"] as hotel3g.Models.HotelOrder;

    Hashtable CouponInfo = new Hashtable();
    double graderate = 0;
    int couponType = 0;
    double reduce = 0;
    if (!string.IsNullOrEmpty(order.CouponInfo))
    {
        CouponInfo = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(order.CouponInfo);
        if (CouponInfo.Count > 0)
        {
            couponType = Convert.ToInt32(CouponInfo["CouponType"]);
            graderate = WeiXinPublic.ConvertHelper.ToDouble(CouponInfo["GradeRate"]);
            reduce = WeiXinPublic.ConvertHelper.ToDouble(CouponInfo["Reduce"]);
        }
    }

    int coupon = WeiXinPublic.ConvertHelper.ToInt(CouponInfo["CouPon"]);
    int isVip = WeiXinPublic.ConvertHelper.ToInt(CouponInfo["IsVip"]);

    //不是会员专享有折扣
    if (isVip == 0)
    {
        if (couponType == 0 && graderate > 0)
        {
            graderate = graderate / 10;
            coupon += (order.ySumPrice - Convert.ToInt32(order.ySumPrice * graderate));
        }

        else if (couponType == 1 && reduce > 0)
        {
            coupon += Convert.ToInt32(reduce) * order.YRoomNum;
        }
    }

    int totalCoupon = Convert.ToInt32(order.ySumPrice - order.sSumPrice);


    bool hasconfirm = !(order.ConfirmOrderDate.CompareTo(Convert.ToDateTime("1900-01-01 01:00:00")) == 0); //是否已确认了
    int paytype = WeiXinPublic.ConvertHelper.ToInt(order.PayType);
    bool haspay = order.AliTradeStatus.Equals("TRADE_FINISHED") && order.AliPayAmount > 0;

    WeiXin.Models.Home.Room room = ViewData["room"] as WeiXin.Models.Home.Room;
    string hoteltel = ViewData["hoteltel"].ToString();
    string address = ViewData["address"].ToString();

    string breakfast = "--";
    if (order.IsHourRoom == 0 && order.RatePlanName.Contains("("))
    {        
        Match match_breakfast = Regex.Match(order.RatePlanName, @"[\s\S]*\(([\s\S]*?)\)");
        breakfast = match_breakfast.Groups[1].Value;
    }
    string waitconfirmtime = null;
    if (!hasconfirm)
    {
        if (order.YinDate.Date.CompareTo(order.OrderTime.Date) == 0)
        {
            if (paytype == 0)
            {
                waitconfirmtime = order.AliPayTime.AddHours(2).ToString("HH:mm") + "前";
            }
            else
            {
                waitconfirmtime = order.OrderTime.AddHours(2).ToString("HH:mm") + "前";
            }
        }
        else
        {
            waitconfirmtime = "次日11点前";
        }
    }
    string stateAry = "{ 1: '待确认', 2: '取消', 3: '处理中', 6: '预订成功', 7: '处理中', 9: '已离店', 22: '预订失败' }";
    Dictionary<int, string> statedic = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<int, string>>(stateAry);
    string bookmessage = null;
    string statestr = null;
    switch (paytype)
    {
        case 0:
            {
                if (order.State == 2 || order.State == 22 || order.State == 9)
                {
                    //取消/预订失败/已离店
                    statestr = statedic[order.State];

                    //付款后预订失败，未退款，显示待退款
                    if (order.State == 22 && (order.AliPayAmount != order.RefundFee))
                    {
                        statestr = "待退款";
                    }
                }
                else
                {
                    if (!haspay)
                    {
                        //未付款的待处理订单
                        statestr = "待支付";
                        bookmessage = "酒店将为您保留30分钟，请在" + order.OrderTime.AddMinutes(30).ToString("M月d日 HH:mm") + "前完成在线支付。如超时未支付订单将自动取消。";
                    }
                    else
                    {
                        if (hasconfirm)
                        {
                            //付款已确认订单
                            statestr = "预订成功";
                            bookmessage = string.Format("房间为您保留到{0}的中午12:00", order.YoutDate.ToString("M月d日"));
                        }
                        else
                        {
                            //付款待确认订单
                            statestr = "待确认";
                            bookmessage = string.Format("订单会在{0}完成确认，请稍等片刻，紧急请直接联系酒店", waitconfirmtime);
                        }
                    }
                }
            }
            break;
        case 1:
            {
                if (order.State == 2 || order.State == 22 || order.State == 9)
                {
                    statestr = statedic[order.State];
                }
                else
                {
                    if (hasconfirm)
                    {
                        //现付已确认订单
                        statestr = "预订成功";
                        bookmessage = string.Format("房间为您保留到{0}的中午12:00", order.YoutDate.ToString("M月d日"));
                    }
                    else
                    {
                        //现付未确认订单
                        statestr = "待确认";
                        bookmessage = string.Format("订单会在{0}完成确认，请稍等片刻，紧急请直接联系酒店", waitconfirmtime);
                    }
                }
            }
            break;
        default:
            break;
    }

    //取消
    if (order.State == 2)
    {
        statestr = "取消";
        bookmessage = "买家取消订单";
    }

    //已离店
    else if (order.State == 9)
    {

        statestr = "交易成功";
        bookmessage = "";
    }

  //已确认
    else if (order.State == 6)
    {
        statestr = "已确认";

        if (paytype == 0)
        {
            bookmessage = "订单已成功确认，在入住日期可以放心使用，酒店一般14点后开始办理入住，提前到店可能需等待";
        }

        else
        {
            bookmessage = string.Format("订单已成功确认，请在入住日期{0}点前到店入住，超时入住请联系酒店", order.timeLast);
        }
    }

    //已付款
    else if (order.State == 24)
    {
        statestr = "已付款";
        bookmessage = "订单正待酒店确认，预计在30分钟内给您答复，如您已到店，请耐心等待";
    }

    //待付款
    else if (order.State == 1)
    {
        if (paytype == 0)
        {
            statestr = "待付款";
            bookmessage = "酒店将为您保留30分钟，如超时未支付订单将自动取消";
        }

        else
        {
            statestr = "待确认";
            bookmessage = "订单正待酒店确认，预计在30分钟内给您答复，如您已到店，请耐心等待";
        }
    }

        //未入住
    else if (order.State == 11)
    {
        statestr = "未入住";
        bookmessage = "";
    }

        //不确认
    else if (order.State == 22)
    {
        statestr = "预定失败";
        bookmessage = "";
    }

    string tipInfo = string.Empty;
    if (!(order.State == 2 || order.State == 22))
    {
        //tipInfo = "预订成功后，房间将整晚保留。";
        tipInfo = "预订后不可以取消或变更";

        if (paytype == 0 && haspay)
        {
            tipInfo = " 不可取消或变更";
        }

        if (paytype == 1)
        {
            tipInfo = string.Format("预订成功后，房间将保留到{0}点。", order.timeLast);
        }

        if (order.IsHourRoom == 1)
        {
            tipInfo = "预订成功后，房间将保留到入住当天" + order.HourEndTime;
        }
    }

    string roomName = order.IsHourRoom == 1 ? string.Format("{0}-{1}", order.RoomName, order.Hours + "小时钟点房") : string.Format("{0}-{1}", order.RoomName, order.RatePlanName.Replace("(" + breakfast + ")", ""));


    bool ismeetingZX = false;
    bool iscanting = false;
    bool ismeetingSale = false;

    if (order.isMeeting == "1" && order.PayType == "1")
    {

        tipInfo = "";
        ismeetingZX = true;
        roomName = order.RoomName;
    }

    if (order.isMeeting == "1" && order.PayType == "0")
    {
        tipInfo = "";
        ismeetingSale = true;
        roomName = order.RoomName;
    }

    if (order.isMeeting == "9")
    {
        tipInfo = "";
        roomName = order.RoomName;
        iscanting = true;
    }


    if (ismeetingZX || iscanting)
    {
        if (order.State == 1)
        {
            statestr = "待跟进";
            bookmessage = "您的信息已成功提交，酒店一般会在1天内尽快联系您，如果紧急，请直接电话联系酒店";

            if (iscanting)
            {
                bookmessage = "您的信息已成功提交，酒店一般会在1小时内尽快联系您，如果紧急，请直接电话联系酒店";
            }
        }

        else if (order.State == 6)
        {
            statestr = "跟进中";
            bookmessage = "订单酒店正在跟进中，请耐心等待";
        }

        else if (order.State == 9 || (order.State == 6 && DateTime.Now.Date > order.YinDate))
        {
            statestr = "跟进完成";

        }
    }

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", hotelweixinid);
    viewDic.Add("hId", hid);
    viewDic.Add("uwx", userweixinid);


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
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script type="text/javascript" src="<%=ViewData["cssUrl"] %>/css/booklist/jquery-ui.js"></script>
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
			<!--<img src="../images/kd1.png" />-->
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
						<span class="yu-f30r yu-f-w100"><%=order.LinkTel %></span>
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
			 
				 			<div class="yu-c99 yu-f30r yu-grid yu-alignc" onclick="javascript:window.location.href='/hotelA/Index/<%=hid %>?key=<%=hotelweixinid%>@<%=userweixinid%>'" >
                  <a class="yu-rmar20r yu-black"  href="javascript:void(0)"><%=order.HotelName %> </a>
				<a class="phone-ico4 a_tel" href="tel:<%=ViewData["hoteltel"]  %>"></a>
			 </div>
		</div>
		<div class="yu-pad20 yu-bglgrey yu-bor bbor">
				<div>
						<p class="yu-f26r yu-l40r yu-bmar10r"><%=roomName %></p>
						<ul class="yu-c99 yu-f24r">

                        <% if (!string.IsNullOrEmpty(tipInfo))
                           { %>
                        	<li><span>取消规则：</span><span> <%=tipInfo%></span> </li>

                            <%} %>
                        <%if (ismeetingZX || ismeetingSale)
                          { %>
                          	<li>
								<span>预定日期：</span>
								<span><%=order.YinDate.ToString("M月d日")%>  时间:<%=order.timeLast%></span>
							</li>
                            	<li>
								<span>联系人：</span>
								<span><%=order.UserName %></span>
							</li>

                                 	<li>
								<span>联系电话：</span>
								<span><%=order.LinkTel %></span>
							</li>


                        <%}
                          else if (iscanting)
                          { %>
                                	<li>
								<span>用餐日期：</span>
								<span><%=order.YinDate.ToString("M月d日")%>  到达时间:<%=order.timeLast %></span>
							</li>
                            	<li>
								<span>联系人：</span>
								<span><%=order.UserName %></span>
							</li>

                                 	<li>
								<span>联系电话：</span>
								<span><%=order.LinkTel %></span>
							</li>


                        <%}

                          else
                          { %>
						
							<li>
								<span>早餐：</span>
								<span><%=breakfast %></span>
							</li>
							<li>
								<span>宽带：</span>
								<span><%=room.NetType %></span>
							</li>
							<li>
								<span>床型：</span>
								<span><%=room.BedType %></span>
							</li>
							<li>
								<span>入住时间：</span>
								<span><%=order.IsHourRoom == 1 ? string.Format("{0} {1}", order.YinDate.ToString("M月d日"), order.HourStartTime) : order.YinDate.ToString("M月d日")%></span>
							</li>
							<li>
								<span>离店时间：</span>
								<span><%=order.IsHourRoom == 1 ? order.HourEndTime : order.YoutDate.ToString("M月d日")%></span> 共<span class="days"><%=order.IsHourRoom == 1 ? string.Format("{0}小时", order.Hours) : string.Format("{0}晚", order.Days)%>*<%=order.YRoomNum %>间</span>
							</li>
							<li>
								<span>入住人：</span>
								<span><%=order.UserName %></span>
							</li>
							<li>
								<span>联系电话：</span>
								<span><%=order.LinkTel %></span>
							</li>

                            <%} %>
						</ul>
				</div>

          
                         
     
				
				<div class="yu-grid yu-alignc yu-bmar10 yu-f40r">
					<div class="yu-overflow">&nbsp;</div>

                    <% if (!ismeetingZX && !iscanting)
                       { %>
					<div>

                       <% if (!(order.State == 2 || order.State == 22 || order.State == 9))
                          {  %>

                     <%if ((paytype == 0 && !haspay) || (paytype == 1))
                       { %>
						<a href="javascript:;" class="yu-btn6 type1 cancelbtn">取消订单</a>
                        <%} %>
                          <% if (paytype == 0 && !haspay)
                             {%>
    
						<a href="javascript:;" class="yu-btn6 type2 prepaybtn">去支付</a>
						<%} %>
                          <%} %>


                        <% if (paytype == 1 && (order.State == 6 || order.State == 11))
                           { %>

                        <a href="javascript:;" class="yu-btn6 type2 book-btn feedback">反馈入住</a>
                        <%} %>

                            <% if (order.State == 2 || order.State == 22)
                               { %>

                        <a href="/hotelA/Index/<%=hid %>?key=<%=hotelweixinid%>@<%=userweixinid%>" class="yu-btn6 type2">重新购买</a>
                        <%} %>
					</div>
                    <%} %>
				</div>
              
		</div>


        		<div class="hide-row">
			<div class="yu-h80r yu-grid  yu-bgw yu-bor bbor yu-f24r">
				<div class="yu-flex1 yu-bor rbor yu-grid yu-h80r yu-alignc">
					<p class="yu-c99 yu-lpad20r yu-rmar30r">间数</p>
					<p class="yu-overflow"><input type="number" class="yu-input3 yroomnum" placeholder="房间数" /></p>
				</div>
				<div class="yu-flex1 yu-bor rbor yu-grid yu-h80r yu-alignc">
					<p class="yu-c99 yu-lpad20r yu-rmar30r">房号</p>
					<p class="yu-overflow"><input type="text" class="yu-input3 yroomno" placeholder="房间号" /></p>
				</div>
				<div class="yu-flex2 yu-grid yu-h80r yu-alignc yu-arr">
					<p class="yu-c99 yu-lpad20r yu-rmar30r">离店日期</p>
					<p class="yu-overflow"><input type="text" class="yu-input3  data-select yuDate" placeholder="请选择离店日期" readonly/></p>
				</div>
			</div>
		</div>

          <% if (!ismeetingZX && !iscanting)
             { %>
		<div class="yu-h120r yu-grid yu-lrpad20r yu-alignc ">
				<p class="yu-black yu-rmar20 yu-f30r">总价</p>
				<div class="yu-overflow">
					<p class="yu-c40 yu-f30r">￥<span class="yu-f36r"><%=order.sSumPrice %></span></p>
					<p class="yu-c99 yu-f22r">已优惠<%=totalCoupon%>元，可获<span class="yu-black"><%=order.JiFen %></span>积分</p>
				</div>
		</div>
        <%} %>
		
	</section>
    <section class="yu-bgw yu-bmar20r yu-lpad20r">
		<div class="yu-h80r yu-bor bbor yu-f30r yu-l80r">订单信息</div>
		<div class="yu-tbpad30r">

			<ul class="yu-f24r yu-c99 yu-l35r">

           <% if (!string.IsNullOrEmpty(order.PayMethod))
              { %>
                         		<li class="yu-grid">
					<p class="yu-rmar20r">支付方式</p>
					<p>  <%=order.PayMethod%></p>
				</li>
                <%} %>

				<li class="yu-grid">
					<p class="yu-rmar20r">订单号</p>
					<p><%=order.OrderNO %></p>
				</li>

            
				<li class="yu-grid">
					<p class="yu-rmar20r">下单时间</p>
					<p><%=order.OrderTime %></p>
				</li>
			</ul>
		</div>
	</section>

        <%if (order.NeedInvoice == 1)
          {
      %>
    	<section class="yu-bgw yu-bmar20r yu-lpad20r">
		<div class="yu-h80r yu-bor bbor yu-f30r yu-l80r">发票信息</div>
		<div class="yu-tbpad30r">
			<ul class="yu-f24r yu-c99 yu-l35r">
				<li class="yu-grid">
					<p>发票金额：</p>
					<p><span>￥<%=order.sSumPrice-order.Foregift %></span>（票面金额）</p>
				</li>
				<li class="yu-grid">
					<p>发票抬头：</p>
					<p><%=order.InvoiceTitle %></p>
				</li>

                	<li class="yu-grid">
					<p>税号：</p>
					<p><%=order.InvoiceNum %></p>
				</li>
			</ul>
		</div>
	</section>

    <%} %>

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
    <!--end-->
    <script>

        var sys_hid = '<%=hid %>';
        var sys_hotelweixinid = '<%=hotelweixinid %>';
        var sys_userweixinid = '<%=userweixinid %>';
        var sys_orderid = '<%=orderid %>';
        var sys_orderno = '<%=order.OrderNO %>';


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
            minDate: new Date(),
            numberOfMonths: 2,
            maxDate: "+2m",
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


                $(".yuDate").val(date);
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
                url: '/action/cancelOrder',
                type: 'post',
                data: { id: sys_orderid, hotelweixinid: sys_hotelweixinid, userweixinid: sys_userweixinid },
                success: function (data) {
                    var _json = $.parseJSON(data);
                    if (_json['success']) {
                        layer.msg("取消成功");
                        setTimeout(function () { window.location.href = window.location.href; }, 1000);
                    }
                    else {
                        layer.msg(_json['message']);
                    }
                }
            });
        });


        function BindData() {

        }


        $(".feedback").click(function () {

            if (!$(this).hasClass("cur")) {
                $(this).addClass("cur");
                $(this).text("保存");
                $(".hide-row").show();
                return false;
            }


            if ($(".yroomnum").val().trim() == "" || isNaN($(".yroomnum").val().trim())) {
                layer.msg("请输入房间数");
                return false;
            }

            if ($(".yroomno").val().trim() == "") {
                layer.msg("请输入房间号");
                return false;
            }

            if ($(".yuDate").val().trim() == "") {
                layer.msg("请选择离店日期");
                return false;
            }


            $.ajax({
                url: '/UserA/Userfeedback',
                type: 'post',
                data: {
                    key: sys_hotelweixinid + "@" + sys_userweixinid, OrderNO: sys_orderno, yroomNum: $(".yroomnum").val().trim(), yuDate: $(".yuDate").val().trim(), yroomNo: $(".yroomno").val().trim()
                },
                dataType: 'json',
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {
                        layer.msg("提交成功");
                        setTimeout(function () { window.location.href = window.location.href; }, 1000);
                    }

                    else {
                        $(".feedback").attr("disabled", false);
                        layer.msg(ajaxObj.Mess);
                    }
                }

            });

        });


        $('.prepaybtn').click(function () {

            window.location.href = '/recharge/CardPay/<%=hid%>?key=<%=hotelweixinid %>@<%=userweixinid %>&orderno=' + sys_orderno;
        });


        $(".a_tel").click(function (event) {
            event.stopPropagation();
        });


    </script>
</body>
</html>
