<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    var products = ViewData["products"] as WeiXin.Models.Home.SaleProduct;

    ViewData["productName"] = products.ProductName;


    List<string> tabList = new List<string>();
    List<string> tabSysList = "周末通用,超长有效期,官网独家,爆款返场".Split(',').ToList();
    if (!string.IsNullOrEmpty(products.Tab))
    {
        tabList = products.Tab.Split(',').ToList();
    }


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
    <title>
        <%=ViewData["productName"]  %></title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/jquery-ui.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.0" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css?v=1.5" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["cssUrl"] %>/css/booklist/jquery-ui.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <style>
        .room-price-d
        {
            top: .65rem;
            font-size: .22rem;
            color: #666;
        }
        .ui-datepicker-current-day .room-price-d
        {
            color: #fff;
        }
        .ui-datepicker td span, .ui-datepicker td a
        {
            line-height: 1.08rem;
            font-size: .24rem;
            color: #666 !important;
        }
        .ui-datepicker-current-day .ui-state-active
        {
            color: #fff !important;
        }
        .room-num
        {
            position: absolute;
            top: .03rem;
            font: .24rem "microsoft yahei" ,simhei;
            color: #f40;
        }
        .ui-datepicker-today .room-num
        {
            color: #f40;
        }
        .ui-datepicker-current-day .room-num
        {
            color: #fff;
        }
    </style>
</head>
<body>
    <article class="full-page">

    <%string bodyclass = ""; %>
    

           <%

               //微信分享
               string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
               string openid = userWeiXinID;
               string hotelWeixinid = weixinID;
               string newkey = string.Format("{0}@{1}", hotelWeixinid, openid);

               if (!openid.Contains(wkn_shareopenid))
               {
                   //非二次分享 获取推广员信息
                   var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(hotelWeixinid, openid);
                   ///原链接已经是分享过的链接
                   newkey = string.Format("{0}@{1}_{2}", hotelWeixinid, wkn_shareopenid, CurUser.memberid);
               }

               string[] desnArry = products.FeeInclude.Replace("\n", "|").Split('|');
               string desn = products.FeeInclude.Replace("\n", "");
               if (desnArry != null && desnArry.Length > 0)
               {
                   desn = desnArry[0];
               }
               string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}&ProductId={2}", Request.Url.LocalPath, newkey, Request.QueryString["ProductId"]);
               hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
               {
                   title = products.ProductName + "(分享)",
                   desn = desn,
                   logo = products.MainPic,
                   debug = false,
                   userweixinid = openid,
                   weixinid = hotelWeixinid,
                   hotelid = int.Parse(hotelid),
                   sharelink = sharelink
               };
               viewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
    %>

     <%Html.RenderPartial("HeaderA", viewDic); %>
 
     	<section class="show-body <%=bodyclass %>">
			<section class="content2  yu-bpad180r <%=bodyclass %>">
				<div class="yu-bgw yu-bmar20r">
					<div class="th-text-bar2" style="display:none">
						会员福利：<br />
						分享该产品，当您的朋友成功<span class="yu-fc0">购买</span>，您将获得<span class="yu-fc0">9元</span>现金奖励。次日微信红包发送。
					</div>
					<div class="yu-tbpad20r yu-lrpad20r yu-f38r">
					 <%=products.ProductName %>
					</div>
					<div class="yu-grid  yu-lrpad20r yu-bgw yu-bmar15r yu-flex-w-w" >
 

                     <%if (tabList.Contains("周末通用"))
                       {%>
						<div class="th-mark2 type1">周末通用</div>
                        <%} %>
                           <%if (tabList.Contains("超长有效期"))
                             {%>
						<div class="th-mark2 type2"   >超长有效期</div>
                        <%} %>
                          <%if (tabList.Contains("官网独家"))
                            {%>
						<div class="th-mark2 type3"   >官网独家</div>
                        <%} %>
                             <%if (tabList.Contains("爆款返场"))
                               {%>
						<div class="th-mark2 type4" >爆款返场</div>
                        <%} %>
                        <% tabList = tabList.Except(tabSysList).ToList(); %>
                            <% for (int i = 0; i < tabList.Count; i++)
                               { %>
                               	<div class="th-mark2 type1"><%=tabList[i]%></div>
                              <%} %>
					</div>
								<p class="yu-f24r yu-c57 yu-lpad20r yu-bmar15r"><%= ViewData["hotelname"] %>直销</p>
					<div class="show-header">
						<div class="inner yu-h360r">
                        <%string show_Pic = !string.IsNullOrEmpty(products.BigMainPic) ? products.BigMainPic : products.MainPic; %>
       	<img src="<%=show_Pic%>" /> 
											
											<div class="txt-bar yu-grid yu-alignc">
												<p class="yu-overflow yu-f30r yu-textr yu-rpad20r">有效期至 <%=products.EndTime.ToString("yyyy-MM-dd HH:mm:ss") %></p>
											</div>
										</div>
					</div>
				</div>
				<div class="yu-bgw yu-bmar20r">
					<p class="yu-h100r yu-lpad20r yu-bor bbor yu-l100r yu-f30r ">套餐详情</p>  
					<ol class="yu-rpad20r yu-f26r yu-c66 yu-lpad50r yu-tb40r">               

               <%=products.FeeInclude.Replace("\n","<br/>") %>						
					</ol>
				</div>
				<div class="yu-bgw yu-bmar20r">
					<p class="yu-h100r yu-lpad20r yu-bor bbor yu-l100r yu-f30r ">产品图片</p>
					<ul class="cp-pic-list">                
                 
                    <%string imagList = !string.IsNullOrEmpty(products.BigImageList) ? products.BigImageList : products.ImageList;   %>               
                    
                    <%for (int i = 0; i < imagList.Split(',').Length; i++)
                      {    %>
                          <li class="yu-bmar20r">
							<div class="show-header">
								<div class="inner yu-h360r">
							<img src="<%=imagList.Split(',')[i] %>">
			                   </div>
							</div>
						</li>
                          
                      <%} %>

					 
					</ul>
				</div>
                <% if (imagList.Split(',').Length > 3)
                   { %>
				<a href="javascript:;" class="watch-more-pic yu-bmar40r">查看更多图片</a>
                <%} %>
				<div class="yu-bgw yu-bmar20r">
					<p class="yu-h100r yu-lpad20r yu-bor bbor yu-l100r yu-f30r ">购买须知</p>

                    					<dl class="yu-f26r yu-lrpad20r yu-c66  yu-tb40r">

                                        <% if (products.ProductType == 0)
                                           { %>
						<dt class="yu-c40  yu-fontb yu-bmar10">有效期</dt>
						<dd class="yu-bmar10">
							<p class="l-style-p yu-lmar30r"><%=products.EffectiveBeginTime.ToString("yyyy-MM-dd") %>至 <%=products.EffectiveEndTime.ToString("yyyy-MM-dd") %></p>
						</dd> 

                        <%} %>
						<dt class="yu-c40 yu-fontb yu-bmar10">使用规则</dt>
						<dd class="yu-bmar10">
							 <%=products.RefundInfo.Replace("\n", "<br/>")%>
						</dd>
						<dt class="yu-c40 yu-fontb yu-bmar10">温馨提示</dt>
						<dd class="yu-bmar10">
				    <%=products.OrderInfo.Replace("\n", "<br/>")%>  
                    <br />
                   费用不包含： <%=products.FeeExclude.Replace("\n", "<br/>")%> 
						</dd>
					</dl>

               
          
				</div>
				<div class="yu-bgw yu-bmar20r">
					<p class="yu-h100r yu-lpad20r yu-bor bbor yu-l100r yu-f30r ">联系我们</p>
					<div class="yu-tb40r yu-grid yu-lrpad20r yu-bor bbor">
						<div class="yu-overflow yu-bor rbor yu-rpad45r">
						 <p class="yu-f28r  yu-bmar10r"><%= ViewData["hotelname"] %></p>
							<p class="yu-c66 yu-f26r yu-bmar10r">电话：<span><%=   ViewData["tel"]  %></span></p>
							<div class="yu-grid yu-c66 yu-f26r">
								<p class="l-ico2"></p>
								<p class="yu-overflow"><%=   ViewData["address"]%></p>
							</div>
						</div>
						<div class="yu-w155r">
							<a class="phone-ico3" href="tel:<%=ViewData["tel"]  %>"></a>
						</div>
					</div>
							<div class="yu-grid yu-tb40r yu-lrpad20r">
						<div class="ewm yu-lmar20r yu-rmar28r">
							<img src="<%=ViewData["WeiXin2Img"] %>" />
						</div>
							<div class="yu-overflow">
							<div class="yu-grid yu-alignc yu-bmar25r">
								<p class="p-pic yu-rmar28r"></p>
								<p class="yu-f36r yu-c66">长按识别二维码</p>
							</div>
							<dl class="yu-f26r">
								<dt class="yu-c40">关注酒店官方公众号：</dt>
								<dd class="yu-c99">可查看已购抢购券、提前进行预定，获取最新会员优惠。</dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="yu-bgw yu-bmar20r" style=" display:none">
					<p class="yu-h100r yu-lpad20r yu-bor bbor yu-l100r yu-f30r ">联系我们</p>
					<ul class="yu-lpad20r">
						<li class="yu-bor bbor yu-tbpad35r yu-rpad20r">
							<p class="yu-f24r yu-c66 yu-bmar10r">
								<span class="yu-rmar20r">2022独角星空 </span>
								<span>2017-03-05</span>
							</p>
							<p class="yu-f26r">这个套餐还挺划算的，都买了3套住6天了</p>
						</li>
						<li class="yu-bor bbor yu-tbpad35r yu-rpad20r">
							<p class="yu-f24r yu-c66 yu-bmar10r">
								<span class="yu-rmar20r">2022独角星空 </span>
								<span>2017-03-05</span>
							</p>
							<p class="yu-f26r">这个套餐还挺划算的，都买了3套住6天了</p>
						</li>
						<li class="yu-bor bbor yu-tbpad35r yu-rpad20r">
							<p class="yu-f24r yu-c66 yu-bmar10r">
								<span class="yu-rmar20r">2022独角星空 </span>
								<span>2017-03-05</span>
							</p>
							<p class="yu-f26r">这个套餐还挺划算的，都买了3套住6天了</p>
						</li>
					</ul>
				</div>
			</section>

 

			<!--三种状态的底栏-->
			<section class="fix-bottom2 fix_1" style="display:<%= (DateTime.Now >=products.BeginTime && DateTime.Now<= products.EndTime) ? "block" : "none"  %>">
				<div class="lasttime-bar">
					抢购还有<span class="t_d"></span>天<span class="t_h"></span>小时<span class="t_m"></span>分<span class="t_s"></span>秒结束
				</div>
				<div class="yu-h120r yu-bgw yu-grid yu-alignc yu-bor tbor yu-lpad20r box-s1">
					<div class="yu-overflow">
						<p class="yu-f34r">门市价：<span class="yu-f26r yu-linethrough">￥</span><span class="yu-linethrough"><%=Convert.ToDouble(  products.MenPrice)%></span></p>
						<p class="yu-c40 yu-f24r yu-lmar40r"></p>
					</div>

					<a class="yu-btn5 yu-rmar10r nowgo" href="#">￥<%=ViewData["minPrice"]%>立即抢购</a>
				</div>
			</section>
			<section class="fix-bottom2 fix_2" style="display:<%= DateTime.Now < products.BeginTime ? "block" : "none"  %>">
				<div class="lasttime-bar">
					还有<span class="t_d"></span>天<span class="t_h"></span>小时<span class="t_m"></span>分<span class="t_s"></span>秒开始抢购
				</div>
				<div class="yu-h120r yu-bgw yu-grid yu-alignc yu-bor tbor yu-lpad20r box-s1">
					<div class="yu-overflow">
						<p class="yu-f34r">门市价：<span class="yu-f26r yu-linethrough">￥</span><span class="yu-linethrough"><%=Convert.ToDouble(  products.MenPrice)%> </span></p>
					</div>

					<a class="yu-btn5 yu-rmar10r sp" href="#">￥<%=ViewData["minPrice"]%> 即将开始</a>
				</div>
			</section>

         
			<section class="fix-bottom2 fix_3" style="display:<%= DateTime.Now >products.EndTime ? "block" : "none"  %>">
				<div class="yu-h120r yu-bgw yu-grid yu-alignc yu-bor tbor yu-lpad20r box-s1">
					<div class="yu-overflow">
						<p class="yu-f34r">门市价：<span class="yu-f26r yu-linethrough">￥</span><span class="yu-linethrough"><%=Convert.ToDouble(products.MenPrice)%></span></p>
					</div>

					<a class="yu-btn5 yu-rmar10r sp" href="#">已售罄</a>
				</div>
			</section>
			<!--三种状态的底栏end-->
		</section>
		<section class="mask tc-mask">
			<div class="mask-bottom-inner yu-bgw">
				<div class="yu-lrpad20r yu-bor bbor yu-bpad50r yu-grid ">
					<div class="full-img1 yu-bor1 bor yu-rmar10r">                           
                     <img src="<%=show_Pic %>" />                      
					</div> 

				<div class="yu-w390r yu-tpad25r yu-pos-r">
						<p class="yu-f28r">     <%=products.ProductName %></p>
						<p class="yu-c40 yu-f24r tc-price">￥
                        <span class="yu-f36r"  id="select_price" >
                         <% if (products.ProductType == 0 && products.List_SaleProducts_TC != null && products.List_SaleProducts_TC.Count > 0)
                            { %>
                             <%= Convert.ToDouble(products.List_SaleProducts_TC[0].ProductPrice)%>
                            <%} %>

                            <%else
                            { %>
                            <%=ViewData["minPrice"]%>
                        
                        <%} %>
                        </span>
                        </p>
                                                

                        <input type="hidden" id="select_date" value="<%=products.ProductType==0 ?  DateTime.Now.ToString("yyyy-MM-dd") : "" %>"  />
                            <input type="hidden" id="select_tcId"  value="0"  />
					</div>
					<div class="close-ico mask-close"></div>
				</div>
				<div class="p-and-d">
					<div class="yu-lrpad20r yu-bpad20r yu-bor bbor yu-tpad40r">
						<p class="yu-f30r yu-bmar40r">套餐类型</p>
						<ul class="select-li tc-list tc_ul">
                            <% int stock = 1; %>
                           <%  if (products.List_SaleProducts_TC != null)
                               {
                                   for (int i = 0; i < products.List_SaleProducts_TC.Count; i++)
                                   {
                                       if (products.ProductType == 0 && i == 0)
                                       {
                                           stock = products.List_SaleProducts_TC[i].ProductNum;

                                       }   %>  
                    
                 	<li class="<%=i==0 ? "cur" : "" %>">  <%=products.List_SaleProducts_TC[i].TcName%></li>
                 <% }
                               } %>
							 
						</ul>
					</div>
					<div class="yu-bpad20r yu-bor bbor yu-tpad40r" id="div_starttime">
						<p class="yu-f30r yu-bmar40r yu-lrpad20r ">出发日期</p>
						<div>
							<div id="datepicker"></div>
						</div>
					</div>
				</div>
				<div class="yu-h20r yu-bgf4"></div>
				<div class="yu-h120r yu-grid yu-alignc yu-lrpad20r">
					<p class="yu-overflow yu-f28r">购买数量</p>
					<div class="yu-f24r yu-c99 yu-rmar15r">剩余:<span id="stock" ><%=stock %></span></div>                   
                  
					<div class="ar yu-grid">
						<p class="reduce ico type3">-</p>
						<p class="food-num type3">1</p>
						<p class="add ico type3">+</p>
					</div>
				</div>
				<div class="yu-h120r yu-l120r yu-textc yu-f36r yu-white yu-sub3 buy-go">确定</div>
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
    </article>
    <script>
        $("#datepicker").datepicker({
            dateFormat: 'yy-mm-dd',
            dayNamesMin: ["日", "一", "二", "三", "四", "五", "六"],
            monthNames: ["1月", "2月", "3月", "4月", "5月", "6月",
         "7月", "8月", "9月", "10月", "11月", "12月"],
            yearSuffix: '年',
            showMonthAfterYear: true,
            minDate: new Date(),
            numberOfMonths: 1,
            maxDate: "+2m",
            showButtonPanel: false,
            onSelect: function (date, me) {
                //  $(".select_date").text(date);

                var selectDay = $("td[data-handler='selectDay'][data-year=" + me.selectedYear + "][data-month=" + me.selectedMonth + "][data-day=" + me.selectedDay + "]");
                $("#stock").text($(selectDay).find(".room-num").text().replace("件", ""));

                $("#select_price").text($(selectDay).find(".room-price-d  i").text());
                $("#select_date").val(date);
                $("#select_tcId").val(arr_Tc[$(".tc_ul").find(".cur").index()].Id);
                $(".yu-sub3").addClass("cur");
            }

        });

        var jsonTc = '<%=products.Json_SaleProducts_TC %>';
        var arr_Tc = new Array();
        var producttype = parseInt('<%=products.ProductType %>');

        $(function () {

            if (jsonTc != "") {
                for (var i = 0; i < $.parseJSON(jsonTc).length; i++) {
                    arr_Tc.push($.parseJSON(jsonTc)[i]);
                }
            }


            if (producttype == 1) {
                BindData();
            }

            else {

                $("#datepicker").css("display", "none");
                $("#div_starttime").css("display", "none");
                $(".p-and-d").addClass("sp");
                $(".yu-sub3").addClass("cur");
            }


            //选项卡
            var tabIndex;
            $(".tab-nav").children("li").on("click", function () {
                $(this).addClass("cur").siblings("li").removeClass("cur");
                tabIndex = $(this).index();
                $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
            })
            //套餐选择
            $(".select-li").children("li").on("click", function () {
                if (!$(this).hasClass("dis")) {

                    $(this).addClass("cur").siblings().removeClass("cur");

                    if (producttype == 1) {
                        BindData();
                    }

                    else {
                        $("#select_price").text(arr_Tc[$(this).index()].ProductPrice);
                        $("#stock").text(arr_Tc[$(this).index()].ProductNum);
                    }

                    //    	                if ($(".select-li").children("li").hasClass("cur")) {
                    //    	                    $(".yu-sub3").addClass("cur");
                    //    	                } else {
                    //    	                    $(".yu-sub3").removeClass("cur");
                    //    	                }
                }
            })
            //加减餐
            var foodNum = 0;
            $(".add").on("click", function () {

                //                $(this).siblings(".food-num").text(1);
                //                return false;


                if ($(this).siblings(".food-num").text() == "") {
                    foodNum = 1;
                    $(this).siblings(".food-num").text(foodNum);
                } else {
                    foodNum = parseInt($(this).siblings(".food-num").text());

                    if ((foodNum + 1) > parseInt($("#stock").text())) {
                        return false;
                    }

                    foodNum++;
                    $(this).siblings(".food-num").text(foodNum);

                };
            });

            $(".reduce").on("click", function () {
                foodNum = parseInt($(this).siblings(".food-num").text());
                if (foodNum > 1) {
                    foodNum--;
                    $(this).siblings(".food-num").text(foodNum);
                };
            });
            //mask
            $(".mask-close,.mask").click(function () {
                $(".mask").fadeOut();
            })
            $(".mask-bottom-inner").on("click", function (e) {
                e.stopPropagation();
            })
            $(".yu-btn5").click(function () {

                if ($(this).hasClass("nowgo")) {
                    $(".tc-mask").fadeIn();
                    $(".mask-bottom-inner").addClass("shin-slide-up");
                }
            })

            var watchNum = 0;
            $(".watch-more-pic").click(function () {
                $(".cp-pic-list").toggleClass("cur");
                if (watchNum == 0) {
                    $(".watch-more-pic").text("收起");
                    watchNum = 1;
                } else {
                    $(".watch-more-pic").text("查看更多图片");
                    watchNum = 0;

                }
            })
            //倒计时
            function GetRTime() {
                var EndTime = new Date();
                var NowTime = new Date();

                if (!$(".fix_1").is(':hidden')) {

                    EndTime = new Date('<%=products.EndTime %>');
                    NowTime = new Date();

                }

                else if (!$(".fix_2").is(':hidden')) {

                    EndTime = new Date('<%=products.BeginTime %>');
                    NowTime = new Date();

                }

                else if (!$(".fix_3").is(':hidden')) {

                }

                var t = EndTime.getTime() - NowTime.getTime();
                var d = 0;
                var h = 0;
                var m = 0;
                var s = 0;
                if (t >= 0) {
                    d = Math.floor(t / 1000 / 60 / 60 / 24);
                    h = Math.floor(t / 1000 / 60 / 60 % 24);
                    m = Math.floor(t / 1000 / 60 % 60);
                    s = Math.floor(t / 1000 % 60);
                }
                $(".t_d").text(d);
                $(".t_h").text(h);
                $(".t_m").text(m);
                $(".t_s").text(s);

            }
            setInterval(GetRTime, 0);
        })




        $(".buy-go").click(function () {

            if (!$(".buy-go").hasClass("cur")) {

                return false;
            }

            if (parseInt($(".food-num").text()) > parseInt($("#stock").text())) {

                //                $(".alert  .tipmsg").text("不能大于库存");
                //                $(".alert").show();
                layer.msg("不能大于库存");
                return false;
            }

            var tcId = arr_Tc[$(".tc_ul").find(".cur").index()].Id;
            if (producttype == 1) {
                tcId = $("#select_tcId").val();
            }

            window.location.href = '/ProductA/ProductConfirmOrder/<%=hotelid%>?key=<%=weixinID%>@<%=userWeiXinID%>&ProductId=<%=Request.QueryString["ProductId"]%>&tcId=' + tcId + '&buyAmount=' + $(".food-num").text() + '&stock=' + $("#stock").text().trim() + '&date=' + $("#select_date").val().trim();


        });



        function BindData() {

            $("td[data-handler='selectDay']").find(".room-price-d em").text("");
            $("td[data-handler='selectDay']").find(".room-price-d i").text("");
            $("td[data-handler='selectDay']").find(".room-num").text("");
            $("td[data-handler='selectDay']").addClass("ui-state-disabled");

            var indextc = $(".select-li li.cur").index();

            if (indextc < 0) {
                return;
            }

            var curr_Day = $("td[data-handler='selectDay']");

            var curr_saleProduct = arr_Tc[indextc].List_SaleProducts_TC_Price;

            if (curr_saleProduct == null) {

                return;
            }


            $(curr_saleProduct).each(function (i, item) {
                var date = item.SaleTime;
                var selectDay = $("td[data-handler='selectDay'][data-year=" + date.split('-')[0] + "][data-month=" + (date.split('-')[1] - 1) + "][data-day=" + date.split('-')[2] + "]");

                if ($(selectDay).length > 0) {

                    $(selectDay).removeClass("ui-state-disabled");
                    $(selectDay).find(".room-price-d em").text("￥");
                    $(selectDay).find(".room-price-d i").text(item.Price);
                    $(selectDay).find(".room-num").text(item.Stock + "件");
                }


            });

        }
    </script>
</body>
</html>
