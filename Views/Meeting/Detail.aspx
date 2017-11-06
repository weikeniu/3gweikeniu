<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
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
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userWeiXinID);

    var rateList = ViewData["rateList"] as List<hotel3g.Models.Home.MeetingRates>;


    Newtonsoft.Json.Converters.IsoDateTimeConverter timeFormat = new Newtonsoft.Json.Converters.IsoDateTimeConverter();
    timeFormat.DateTimeFormat = "yyyy-M-d";
    string rateJson = Newtonsoft.Json.JsonConvert.SerializeObject(rateList, timeFormat);


    var picList = ViewData["picList"] as List<WeiXin.Common.RoomTypeImgEntity>;
    string img = "../../images/defaultRoomImg.jpg";
    if (picList.Count > 0)
    {
        img = picList[0].Url;

        if (!string.IsNullOrEmpty(picList[0].Big_url))
        {
            img = picList[0].Big_url;
        }
    }
    var meeting = ViewData["meeting"] as hotel3g.Models.Home.Meeting;




    var date = Convert.ToDateTime(Request.QueryString["date"]);
    // double price = Convert.ToDouble(rateList.Where(c => c.Date == date).FirstOrDefault().AmPrice);

    var curr_price = rateList.Where(c => c.Date == date).FirstOrDefault();


    if (curr_price == null && meeting.PayType == 0)
    {
        Response.Redirect(string.Format("/meeting/Index/{0}?key={1}@{2}", hotelid, weixinID, userWeiXinID));
    }

    string meetingClass = string.Empty;
    string meetingClassPrice = string.Empty;
    if (meeting.PayType == 1)
    {
        curr_price = new hotel3g.Models.Home.MeetingRates();

        meetingClassPrice = "none";
        meetingClass = "meeting_zx";
    }

    string hotelName = ViewData["hotelName"].ToString();


    List<string> list_equipmentInfo = meeting.EquipmentInfo.Split(',').ToList();


    double graderate = WeiXinPublic.ConvertHelper.ToDouble(ViewData["graderate"]);
    string MemberCardRuleJson = ViewData["MemberCardRuleJson"].ToString();

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
    <title>填写订单</title>
    <link href="<%=ViewData["cssUrl"]%>/swiper/swiper-3.4.1.min.css?v=1.0" rel="stylesheet"
        type="text/css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/jquery-ui.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["cssUrl"] %>/css/booklist/jquery-ui.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <script src="<%=ViewData["jsUrl"]%>/swiper/swiper-3.4.1.jquery.min.js" type="text/javascript"></script> 

    <style>
        .hongbao-mask .copy
        {
            display: none;
        }
        
        .room-num
        {
            display: none;
        }
        
        .meeting_zx
        {
            display: none;
        }
        
        .room-price-d
        {
            display: <%=meetingClassPrice%>;
        }
    </style>
</head>
<body>
    <article class="full-page">
      
   

    <%string bodyclass = "sp"; %>
   

     <%   if (meeting.PayType == 1)
          { %>
     <style>
         .ui-datepicker td span, .ui-datepicker td a
         {
             line-height: 1.08rem;
         }
     </style>
        <%} %>

     <section class="show-body <%=bodyclass %>">
	 
			<section class="content2 yu-bpad120r <%=bodyclass %>">
				<div class="show-header"> 
								<%--		<div class="inner yu-h360r">
											<img src="<%=img %>" />
										</div>--%>

                                        	<div class="yu-h360r">
											<!--<img src="../images/booking.jpg" />-->
											<div class="swiper-container yu-h360r">
											    <div class="swiper-wrapper">

                                                
                                                 <% if (picList.Count > 0)
                                                    {
                                                        foreach (var item in picList)
                                                        {    %>
                                                <div class="swiper-slide full-img">	<img src="<%=string.IsNullOrEmpty(item.Big_url) ? item.Url :item.Big_url %>" /></div>		
                                                <%  }
                                                    }
                                                    else {  %>
                                                      	<div class="swiper-slide full-img">	<img src="<%=img %>" /></div>			
                                                    <%} %> 
                                                        								       
													</div>
											    <div class="swiper-pagination"></div>
										  	</div>
										</div>
										<div class="yu-bgf3 yu-h50 yu-grid yu-alignc yu-bor bbor yu-lrpad10">
											<p class="yu-overflow yu-f30r"  id="roomName"  ><%=meeting.Name %></p>
											<p class="yu-c40 yu-f30r <%=meetingClass %>">￥<label  id="totalprice2">0</label></p>
										</div>

                                      	 
									</div>
				<div class="tab-con">
					<ul class="tab-nav yu-grid yu-bor bbor type3 yu-alignc yu-bmar20r sp">
						<li class="cur yu-overflow">预订信息</li>
						<li class="yu-overflow">容量</li>
						<li class="yu-overflow">设施与服务</li>
					</ul>
					<ul class="tab-inner">
						<li class="cur">
							<div class="yu-bgw yu-bmar20r yu-lpad10">
								<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 usernamelist">
									<div class="l-ico type5 yu-rmar10"></div>
									<p class="yu-w60 yu-f30r">联系人</p>
									<div class="yu-overflow"><input type="text" class="yu-input2  username" placeholder="请输入联系人"></div>
									<div class="yu-grid sex-select yu-alignc yu-f30r">
											<label class="yu-rmar45r">
												<span>先生</span><span class="ico"></span>
											</label>
											<label>
												<span>女士</span><span class="ico"></span>
											</label>
										</div>
								</div>
								<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
									<div class="l-ico type6 yu-rmar10"></div>
									<p class="yu-w60 yu-f30r">手机号</p>
									<div class="yu-overflow"><input type="tel" class="yu-input2 phonenum-input phonenumber" maxlength="11" placeholder="请输入手机号码"  /></div>
								</div>
							 
									<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 yu-arr data-select">
									<div class="l-ico type2 yu-rmar10"></div>
									<p class="yu-w60 yu-f30r">日期</p>
									<div class="yu-overflow yu-f30r"><span id="indate"><%=date.ToString("yyyy-MM-dd") %></span></div>
								</div>
								<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 yu-arr lasttimeselect">
									<div class="l-ico type15 yu-rmar10"></div>
									<p class="yu-w60 yu-f30r">时间</p>
									<div class="yu-overflow yu-f30r"><apan id="lasttime">上午</apan></div>
								</div>
								<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
									<div class="l-ico type7 yu-rmar10"></div>
									<p class="yu-w60 yu-f30r">备注</p>
									<div class="yu-overflow"><input type="text" class="yu-input2" placeholder="请输入备注信息"  id="demo"></div>
								</div>


                                				<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 yu-arr hongbao-btn" style="display:none">
									<div class="l-ico type8 yu-rmar10"></div>
									<p class="yu-w60 yu-f30r">红包</p>
									<div class="yu-overflow">
										<p class="yu-c40 yu-f36r"><i class="yu-font12">￥</i><label id="couponprice">0</label></p>
										<p class="yu-c66 yu-f22r">已从房费金额中扣除</p>
									</div>
								</div>
 

								<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 <%=meetingClass %>">
									<div class="l-ico type9 yu-rmar10"></div>
									<p class="yu-w60 yu-f30r">总价</p>
									<div class="yu-overflow">
											<p class="yu-c40 yu-f36r"><i class="yu-font12">￥</i><label id="totalprice" ></label></p>
									<p class="yu-c66 yu-f22r">	 <span class="discountstr"  style="display:none"> 已优惠<label>0</label>元</span>
                            <span class="memberpointsstr"  style="display:none">可获<i class="yu-c40 memberpoints">0</i>积分</span>
                            </p>
									</div>
								</div>


							</div>
							<div class="yu-bgw yu-bor tbor yu-f26r yu-tb40r yu-lr70r yu-bmar20r">
								 <%=meeting.Remark %>
							</div>
						</li>
						<li>
							<div class="hy-build yu-bmar20r">
								<p class="yu-h100r yu-bor bbor yu-bgw yu-f30r yu-lpad20r yu-l100r">
									场地台型及容量
								</p>
								<ul class="yu-bgfc yu-lpad20r yu-f30r">     

                                 <% foreach (var item in meeting.listMeetingTypeCapacity)
                                    {  %>
                                      		<li class="yu-bor bbor yu-h100r yu-grid yu-alignc">
									<div class="yu-overflow yu-grid yu-alignc yu-flex-w-w">
											<p class="ico"></p>
											<p class="yu-c66 yu-rmar20r"><%=item.Name %></p>
											<p><%=item.Person %>人</p>
                                                <div class="yu-f18r yu-c66 yu-w-full"><%=item.Remark %></div>
										</div>
										
									</li>
                                      
                                 <%  } %>
 
							 
								</ul>
							</div>
							
							<div class="hy-build sp yu-bmar20r">
								<p class="yu-h100r yu-bor bbor yu-bgw yu-f30r yu-lpad20r yu-l100r">
									场地数据
								</p>
								<ul class="yu-bgfc yu-lpad20r yu-f30r">
									<li class="yu-bor bbor yu-h100r yu-grid yu-alignc">
										<div class="yu-overflow yu-grid yu-alignc">
											<p class="ico"></p>
											<p class="yu-c66 yu-rmar20r">长&宽(m*m)</p>
										</div>
										<div class="yu-overflow yu-grid yu-alignc">
											<p class=""><%=Convert.ToDouble( meeting.Long )%>m*<%=Convert.ToDouble(  meeting.Width ) %>m</p>
										</div>
									</li>
									<li class="yu-bor bbor yu-h100r yu-grid yu-alignc">
										<div class="yu-overflow yu-grid yu-alignc">
											<p class="ico"></p>
											<p class="yu-c66 yu-rmar20r">高(m)</p>
										</div>
										<div class="yu-overflow yu-grid yu-alignc">
											<p class=""><%=Convert.ToDouble( meeting.Height) %>m</p>
										</div>
									</li>
									<li class="yu-bor bbor yu-h100r yu-grid yu-alignc">
										<div class="yu-overflow yu-grid yu-alignc">
											<p class="ico"></p>
											<p class="yu-c66 yu-rmar20r">面积(m2)</p>
										</div>
										<div class="yu-overflow yu-grid yu-alignc">
											<p class="yu-c66 yu-rmar20r">  <%=Convert.ToDouble( meeting.Long *meeting.Width )%>平方</p>
										</div>
									</li>
									<li class="yu-bor bbor yu-h100r yu-grid yu-alignc">
										<div class="yu-overflow yu-grid yu-alignc">
											<p class="ico"></p>
											<p class="yu-c66 yu-rmar20r">门长&门宽(m*m)</p>
										</div>
										<div class="yu-overflow yu-grid yu-alignc">
											<p class=""><%=meeting.DoorInfo %></p>
										</div>
									</li>
									<li class="yu-bor bbor yu-h100r yu-grid yu-alignc">
										<div class="yu-overflow yu-grid yu-alignc">
											<p class="ico"></p>
											<p class="yu-c66 yu-rmar20r">自然光线</p>
										</div>
										<div class="yu-overflow yu-grid yu-alignc">
											<p class=""><%=meeting.Light%></p>
										</div>
									</li>
									<li class="yu-bor bbor yu-h100r yu-grid yu-alignc">
										<div class="yu-overflow yu-grid yu-alignc">
											<p class="ico"></p>
											<p class="yu-c66 yu-rmar20r">楼层</p>
										</div>
										<div class="yu-overflow yu-grid yu-alignc">
											<p class=""><%=meeting.Floor %></p>
										</div>
									</li>
								</ul>
							</div>
						</li>
						<li>
							<ul class="yu-bgw hy-build2 yu-f30r equipment">


                            <% if (list_equipmentInfo.Contains("麦克风"))
                               { %>
								<li class="yu-grid yu-alignc yu-h100r" >
									<div class="yu-overflow yu-grid yu-alignc yu-lpad40r">
										<p class="ico type1"></p>
										<p>麦克风</p>
									</div>
									
								</li>

                                <%} %>

                                 <% if (list_equipmentInfo.Contains("纸/笔/水"))
                                    { %>
								<li class="yu-grid yu-alignc yu-h100r">
									<div class="yu-overflow yu-grid yu-alignc yu-lpad40r">
										<p class="ico type2"></p>
										<p>纸/笔/水</p>
									</div>
								</li>
                                  <%} %>
                                  
                                 <% if (list_equipmentInfo.Contains("立式讲台"))
                                    { %>
								<li class="yu-grid yu-alignc yu-h100r">
									<div class="yu-overflow yu-grid yu-alignc yu-lpad40r">
										<p class="ico type3"></p>
										<p>立式讲台</p>
									</div>
									
								</li>
                                <%} %>

                                  <% if (list_equipmentInfo.Contains("引导指示牌"))
                                     { %>
								<li class="yu-grid yu-alignc yu-h100r">
									<div class="yu-overflow yu-grid yu-alignc yu-lpad40r">
										<p class="ico type4"></p>
										<p>引导指示牌</p>
									</div>
								</li>

                                <%} %>
                                  <% if (list_equipmentInfo.Contains("签到台"))
                                     { %>
								<li class="yu-grid yu-alignc yu-h100r">
									<div class="yu-overflow yu-grid yu-alignc yu-lpad40r">
										<p class="ico type5"></p>
										<p>签到台</p>
									</div>
									
								</li>
                                <%} %>

                                 <% if (list_equipmentInfo.Contains("投影仪"))
                                    { %>
								<li class="yu-grid yu-alignc yu-h100r">
									<div class="yu-overflow yu-grid yu-alignc yu-lpad40r">
										<p class="ico type6"></p>
										<p>投影仪</p>
									</div>
								</li>

                                <%} %>

                                    <% if (list_equipmentInfo.Contains("投影幕布"))
                                       { %>
								<li class="yu-grid yu-alignc yu-h100r">
									<div class="yu-overflow yu-grid yu-alignc yu-lpad40r">
										<p class="ico type7"></p>
										<p>投影幕布</p>
									</div>
									
								</li>

                                <%} %>

                                  <% if (list_equipmentInfo.Contains("白板"))
                                     { %>
								<li class="yu-grid yu-alignc yu-h100r">
									<div class="yu-overflow yu-grid yu-alignc yu-lpad40r">
										<p class="ico type8"></p>
										<p>白板</p>
									</div>
								</li>
                                <%} %>

                                    <% if (list_equipmentInfo.Contains("音响"))
                                       { %>
								<li class="yu-grid yu-alignc yu-h100r">
									<div class="yu-overflow yu-grid yu-alignc yu-lpad40r">
										<p class="ico type9"></p>
										<p>音响</p>
									</div>
									
								</li>
                                <%} %>

                             <% if (list_equipmentInfo.Contains("舞台"))
                                { %>

								<li class="yu-grid yu-alignc yu-h100r">
									<div class="yu-overflow yu-grid yu-alignc yu-lpad40r">
										<p class="ico type10"></p>
										<p>舞台</p>
									</div>
								</li>
                                <%} %>

                                
                             <% if (list_equipmentInfo.Contains("LED屏幕"))
                                { %>

								<li class="yu-grid yu-alignc yu-h100r">
									<div class="yu-overflow yu-grid yu-alignc yu-lpad40r">
										<p class="ico type11"></p>
										<p>LED屏幕</p>
									</div>
									
								</li>
                                <%} %>
							</ul>
						</li>
						
					</ul>
				</div>

                <section class="yu-lrpad10r yu-f34r yu-bpad20r" style="<%=meeting.PayType==0 ? "display:none"  : ""  %>">
					<input class="yu-btn3  btn_yuding" value="立即预定" type="button"    />
				</section>
			</section>
			<footer class="yu-grid fix-bottom yu-bor tbor yu-lpad10 sp"  style="<%=meeting.PayType==1 ? "display:none"  : ""  %>" >
				<div class="yu-overflow">
					<p class="yu-f34r yu-c40 <%=meetingClass %>">合计￥<label class="actualprice"></label></p>
					<p class="yu-grey yu-f26r  <%=meetingClass %>">包含服务及增值税￥0</p>
				</div>
			 
                  <input type="button" value="<%= meeting.PayType ==0 ?  "立即预订"  :  "提交" %>" class="yu-btn yu-bg40  btn_yuding"  />
			</footer>
		</section>
		<!--红包-->
	<section class="mask hongbao-mask">
		<div class="mask-bottom-inner yu-bgw">
			<p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">红包</p>
			<ul class="yu-lrpad10 yu-c99 hongbao-select">
				 

                	<li class="yu-h120r yu-grid yu-alignc yu-bor bbor copy">
					<p class="yu-rmar10 yu-l120r"><i class="yu-f25r">￥</i><i class="yu-f50r yu-fontb couponmoney">0</i></p>
					<div class="yu-overflow yu-f24r">
						<p>订房红包</p>
					<p>有效期<span class="couponstdate"></span>-<span class="couponendate"></span></p>
					</div>
					<p class="copy-radio"></p>
				</li>

             
		 
			</ul>
			<div class="yu-l100r yu-h100r yu-bg40 yu-white  yu-textc mask-close yu-font32r" style="display:none">关闭</div>
		</div>
	</section>
	<!--时间--> 
	<section class="mask lasttime-mask">
		<div class="mask-bottom-inner yu-bgw">
			<p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">时间</p>
			<ul class="yu-lrpad10 yu-c99 hongbao-select">
				<li class="yu-h120r yu-grid yu-alignc yu-bor bbor" lasttime="am">
					<div class="yu-overflow yu-f30r">
					上午
					</div>
					<p class="copy-radio"></p>
				</li>
				<li class="yu-h120r yu-grid yu-alignc yu-bor bbor"  lasttime="pm">
					<div class="yu-overflow yu-f30r">
						下午
					</div>
					<p class="copy-radio"></p>
				</li>

                	<li class="yu-h120r yu-grid yu-alignc yu-bor bbor" lasttime="apm">
					<div class="yu-overflow yu-f30r">
						上下午
					</div>
					<p class="copy-radio"></p>
				</li>
                
                	<li class="yu-h120r yu-grid yu-alignc yu-bor bbor" lasttime="nt">
					<div class="yu-overflow yu-f30r">
						晚上
					</div>
					<p class="copy-radio"></p>
				</li>
			</ul>
			<div class="yu-l100r yu-h100r yu-bg40 yu-white  yu-textc mask-close yu-font32r"  style="display:none">关闭</div>
		</div>
	</section>
 
    	<!--日历-->
	<section class="data-page">
			<div id="datepicker"></div>
			<div class="fix-bottom yu-bor tbor yu-grid yu-alignc yu-lrpad10 yu-h34r"  style=" display:none">
				<p class="yu-overflow ">选择日期:<label class="select_date"> </label></p>     
				<div>
					<div class="yu-grid yu-alignc">
						<p class="data-btn cal yu-bor1 bor select_cal">取消</p>
						<p class="data-btn sub  select_qd">确定</p>
					</div>
				</div>
			</div>
		</section>
		<!--日历end-->
     

            <!--弹窗-->
    <section class="mask alert">
		 
		<div class="inner yu-w480r">
			<div class="yu-bgw">
				<p class="yu-lrpad40r yu-tbpad50r yu-textc yu-bor bbor yu-f30r tipmsg" >请您输入订购信息</p>
				<div class="mask-close yu-tbpad30r yu-textc yu-c40 yu-f36r">知道了</div>
			</div>
		</div>
	</section>

        <section class="loading-page" style="position: fixed; display: none">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
	</article>
    <% ViewData["key"] = Request.QueryString["key"]; ViewData["hId"] = hotelid; %>
    <% Html.RenderPartial("QuickNavigation", null); %>
    <script>

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

                $(".select_date").text(date);


                if (meetingType == 0) {
                    var selectDay = $("td[data-handler='selectDay'][data-year=" + me.selectedYear + "][data-month=" + me.selectedMonth + "][data-day=" + me.selectedDay + "]");

                    meetingTempPrice.AmPrice = $(selectDay).find(".room-price-d  i").attr("data-amprice");
                    meetingTempPrice.PmPrice = $(selectDay).find(".room-price-d  i").attr("data-pmprice");
                    meetingTempPrice.DayPrice = $(selectDay).find(".room-price-d  i").attr("data-dayprice");
                    meetingTempPrice.NightPrice = $(selectDay).find(".room-price-d  i").attr("data-nightprice");

                    meetingTempPrice.AmStatus = (selectDay).find(".room-price-d  i").attr("data-amstatus");
                    meetingTempPrice.PmStatus = (selectDay).find(".room-price-d  i").attr("data-pmstatus");
                    meetingTempPrice.DayStatus = (selectDay).find(".room-price-d  i").attr("data-daystatus");
                    meetingTempPrice.NightStatus = (selectDay).find(".room-price-d  i").attr("data-nightstatus");

                    if ($(selectDay).find(".room-price-d  i").attr("data-amprice") == undefined) {
                        meetingTempPrice.AmPrice = 0;
                        meetingTempPrice.PmPrice = 0;
                        meetingTempPrice.DayPrice = 0;
                        meetingTempPrice.NightPrice = 0;
                        meetingTempPrice.AmStatus = 0;
                        meetingTempPrice.PmStatus = 0;
                        meetingTempPrice.DayStatus = 0;
                        meetingTempPrice.NightStatus = 0;
                    }

                }

                setTimeout("$('.select_qd').click()", 100);


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


        var rataJson = '';
        var memberJson = $.parseJSON('<%=MemberCardRuleJson %>');
        var meetingType = parseInt('<%=meeting.PayType %>');

        var meetingPrice = new Object();
        var meetingTempPrice = new Object();
        meetingPrice.AmPrice = '<%=Convert.ToDouble( curr_price.AmPrice)  %>';
        meetingPrice.PmPrice = '<%=Convert.ToDouble( curr_price.PmPrice)  %>';
        meetingPrice.DayPrice = '<%=Convert.ToDouble( curr_price.DayPrice)  %>';
        meetingPrice.NightPrice = '<%=Convert.ToDouble( curr_price.NightPrice)  %>';

        meetingPrice.AmStatus = '<%=Convert.ToDouble( curr_price.Status)  %>';
        meetingPrice.PmStatus = '<%=Convert.ToDouble( curr_price.PmStatus)  %>';
        meetingPrice.DayStatus = '<%=Convert.ToDouble( curr_price.DayStatus)  %>';
        meetingPrice.NightStatus = '<%=Convert.ToDouble( curr_price.NightStatus)  %>';


        function BindData() {
            if (meetingType != 0 || rataJson == '') {

                return false;
            }

            $("td[data-handler='selectDay']").find(".room-price-d em").text("满");
            $("td[data-handler='selectDay']").find(".room-price-d").addClass("full");
            $("td[data-handler='selectDay']").find(".room-price-d i").text("");
            // $("td[data-handler='selectDay']").addClass("ui-state-disabled");

            $(rataJson).each(function (i, item) {
                var date = item.Date;
                var selectDay = $("td[data-handler='selectDay'][data-year=" + date.split('-')[0] + "][data-month=" + (date.split('-')[1] - 1) + "][data-day=" + date.split('-')[2] + "]");

                if ($(selectDay).length > 0) {

                    var curshowPrice = 0;

                    if ($(".lasttime-mask li.cur").attr("lasttime") == "am") {

                        if (item.AmPrice > 0 && item.Status == 1) {
                            curshowPrice = item.AmPrice;
                        }

                    }

                    else if ($(".lasttime-mask li.cur").attr("lasttime") == "pm") {
                        if (item.PmPrice > 0 && item.PmStatus == 1) {
                            curshowPrice = item.PmPrice;
                        }
                    }
                    else if ($(".lasttime-mask li.cur").attr("lasttime") == "apm") {
                        if (item.DayPrice > 0 && item.DayStatus == 1) {
                            curshowPrice = item.DayPrice;
                        }
                    }
                    else if ($(".lasttime-mask li.cur").attr("lasttime") == "nt") {
                        if (item.NightPrice > 0 && item.NightStatus == 1) {
                            curshowPrice = item.NightPrice;
                        }
                    }


                    if (curshowPrice > 0) {

                        $(selectDay).removeClass("ui-state-disabled");
                        $(selectDay).find(".room-price-d em").text("￥");
                        $(selectDay).find(".room-price-d").removeClass("full");

                        $(selectDay).find(".room-price-d i").text(curshowPrice);
                    }



                    $(selectDay).find(".room-price-d i").attr("data-amprice", item.AmPrice);
                    $(selectDay).find(".room-price-d i").attr("data-pmprice", item.PmPrice);
                    $(selectDay).find(".room-price-d i").attr("data-dayprice", item.DayPrice);
                    $(selectDay).find(".room-price-d i").attr("data-nightprice", item.NightPrice);


                    $(selectDay).find(".room-price-d i").attr("data-amstatus", item.Status);
                    $(selectDay).find(".room-price-d i").attr("data-pmstatus", item.PmStatus);
                    $(selectDay).find(".room-price-d i").attr("data-daystatus", item.DayStatus);
                    $(selectDay).find(".room-price-d i").attr("data-nightstatus", item.NightStatus);

                }


            });

        }

        $(".select_qd").click(function () {


            $(".show-body").show();
            $("header").show();
            $(".data-page").hide();

            $("#indate").text($(".select_date").text());


            if (meetingType == 0) {

                //                var tempyufull = false;
                //                if ($($("#datepicker .specialdays")[0]).find(".full").length > 0) {

                //                    tempyufull = true;
                //                }

                //                if (tempyufull) {
                //                    $(".btn_yuding").addClass("yu-bgcc");
                //                    $(".btn_yuding").text("订完");
                //                }
                //                else {
                //                    $(".btn_yuding").removeClass("yu-bgcc");
                //                    $(".btn_yuding").text("立即预订");
                //                 
                //                }


                $.extend(true, meetingPrice, meetingTempPrice);
                calculatePrice();
            }

        });




        $(document).on('click', '.lasttime-mask li[lasttime]', function () {
            var lasttime = $(this).find("div").text().trim();
            $('#lasttime').text(lasttime);
            $(this).parents(".mask").fadeOut();
            calculatePrice();
        });



        $(".hongbao-mask li").click(function () {

            var couponid = $(this).attr('couponid');
            $('#couponprice').attr('couponid', couponid);

            var money = $(this).find(".couponmoney").text().trim();

            $('#couponprice').text(money);
            if (money > 0) {
                $('#couponprice').closest('.hongbao-btn').show();
            }

            calculatePrice();

            $(this).parents(".mask").fadeOut();
        })


        function calculatePrice() {

            if (meetingType != 0) {

                return false;
            }


            var saleprice = 0;


            if ($(".lasttime-mask li.cur").attr("lasttime") == "am") {

                if (meetingPrice.AmPrice > 0 && meetingPrice.AmStatus == 1) {
                    saleprice = meetingPrice.AmPrice;
                }

            }

            else if ($(".lasttime-mask li.cur").attr("lasttime") == "pm") {

                if (meetingPrice.PmPrice > 0 && meetingPrice.PmStatus == 1) {
                    saleprice = meetingPrice.PmPrice;
                }


            }

            else if ($(".lasttime-mask li.cur").attr("lasttime") == "apm") {

                if (meetingPrice.DayPrice > 0 && meetingPrice.DayStatus == 1) {
                    saleprice = meetingPrice.DayPrice;
                }
            }

            else if ($(".lasttime-mask li.cur").attr("lasttime") == "nt") {

                if (meetingPrice.NightPrice > 0 && meetingPrice.NightStatus == 1) {
                    saleprice = meetingPrice.NightPrice;
                }
            }

            if (saleprice == 0) {

                $(".btn_yuding").addClass("yu-bgcc");
                $(".btn_yuding").text("订完");
                return;
            }

            $(".btn_yuding").removeClass("yu-bgcc");
            $(".btn_yuding").text("立即预订");

            var couponprice = parseInt($('#couponprice').text());

            var totalprice = parseInt(saleprice) - couponprice;

            var discountprice = couponprice;

            if (discountprice > 0) {
                $('.discountstr label').text(discountprice);
                $('.discountstr').show();
            }
            var actualprice = totalprice;
            $('.actualprice').text(actualprice);
            $('#totalprice').text(actualprice);
            $('#totalprice2').text(actualprice);

            if (memberJson["rule"]['GradePlus'] > 0) {
                var memberpoints = parseInt(totalprice * memberJson["rule"]['GradePlus'] * memberJson["rule"]['equivalence']);
                $('.memberpoints').text(memberpoints);
                if (memberpoints > 0) {
                    $('.memberpointsstr').show();
                }
            }
        }



        function fetchcouponlist() {
            var that = $('.hongbao-mask ul');
            $('.hongbao-mask  ul  li[couponid]').remove();

            $.ajax({
                url: '/action/getCouponlist',
                type: 'post',
                data: { hotelWeixinid: '<%=weixinID %>', userWeixinid: '<%=userWeiXinID %>', key: '<%=HotelCloud.Common.HCRequest.GetString("key") %>' },
                success: function (data) {
                    couponjson = $.parseJSON(data);
                    $.each(couponjson, function (k, coupon) {
                        var div = $('.hongbao-mask .copy').clone(true).removeClass('copy');
                        div.find('.couponmoney').text(coupon['Moneys']);
                        div.find('.couponstdate').text(getcoupondatestr(coupon['sTime']));
                        div.find('.couponendate').text(getcoupondatestr(coupon['ExtTime']));
                        div.attr('couponid', coupon['Id']);
                        that.append(div);
                    });
                    if ($('.hongbao-mask li[couponid]').length > 0) {
                        $('#couponprice').closest('.hongbao-btn').show();
                        $('.hongbao-mask  li[couponid]:first').trigger('click');

                    }
                }
            });

        }


        function GetRateJson() {

            $.ajax({
                url: '/Meeting/GetRateList/' + '<%=hotelid %>',
                type: 'post',
                data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key") %>', meetingId: '<%=meeting.Id %>' },
                success: function (ajaxObj) {
                    if (ajaxObj.Data) {
                        rataJson = $.parseJSON(ajaxObj.Data);
                        BindData();
                        $(".loading-page").hide();
                    }
                }
            });
        }

        //返回yyyy.MM.dd格式
        function getcoupondatestr(_date) {
            var date = new Date(_date.match(/\d+/)[0] * 1);
            var year = date.getYear() + 1900;
            var month = date.getMonth() + 1;
            var day = date.getDate();
            if (month < 10) {
                month = '0' + month;
            }
            if (day < 10) {
                day = '0' + day;
            }
            return year.toString() + '.' + month.toString() + '.' + day.toString();
        }



        //保存
        $('.btn_yuding').click(function () {

            if ($('.btn_yuding').hasClass("yu-bgcc")) {

                return false;
            }


            $('.btn_yuding').prop('disabled', true);
            var nameary = new Array();
            var isnameempty = false;
            $.each($('.username'), function () {
                var name = $(this).val();
                if (name == '') {
                    isnameempty = true;
                    $(this).focus();
                    return false;
                }
                nameary.push(name);
            });

            if (isnameempty) {
                $(".alert  .tipmsg").text("请输入联系人");
                $(".alert").show();
                $('.btn_yuding').prop('disabled', false);
                return false;
            }
            var username = nameary.join('|');
            if (!isNaN(username)) {

                $(".alert  .tipmsg").text("联系人不能填写数字");
                $(".alert").show();

                $('.btn_yuding').prop('disabled', false);
                return false;
            }

            var phonenumber = $('.phonenumber').val().trim();
            if (!/^1\d{10}$/.test(phonenumber)) {

                $('.btn_yuding').prop('disabled', false);
                $(".alert  .tipmsg").text("请输入正确手机号");
                $(".alert").show();
                $(".phonenumber").focus();
                return false;
            }


            var needinvoice = 0;

            //            if ($(".fapiao .radio").hasClass("cur")) {
            //                needinvoice = 1;

            //                if ($("#fapiao_nr").val().trim() == "") {
            //                    layer.msg('请输入发票抬头！');
            //                    ("#fapiao_nr").focus();
            //                    $('.btn_yuding').prop('disabled', false);
            //                    return false;
            //                }
            //            }


            //写入信息保存
            var saveinfo = {};
            var roomnum = 1;
            saveinfo['yroomnum'] = roomnum;
            saveinfo['username'] = username;
            saveinfo['linktel'] = phonenumber;
            saveinfo['needinvoice'] = needinvoice;
            if (needinvoice == 1) {
                saveinfo['invoicetitle'] = $("#fapiao_nr").val().trim();
            }
            var foregift = 0;
            saveinfo['foregift'] = foregift;
            var actualprice = parseInt($('.actualprice:eq(0)').text());
            if (meetingType == 1) {
                actualprice = 0;
            }
            saveinfo['ssumprice'] = actualprice;
            saveinfo['roomid'] = '<%=meeting.Id %>';
            saveinfo['rateplanid'] = '<%=meeting.Id %>';
            saveinfo['hotelid'] = '<%=hotelid %>';
            saveinfo['roomname'] = '<%=meeting.Name %>';
            saveinfo['hotelname'] = '<%=hotelName %>';
            saveinfo['ishourroom'] = 0;
            var lasttime = $('#lasttime').text();
            saveinfo['yindate'] = $("#indate").text().trim();
            saveinfo['youtdate'] = $("#indate").text().trim();
            var rateplanname = '<%=meeting.Name %>';

            saveinfo['lasttime'] = lasttime;

            saveinfo['rateplanname'] = rateplanname;
            saveinfo['weixinid'] = '<%=weixinID %>';
            saveinfo['userWeixinid'] = '<%=userWeiXinID %>';
            var paytype = '<%=meeting.PayType %>';
            saveinfo['paytype'] = paytype;
            var priceAry = new Array();

            var originalsaleprice = actualprice + parseInt($('#couponprice').text());

            priceAry.push($("#indate").text().trim() + ':' + originalsaleprice);

            saveinfo['priceAry'] = priceAry.join('|');
            var memberpoints = parseInt($('.memberpoints').text());
            saveinfo['jifen'] = memberpoints;
            saveinfo['demo'] = $('#demo').val();
            saveinfo['token'] = "";
            saveinfo['cardno'] = memberJson["rule"]["CardNo"];
            saveinfo['memberid'] = memberJson['memberid'];

            //以下信息保存到 couponinfo 字段
            saveinfo['originalsaleprice'] = originalsaleprice;
            saveinfo['couponid'] = $('#couponprice').attr('couponid');
            saveinfo['couponprice'] = parseInt($('#couponprice').text());
            saveinfo['graderate'] = memberJson["rule"]['GradeRate'];
            saveinfo['gradename'] = memberJson["rule"]['GradeName'];
            saveinfo['isvip'] = 0;
            saveinfo['ismeeting'] = 1;
            $.ajax({
                url: '/HotelA/saveorderinfo/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>',
                type: 'post',
                data: { saveinfo: JSON.stringify(saveinfo) },
                success: function (data) {
                    var _json = $.parseJSON(data);
                    var gohref = "";
                    if (_json['success']) {



                        if (paytype == 0) {

                            gohref = '/Recharge/CardPay/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>&orderno=' + _json['orderno'];
                            window.location.href = gohref;

                        } else if (paytype == 1) {
                            //现付跳转到订单列表

                            gohref = '/User/MyOrders/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>';


                            $(".alert  .tipmsg").text("提交订单成功！服务人员会尽快联系您。请保持手机畅通！");
                            $(".alert").show();
                            setTimeout("window.location.href='" + gohref + "'", 1000);

                        }


                    }
                    else {

                        $(".alert  .tipmsg").text(_json['message']);
                        $(".alert").show();
                        $('.btn_yuding').prop('disabled', false);
                    }
                }
            });
        });






        $(function () {

            $(".lasttime-mask li").eq(0).addClass("cur");


            if (meetingType == 0) {

                // BindData();
                GetRateJson();

                calculatePrice();

                // fetchcouponlist();

                var currTime = $('.lasttime-mask li[lasttime="<%=Request.QueryString["time"]%>"]');
                if ($(currTime).length > 0) {

                    $(currTime).addClass("cur").siblings().removeClass("cur");
                    $(currTime).click();
                }


            }




            //选项卡
            var tabIndex;
            $(".tab-nav").children("li").on("click", function () {
                $(this).addClass("cur").siblings("li").removeClass("cur");
                tabIndex = $(this).index();
                $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
            })

            //性别
            $(".sex-select>label").on("click", function () {
                $(this).addClass("cur").siblings().removeClass("cur");
            })



            //红包
            $(".hongbao-select>li").on("click", function () {
                $(this).addClass("cur").siblings().removeClass("cur");
            })



            $(".hongbao-btn").click(function () {
                $(".hongbao-mask").fadeIn();
                $(".mask-bottom-inner").addClass("shin-slide-up");
            })
            $(".mask-close").click(function () {
                $(".mask").fadeOut();
            })
            $(".mask-bottom-inner").on("click", function (e) {
                //   e.stopPropagation();
            })

            //时间
            $(".lasttimeselect").click(function () {
                $(".lasttime-mask").fadeIn();
                $(".mask-bottom-inner").addClass("shin-slide-up");

            })

            //选择日期
            $(".data-select").on("click", function () {
                $(".show-body").hide();
                $("header").hide();
                $(".select_date").text($("#indate").text());
                $.extend(true, meetingTempPrice, meetingPrice);
                BindData();
                $(".data-page").show();

                if (rataJson == '' && meetingType==0) {
                    $(".loading-page").show();
                }
          

                if ($("#datepicker").find(".specialdays").length == 0) {
                    $(".ui-state-active").removeClass("ui-state-active");
                    var cur_indate = $("#indate").text();
                    var cur_year = cur_indate.split('-')[0];
                    var cur_month = cur_indate.split('-')[1].indexOf('0') == 0 ? cur_indate.split('-')[1].replace("0", "") : cur_indate.split('-')[1];
                    var cur_day = cur_indate.split('-')[2].indexOf('0') == 0 ? cur_indate.split('-')[2].replace("0", "") : cur_indate.split('-')[2];
                    var selectDay = $("td[data-handler='selectDay'][data-year=" + cur_year + "][data-month=" + (parseInt(cur_month) - 1) + "][data-day=" + cur_day + "]");
                    $(selectDay).addClass("specialdays");
                }

            })

            //只能输入数字
            $(".phonenum-input").keyup(function () {
                this.value = this.value.replace(/[^\d]/g, '');
            })


            $(".data-btn.cal").click(function () {

                $(".show-body").show();
                $("header").show();
                $(".data-page").hide();
            })
        })
    </script>
</body>
</html>
