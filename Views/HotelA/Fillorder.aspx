<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    string hid = ViewData["hid"].ToString();
    string key = HotelCloud.Common.HCRequest.GetString("key");
    string hotelWeixinid = string.Empty;
    string userWeixinid = string.Empty;
    if (!string.IsNullOrEmpty(key) && key.Contains("@"))
    {
        List<string> list = key.Split('@').ToList();
        hotelWeixinid = list[0];
        userWeixinid = list[1];
    }
    string orderjson = HotelCloud.Common.HCRequest.GetString("orderjson");
    Hashtable orderjsondic = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(orderjson);
    WeiXin.Models.Home.Room room = Newtonsoft.Json.JsonConvert.DeserializeObject<WeiXin.Models.Home.Room>(orderjsondic["room"].ToString());
    WeiXin.Models.Home.RatePlan rateplan = Newtonsoft.Json.JsonConvert.DeserializeObject<WeiXin.Models.Home.RatePlan>(orderjsondic["rateplan"].ToString());
    int ishourroom = WeiXinPublic.ConvertHelper.ToInt(rateplan.IsHourRoom);
    string hours = rateplan.HourRoomType;
    string breakfast = "--";
    string area = "--";
    string nettype = "--";
    string floor = "--";
    string bedtype = "--";
    string addbed = "--";
    if (rateplan != null)
    {
        if (ishourroom == 0 && !string.IsNullOrEmpty(rateplan.ZaoCan))
        {
            breakfast = rateplan.ZaoCan;
        }
        if (!(string.IsNullOrEmpty(room.Area) || room.Area.Equals("0")))
        {
            area = room.Area;
            area = area.Replace("平方米", "").Replace("平方", "");
            area += "㎡";
        }
        if (!string.IsNullOrEmpty(room.NetType))
        {
            nettype = room.NetType;
        }
        if (!(string.IsNullOrEmpty(room.Floor) || room.Floor.Equals("0")))
        {
            floor = room.Floor;
        }
        if (!string.IsNullOrEmpty(room.BedType))
        {
            bedtype = room.BedType;
        }
        if (!string.IsNullOrEmpty(room.AddBed))
        {
            addbed = room.AddBed;
        }
    }
    int paytype = WeiXinPublic.ConvertHelper.ToInt(rateplan.PayType);


  //  string ratelistjson = ViewData["ratelistjson"].ToString();
 

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", hotelWeixinid);
    viewDic.Add("hId", hid);
    viewDic.Add("uwx", userWeixinid);
    string cssurl = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
    <title>填写订单</title>
   
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"]%>/css/booklist/jquery-ui.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"]%>/css/booklist/sale-date.css?v=1.0" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"]%>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"]%>/css/booklist/new-style.css?v=1.0" />
      <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"]%>/css/booklist/fontSize.css?v=1.0" />

     <script type="text/javascript" src="<%=ViewData["jsUrl"]%>/Scripts/jquery-1.8.0.min.js"></script>
        <script type="text/javascript" src="<%=ViewData["jsUrl"]%>/Scripts/fontSize.js"></script>

 
    <style>
        .lasttime-mask .copy
        {
            display: none;
        }
        
        .hongbao-mask .copy
        {
            display: none;
        }
        
        .room-num
        {
            display: none;
        }
    </style>
</head>
<body>
    <section class="loading-page" style="position: fixed; display: none">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
    <article class="full-page">  
     <%Html.RenderPartial("HeaderA", viewDic); %>

     <section class="show-body">
			
			<section class="content2 yu-f30r yu-bpad60">
				<div class="booking-pic">
					<img src=""  />
				</div>
				<div class="yu-h50 yu-lrpad10 yu-grid yu-alignc yu-bor bbor yu-f30r">
					<p class="yu-overflow">   <%=ishourroom == 0 ? string.Format("{0}-{1}", room.RoomName, rateplan.RatePlanName) : string.Format("{0}-{1}小时钟点房", room.RoomName, rateplan.HourRoomType)%>  </p>
				          <p>共<label  id="days"><%=ishourroom == 1 ?  hours : orderjsondic["days"]%></label><%=ishourroom == 1 ? "小时" : "晚"%></p>
                               <label style= "display:none"  id="total_days"><%=orderjsondic["days"] %></label>
				</div>
				<div class="yu-bgw yu-bmar10 yu-lpad10">
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<div class="l-ico type1 yu-rmar10"></div>
						<div class="yu-overflow">房间数量</div>
							<div class="ar yu-grid">
								<p class="reduce ico type2 cur"></p>
								<p id="roomnum"  class="food-num cur">1</p>
								<p class="add ico type2"></p>
						</div>
					</div>
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 data-select">
						<div class="l-ico type2 yu-rmar10"></div>
						<div class="yu-overflow">
							<span class="yu-rmar10">入住日期</span>
							<span id="indate"><%=WeiXinPublic.ConvertHelper.ToDateTime(orderjsondic["indate"]).ToString("yyyy-MM-dd")%></span>
						</div>
					</div>
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 data-select">
						<div class="l-ico type3 yu-rmar10"></div>
						<div class="yu-overflow">
							<span class="yu-rmar10">离店日期</span>
							<span id="outdate" ><%=WeiXinPublic.ConvertHelper.ToDateTime(orderjsondic["outdate"]).ToString("yyyy-MM-dd")%></span>
						</div>
					</div>

                    	<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 yu-arr  lasttimeselect" style="<%=paytype == 0 && ishourroom == 0?"display:none":"" %>">
						<div class="l-ico type2 yu-rmar10"></div>
						<div class="yu-overflow">
							<span class="yu-rmar10"><%=ishourroom == 1 ? "使用时段" : "保留到"%> </span>
							<span id="lasttime"></span>
						</div>
					</div>


					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 add-bed" style="display:none" > 
						<div class="l-ico type4 yu-rmar10"></div>
						<div class="yu-overflow">
							<span class="yu-rmar10">需要加床</span>
							<span class="yu-c40">￥300</span>
						</div>
					</div>
				</div>


                
				<div class="yu-bgw yu-bmar10 yu-lpad10">
					<div class="yu-bor bbor usernamelist">
						<div class="yu-h50 yu-grid yu-alignc yu-rpad10">
							<div class="l-ico type5 yu-rmar10"></div>
							<p class="yu-w60">入住人</p>
							<div class="yu-overflow"><input type="text" class="yu-input2 username" placeholder="请输入入住人" /></div>
							<div class="yu-grid sex-select yu-alignc">
								<label class="yu-rmar10">
									<span>先生</span><span class="ico"></span>
								</label>
								<label>
									<span>女士</span><span class="ico"></span>
								</label>
							</div>
						</div>
					</div>
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<div class="l-ico type6 yu-rmar10"></div>
						<p class="yu-w60">手机号</p>
						<div class="yu-overflow"><input type="tel" class="yu-input2 phonenum-input phonenumber" placeholder="请输入手机号码"     maxlength="11" /></div>
					</div>
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<div class="l-ico type7 yu-rmar10"></div>
						<p class="yu-w60">备注</p>
						<div class="yu-overflow"><input type="text" class="yu-input2" placeholder="请输入备注信息"  id="demo"  /></div>
					</div>
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 yu-arr hongbao-btn" style="display:none">
						<div class="l-ico type8 yu-rmar10"></div>
						<p class="yu-w60">红包</p>
						<div class="yu-overflow tip_youhongbao">
							<p class="yu-c40 yu-f36r"><i class="yu-f30r">￥</i><label id="couponprice">0</label></p>
							<p class="yu-c66 yu-f22r">已从房费金额中扣除</p>
						</div>
                    <p class="yu-overflow yu-f30r yu-textr yu-c99 yu-rpad30r tip_wuhongbao"  style="display:none">暂无可用</p>
					</div>
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 total_zongprice">
						<div class="l-ico type9 yu-rmar10"></div>
						<p class="yu-w60">总房价</p>
						<div class="yu-overflow">
							<p class="yu-c40 yu-f36r"><i class="yu-f30">￥</i><label id="totalprice" ></label></p>
							<p class="yu-c66 yu-f22r" >
                            <span class="hydiscountstr" style="display:none">会员优惠<label>0</label>元</span>
                            <span class="discountstr" style="display:none">已优惠<label>0</label>元</span>
                            <span class="memberpointsstr" style="display:none" >可获<i class="yu-c40 memberpoints">0</i>积分</span>
                            
                            </p>
                           
						</div>
					</div>
				</div>
 


				<div class="yu-bgw yu-bmar10 yu-lpad10">
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 fapiao">
						<p class="yu-w60">发票</p>
						<div class="yu-overflow">
							<div class="radio cur"></div>
						</div>
					</div>
					<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<p class="yu-w60">发票抬头</p>
						<div class="yu-overflow">
							<input type="text" placeholder="请输入个人/单位名称" class="yu-input2"  id="fapiao_nr" />
						</div>
					</div>

                    		<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
						<p class="yu-w60">税号</p>
						<div class="yu-overflow">
							<input type="text" placeholder="请输入纳税人识别号" class="yu-input2"  id="invoicenum" />
						</div>
					</div>

				</div>


                   <section class="main">
    <dl style="display:none;" class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60">
        <dt class="yu-greys yu-rmar30">押金</dt>
        <dd class="yu-overflow">
            <div class="radio" id="foregiftselect">
            </div>
        </dd>
    </dl>
    <dl style="display:none;" class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60">
        <dt class="yu-greys yu-rmar30">酒店押金</dt>
        <dd class="yu-overflow yu-tb yu-h60">
            <div class="yu-tbcell">
                <p class="orange">
                    ￥<label id="foregift">0</label></p>
                <p class="text-mark">
                    提前交酒店押金，离店后原路返还</p>
            </div>
        </dd>
    </dl>
     </section>


				<div class="tab-con" style="display:none">
					<ul class="tab-nav type0 yu-grid yu-bor bbor">
						<li class="yu-overflow cur">房间配套</li>
						<li class="yu-overflow">入住须知</li>
						<li class="yu-overflow">客房介绍</li>
					</ul>
					<ul class="tab-inner">
						<li class="cur yu-bgw">
							<table width="100%" class="room-de-tb">
								<colgroup>
									<col style="width: 50%;"/>
									<col style="width: 50%;"/>
								</colgroup>
								<tbody>
								<tr>
									<td class="yu-bor rbbor">
										<span class="ico wifi"></span>
										<span>WIFI</span>
									</td>
									<td  class="yu-bor bbor">
										<span class="ico weiyu"></span>
										<span>独立卫浴</span>
									</td>
								</tr>
								<tr>
									<td class="yu-bor rbbor">
										<span class="ico dachuang"></span>
										<span>大床</span>
									</td>
									<td class="yu-bor bbor">
										<span class="ico kongtiao"></span>
										<span>空调</span>
									</td>
								</tr>
								<tr>
									<td class="yu-bor rbbor">
										<span class="ico chuifengji"></span>
										<span>吹风机</span>
									</td>
									<td class="yu-bor bbor">
										<span class="ico chuanghu"></span>
										<span>窗户</span>
									</td>
								</tr>
								</tbody>
							</table>
						</li>
						<li class="yu-bgw yu-lrpad10">
							<div class="yu-tbpad20">
								<div class="yu-grid yu-alignc">
									<p class="star-ico"></p>
									<p class="yu-overflow">支付成功后，不可更改及取消；</p>
								</div>
								<div class="yu-grid yu-alignc">
									<p class="star-ico"></p>
									<p class="yu-overflow">价格已已经包含服务费及税费；</p>
								</div>
								<div class="yu-grid yu-alignc">
									<p class="star-ico"></p>
									<p class="yu-overflow">价格不含次日早餐；</p>
								</div>
							</div>
						</li>
						<li class="yu-bgw yu-lrpad10">
							<div class="yu-tbpad20">
								53 平米的吸烟客房设有 10 平米的阳台、32 英寸
									液晶电视、独立淋浴间 /浴缸和雨林花洒，可欣赏壮
									丽的山景。 •571 英尺 / 53 平米 •甜梦之床 •山峦
									景观 •阳台 •高速上网（需额外付费）
							</div>
						</li>
					</ul>
				</div>
			</section>
			<footer class="yu-grid fix-bottom yu-bor tbor yu-lpad10 sp">
	
				<div class="yu-overflow  footer_price">
					<p class="yu-f34r yu-c40">合计￥<label class="actualprice" ></label></p>
					<p class="yu-grey yu-f26r discountstr2" style="display:none">已优惠<label></label>元</p>
				</div>
				 
          <input type="button" value="立即预订" class="yu-btn yu-bg40" id="btn_yuding"  />		
			</footer>
		</section>  

        		<section class="data-page">
               <div class="top" style="display:none">入住日期</div>
			<div id="datepicker"></div>

            		<div class="fix-bottom yu-bor tbor yu-grid yu-alignc yu-lrpad10 yu-h34r" style="display:none">
				<p class="yu-overflow ">入住共<span class="selectNum">1</span>晚</p> 
				<div>
					<div class="yu-grid yu-alignc">
						<p class="data-btn cal yu-bor1 bor">取消</p>
						<p class="data-btn sub  select_qd">确定</p>
					</div>
				</div>
			</div>
		 
		</section>
</article>
    <!--红包-->
    <section class="mask hongbao-mask">
		<div class="mask-bottom-inner yu-bgw">			 
            	<p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">红包</p>
			<ul class="yu-lrpad10 yu-c99 hongbao-select">
             	<li class="yu-h120r yu-grid yu-alignc yu-bor bbor  no-usehongbao">
					<p class="yu-overflow yu-f34r">不使用红包 <i class="yu-f50r yu-fontb couponmoney"  style="display:none">0</i></p>
					<p class="copy-radio"></p>
				</li>
		 
				<li class="yu-h120r yu-grid yu-alignc yu-bor bbor copy">
					<p class="yu-rmar10 yu-l120r"><i class="yu-f25r">￥</i><i class="yu-f50r yu-fontb  couponmoney" >0</i></p>
					<div class="yu-overflow yu-f24r">
				    <p><label  class="couponqiyong"></label>元起用</p>
					 <p>有效期<span class="couponstdate"></span>-<span class="couponendate"></span></p>
					</div>
				<p class="copy-radio hongbao_gou"></p>
				</li>
			 
			</ul>
         <div class="yu-l100r yu-h100r yu-bg40 yu-white  yu-textc mask-close yu-font32r" >关闭</div>
 
		</div>
	</section>
    <!--弹窗-->
    <section class="mask alert">
		 
		<div class="inner yu-w480r">
			<div class="yu-bgw">
				<p class="yu-lrpad40r yu-tbpad50r yu-textc yu-bor bbor yu-f30r tipmsg" >请您输入订购信息</p>
				<div class="mask-close yu-tbpad30r yu-textc yu-c40 yu-f36r">知道了</div>
			</div>
		</div>
	</section>
    <!--最晚到店-->
    <section class="mask lasttime-mask">
		<div class="mask-bottom-inner yu-bgw">
			<p class="yu-h60 yu-line60 yu-textc yu-bor bbor yu-f34r">  <%=ishourroom == 1 ? "使用时段" : "最晚到店时间"%></p>
                <%if (ishourroom == 0)
                  {
              %>
			<p class="yu-h60 yu-line60 yu-textc yu-bor bbor  yu-f20r  yu-c40 yu-bgf9">该酒店14：00办理入住，早到可能需要等待。</p>

            <%} %>
			<ul class="yu-lrpad10 yu-c99 hongbao-select">
				<li class="yu-h60 yu-grid yu-alignc yu-bor bbor copy">
					<div class="yu-overflow yu-font20">						 
					</div>
					<p class="copy-radio"></p>
				</li>
				 
			</ul>
			<div class="yu-h60 yu-bg40 yu-white yu-line60 yu-textc mask-close yu-f30r" style="display:none">关闭</div>
		</div>
	</section>


    <script type="text/javascript" src="<%=ViewData["jsUrl"]%>/css/booklist/jquery-ui.js?v=1.0"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"]%>/Scripts/layer/layer.js"></script>
    <script type="text/javascript" src="<%=ViewData["cssUrl"]%>/css/booklist/date-range-picker.js?v=1.1"></script>
 
    <script>

        var dClickNum = 0;
        var selectdate = 0;
        var roomstock = 1;

        $("#datepicker").datepicker({
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
            onSelect: function (selectedDate, e) {

                if (dClickNum == 0) {
                    //console.log("第一次")
                    dClickNum = 1;
                } else {
                    //console.log("第二次")
                    dClickNum = 0;
                }

                //             return;
                //                var sDate = selectedDate;
                //                if (selectdate == 0) {

                //                    selectdate++;
                //                    $("#indate").text(sDate);
                //                    sDate = new Date(sDate);
                //                    sDate.setDate(sDate.getDate() + 1);
                //                    $("#datepicker").datepicker('option', 'minDate', sDate);
                //                    $(".data-page .top").text("离店日期");

                //                }

                //                else {

                //                    $("#outdate").text(sDate);
                //                    $("#datepicker").datepicker('option', 'minDate', new Date());


                //                    $(".data-page .top").text("入住日期");
                //                    selectdate = 0;
                //                    $("#days").text(getDays($("#indate").text().trim(), $("#outdate").text().trim()));



                //                    GetDatePrice($("#indate").text().trim(), $("#outdate").text().trim());

                //                }
            }
        });

        $(function () {
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
            //加减
            var foodNum = 0;

            $(".add").on("click", function () {


                if ($(this).siblings(".food-num").text() == "") {
                    foodNum = 1;
                    $(this).siblings(".food-num").text(foodNum);
                } else {
                    foodNum = parseInt($(this).siblings(".food-num").text());
                    foodNum++;
                    if (foodNum > roomstock || foodNum > 8) {
                        return;
                    }
                    $(this).siblings(".food-num").text(foodNum);
                };

                var uesrNameRow = $('<div class="yu-h50 yu-grid yu-alignc yu-rpad10 adduser">' +
							'<div class="yu-w96"></div>' +
							'<div class="yu-overflow"><input type="text" class="yu-input2 username" placeholder="请输入入住人" /></div>' +
							'<div class="yu-grid sex-select yu-alignc">' +
							'<label class="yu-rmar10">' +
							'<span>先生</span><span class="ico"></span>' +
							'</label>' +
							'<label>' +
							'<span>女士</span><span class="ico"></span>' +
							'</label>' +
							'</div>' +
							'</div>');
                $(".usernamelist").append(uesrNameRow);


                calculatePrice();

            });

            $(".reduce").on("click", function () {
                foodNum = parseInt($(this).siblings(".food-num").text());
                if (foodNum > 1) {
                    foodNum--;
                    $(this).siblings(".food-num").text(foodNum);
                    $(".usernamelist").children(".adduser").last().remove();
                    calculatePrice();
                };

            });
            //加床
            $(".add-bed").click(function () {
                $(this).toggleClass("cur");
            })
            //radio
            $(".radio").on("click", function () {
                if ($(this).hasClass("cur")) {
                    $(this).parents(".fapiao").siblings("div").fadeOut();
                    $(this).removeClass("cur");
                } else {
                    $(this).parents(".fapiao").siblings("div").fadeIn();
                    $(this).addClass("cur");
                }
            })
            //性别
            $(".sex-select>label").on("click", function () {
                $(this).addClass("cur").siblings().removeClass("cur");
            })
            $(".usernamelist").on("click", "label", function () {
                $(this).addClass("cur").siblings().removeClass("cur");
            })
            //选项卡
            var tabIndex;
            $(".tab-nav").children("li").on("click", function () {
                $(this).addClass("cur").siblings("li").removeClass("cur");
                tabIndex = $(this).index();
                $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
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
                //  e.stopPropagation();
            })
        })
        //预订按钮
        $(".yu-btn").click(function () {
            //  $(".alert").fadeIn();
        })
        //最晚到店
        $(".lasttimeselect").click(function () {
            $(".lasttime-mask").fadeIn();
            $(".mask-bottom-inner").addClass("shin-slide-up");

        })
        //选择时间
        $(".data-select").on("click", function () {
            $(".show-body").hide();
            $("header").hide();
            $(".data-page").show();

            if(ratelistjson =='')
            {
               $(".loading-page").show();              
            }

            if ($("#datepicker").find(".specialdays").length == 0) {
                $(".ui-state-active").removeClass("ui-state-active");
                var cur_indate = $("#indate").text();
                for (var i = 0; i < 2; i++) {

                    if (i == 1) {
                        cur_indate = $("#outdate").text();
                    }
                    var cur_year = cur_indate.split('-')[0];
                    var cur_month = cur_indate.split('-')[1].indexOf('0') == 0 ? cur_indate.split('-')[1].replace("0", "") : cur_indate.split('-')[1];
                    var cur_day = cur_indate.split('-')[2].indexOf('0') == 0 ? cur_indate.split('-')[2].replace("0", "") : cur_indate.split('-')[2];
                    var selectDay = $("td[data-handler='selectDay'][data-year=" + cur_year + "][data-month=" + (parseInt(cur_month) - 1) + "][data-day=" + cur_day + "]");
                    if (i == 1) {
                        $(selectDay).addClass("specialdays").addClass("last");
                    }

                    else {
                        $(selectDay).addClass("specialdays").addClass("first");
                    }

                }
            }
        })


        function GetRateJson() {          
         
            $.ajax({
                url: '/hotelA/GetRoomPriceList/' + sys_hid,
                type: 'post',
                data: { key: sys_key, roomId: orderjson['roomid'], rateplanId: orderjson["rateplanid"] },
                success: function (ajaxObj) {
                    if (ajaxObj.Data) {
                        ratelistjson = $.parseJSON(ajaxObj.Data);
                        BindData();
                        $(".loading-page").hide();
                    }
                }
            });
        }


        //只能输入数字
        $(".phonenum-input").keyup(function () {
            this.value = this.value.replace(/[^\d]/g, '');
        })

        $(".data-btn.cal").click(function () {

            $(".show-body").show();
            $("header").hide();
            $(".data-page").hide();
        })


        var sys_hotelWeixinid = '<%=hotelWeixinid %>';
        var sys_userWeixinid = '<%=userWeixinid %>';
        var sys_orderjson = '<%=orderjson %>';
        var sys_hid = '<%=hid %>';
        var sys_key = '<%=key %>';
        var ratelistjson = "";

        $(function () {
            $(".fapiao .radio").click();

            fetchorder();

            // BindData();

               GetRateJson();

            $(".phonenumber").val(orderjson['mobile']);
            $(".username").val(orderjson['username']);
        });



        var couponjson = {};
        var orderjson = {};

        function fetchorder() {
            orderjson = $.parseJSON(sys_orderjson);

            fetchlasttime();
            if (orderjson['room']['ConPons'] == 1) {
                fetchcouponlist();
            }
            //     fetchdemolist();

            $('.lasttime-mask li[lasttime]:first').trigger('click');

            $(".booking-pic img").attr("src", orderjson['roomimg']);

            calculatePrice();

            if (orderjson['available'] == "0" || orderjson['price'] == 0) {
                $("#btn_yuding").addClass("yu-bgcc");
                $("#btn_yuding").text("订完");
                $(".footer_price").css("visibility", "hidden");
                $(".total_zongprice").css("display", "none");
            }
            roomstock = parseInt(orderjson["roomstock"]);
        }


        function BindData() {

            $("td[data-handler='selectDay']").find(".room-price-d em").text("满");
            $("td[data-handler='selectDay']").find(".room-price-d").addClass("full");
            $("td[data-handler='selectDay']").find(".room-price-d i").text("");
            $("td[data-handler='selectDay']").find(".room-num").attr("roomstock", "0");

            // $("td[data-handler='selectDay']").addClass("ui-state-disabled");


            $(ratelistjson).each(function (i, item) {
                var date = item.Dates;

                var cur_year = date.split('-')[0];
                var cur_month = date.split('-')[1].indexOf('0') == 0 ? date.split('-')[1].replace("0", "") : date.split('-')[1];
                var cur_day = date.split('-')[2].indexOf('0') == 0 ? date.split('-')[2].replace("0", "") : date.split('-')[2];

                var selectDay = $("td[data-handler='selectDay'][data-year=" + cur_year + "][data-month=" + (parseInt(cur_month) - 1) + "][data-day=" + cur_day + "]");

                if ($(selectDay).length > 0) {

                    // $(selectDay).removeClass("ui-state-disabled");
                    $(selectDay).find(".room-price-d em").text("￥");
                    $(selectDay).find(".room-price-d").removeClass("full");
                    $(selectDay).find(".room-price-d i").text(item.Price);
                    $(selectDay).find(".room-num").text(item.RoomStock + "间");
                    $(selectDay).find(".room-num").attr("roomstock", item.RoomStock);
                }


            });

        }



        function calculatePrice() {
            var roomnum = $('#roomnum').text().trim();
            var saleprice = orderjson['price'];

            var nights = parseInt($("#total_days").text());
            var discount = orderjson['discount'];

            ShowHongbao((saleprice - discount * nights) * roomnum);

            var couponprice = parseInt($('#couponprice').text());
            var totalprice = (saleprice - discount * nights) * roomnum - couponprice;
            var discountprice = discount * nights * roomnum + couponprice;
            if (discountprice > 0) {
                $('.discountstr label').text(discountprice);
                $('.discountstr2 label').text(discountprice);
                $('.discountstr').show();
                $('.discountstr2').show();
            }

            if (discount > 0) {
                $('.hydiscountstr label').text(discountprice - couponprice);
                $('.hydiscountstr').show();
            }
            var foregift = parseInt($('#foregift').text());
            var actualprice = totalprice + foregift;
            $('.actualprice').text(actualprice);
            $('#totalprice').text(totalprice);
            if (orderjson['MemberCardRule']['GradePlus'] > 0) {
                var memberpoints = parseInt(totalprice * orderjson['MemberCardRule']['GradePlus'] * orderjson['MemberCardRule']['equivalence']);
                $('.memberpoints').text(memberpoints);
                if (memberpoints > 0) {
                    $('.memberpointsstr').show();
                }
            }
        }


        function fetchlasttime() {
            var ary = undefined;
            if (orderjson['rateplan']['IsHourRoom'] == 1) {
                ary = new Array();
                var now = new Date();
                var hour = now.getHours();
                var minute = now.getMinutes();
                var eHour = parseInt(orderjson['rateplan']['EndHour']) - parseInt(orderjson['rateplan']['HourRoomType']);
                var endhour = parseInt(orderjson['rateplan']['EndHour']);
                var starthour = parseInt(orderjson['rateplan']['StartHour']);
                var nottoday = false;
                if (!comparedate(now, orderjson['indate']) || starthour > hour) {
                    hour = starthour;
                    nottoday = true;
                }

                var hourroomtype = parseInt(orderjson['rateplan']['HourRoomType']);
                if (eHour > hour || nottoday) {
                    var hourindex = minute < 30 ? 0 : 1;
                    if (nottoday) {
                        hourindex = 0;
                    }

                    for (var i = hourindex; i <= eHour - hour; i++) {
                        var _sthour = hour + i;
                        var _enhour = _sthour + parseInt(orderjson['rateplan']['HourRoomType']);
                        for (var j = 0; j < 2; j++) {
                            if (j == 0 && _sthour >= hour) {
                                if (nottoday || _sthour > hour) {
                                    ary.push(_sthour + ':00-' + _enhour + ':00');
                                }

                            } else if (j == 1 && _enhour < endhour) {
                                ary.push(_sthour + ':30-' + _enhour + ':30');
                            }
                        }
                    }
                }
            } else {
                ary = ['18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '凌晨3点'];
            }
            var that = $('.lasttime-mask ul');
            $('.lasttime-mask ul li[lasttime]').remove();
            $.each(ary, function (k, v) {
                var div = $('.lasttime-mask .copy').clone(true).removeClass('copy');
                div.find('div').text(v);
                div.attr('lasttime', v);
                that.append(div);
            });
        }

        function fetchcouponlist() {
            var that = $('.hongbao-mask ul');
            $('.hongbao-mask  ul  li[couponid]').remove();
            if (orderjson['rateplan']['IsVip'] == 0) {
                $.ajax({
                    url: '/action/getCouponlist',
                    type: 'post',
                    data: { hotelWeixinid: sys_hotelWeixinid, userWeixinid: sys_userWeixinid, key: sys_key, type: "hotel" },
                    success: function (data) {
                        couponjson = $.parseJSON(data);
                        $.each(couponjson, function (k, coupon) {
                            var div = $('.hongbao-mask .copy').clone(true).removeClass('copy');
                            div.find('.couponmoney').text(coupon['Moneys']);
                            div.find('.couponstdate').text(getcoupondatestr(coupon['sTime']));
                            div.find('.couponendate').text(getcoupondatestr(coupon['ExtTime']));
                            div.find('.couponqiyong').text(coupon['AmountLimit']);
                            div.attr('couponid', coupon['Id']);
                            div.attr('amountlimit', coupon['AmountLimit']);
                            that.append(div);
                        });
                        if ($('.hongbao-mask li[couponid]').length > 0) {

                            $('#couponprice').closest('.hongbao-btn').show();
                            calculatePrice();

                            //  $('.hongbao-mask  li[couponid]:first').trigger('click');

                        }
                    }
                });
            }
        }


        function ShowHongbao(curr_price) {

            var no_hb = "";

            $('.hongbao-mask  li[couponid]').each(function (i, item) {

                if ($(this).find(".couponmoney").text().trim() >= parseFloat(curr_price) || parseFloat($(this).attr("amountlimit")) > parseFloat(curr_price)) {
                    $(this).find(".hongbao_gou").removeClass("copy-radio");
                    $(this).addClass("dis");

                    if ($(this).hasClass("cur")) {
                        $(this).removeClass("cur");
                        $('#couponprice').text("0");
                        $('#couponprice').attr('couponid', 0);
                        no_hb = "sys";
                    }
                }

                else {
                    $(this).find(".hongbao_gou").addClass("copy-radio");
                    $(this).removeClass("dis");
                }
            });


            if (($('.hongbao-mask  li.cur').length == 0 || ($(".no-usehongbao").hasClass("cur") && no_hb != "")) && $('.hongbao-mask  li[couponid]:not(".dis")').length > 0) {

                var curr_hongbao_li = $('.hongbao-mask  li[couponid]:not(".dis"):first');
                $(curr_hongbao_li).addClass("cur").siblings().removeClass("cur");
                var couponid = $(curr_hongbao_li).attr('couponid');
                $('#couponprice').attr('couponid', couponid);
                var money = $(curr_hongbao_li).find(".couponmoney").text().trim();
                $('#couponprice').text(money);
            }

            if ($('.hongbao-mask  li[couponid].dis').length > 0) {

                var curr_dis = $('.hongbao-mask  li[couponid].dis');
                $('.hongbao-mask  li[couponid].dis').remove();
                $('.hongbao-mask ul').append(curr_dis);
            }


            $(".tip_wuhongbao").hide();
            $(".tip_youhongbao").show();
            $(".tip_wuhongbao").text("暂无可用");

            if ($('.hongbao-mask  li[couponid]:not(.dis)').length == 0) {
                $(".tip_wuhongbao").show();
                $(".tip_youhongbao").hide();

            }

            if ($('.hongbao-mask  li[couponid]:not(.dis)').length > 0 && $(".no-usehongbao").hasClass("cur")) {
                $(".tip_wuhongbao").show();
                $(".tip_wuhongbao").text("请选择");
                $(".tip_youhongbao").hide();

            }



            $('.hongbao-mask  li').unbind();
            $('.hongbao-mask  li').bind('click', function () {
                if ($(this).hasClass("dis")) {
                    return;
                }
                $(this).addClass("cur").siblings().removeClass("cur");

                var couponid = $(this).attr('couponid');
                if (couponid == undefined) {
                    couponid = 0;
                }
                $('#couponprice').attr('couponid', couponid);

                var money = 0;
                if (couponid > 0) {
                    money = couponjson['_' + couponid]['Moneys'];
                }

                $('#couponprice').text(money);
                if (money > 0) {
                    $('#couponprice').closest('.hongbao-btn').show();
                }
                calculatePrice();
                $(this).parents(".mask").fadeOut();

            });

        }




        $(document).on('click', '.lasttime-mask li[lasttime]', function () {
            var lasttime = $(this).attr('lasttime');
            $('#lasttime').text(lasttime);
            $(this).parents(".mask").fadeOut();
        });

        $(".hongbao-mask li").click(function () {

            //            var couponid = $(this).attr('couponid');
            //            $('#couponprice').attr('couponid', couponid);

            //            var money = couponjson['_' + couponid]['Moneys'];
            //            $('#couponprice').text(money);
            //            if (money > 0) {
            //                $('#couponprice').closest('.hongbao-btn').show();
            //            }
            //            calculatePrice();

            //            $(this).parents(".mask").fadeOut();
        })


        $(".select_qd").click(function () {

            if ($("#datepicker .specialdays").length != 2) {
                //   layer.msg("请选择入住离店日期");
                return false;
            }


            var tempyufull = false;

            var tempTotalPrice = 0;
            if ($($("#datepicker .specialdays")[0]).find(".full").length > 0) {

                tempyufull = true;
            }

            else {
                tempTotalPrice = parseInt($($("#datepicker .specialdays")[0]).find(".room-price-d i").text());
            }


            var tempListDate = new Array();
            tempListDate.push($($("#datepicker .specialdays")[0]).attr("title"));

            roomstock = parseInt($($("#datepicker .specialdays")[0]).find(".room-num").attr("roomstock"));

            $("#datepicker  .ui-range-selected").each(function (i, item) {

                if (roomstock > parseInt($(this).find(".room-num").attr("roomstock"))) {
                    roomstock = parseInt($(this).find(".room-num").attr("roomstock"));
                }

                if ($(this).find(".full").length > 0) {
                    tempyufull = true;
                }

                else {
                    tempTotalPrice += parseInt($(this).find(".room-price-d i").text());
                }

                var tempyear = parseInt($(this).attr("data-year"));
                var tempmonth = parseInt($(this).attr("data-month")) + 1;
                var tempday = parseInt($(this).attr("data-day"));

                tempmonth = tempmonth < 10 ? "0" + tempmonth : tempmonth;
                tempday = tempday < 10 ? "0" + tempday : tempday;

                var tempdate = tempyear + "-" + tempmonth + "-" + tempday;
                tempListDate.push(tempdate);


            });

            orderjson['price'] = tempTotalPrice;

            var tempRateList = new Array();
            for (var i = 0; i < tempListDate.length; i++) {

                $(ratelistjson).each(function (j, item) {
                    if (tempListDate[i] == this.Dates) {
                        tempRateList.push(this);
                    }
                });
            }

            orderjson['rateplan']['RateList'] = tempRateList;

            $("#indate").text($($("#datepicker .specialdays")[0]).attr("title"));
            $("#outdate").text($($("#datepicker .specialdays")[1]).attr("title"));

            orderjson['indate'] = $("#indate").text().trim();
            orderjson['outdate'] = $("#outdate").text().trim();

            if (orderjson['rateplan']['IsHourRoom'] == 1) {
                fetchlasttime();
                $('.lasttime-mask li[lasttime]:first').trigger('click');
            }


            if (tempyufull || (orderjson['ishourroom'] == "1" && parseInt($(".selectNum").text()) > 1)) {

                $("#btn_yuding").addClass("yu-bgcc");
                $("#btn_yuding").text("订完");
                $(".footer_price").css("visibility", "hidden");
                $(".total_zongprice").css("display", "none");

                orderjson['price'] = 99999;
            }

            else {
                $("#btn_yuding").removeClass("yu-bgcc");
                $("#btn_yuding").text("立即预订");
                $(".footer_price").css("visibility", "visible");
                $(".total_zongprice").css("display", "");

                if (parseInt($('#roomnum').text().trim()) > roomstock) {
                    for (var u = 0; u < (parseInt($('#roomnum').text().trim()) - roomstock); u++) {
                        $(".usernamelist").children(".adduser").last().remove();
                    }
                    $('#roomnum').text(roomstock);
                }
            }

            if ('<%=ishourroom %>' == "0") {
                $("#days").text($(".selectNum").text());
                $("#total_days").text($(".selectNum").text());
            }



            calculatePrice();

            $(".show-body").show();
            $("header").show();
            $(".data-page").hide();

            layer.closeAll();
        });


        function getdatestr(datestr) {
            var date = new Date(getDateFormate(new Date(datestr)));
            var today = new Date(getDateFormate(new Date()));
            var days = getDays(today, date);
            if (days == 0) {
                return '今天';
            }
            if (days == 1) {
                return '明天';
            }
            if (days == 2) {
                return '后天';
            }
            var weekary = { 0: '周日', 1: '周一', 2: '周二', 3: '周三', 4: '周四', 5: '周五', 6: '周六' };
            return weekary[date.getDay()];
        }

        function getDays(indate, outdate) {
            var indate = new Date(getDateFormate(new Date(indate)));
            var outdate = new Date(getDateFormate(new Date(outdate)));

            var days = parseFloat(outdate.getTime()) - parseFloat(indate.getTime());
            var d = days / (24 * 60 * 60 * 1000);
            return d;
        }

        function getDateFormate(date) {
            var todayYear = parseInt(date.getYear()) + 1900;
            var todayMonth = parseInt(date.getMonth()) + 1;
            if (todayMonth < 10) {
                todayMonth = '0' + todayMonth;
            }

            var todayDay = parseInt(date.getDate());
            if (todayDay < 10) {
                todayDay = '0' + todayDay;
            }

            return todayYear.toString() + '-' + todayMonth.toString() + '-' + todayDay.toString();
        }


 


        //保存
        $('#btn_yuding').click(function () {

            if ($('#btn_yuding').hasClass("yu-bgcc")) {

                return false;
            }


            $('#btn_yuding').prop('disabled', true);
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

                $(".alert  .tipmsg").text("请输入房间入住人");
                $(".alert").show();
                $('#btn_yuding').prop('disabled', false);

                $(".username").focus();
                return false;
            }
            var username = nameary.join('|');
            if (!isNaN(username)) {

                $(".alert  .tipmsg").text("入住人不能填写数字");
                $(".alert").show();
                $('#btn_yuding').prop('disabled', false);
                $(".username").focus();
                return false;
            }

            var phonenumber = $('.phonenumber').val().trim();
            if (!/^1\d{10}$/.test(phonenumber)) {

                $('#btn_yuding').prop('disabled', false);
                $(".alert  .tipmsg").text("请输入正确手机号");
                $(".alert").show();
                $(".phonenumber").focus();
                return false;
            }


            var needinvoice = 0;

            if ($(".fapiao .radio").hasClass("cur")) {
                needinvoice = 1;

                if ($("#fapiao_nr").val().trim() == "") {
                    $(".alert  .tipmsg").text("请输入发票抬头");
                    $(".alert").show();
                    $("#fapiao_nr").focus();
                    $('#btn_yuding').prop('disabled', false);
                    return false;
                }



                if ($("#invoicenum").val().trim() == "") {
                    $(".alert  .tipmsg").text("请输入纳税人识别号");
                    $(".alert").show();
                    $("#invoicenum").focus();
                    $('#btn_yuding').prop('disabled', false);
                    return false;
                }
            }



            //写入信息保存
            var saveinfo = {};
            var roomnum = parseInt($('#roomnum').text().trim());
            saveinfo['yroomnum'] = roomnum;
            saveinfo['username'] = username;
            saveinfo['linktel'] = phonenumber;
            saveinfo['needinvoice'] = needinvoice;
            if (needinvoice == 1) {
                saveinfo['invoicetitle'] = $("#fapiao_nr").val().trim();
                saveinfo['invoicenum'] = $("#invoicenum").val().trim();
            }
            var foregift = parseInt($('#foregift').text());
            saveinfo['foregift'] = foregift;
            var actualprice = parseInt($('.actualprice:eq(0)').text());
            saveinfo['ssumprice'] = actualprice;
            saveinfo['roomid'] = orderjson['roomid'];
            saveinfo['rateplanid'] = orderjson['rateplanid'];
            saveinfo['hotelid'] = orderjson['room']['HotelID'];
            saveinfo['roomname'] = orderjson['room']['RoomName'];
            saveinfo['hotelname'] = orderjson['hotelname'];
            saveinfo['ishourroom'] = orderjson['ishourroom'];
            var lasttime = $('#lasttime').text();
            saveinfo['yindate'] = $("#indate").text().trim();
            saveinfo['youtdate'] = $("#outdate").text().trim();
            var rateplanname = orderjson['rateplan']['RatePlanName'] + '(' + orderjson['rateplan']['ZaoCan'] + ')';
            if (orderjson['ishourroom'] == 1) {
                var hourtimeary = lasttime.toString().split('-');
                saveinfo['hourstarttime'] = hourtimeary[0];
                saveinfo['hourendtime'] = hourtimeary[1];
                rateplanname = orderjson['rateplan']['HourRoomType'] + '小时钟点房';
            } else {
                saveinfo['lasttime'] = lasttime;
            }
            saveinfo['rateplanname'] = rateplanname;
            saveinfo['weixinid'] = sys_hotelWeixinid;
            saveinfo['userWeixinid'] = sys_userWeixinid;
            var paytype = orderjson['rateplan']['PayType'];
            saveinfo['paytype'] = paytype;
            var priceAry = new Array();
            $.each(orderjson['rateplan']['RateList'], function (k, rate) {
                priceAry.push(rate['Dates'] + ':' + rate['Price']);
            });
            saveinfo['priceAry'] = priceAry.join('|');
            var memberpoints = parseInt($('.memberpoints').text());
            saveinfo['jifen'] = memberpoints;
            saveinfo['demo'] = $('#demo').val();
            saveinfo['token'] = orderjson['token'];
            saveinfo['cardno'] = orderjson['MemberCardRule']['CardNo'];
            saveinfo['memberid'] = orderjson['memberid'];

            //以下信息保存到 couponinfo 字段
            saveinfo['originalsaleprice'] = orderjson['price'] * roomnum;
            saveinfo['couponid'] = $('#couponprice').attr('couponid');
            saveinfo['couponprice'] = parseInt($('#couponprice').text());
            saveinfo['graderate'] = orderjson['MemberCardRule']['GradeRate'];
            saveinfo['gradename'] = orderjson['MemberCardRule']['GradeName'];

            saveinfo['coupontype'] = orderjson['MemberCardRule']['CouponType'];
            saveinfo['reduce'] = orderjson['MemberCardRule']['Reduce'] * parseInt($("#total_days").text());

            saveinfo['isvip'] = orderjson['rateplan']['IsVip'];

            $.ajax({
                url: '/HotelA/saveorderinfo/' + sys_hid + '?key=' + sys_key,
                type: 'post',
                data: { saveinfo: JSON.stringify(saveinfo) },
                success: function (data) {
                    var _json = $.parseJSON(data);
                    var gohref = "";
                    if (_json['success']) {

                        if (paytype == 0) {
                            gohref = '/Recharge/CardPay/' + orderjson['room']['HotelID'] + '?key=' + sys_hotelWeixinid + '@' + sys_userWeixinid + '&orderno=' + _json['orderno'];

                        } else if (paytype == 1) {
                            //现付跳转到订单列表
                            // gohref = '/UserA/MyOrders/' + orderjson['room']['HotelID'] + '?key=' + sys_hotelWeixinid + '@' + sys_userWeixinid;
                            gohref = '/UserA/OrderInfo/' + orderjson['room']['HotelID'] + '?id=' + _json['orderid'] + '&key=' + sys_hotelWeixinid + '@' + sys_userWeixinid;
                        }

                        window.location.href = gohref;

                    }
                    else {

                        $(".alert  .tipmsg").text(_json['message']);
                        $(".alert").show();

                        $('#btn_yuding').prop('disabled', false);
                    }
                }
            });
        });






        function comparedate(_firstdate, _seconddate) {
            var firstdate = new Date(_firstdate);
            var seconddate = new Date(_seconddate);
            if (firstdate.getYear() == seconddate.getYear() && firstdate.getMonth() == seconddate.getMonth() && firstdate.getDate() == seconddate.getDate()) {
                return true;
            }
            return false;
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

    </script>
</body>
</html>
