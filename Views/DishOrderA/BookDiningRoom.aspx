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
    <meta name="keywords" content="关键词1, 关键词2,关键词3" />
    <meta name="description" content="对网站的描述" />
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <title>餐厅订位</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/jquery-ui.css"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"]%>/css/booklist/sale-date.css"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css"/>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js?v=1.1"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/css/booklist/jquery-ui.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js?v=1.1"></script>
    
    <style>
	    .room-price-d{
		    display: none;
	    }
	    .ui-datepicker td span, .ui-datepicker td a{
		    line-height: 1.08rem;
	}
	.room-num{
		display: none;
	}
</style>
</head>
<body >
	<article class="full-page">
		<%Html.RenderPartial("HeaderA", viewDic) ;%>

        <% hotel3g.Models.StoresView room = (hotel3g.Models.StoresView)ViewData["room"]; %>
		<section class="show-body">
			<section class="content2 yu-bpad60">
				<div class="show-header">
					<div class="inner yu-h360r">
						<img src="<%=room.Logoimg %>">
					</div>
					<div class="yu-bgf3 yu-h100r yu-grid yu-alignc yu-bor bbor yu-lrpad10 ">
						<p class="yu-overflow yu-f30r"><%=room.StoreName %></p>
					</div>
					<div class="yu-bgw yu-lrpad20r yu-tbpad50r yu-f26r yu-l40r yu-bmar20r">
						<div class="yu-bmar20r"><%=room.StoreDesc%></div>
						<ul>
							<li><%=string.IsNullOrEmpty(room.Foods) ? "" : "美食： " + room.Foods%></li>
							<li><%=string.IsNullOrEmpty(room.StorePhone) ? "" : "电话： " + room.StorePhone%></li>
							<li>
                             <%   string[] strbegin = (room.BusinessBeginTime + "").Split('|');
                                    string b1=strbegin.Length > 0 ? strbegin[0] : "";
                                    string b2 = strbegin.Length > 1 ? strbegin[1] : "";
                                    string b3 = strbegin.Length > 2 ? strbegin[2] : "";

                                    string[] strend = (room.BusinessEndTime + "").Split('|');
                                    string e1 = strend.Length > 0 ? strend[0] : "";
                                    string e2 = strend.Length > 1 ? strend[1] : "";
                                    string e3 = strend.Length > 2 ? strend[2] : "";
                               %>
                               营业时间:<%=(b1 != "" || e1 != "") ? string.Format("{0}-{1}", b1, e1) : ""%>
                               <%=(b2 != "" || e2 != "")?string.Format("{0}-{1}",b2,e2):"" %>
                               <%=(b3 != "" || e3 != "")?string.Format("{0}-{1}",b3,e3):"" %>
                            </li>
							<li><%=string.IsNullOrEmpty(room.Require) ? "" : "餐厅要求： " + room.Require%></li>
						</ul>
					</div>
					<form>
					<div class="yu-bgw yu-bor tbor yu-lpad20r">
						<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
							<div class="l-ico type12 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">用餐人数</p>
							<p class="yu-overflow yu-f30r yu-c99"></p>
							<div class="ar yu-grid">
									<p class="reduce ico type2" style="display:block"></p>
									<p class="food-num" id="use_number" style="display:block">1</p>
									<p class="add ico type2"></p>
							</div>
						</div>
						<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 yu-arr data-select">
							<div class="l-ico type2 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">用餐日期</p>
							<div class="yu-overflow yu-f30r selectdata"><%=DateTime.Now.ToString("yyyy-MM-dd") %></div>
						</div>
						<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10 yu-arr timeselect">
							<div class="l-ico type15 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">到达时间</p>
							<div class="yu-overflow yu-f30r selecttime"></div>
						</div>
						<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
							<div class="l-ico type5 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">联系人</p>
							<div class="yu-overflow"><input type="text" id="lianxiren" class="yu-input2" placeholder="请输入姓名"></div>
							<div class="yu-grid sex-select yu-alignc yu-f30r">
                                <input type="hidden" id="hid_sex" value="-1" />
								<label class="yu-rmar45r" onclick="$(this).addClass('cur').siblings().removeClass('cur');$('#hid_sex').val(1);">
									<span>先生</span><span class="ico"></span>
								</label>
								<label onclick="$(this).addClass('cur').siblings().removeClass('cur');$('#hid_sex').val(2);">
									<span>女士</span><span class="ico"></span>
								</label>
							</div>
						</div>
						<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
							<div class="l-ico type6 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">手机号</p>
							<div class="yu-overflow"><input type="number" id="lianxidianhua" class="yu-input2" maxlength="11" placeholder="请输入订餐人手机号码" /></div>
						</div>
						<%--<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
							<div class="l-ico type14 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">邮件地址</p>
							<div class="yu-overflow"><input type="text" class="yu-input2" placeholder="请输入邮箱地址"></div>
						</div>--%>
						<div class="yu-h50 yu-bor bbor yu-grid yu-alignc yu-rpad10">
							<div class="l-ico type7 yu-rmar10"></div>
							<p class="yu-w60 yu-f30r">备注</p>
							<div class="yu-overflow"><input type="text" id="beizhu" class="yu-input2" placeholder="请输入其它要求"/></div>
						</div>
					</div>
					<div class="yu-pad20r" id="div-btn">
						<input type="button" value="立即预订" class="yu-btn3" onclick="javascript:Booking();"/>
					</div>
					</form>
				</div>
			</section>
		</section>
        <!--弹窗-->
	    <section class="mask alert">
		    <div class="inner yu-w480r">
			    <div class="yu-bgw">
				    <p class="yu-lrpad40r yu-tbpad50r yu-textc yu-bor bbor yu-f30r" id="tishi_msg">提示信息</p>
				    <div class="yu-h80r yu-l80r yu-textc yu-c40 yu-f36r yu-grid">
					    <p class="yu-overflow mask-close" id="tishi_close">好的，知道了</p>
				    </div>
			    </div>
		    </div>
	    </section>
		<!--红包-->
	<%--<section class="mask hongbao-mask">
		<div class="mask-bottom-inner yu-bgw">
			<p class="yu-h60 yu-line60 yu-textc yu-bor bbor">红包</p>
			<ul class="yu-lrpad10 yu-c99 hongbao-select">
				<li class="yu-h60 yu-grid yu-alignc yu-bor bbor cur">
					<p class="yu-overflow">不使用红包</p>
					<p class="copy-radio"></p>
				</li>
				<li class="yu-h60 yu-grid yu-alignc yu-bor bbor">
					<p class="yu-rmar10"><i class="yu-font12">￥</i><i class="yu-font26">10</i></p>
					<div class="yu-overflow yu-font12">
						<p>0元起用</p>
						<p>有效期2017.01.01-2017.01.15</p>
					</div>
					<p class="copy-radio"></p>
				</li>
				<li class="yu-h60 yu-grid yu-alignc yu-bor bbor">
					<p class="yu-rmar10"><i class="yu-font12">￥</i><i class="yu-font26">30</i></p>
					<div class="yu-overflow yu-font12">
						<p>0元起用</p>
						<p>有效期2017.01.01-2017.01.15</p>
					</div>
					<p class="copy-radio"></p>
				</li>
				<li class="yu-h60 yu-grid yu-alignc yu-bor bbor">
					<p class="yu-rmar10"><i class="yu-font12">￥</i><i class="yu-font26">50</i></p>
					<div class="yu-overflow yu-font12">
						<p>0元起用</p>
						<p>有效期2017.01.01-2017.01.15</p>
					</div>
					<p class="copy-radio"></p>
				</li>
			</ul>
			<div class="yu-h60 yu-bg40 yu-white yu-line60 yu-textc mask-close">关闭</div>
		</div>
	</section>--%>

    <!--日历-->
	<section class="data-page">
			<div id="datepicker"></div>
			<div class="fix-bottom yu-bor tbor yu-grid yu-alignc yu-lrpad10 yu-h34r"  style="display:none">
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
	<!--时间--> 
    <% var dd = DateTime.Now.Hour; %>
    <style> .cur119{display:none;}</style>
	<section class="mask lasttime-mask">
		<div class="mask-bottom-inner yu-bgw">
			<p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">预计到达时间</p>
			<ul class="yu-lrpad10 yu-c99 hongbao-select" id="ul-time">
                <li class="yu-h120r yu-grid yu-alignc yu-bor bbor <%=dd < 8?"":"cur119" %>" id="li8">
					<div class="yu-overflow yu-f30r timelist">6:00-8:00</div>
					<p class="copy-radio"></p>
				</li>
				<li class="yu-h120r yu-grid yu-alignc yu-bor bbor <%=dd < 10?"":"cur119" %>" id="li10">
					<div class="yu-overflow yu-f30r timelist">8:00-10:00</div>
					<p class="copy-radio"></p>
				</li>
				<li class="yu-h120r yu-grid yu-alignc yu-bor bbor <%=dd < 12?"":"cur119" %>" id="li12">
					<div class="yu-overflow yu-f30r timelist">10:00-12:00</div>
					<p class="copy-radio"></p>
				</li>
                <li class="yu-h120r yu-grid yu-alignc yu-bor bbor <%=dd < 14?"":"cur119" %>" id="li14">
					<div class="yu-overflow yu-f30r timelist">12:00-14:00</div>
					<p class="copy-radio"></p>
				</li>
                <li class="yu-h120r yu-grid yu-alignc yu-bor bbor <%=dd < 16?"":"cur119" %>" id="li16">
					<div class="yu-overflow yu-f30r timelist">14:00-16:00</div>
					<p class="copy-radio"></p>
				</li>
                <li class="yu-h120r yu-grid yu-alignc yu-bor bbor <%=dd < 18?"":"cur119" %>" id="li18">
					<div class="yu-overflow yu-f30r timelist">16:00-18:00</div>
					<p class="copy-radio"></p>
				</li>
                <li class="yu-h120r yu-grid yu-alignc yu-bor bbor <%=dd < 20?"":"cur119" %>" id="li20">
					<div class="yu-overflow yu-f30r timelist">18:00-20:00</div>
					<p class="copy-radio"></p>
				</li>
                <li class="yu-h120r yu-grid yu-alignc yu-bor bbor <%=dd < 22?"":"cur119" %>" id="li22">
					<div class="yu-overflow yu-f30r timelist">20:00-22:00</div>
					<p class="copy-radio"></p>
				</li>
                <li class="yu-h120r yu-grid yu-alignc yu-bor bbor <%=dd < 24?"":"cur119" %>" id="li24">
					<div class="yu-overflow yu-f30r timelist">22:00-24:00</div>
					<p class="copy-radio"></p>
				</li>
			</ul>
			<div class="yu-l100r yu-h100r yu-bg40 yu-white  yu-textc mask-close yu-font32r" style="display:none">关闭</div>
		</div>
	</section>

	</article>

	<script>
    var speciald=new Array(); 
	var selectdata;
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
           maxDate: '<%=DateTime.Now.AddYears(1).ToString("yyyy-MM-dd") %>',
           numberOfMonths:2,
           showButtonPanel:false,
           onSelect:function(data, me){
				selectdata=data;
                $(".show-body").show();
			    $("header").show();
			    $(".data-page").hide();
			    $(".selectdata").text(selectdata);
                //选择新日期，清空时间
                $('.selecttime').text('');
                var now='<%=DateTime.Now.ToString("yyyy-MM-dd") %>';
                if(now==selectdata){
                   var hour = '<%=DateTime.Now.Hour %>';
                   if(hour<8){$("#li8").removeClass("cur119");}
                   if(hour>=8 && hour<10){$("#li8").addClass("cur119");$("#li10").removeClass("cur119");}
                   if(hour>=10 && hour<12){$("#li8,#li10").addClass("cur119");$("#li12").removeClass("cur119");}
                   if(hour>=12 && hour<14){$("#li8,#li10,#li12").addClass("cur119");$("#li14").removeClass("cur119");}
                   if(hour>=14 && hour<16){$("#li8,#li10,#li12,#li14").addClass("cur119");$("#li16").removeClass("cur119");}
                   if(hour>=16 && hour<18){$("#li8,#li10,#li12,#li14,#li16").addClass("cur119");$("#li18").removeClass("cur119");}
                   if(hour>=18 && hour<20){$("#li8,#li10,#li12,#li14,#li16,#li18").addClass("cur119");$("#li20").removeClass("cur119");}
                   if(hour>=20 && hour<22){$("#li8,#li10,#li12,#li14,#li16,#li18,#li20").addClass("cur119");$("#li22").removeClass("cur119");}
                   if(hour>=22 && hour<24){$("#li8,#li10,#li12,#li14,#li16,#li18,#li20,#li22").addClass("cur119");$("#li24").removeClass("cur119");}
                }else{
                   $("#ul-time>li").removeClass("cur119");
                }
           },
           
        });
        
//        //选择日期
//         $(".data-btn.sub").click(function(){
//         	$(".show-body").show();
//			$("header").show();
//			$(".data-page").hide();
//			$(".selectdata").text(selectdata);
//            
//            //选择新日期，清空时间
//            $('.selecttime').text('');
//            var now='<%=DateTime.Now.ToString("yyyy-MM-dd") %>';
//            if(now==selectdata){
//               var hour = '<%=DateTime.Now.Hour %>';
//               if(hour<8){$("#li8").removeClass("cur119");}
//               if(hour>=8 && hour<10){$("#li8").addClass("cur119");$("#li10").removeClass("cur119");}
//               if(hour>=10 && hour<12){$("#li8,#li10").addClass("cur119");$("#li12").removeClass("cur119");}
//               if(hour>=12 && hour<14){$("#li8,#li10,#li12").addClass("cur119");$("#li14").removeClass("cur119");}
//               if(hour>=14 && hour<16){$("#li8,#li10,#li12,#li14").addClass("cur119");$("#li16").removeClass("cur119");}
//               if(hour>=16 && hour<18){$("#li8,#li10,#li12,#li14,#li16").addClass("cur119");$("#li18").removeClass("cur119");}
//               if(hour>=18 && hour<20){$("#li8,#li10,#li12,#li14,#li16,#li18").addClass("cur119");$("#li20").removeClass("cur119");}
//               if(hour>=20 && hour<22){$("#li8,#li10,#li12,#li14,#li16,#li18,#li20").addClass("cur119");$("#li22").removeClass("cur119");}
//               if(hour>=22 && hour<24){$("#li8,#li10,#li12,#li14,#li16,#li18,#li20,#li22").addClass("cur119");$("#li24").removeClass("cur119");}
//            }else{
//               $("#ul-time>li").removeClass("cur119");
//            }

//         })

		$(".data-select").on("click",function(){
			$(".show-body").hide();
			$("header").hide();
			$(".data-page").show();
			
		})
		$(".data-btn.cal").click(function(){
			$(".show-body").show();
			$("header").show();
			$(".data-page").hide();
		})



	    $(function () {
	        //选项卡
	        var tabIndex;
	        $(".tab-nav").children("li").on("click", function () {
	            $(this).addClass("cur").siblings("li").removeClass("cur");
	            tabIndex = $(this).index();
	            $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
	        })

	        //加减餐
	        $(".add").on("click", function () {
	            var foodNum = 0;
	            if ($(this).siblings(".food-num").text() == "") {
	                foodNum = 1;
	                $(this).siblings(".food-num").text(foodNum);
	            } else {
	                foodNum = parseInt($(this).siblings(".food-num").text());
	                foodNum++;
	                $(this).siblings(".food-num").text(foodNum);
	            };
	        });

	        $(".reduce").on("click", function () {
	            var foodNum = parseInt($(this).siblings(".food-num").text());
	            if (foodNum > 1) {
	                foodNum--;
	                $(this).siblings(".food-num").text(foodNum);
	            };
	        });

	        
//	        时间
		var selecttime;
		$(".hongbao-select>li").on("click",function(){
			$(this).addClass("cur").siblings().removeClass("cur");
			selecttime=$(this).find(".timelist").text();
			$(".selecttime").text(selecttime);
            $(".mask").fadeOut();
		})
		$(".hongbao-btn").click(function(){
			$(".hongbao-mask").fadeIn();
			$(".mask-bottom-inner").addClass("shin-slide-up");
		})
		$(".mask-close,.mask").click(function(){
			$(".mask").fadeOut();
		})
		$(".mask-bottom-inner").on("click",function(e){
			e.stopPropagation();
		})	
		//时间
		$(".timeselect").click(function(){
			$(".lasttime-mask").fadeIn();
			$(".mask-bottom-inner").addClass("shin-slide-up");
            
		})
	    })
	</script>

    <script type="text/javascript">
        function Booking() {
            
            var lianxiren = $('#lianxiren').val();
            var lianxidianhua = $('#lianxidianhua').val();
            var sex = $('#hid_sex').val();
            var beizhu = $('#beizhu').val();
            var number = $('#use_number').text();
            var usedate = $('.selectdata').text();
            var usetime = $('.selecttime').text();

            if (usedate == "") {
                $("#tishi_msg").html("请选择日期！");
                $(".alert").fadeIn();
                return;
            }
            if (usetime == "" ) {
                $("#tishi_msg").html("请选择到达时间！");
                $(".alert").fadeIn();
                return;
            }
            if (number == "" || parseInt(number) < 1) {
                $("#tishi_msg").html("用餐人数不能为空！");
                $(".alert").fadeIn();
                return;
            }
            if (lianxiren == "") {
                $("#tishi_msg").html("请输入联系人！");
                $(".alert").fadeIn();
                $('#lianxiren').focus();
                return;
            }
            if (sex == "-1") {
                $("#tishi_msg").html("请选择先生/女士！");
                $(".alert").fadeIn();
                return;
            }
            var re = /^1\d{10}$/;
            if (!re.test(lianxidianhua)) {
                $("#tishi_msg").html("请输入正确的手机号！");
                $(".alert").fadeIn();
                $('#lianxidianhua').focus();
                return;
            }

            var param = '&roomId=<%=ViewData["roomId"] %>&lianxiren=' + lianxiren + '&lianxidianhua=' + lianxidianhua + '&sex=' + sex + '&number=' + number + '&usedate=' + usedate + '&usetime=' + usetime + '&beizhu=' + beizhu;

            var data = { roomId: '<%=ViewData["roomId"] %>', lianxiren: lianxiren, lianxidianhua: lianxidianhua,
                sex: sex, number: number, usedate: usedate, usetime: usetime, beizhu: beizhu
            };

            $.post('/DishOrderA/Booking/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>',data, function (data) {
                if (data.error == 1) {//成功
                    $('#lianxiren,#lianxidianhua').val('');
                    $("#tishi_msg").html("餐厅预订提交成功！");
                    $(".alert").fadeIn();
                } else {
                    $("#tishi_msg").html(data.message);
                    $(".alert").fadeIn();
                 }
                
            });

        }
    
    </script>
</body>
</html>
