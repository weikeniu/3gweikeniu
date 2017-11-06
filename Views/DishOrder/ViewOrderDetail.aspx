<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    bool iszbsj = (bool)ViewData["iszbsj"];
    string key = HotelCloud.Common.HCRequest.GetString("key");
    string weixinID = "";
    string userWeiXinID = "";
    if (key.Contains("@"))
    {
        string[] a = key.Split('@');
        weixinID = a[0];
        userWeiXinID = a[1];
    }
    //微信分享
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    bool isShare = false;
    if (userWeiXinID.Contains(wkn_shareopenid))
    {
        isShare = true;
    }


    int eatatstore=(int)ViewData["eatatstore"];
    // 1 旅行社版本
    int istravel = WeiXin.Common.NormalCommon.IsLXSDoMain() ? 1 : 0;
    //扫码点餐
    int tid = (int)ViewData["tablenumberid"]; //HotelCloud.Common.HCRequest.getInt("tid");
    ViewData["tid"] = tid;
 %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
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
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css"/>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/Restaurant.css"/>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/newpay.css">
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/number-bar.css">
     
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/fontSize.css"/>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/drag.js" type="text/javascript"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/js.js" type="text/javascript"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/fontSize.js"></script>
</head>
<body>
   <% 
       
       System.Data.DataTable dt_dish = (System.Data.DataTable)ViewData["dt_dish"];
       
        %>
	<section class="yu-bgw yu-bmar10">
		<a class="yu-grid yu-alignc yu-pad20">
			<p class="gps-ico"></p>&nbsp;&nbsp;
			<div>
                
                <%
                    if (tid == Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
                    {
                        string linkman = ViewData["linkman"] + "";
                        if (!string.IsNullOrEmpty(linkman))
                        {
                        %>
                       <p class="yu-black yu-bmar5">
					    <span><%=ViewData["linkman"]%></span>
					    <span><%=ViewData["linkphone"]%></span>
				        </p>
				        <p class="yu-grey yu-font12">
					        <span><%=ViewData["hotel"]%></span>
					        <span><%=ViewData["roomNo"]%></span>
				        </p>
                        <%}
                        else
                        { %>
                          <p class="yu-black yu-bmar5">
					        <span><%=ViewData["tablenumber"]%></span>
				        </p>
                <%
                    }
                    }
                    else
                    {
                        %>
                        <p class="yu-black yu-bmar5">
					        <span><%=ViewData["tablenumber"]%></span>
				        </p>
                        <%
                    }
                 %>
			</div>
		</a>
		<div class="colorBorder"></div>
	</section>
	<section class="yu-bgw yu-bmar10">
        <div class="yu-h50 yu-lrpad10 yu-grey yu-line50 yu-bor bbor yu-grid ">
			<p class="yu-rmar10"><%=ViewData["storeName"]%></p>
            <% if ((ViewData["storePhone"] + "") != "")
               { %>
			    <a class="yu-grid yu-blue2 yu-alignc" href="tel:<%=ViewData["storePhone"] %>">
					    <p class="tel-ico"></p>
					    <p><%=ViewData["storePhone"]%></p>
                    
			    </a>
            <% } %>
		</div>
        <% 
           string ordertips = ViewData["ordertips"] + "";
           if (!string.IsNullOrEmpty(ordertips))
           { %>
        <div class="yu-grid yu-alignc charge-tip yu-lrpad20r yu-f22r yu-c40">
			<span class="iconfont icon-gonggao y-f22r yu-rmar10r"></span>
			<span>提示：<%=ordertips%> <%--提示：如需在酒店大厅或茶皇厅就餐，服务费10%，茶位费另计。--%></span>
		</div>
        <% } %>
		<div class="yu-pad20 yu-bglgrey yu-bor bbor">
			<ul>
				<%
                    //遍历订单菜品
                    foreach (System.Data.DataRow row in dt_dish.Rows) 
                    {
                      %>
                      <li class="yu-grid yu-alignc yu-bmar10">
					        <div class="yu-overflow">
						        <div class="yu-grid yu-alignc">
							        <p  style="width:120px"><%=row["dishesName"]%></p>
							        <% if (!iszbsj){ %>
                                    <div class="la-lv type<%=row["Hot"]%>"></div>
                                    <%} %>
						        </div>
					        </div>
                            <% if (double.Parse(row["discount"] + "") > 0)
                               { %>
                            <p class="yu-c99 yu-f26r yu-w150r">会员<%=double.Parse(row["discount"] + "")%>折</p>
                            <% } %>
					        <p class="yu-grey yu-rmar20">X<%=row["number"]%></p>
					        <p>￥<%=row["price"]%></p>
				        </li>
                      <%
                    }
                   
                    decimal bagging = (decimal)ViewData["bagging"];
                    if (bagging > 0)
                    { 
				  %>
                  <li class="yu-grid yu-alignc yu-bmar10">
					    <div class="yu-overflow">
						    <div class="yu-grid yu-alignc">
							    <p>打包费</p>
							    <%--<div class="la-lv"></div>--%>
						    </div>
					    </div>
					    <p class="yu-grey yu-rmar20"></p>
					    <p>￥<%=bagging%></p>
				    </li>
                <% } %>
			</ul>
		</div>
		<%--<div class="yu-bor bbor yu-arr yu-h60 yu-grid yu-lrpad10 yu-alignc usehb">
				<p class="yu-black yu-rmar20">红包</p>
				<div class="yu-overflow">
					<p class="yu-orange yu-font16">￥5</p>
					<p class="yu-grey yu-font12">已从订单金额中扣减</p>
				</div>
		</div>--%>
		<div class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<div class="yu-overflow">
                <p class="yu-orange yu-font16">￥<%=ViewData["PayAmount"]%></p>
                    <p class="yu-grey yu-font12">
                    <%if (Convert.ToDecimal(ViewData["YouhuiMoney"]) != 0) {  %>&nbsp;会员优惠<span class="yu-blue"><%=ViewData["YouhuiMoney"]%></span>元 <% } %>
                    <%if (Convert.ToDecimal(ViewData["CouponMoney"]) != 0){ %>&nbsp;<span class="yu-blue">已扣除红包<%=ViewData["CouponMoney"]%></span>元<% }%>
                    &nbsp;获得 <span class="yu-blue"><%=ViewData["jifen"]%></span> 积分
                    </p>
                    <p class="yu-grey yu-font12">
                    <%if (Convert.ToDecimal(ViewData["manjianmoney"]) > 0)
                      {  
                          %>
                         &nbsp;<%=ViewData["manjianremo"] %>
                      <%} %>
                    </p>
                </div>
		</div>
	</section>
	
	<section class="yu-bgw yu-bmar10">
		<% if (!iszbsj)
     { %>
        <div class="yu-bor bbor  yu-h60 yu-grid yu-lrpad10 yu-alignc usernum">
			<p class="yu-black yu-overflow">用餐人数</p>
			<p class="yu-grey yu-font12 yu-rpad20">
            <%=string.IsNullOrEmpty(ViewData["userNumber"] + "") ? "" : ViewData["userNumber"] + "人"%>
            </p>
		</div>
        <div>
			<a class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<p class="yu-black yu-overflow">用餐时间</p>
				<p class="yu-grey yu-font12 yu-rpad20"><%= ViewData["usetime"]%></p>
			</a>
		</div>
        <% if (istravel != 1 && tid != Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
           { %>
        <div>
			<a class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<p class="yu-black yu-overflow">桌台号</p>
				<p class="yu-grey yu-font12 yu-rpad20"><%= ViewData["tablenumber"]%></p>
			</a>
		</div>
        <%}
     } %>
		<div>
			<a class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<p class="yu-black yu-overflow">订单备注</p>
				<p class="yu-grey yu-font12 yu-rpad20"><%= ViewData["remo"]%></p>
			</a>
		</div>
        <div>
			<a class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<p class="yu-black yu-overflow">订单状态</p>
				<p class="yu-grey yu-font12 yu-rpad20"><%= ViewData["StatusName"]%></p>
			</a>
		</div>
        <% if (ViewData["willArriveTime"] + "" != "")
           { %>
        <div>
			<a class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<p class="yu-black yu-overflow">预计送达时间</p>
				<p class="yu-grey yu-font12 yu-rpad20"><%= ViewData["willArriveTime"] + "" == "" ? "" : ViewData["willArriveTime"] + "分钟"%></p>
			</a>
		</div>
        <% } %>

        <% if (ViewData["songcanyuan"] + "" != "")
           { %>
        <div>
			<a class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<p class="yu-black yu-overflow">配送员</p>
				<p class="yu-grey yu-font12 yu-rpad20"><%= ViewData["songcanyuan"]%></p>
			</a>
		</div>
        <% } %>

        <% if (ViewData["songcanphone"] + "" != "")
           { %>
        <div>
			<a class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc" href="tel:<%= ViewData["songcanphone"]%>">
				<p class="yu-black yu-overflow">配送员手机号</p>
				<p class="yu-grey yu-font12 yu-rpad20"><%= ViewData["songcanphone"]%></p>
			</a>
		</div>
        <% } %>
	</section>
	<section class="number-bar">
      <div class="scrn">
        <p class="sjh">人数</p>
        <p class="scrn-txt"><%= ViewData["userNumber"]%></p>
      </div>
      <div class="num-key">
       
      <div class="num-key-row">
          <p data="1" class="num-k">1</p>
          <p data="2" class="num-k">2</p>
          <p data="3" class="num-k">3</p>
        </div>        
      <div class="num-key-row">
          <p data="4" class="num-k">4</p>
          <p data="5" class="num-k">5</p>
          <p data="6" class="num-k">6</p>
        </div> 
      <div class="num-key-row">
          <p data="7" class="num-k">7</p>
          <p data="8" class="num-k">8</p>
          <p data="9" class="num-k">9</p>
        </div>
 <div class="num-key-row">
          <p class="submit">确认</p>
          <p data="0" class="num-k">0</p>
          <p class="del"><span></span></p>
        </div>                           
      </div>
      <div class="slide-bar"></div>
    </section>
    <!--红包-->
    <section class="mask hb-mask">
    <div class="mask-inner">
            <div class="row yu-line60 yu-h60 yu-font20 yu-grid yu-bmar10">
                        <p class="yu-grey yu-w70 cancel">取消</p>
                        <p class="yu-overflow">选择红包</p>
                        <p class="yu-blue yu-w70 yhq-over">完成</p>
                     </div>   

            <div class="yhq-box select-box">
              <div class="row">
                <div class="hongbao type1 yu-grid">
                    <div class="yu-overflow yu-textl">
                      <p class="yu-bmar10"><i class="yu-font14">￥</i><i class="yu-font30">10</i></p>
                      <p class="yu-font14">订房红包</p>
                      <p class="yu-font14">有效期2017.01.01-2017.01.15</p>
                    </div>
                    <p class="hongbao-state"><span class="type1">未选用</span><span class="type2">已选用</span></p>
                </div>
              </div>

              <div class="row">
                <div class="hongbao type1 yu-grid">
                    <div class="yu-overflow yu-textl">
                      <p class="yu-bmar10"><i class="yu-font14">￥</i><i class="yu-font30">10</i></p>
                      <p class="yu-font14">订房红包</p>
                      <p class="yu-font14">有效期2017.01.01-2017.01.15</p>
                    </div>
                    <p class="hongbao-state"><span class="type1">未选用</span><span class="type2">已选用</span></p>
                </div>
              </div>                
           
            <div class="row">
                <div class="hongbao type1 yu-grid">
                    <div class="yu-overflow yu-textl">
                      <p class="yu-bmar10"><i class="yu-font14">￥</i><i class="yu-font30">10</i></p>
                      <p class="yu-font14">订房红包</p>
                      <p class="yu-font14">有效期2017.01.01-2017.01.15</p>
                    </div>
                    <p class="hongbao-state"><span class="type1">未选用</span><span class="type2">已选用</span></p>
                </div>
              </div>              

 <div class="row">
                <div class="hongbao type1 yu-grid">
                    <div class="yu-overflow yu-textl">
                      <p class="yu-bmar10"><i class="yu-font14">￥</i><i class="yu-font30">10</i></p>
                      <p class="yu-font14">订房红包</p>
                      <p class="yu-font14">有效期2017.01.01-2017.01.15</p>
                    </div>
                    <p class="hongbao-state"><span class="type1">未选用</span><span class="type2">已选用</span></p>
                </div>
              </div>                     


            </div>          
         </div>
         </section>
             <!--end-->

             <section class="mask pay-cancel-mask" >
			<div class="yu-bgw pay-cancel-tip">
				<p class="yu-font18 yu-bmar10">提醒</p>
				<p class="yu-font16 yu-bmar20">您是否确定取消订单</p>
				<div class="yu-grid yu-bor tbor yu-h50 yu-line50 yu-font16">
					<p class="yu-overflow yu-bor rbor yu-greys" onclick="javascript:CancelOrder()">
						是
					</p>
					<p class="yu-overflow yu-blue not-cancel">
						否
					</p>
				</div>
		</div>
	</section>

         <!--快速导航-->

         <%  Html.RenderPartial("QuickNavigation", null); %>

<% int Status=(int)ViewData["Status"]; %>	
<footer class="fix-bottom yu-lpad10 yu-bgw yu-grid">
   <!--申请退款 3g暂时不能退款---->
   <% if (Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPay))
      { %>
	    <%-- <div class="yu-overflow yu-bor1 bor bottom-btn1 type2" onclick="javascript:ApplyRefound('<%=ViewData["orderCode"] %>','<%=ViewData["key"] %>')">申请退款</div>--%>
   <% } %>
	
    <!--再来一单---->
    <% if ((Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPay) ||
           Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsSure) ||
           Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.JudanTuikuan) ||
           Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsOverTime) ||
           Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsCancel) ||
           Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsFinish) ||
           Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPeiSongZhong) ||
           Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsBossCancel) ||
           Status == 2)
           && !isShare)
       { %>
    <div class="yu-overflow yu-bor1 bor bottom-btn1 type2" id="div-btn-agin"  onclick="javascript:BuyAgain('<%=ViewData["hId"] %>','<%=ViewData["key"] %>','<%=ViewData["storeId"] %>');">
           再来一单</div>
    <% } %>

    <!--催单---->
    <% if (Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPay) || Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsSure))
      { %>
          <a class="yu-overflow yu-bor1 bor yu-rmar10 bottom-btn1 type1" href="tel:<%=ViewData["storePhone"]%>">催单</a>
	<% } %>
    
    <!--去支付---->
    <% if (Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.UnPay))
      { %>
         <div class="pay-btn1 type1 yu-bor1 bor cancel1" id="div-btn-cancel">取消订单</div>
         <div class="yu-btn yu-overflow" onclick="javascript:ToPay()" id="div-btn-pay">去支付</div>
         <% if (!isShare)
            {%>
         <div class="yu-overflow yu-bor1 bor bottom-btn1 type2" style=" display:none" id="div-btn-overtime-agin"  onclick="javascript:BuyAgain('<%=ViewData["hId"] %>','<%=ViewData["key"] %>','<%=ViewData["storeId"] %>');">
           再来一单</div>
           <%} %>
         <div class="yu-btn yu-overflow" style=" display:none" id="div-btn-overtime">超时支付</div>
    <% } %>
    
    <!--超时单---->
    <% if (Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsOverTime))
      { %>
         <div class="yu-btn yu-overflow">超时支付</div>
    <% } %>

    <!--确认收货---->
    <% if (Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsSure) || Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPeiSongZhong))
      { %>
        <a class="yu-overflow yu-bor1 bor yu-rmar10 bottom-btn1 type1" onclick="javascript:FinishOrder()">确认收货</a>
    <% } %>

    <!--点评  暂时不开放---->
    <% 
        bool NoHasDianPing = false;//(bool)ViewData["HasDianPing"];
        if (Status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsFinish) && NoHasDianPing&&1==2) //已完成订单&未评价过
        { %>
          <%--<a class="yu-overflow yu-bor1 bor yu-rmar10 bottom-btn1 type1" onclick="javascript:DianPing()">立即评价</a>--%>
    <% } %>

</footer>
<script>
    sessionStorage.IsDishBack = 0;
//    sessionStorage.orderNo = 'abc';
    $(function () {
        $(".cancel1").click(function () {
            $(".pay-cancel-mask").show();
        })
        $(".not-cancel,.mask").on("click", function () {
            $(".mask").hide();
        })
        $(".pay-cancel-tip").click(function (e) {
            e.stopPropagation();
        })

        


        //mask操作
        $(".mask").on("click", function () {
            $(this).fadeOut();
        })
        $(".mask-inner").on("click", function (e) {
            e.stopPropagation();
        })
        var lasttime,
              yhqNum,
              tsyqTxt;
        $(".select-box .row").on("click", function () {
            $(this).addClass("cur").siblings(".row").removeClass("cur");
            if ($(this).parent(".select-box").hasClass("time-box")) {//最晚时间
                lasttime = $(this).children("p").eq(1).text();
                $(".lasttimeselect").text(lasttime);
                $(this).parents(".mask").fadeOut();
            } else if ($(this).parent(".select-box").hasClass("yhq-box")) {//优惠券
                $(this).find(".txt").removeClass("yu-orange");
                $(this).siblings().find(".txt").addClass("yu-orange");
                yhqNum = $(this).index() + 1;
                return yhqNum;
            } else if ($(this).parent(".select-box").hasClass("tsyq-box")) {//特殊要求      
                tsyqTxt = $(this).children("p").eq(1).text();
                return tsyqTxt;
            }
        })
        //红包
        $(".usehb").click(function () {
            $(".hb-mask").fadeIn();
        })
        $(".cancel").click(function () {
            $(".mask").fadeOut();
        })
        $(".yhq-over").click(function () {
            $(".mask").fadeOut();
            //          $(".yhq-type").text("￥"+yhqNum+"0");
        })
        
        //加减餐
        var foodNum = 0;
        var totalNum = 0;
        //	$(".add").on("click",function(){
        $(".food-list,.food-details").find("dd").on("click", ".add", function () {
            totalNum++;
            $(".yu-btn").text("选好了");
            if ($(this).siblings(".food-num").text() == "") {
                foodNum = 1;
                $(this).siblings(".food-num").text(foodNum);
            } else {
                foodNum = parseInt($(this).siblings(".food-num").text());
                foodNum++;
                $(this).siblings(".food-num").text(foodNum);
            };
            $(this).siblings().fadeIn();
            $(".gwc-ico .num").text(totalNum);
            $(".gwc-ico .num").fadeIn();
        });

        //	$(".reduce").on("click",function(){
        $(".food-list,.food-details").find("dd").on("click", ".reduce", function () {
            foodNum = parseInt($(this).siblings(".food-num").text());
            if (foodNum > 0) {
                totalNum--;
                foodNum--;
                $(this).siblings(".food-num").text(foodNum);
                $(".gwc-ico .num").text(totalNum);
                totalNum == 0 ? $(".yu-btn").text("请选择") : $(".yu-btn").text("选好了");
                if (totalNum == 0) {
                    $(".yu-btn").text("请选择");
                    $(".gwc-ico .num").fadeOut();
                }
                if (foodNum == 0 && $(this).parents("dl").hasClass("food-list")) {
                    $(this).fadeOut().siblings(".food-num").fadeOut();
                }
            };
        });

        //数字键
        function datas() {
            this.datastore = [];
            this.top = 0;
            this.push = function (ele) {
                if (this.top < 3) {
                    this.datastore[this.top++] = ele;
                }
            };
            this.pop = function () {
                if (this.top > 0) {
                    this.datastore.pop();
                    this.top--;
                }
            };
            this.show = function () {
                return this.datastore.join("");
            };
        };
        var number;
        var userNum = new datas();
        var clickNum = 0;
        $(".num-key-row").children(".num-k").on("click", function () {
            if (clickNum < 3) {
                clickNum++;
            }
            number = $(this).attr("data");
            userNum.push(number);
            $(".scrn-txt").text(userNum.show());
            $(".submit").addClass("cur");
        })
        $(".num-key-row").children(".del").click(function () {
            if (clickNum > 0) {
                clickNum--;

            }
            userNum.pop();
            if (userNum.top == 0) {
                $(".submit").removeClass("cur");

            }

            $(".scrn-txt").text(userNum.show());
        });
        $(".slide-bar").click(function () {
            $(".number-bar").fadeOut();
        })
        $(".num-key-row").on("click", ".cur", function () {
            $(".userNumber").val(userNum.show());
            $(".number-bar").fadeOut();
        })
        //end
    })
</script>

<script type="text/javascript">
    function ApplyRefound(ordercode,key) {
        window.location.href = "/DishOrder/ApplyRefund/<%=ViewData["hId"] %>?key=" + key + "&orderCode=" + ordercode;
     }

    function BuyAgain(hId,key,storeId)
    {
      window.location.href = "/DishOrder/DishOrderIndex/"+hId+"?key=" + key + "&storeId=" + storeId+"&tid=<%=tid %>";
    }

    function ToPay()
    {
       $.post("/DishOrder/SendOrderToPay/?orderCode=<%=ViewData["orderCode"] %>&fromview=1",
                function(data){
                    if(data.error==1){
                          window.location.href = '/Recharge/CardPay/<%=Html.ViewData["hId"]%>?key=<%=Html.ViewData["key"] %>&orderNo=' + '<%=ViewData["orderCode"] %>';
                    }else{
                       layer.msg(data.message);
                    }
                });
    }

    //取消订单
    function CancelOrder() {
        $.post("/DishOrder/CancelOrder/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&orderCode=<%=ViewData["orderCode"] %>&storeId=<%=ViewData["storeId"] %>", 
        function (data) {
            if(data.error==1)//取消成功跳回点餐首页
            { 
              <% if(!isShare){ %>
                window.location.href= "/DishOrder/DishOrderIndex/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&tid=<%=tid %>";
              <%}else{ %>
               window.location.reload();
              <%} %>
            }
            $(".mask").hide();
        });
        }
   //确认收货，订单完成
    function FinishOrder() {
        
        layer.confirm('确认操作收货吗？', { btn: ['确定','取消'] }, 
        function(){
            $.post("/DishOrder/FinishOrder/?orderCode=<%=ViewData["orderCode"] %>&storeId=<%=ViewData["storeId"] %>", 
            function (data) {
                if(data.error==1)//确认收货成功跳回订单管理页
                { 
                    window.location.reload();
                }else{
                   layer.msg("操作失败！请稍后重新操作！");
                }
            })
        }, function(){
             $('.layui-layer-dialog').hide();
          });
     }

     //评价
     function DianPing()
     {
         window.location.href="/DishOrder/DianPing/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&orderCode=<%=ViewData["orderCode"] %>&storeId=<%=ViewData["storeId"] %>";
     }



        $(function(){
          function SetTime(TotalSeconds) {
         
             if(TotalSeconds>=0){
                var m=parseInt(TotalSeconds/60);
                var s=parseInt(TotalSeconds%60);
                if(m<=9){m='0'+m;}
                if(s<=9){s='0'+s;}
                var time=m+':'+s;
               
               $('#div-btn-pay').html(time+' 去支付');
               setTimeout(function(){SetTime(TotalSeconds-1)},1000);
               }
               else //订单超时
               {
                    $.post("/DishOrder/SaveOrderOverTime/?orderCode=<%=ViewData["orderCode"] %>",function(data){
                    });
                  $('#div-btn-pay,#div-btn-cancel').hide();
                  $("#div-btn-overtime,#div-btn-overtime-agin").show();
               }
             }
         var s='<%=Status %>';
         if(s=='1'){ //待支付状态才倒计时
           var tt='<%=ViewData["TotalSeconds"] %>';
           SetTime(tt);
         }

         });
</script>
</body>
</html>
