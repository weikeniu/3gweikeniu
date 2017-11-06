<!DOCTYPE html >

<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    hotel3g.Models.OrderAddress model = (hotel3g.Models.OrderAddress)ViewData["address"];
    bool iszbsj = (bool)ViewData["iszbsj"];//周边商家[不是酒店餐饮]

    // 1 旅行社版本
    int istravel = WeiXin.Common.NormalCommon.IsLXSDoMain() ? 1 : 0;


    int tid = HotelCloud.Common.HCRequest.getInt("tid");//aush   桌台号id
    ViewData["tid"] = tid;
    
    int eatatstore = (int)ViewData["eatatstore"];//// 是否堂食 1是，0否
    string tablenumber = ViewData["tablenumber"] + "";//座号
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta name="keywords" content="关键词1,关键词2,关键词3" />
    <meta name="description" content="对网站的描述" />
    <meta name="format-detection" content="telephone=no" />
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes" />
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*" />
    <title>订单支付</title>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/newpay.css" />
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/number-bar.css" />
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/mobileSelect.css"/>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/drag.js" type="text/javascript"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/mobileSelect.js"></script>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/fontSize.js"></script>
    <%--<script type="text/javascript" src="../../css/booklist/number-bar.js"></script>--%>
</head>
<%
    hotel3g.Models.Youhui manjian_model = (hotel3g.Models.Youhui)ViewData["manjian_model"];//消费满减
%>
<body>
 <% 
     if (istravel != 1||!iszbsj)//酒店餐饮[酒店版本]or 旅行社餐饮[旅行社版本餐饮]
     {
         if (tid == Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
         {
             if (eatatstore == Convert.ToInt32(hotel3g.Models.EnumEatAtStore.外卖))
             { 
                 %>
    <section class="yu-arr yu-bgw yu-bmar10 ">
		<div class="yu-grid yu-alignc">
			<a class="gps-ico" onclick="javascript:OpenMap()"></a>
            <a class="yu-alignc yu-pad20 yu-overflow" onclick="javascript:EditAddress(1)">
				<% if (model.AddressID > 0)
       { %>
                        <div>
					        <p class="yu-black yu-bmar5">
						        <span><%=model.LinkMan%></span>
						        <span><%=model.LinkPhone%></span>
					        </p>
                            <% 
     if (Convert.ToInt32(ViewData["openaddress"]) == Convert.ToInt32(hotel3g.Models.EnumStoreOpenAddress.开启))
     {%>
                                   <p class="yu-grey yu-font12">
						            <span><%=model.Address%></span>
						            <span><%=model.RoomNo%></span>
					              </p>
                               <% } %>
				        </div>
                <% }
       else
       { %>
                        <div class="yu-black">
					        请输入一个联系方式
				        </div>
                <% } %>
			</a>
           </div>
		<div class="colorBorder"></div>
	</section>
    <%      }
         }
     }
     else
     {
        %>
         <section class="yu-arr yu-bgw yu-bmar10 ">
		    <div class="yu-grid yu-alignc">
			<a class="gps-ico" onclick="javascript:OpenMap()"></a>
            <a class="yu-alignc yu-pad20 yu-overflow" onclick="javascript:EditAddress(1)">
				<% if (model.AddressID > 0)
       { %>
                        <div>
					        <p class="yu-black yu-bmar5">
						        <span><%=model.LinkMan%></span>
						        <span><%=model.LinkPhone%></span>
					        </p>
                            <% 
     if (Convert.ToInt32(ViewData["openaddress"]) == Convert.ToInt32(hotel3g.Models.EnumStoreOpenAddress.开启))
     {%>
                                   <p class="yu-grey yu-font12">
						            <span><%=model.Address%></span>
						            <span><%=model.RoomNo%></span>
					              </p>
                               <% } %>
				        </div>
                <% }
       else
       { %>
                        <div class="yu-black">
					        请输入一个联系方式
				        </div>
                <% } %>
			</a>
           </div>
		    <div class="colorBorder"></div>
	     </section>

     <%
     } %>

    <%
        var key = Html.ViewData["key"] + "";
        string userweixinid = "";
        if (key.Contains("@"))
        {
            userweixinid = key.Split('@')[1];
        }
        string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    %>
    <section class="yu-bgw yu-bmar10">
		<div class="yu-h50 yu-lrpad10 yu-grey yu-line50 yu-bor bbor" onclick="javascript:<%=(!string.IsNullOrEmpty(userweixinid) && !userweixinid.Contains(wkn_shareopenid))?"toIndex()":"" %>">
			<a class="yu-grey yu-d-b"><%=ViewData["storeName"]%></a>
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
                    //hotel3g.Repository.MemberCardIntegralRule rule = ViewData["hasRule"] as hotel3g.Repository.MemberCardIntegralRule;//优惠政策
                    decimal Amount = (decimal)ViewData["Amount"];
                    decimal total = (decimal)ViewData["total"];
                    decimal YouHuiMoney = decimal.Parse(ViewData["YouhuiMoney"] + "");
                    decimal MealGradeRate = 0;

                    decimal canCouponTotalMoney = 0;	//1先减后折扣贵些， 2先折后减更实惠    
                    System.Data.DataTable dt_dish = (System.Data.DataTable)ViewData["dt_dish"];
                    foreach (System.Data.DataRow row in dt_dish.Rows)
                    {
                      %>
                      <li class="yu-grid yu-alignc yu-bmar10">
					        <div class="yu-overflow">
						        <div class="yu-grid yu-alignc">
							        <p style="width:120px"><%=row["dishesName"]%></p>
							        <% if (!iszbsj)
                  { %>
                                    <div class="la-lv type<%=row["Hot"]%>"></div>
                                    <%} %>
                                    <p></p>
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
        <%  System.Data.DataTable couponDataTable = (System.Data.DataTable)ViewData["couponDataTable"]; %>
        <div style="display:<%=couponDataTable.Rows.Count>0?"block":"none" %>">
		<div class="yu-bor bbor yu-arr yu-h60 yu-grid yu-lrpad10 yu-alignc usehb">
				<p class="yu-black yu-rmar20">红包</p>
                <div class="yu-overflow" id="div_couponMoney1">
					<p class="yu-f30r yu-c99">请选择优惠红包</p>
				</div>
				<div class="yu-overflow" id="div_couponMoney2" style="display:none;">
					<p class="yu-orange yu-font16">￥<span id="p_couponMoney">0</span></p>
					<p class="yu-grey yu-font12">已从订单金额中扣减</p>
				</div>
		</div>
        </div>
		<div class="yu-bor bbor yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<p class="yu-black yu-rmar20">订单</p>
				<div class="yu-overflow">
					<p class="yu-orange yu-font16" id="p_amount">￥<%=(Amount - YouHuiMoney).ToString("f2")%></p>
					<p class="yu-grey yu-font12">
                    <% if (YouHuiMoney > 0)
                       { %>
                            会员优惠<%=YouHuiMoney.ToString("f2")%>元,
                        <% } %>
                        可获<i class="yu-c40" id="id_jifen"><%=ViewData["orderScore"]%></i>积分
                        </p>
				</div>
		</div>
	</section>
    <!--快速导航-->
    <% Html.RenderPartial("QuickNavigation", null); %>
    <section class="yu-bgw yu-bmar10">
        <div class="yu-bor bbor  yu-h60 yu-grid yu-lrpad10 yu-alignc usernum" <%=iszbsj?"style='display:none'":"" %>>
			<p class="yu-black yu-overflow">用餐人数</p>
			<!--<p class="yu-grey yu-font12 yu-rpad20">便于商家带够餐具</p>-->
			<div class="ar yu-grid">
				<p class="reduce ico p-btn" style="<%=string.IsNullOrEmpty(ViewData["userNumber"]+"") ? "" : "display: block;"%>"></p>
				<p class="food-num" style="<%=string.IsNullOrEmpty(ViewData["userNumber"]+"") ? "" : "display: block;"%>"><%= ViewData["userNumber"]%></p>
				<p class="add ico p-btn"></p>
			</div>
		</div>
		<div class="yu-bor bbor yu-arr yu-h60 yu-grid yu-lrpad10 yu-alignc usetime" <%=iszbsj?"style='display:none'":"" %>>
			<p class="yu-black yu-overflow">用餐时间</p>
			<p class="yu-grey yu-font12 yu-rpad20 selecttime">实时<%--<%=DateTime.Now.ToString("HH:mm")+"-"+DateTime.Now.AddHours(1).ToString("HH:mm") %>--%></p>
		</div>

        <% if (!(istravel == 1 && iszbsj))//非旅行社版本周边商家
           {
               if (tid != Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码) || eatatstore == Convert.ToInt32(hotel3g.Models.EnumEatAtStore.堂食))
               {
                %>
        <div class="yu-bor bbor  yu-h60 yu-grid yu-lrpad10 yu-alignc ">
			<p class="yu-black yu-overflow">取餐方式</p>
			<div>
				<div class="get-food-type">送餐到桌</div>
			</div>
		</div>
        <div class="yu-bor bbor  yu-h60 yu-grid yu-lrpad10 yu-alignc ">
			<p class="yu-black">桌台号</p>
			<div class="yu-overflow">
                <input class="yu-input2 yu-lpad40r" id="select-desk" placeholder="请选择桌台或输入餐台号" type="text" value='<%=tablenumber %>' onkeyup="javascript:ChangeTableNumber()"/>
            </div>
			<div class="select-desk  yu-arr" id="trigger2"></div>
		</div>
        <%   
               }
           }%>

        <div>
			<%--<a onclick="javascript:EditAddress(2)" class="yu-bor bbor yu-arr yu-h60 yu-grid yu-lrpad10 yu-alignc">
				<p class="yu-black yu-overflow">订单备注</p>
				<p class="yu-grey yu-font12 yu-rpad20"><%= ViewData["remo"]%></p>
			</a>--%>
            <div class="yu-bor bbor  yu-h60 yu-grid yu-lrpad10 yu-alignc " >
				<p class="yu-black yu-rmar20">订单备注</p>
				<div class="yu-overflow">
					<input type="text" class="yu-input2" id="remo" placeholder="请输入订单备注" value='<%= ViewData["remo"]%>'/>
				</div>
		    </div>
		</div>
	</section>
    <section class="mask numberb-mask"></section>
    <!--红包-->
    <section class="mask hb-mask">
       <div class="mask-inner">
            <div class="row yu-line60 yu-h60 yu-font20 yu-grid yu-bmar10">
                        <p class="yu-grey yu-w70 cancel">取消</p>
                        <p class="yu-overflow">选择红包</p>
                        <p class="yu-blue yu-w70 yhq-over">完成</p>
                     </div>   

            <div class="yhq-box select-box">
              <% foreach (System.Data.DataRow data in couponDataTable.Rows)
                 { %>
              <div class="row hongbaorow">
                <div class="hongbao type1 yu-grid">
                    <div class="yu-overflow yu-textl">
                      <input type="hidden" name="CouponId" value="<%=data["id"]%>" />
                      <input type="hidden" name="CouponMoney" value="<%=data["moneys"]%>" />
                      <input type="hidden" name="CouponLimitMoney" value="<%=data["amountlimit"]%>" />
                      <p class="yu-bmar10"><i class="yu-font14">￥</i><i class="yu-font30 yu-fontb"><%=data["moneys"]%></i></p>
                      <p class="yu-font14"><%=data["amountlimit"]%>元起用</p>
                      <p class="yu-font14">有效期<%=DateTime.Parse(data["sTime"].ToString()).ToShortDateString()%>-<%=DateTime.Parse(data["ExtTime"].ToString()).ToShortDateString()%></p>
                    </div>
                    <p class="hongbao-state"><span class="type1">未选用</span><span class="type2">已选用</span></p>
                </div>
              </div>                
            <% } %>

            <%--<div class="row hongbaorow">
                <div class="hongbao type1 yu-grid">
                    <div class="yu-overflow yu-textl">
                      <input type="hidden" name="CouponId" value="33" />
                      <input type="hidden" name="CouponMoney" value="5" />
                      <input type="hidden" name="CouponLimitMoney" value="5" />
                      <p class="yu-bmar10"><i class="yu-font14">￥</i><i class="yu-font30 yu-fontb">5</i></p>
                      <p class="yu-font14">5元起用</p>
                      <p class="yu-font14"></p>
                    </div>
                    <p class="hongbao-state"><span class="type1">未选用</span><span class="type2">已选用</span></p>
                </div>
              </div>--%>  
            </div>          
         </div>
    </section>
    <!--时间-->
    <section class="mask lasttime-mask">
		<div class="mask-bottom-inner yu-bgw">
			<p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">预计用餐时间</p>
			<ul class="yu-lrpad10 yu-c99 hongbao-select test-select">
                 <li class="yu-h120r yu-grid yu-alignc yu-bor bbor">
					<div class="yu-overflow yu-f30r timelist">实时</div>
					<p class="copy-radio"></p>
				 </li>
                <% 
                    var dd = DateTime.Now.Hour;
                    int count = 50 - 2 * dd;
                    for (int k = 1; k < count; k++)
                    {
                        int mins = k * 30;
                     %>
                 <li class="yu-h120r yu-grid yu-alignc yu-bor bbor">
					<div class="yu-overflow yu-f30r timelist"><%=DateTime.Now.AddMinutes(mins).ToString("HH:mm") + "-" + DateTime.Now.AddMinutes(mins + 30).ToString("HH:mm")%></div>
					<p class="copy-radio"></p>
				 </li>
                <% } %>
                
			</ul>
			<!--<div class="yu-l100r yu-h100r yu-bg40 yu-white  yu-textc mask-close yu-font32r">关闭</div>-->
		</div>
	</section>
    <!--end-->
    <footer class="yu-grid fix-bottom yu-bor tbor yu-lpad10 touch_action">
		<div class="yu-overflow">
			<p class="yu-orange">在线支付￥<span id="payamount_id"><%=(Amount-YouHuiMoney-manjian_model.DelMoney).ToString("f2")%></span></p>
            <p class="yu-grey yu-font12" id="manjianremoID"><%=manjian_model.Remo%></p>
			 <p class="yu-grey yu-font12">包含服务及增值税￥0</p>
		</div>
	<div class="yu-btn" onclick="javascript:ToOrderPay()" id="div-btn-pay">去支付</div>
	<div class="yu-btn" style=" display:none" id="div-btn-overtime">支付超时</div>
   </footer>
    <input type="hidden" id="hid_selCouponId" value="0" />
    <input type="hidden" id="hid_selCouponMoney" value="0" />
    <input type="hidden" id="hid_manjianmoney" value="<%=manjian_model.DelMoney %>" />
    <script>
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

        var unsale = '<%=ViewData["unsale"] %>';
        $(function () {
            //mask操作
            $(".mask").on("click", function () {
                $(this).fadeOut();
            });
            $(".mask-inner").on("click", function (e) {
                e.stopPropagation();
            });
            //用餐时间
            $(".usetime").click(function () {
                $(".lasttime-mask").fadeIn();
            });
            $(".hongbao-select>li").on("click", function () {
                $(this).addClass("cur").siblings().removeClass("cur");
                var selecttime = $(this).find(".timelist").text();
                $(".selecttime").text(selecttime);
                $(".mask").fadeOut();
            })
            if (unsale != '') {
                layer.msg("餐品" + unsale + "已下架！请到首页重新选购！");
            }

            //选择桌台
            //var UplinkData = [{id:1,value:'a',childs:[{id:2,value:'123'}]}];
            
            <% if (!(istravel == 1 && iszbsj))//非旅行社版本周边商家
           {
               if (tid != Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码) || eatatstore == Convert.ToInt32(hotel3g.Models.EnumEatAtStore.堂食))
               {
                %>
            var UplinkData = [<%=ViewData["data"] %>];
            //只有trigger 和 wheels 是必要参数  其他都是选填参数
            if(UplinkData.length>0){
                var mobileSelect2 = new MobileSelect({
                    trigger: '#trigger2',
                    title: '选择桌台',
                    wheels: [
	                    { data: UplinkData }
	                ],
                    transitionEnd: function (indexArr, data) {
                        //console.log(data);
                    },
                    callback: function (indexArr, data) {
                        //console.log(data);
                    }
                });
            }
            <%}} %>

        })
    </script>
    <script type="text/javascript">
    var MealGradeRate = '<%=MealGradeRate %>' * 1;
    var YouHuiMoney = '<%=YouHuiMoney %>' * 1;
    var equivalence = '<%=ViewData["equivalence"] %>' * 1;
    var GradePlus = '<%=ViewData["GradePlus"] %>' * 1;

    $(function () {
        var orn='<%=ViewData["orderCode"] %>';
        if(sessionStorage.IsDishBack == 1 &&sessionStorage.orderNo==orn){
             window.location.href = "/DishOrder/ViewOrderDetail/<%=ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&key=<%=ViewData["key"] %>&orderCode=<%=ViewData["orderCode"] %>&tid=<%=tid %>";
            }

    //加减餐
	var foodNum=0;
	var totalNum=0;
	$(".add").on("click",function(){
		totalNum++;
		
		if($(this).siblings(".food-num").text()==""){
			foodNum=1;
			$(this).siblings(".food-num").text(foodNum);
		}else{
			foodNum=parseInt($(this).siblings(".food-num").text());
			foodNum++;
			$(this).siblings(".food-num").text(foodNum);
	};
		$(this).siblings().fadeIn();
		$(".gwc-ico .num").text(totalNum);
		$(".gwc-ico .num").fadeIn();
	});
	
	$(".reduce").on("click",function(){
		foodNum=parseInt($(this).siblings(".food-num").text());
		if(foodNum>1){
			totalNum--;
			foodNum--;
			$(this).siblings(".food-num").text(foodNum);
			$(".gwc-ico .num").text(totalNum);
			
			if(totalNum==0){
				$(".gwc-ico .num").fadeOut();
			}
			if(foodNum==0&&$(this).parents("dl").hasClass("food-list")){
				 $(this).fadeOut().siblings(".food-num").fadeOut();	
			}
		};
	});

      
      var payamount='<%=total%>'*1;
        //mask操作
        $(".mask").on("click", function () {
            //$(this).fadeOut();
        })
        $(".mask-inner").on("click", function (e) {
            e.stopPropagation();
        })
        var lasttime,
              yhqNum,
              tsyqTxt;
        $(".select-box .row").on("click", function () {
            var limit=$(this).find("input[name='CouponLimitMoney']").val()*1;
            if(payamount>=limit){
               $(this).addClass("cur").siblings(".row").removeClass("cur");
            }else{
               layer.msg("消费"+limit+"元起用！");
            }
        })

        //红包
        $(".usehb").click(function () {
            $(".hb-mask").fadeIn();
        })
        $(".cancel").click(function () {
            $(".mask").fadeOut();
            $(".hongbaorow").removeClass("cur");
            
            var jifen='<%=ViewData["orderScore"]%>';
            $('#id_jifen').html(jifen);
            $("#p_amount").html("￥" + payamount.toFixed(2));
            $("#payamount_id").html(payamount.toFixed(2));//支付金额

            $("#hid_selCouponId,#hid_selCouponMoney").val(0);//红包id，红包金额
            $("#div_couponMoney1").show();
            $("#div_couponMoney2").hide();
            $("#p_couponMoney").html(0);

            JiSuanManJian();//选择红包，重新计算消费满减
        })
        $(".yhq-over").click(function () {
            $(".mask").fadeOut();
            $.each($(".hongbaorow"),function(){
               if($(this).hasClass("cur"))
               {
                 var CouponId=$(this).find("input[name='CouponId']").val();//红包id
                 var CouponMoney=$(this).find("input[name='CouponMoney']").val()*1;//红包金额
                 $("#hid_selCouponId").val(CouponId);
                 $("#hid_selCouponMoney").val(CouponMoney);
                 $("#p_couponMoney").html(CouponMoney);
                 $("#div_couponMoney2").show();
                 $("#div_couponMoney1").hide();
                 
                 var paytotal=(payamount*1-CouponMoney).toFixed(2);
                  var jifen = parseInt((paytotal * equivalence * GradePlus).toFixed(2));
                  $('#id_jifen').html(jifen);
                 $("#p_amount").html("￥" + paytotal);
                 $("#payamount_id").html(paytotal);//支付金额

                 JiSuanManJian();//选择红包，重新计算消费满减
                 return;
               }
            });
        })

//加减人数
        $(".p-btn").click(function()
        {
           var num=$(".food-num").text();
           
           if(parseInt(num)>-1)
           {
               $.post('/DishOrder/SaveUserNumber/?orderCode=<%=ViewData["orderCode"] %>&userweixinid=<%=ViewData["userweixinid"] %>&n=' + num, function (data) {
                    if (data.error == 1) {
                      
                    } else {
                        $(".food-num").text('<%= ViewData["userNumber"]%>');
                        layer.msg(data.message);
                        return false;
                    }
                });
           }
        });

    });

    ///begin 20170810 
    function JiSuanManJian(){
       var payamount=$("#payamount_id").html()*1;
       var youhuiids='<%=ViewData["youhuiids"] %>';
       $.post('/DishOrder/GetYouhuiAmount/?pamount='+payamount+'&ids='+youhuiids,function(data){
           var m=payamount-data.money*1;
           $("#payamount_id").html(m);
           $("#manjianremoID").html(data.msg);
           $("#hid_manjianmoney").val(data.money);
       });
    }
    
    ///end


    //去支付
    function ToOrderPay()
    {
        var sure=true;
        if(unsale!=''){
           layer.msg("餐品" + unsale + "已下架！请到首页重新选购！");
           sure=false;
           return;
        }
        var iszbsj='<%=iszbsj %>';
        var openaddress='<%=ViewData["openaddress"] %>';
        var L='<%=model.LinkMan%>';
        var A='<%=model.Address %>';

        var istravel='<%=istravel %>';

        var eatatstore='<%=eatatstore %>';//是否堂食 1是，0否

        var tid='<%=tid %>';

        if(tid=='<%=Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码) %>'){ //begin非扫码
       
        if(eatatstore=='<%=Convert.ToInt32(hotel3g.Models.EnumEatAtStore.外卖) %>'){    //begin外卖

            if(iszbsj.toLocaleLowerCase()=='true'){//旅行社周边商家必填联系人+地址
                if(L=="" || A==''){
                  layer.msg("请先设置联系人/地址！");
                  sure=false;
                  return;
                }
            }else{
               if(openaddress=='<%=Convert.ToInt32(hotel3g.Models.EnumStoreOpenAddress.开启) %>'){ //商家开启地址
                  if(L=="" || A==''){
                      layer.msg("请先设置联系人/地址！");
                      sure=false;
                      return;
                  }
               }else{
                 if(L==''){
                      layer.msg("请先设置联系人！");
                      sure=false;
                      return;
                 }
               }
            }

         } //end 外卖
         else{   
           var tablenumber=$('#select-desk').val();
           if(tablenumber==''){
                layer.msg("请输入桌台号！");
                sure=false;
                return;
            }
            tid='99999999';
         }
        
        } //end非扫码
        else{ 
           var tablenumber=$('#select-desk').val();
           if(tablenumber==''){
                layer.msg("请输入桌台号！");
                sure=false;
                return;
            }
        }

        if(sure){
            $('#div-btn-pay').attr("disabled", true);

           var CouponId=$("#hid_selCouponId").val();
           var CouponMoney=$("#hid_selCouponMoney").val();
           var usetime=$('.selecttime').text();//用餐时间
           var jifen = $('#id_jifen').html();
           var yhamount = YouHuiMoney;//立减/折扣的金额
           var manjianmoney=$("#hid_manjianmoney").val();//消费满减金额
           var manjianremo=$("#manjianremoID").html();//消费满减信息
           
           var tbnum=$('#select-desk').val();

           var data={ orderCode:'<%=ViewData["orderCode"] %>',storeId:'<%=ViewData["storeId"] %>',
           CouponId:CouponId,CouponMoney:CouponMoney,usetime:usetime,jifen:jifen,yhamount:yhamount,manjianmoney:manjianmoney,
           manjianremo:manjianremo,tablenumber:tbnum,
           remo:$('#remo').val(),key:'<%=Html.ViewData["key"] %>',eatatstore:eatatstore,tid:tid};

           $.post("/DishOrder/SendOrderToPay/",data,function(data){
                    if(data.error==1){
                       sessionStorage.IsDishBack = 1;
                       sessionStorage.orderNo= '<%=ViewData["orderCode"] %>';
                       window.location.href = '/Recharge/CardPay/<%=Html.ViewData["hId"]%>?key=<%=Html.ViewData["key"] %>&orderNo=' + '<%=ViewData["orderCode"] %>';
                    }else{
                       layer.msg(data.message);
                       if(data.error==7){
                          setTimeout(function(){window.location.reload();},500);
                       }
                    }

                     $("#div-btn-pay").removeAttr("disabled");
                });
          }
    }

    function EditAddress(obj) {
        $.post('/DishOrder/ValidateOrderStatus/?orderCode=<%=ViewData["orderCode"] %>',function(data){
            if(data.error==1){
               if(obj==1){
                  window.location.href="/DishOrder/EditAddress/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&iszbsj=<%=iszbsj %>";
               }
               if(obj==2){
                  window.location.href="/DishOrder/OrderRemo/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&iszbsj=<%=iszbsj %>";
               }
            }else{
               layer.msg(data.message);
               return;
            }
        });
        
     }

     function toIndex()
     {
        window.location.href='/DishOrder/DishOrderIndex/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>&tid=<%=tid %>';
     }

     function OpenMap()
     {
          window.location.href="http://hotel.weikeniu.com/Hotel/map/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>"
     }

     function ChangeTableNumber()
     {
         //var old='<%=tablenumber %>';
         var value=$('#select-desk').val();
         $('#title_tablenumber').html(value);
     }

    </script>
    <script>
        //    $(function(){
        //          function SetTime(TotalSeconds) {
        //         
        //             if(TotalSeconds>=0){
        //                var m=parseInt(TotalSeconds/60);
        //                var s=parseInt(TotalSeconds%60);
        //                if(m<=9){m='0'+m;}
        //                if(s<=9){s='0'+s;}
        //                var time=m+':'+s;
        //               $('#div-btn-pay').html(time+' 去支付');
        //               setTimeout(function(){SetTime(TotalSeconds-1)},1000);
        //               }
        //               else //订单超时
        //               {
        //                    $.post("/DishOrder/SaveOrderOverTime/?orderCode=<%=ViewData["orderCode"] %>",function(data){
        //                        if(data.error==0)
        //                        {
        //                            alert(data.message);
        //                        }
        //                        window.location.href="/DishOrder/DishOrderIndex/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>";
        //                    });
        //                  $('#div-btn-pay').hide();
        //                  $("#div-btn-overtime").show();
        //               }
        //             }
        //         var tt='0';
        //         SetTime(tt);

        //         });


    </script>
</body>
</html>
