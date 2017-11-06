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

    //微信分享
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    bool isShare = false;
    if (userWeiXinID.Contains(wkn_shareopenid))
    {
        isShare = true;
    }


    int tid = 0;//扫码来的桌台号id
    int.TryParse(ViewData["tablenumberid"] + "", out tid);
    if (tid == 0)
    {
        tid = HotelCloud.Common.HCRequest.getInt("tid");
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.1"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css?v=1.1"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css?v=1.1"/>
<%--    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/font/iconfont.css"/>--%>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css?v=1.1"/>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js?v=1.1"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js?v=1.1"></script>
</head>
 <%   int status = (int)ViewData["Status"]; //订单状态    %>
<body class="o-f-auto">
    <article class="full-page">
     <%
         if (!isShare)
         {
             if (tid == Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
             {
                 Html.RenderPartial("HeaderA", viewDic);
             }
         }%>
	<section class="order-d-top yu-pos-r bl">
		<div class="yu-cw">
			<p class="yu-f40r"><%=ViewData["StatusName"]%></p>
			<p class="yu-f26r"><%=ViewData["cue"]%></p>
		</div>
		<div class="kd-pic">
           <% if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.UnPay))
              { %>
              <img src="../../images/order-ico/dfkb_03.jpg" />
           <% }
               if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPay)&&
                   Convert.ToInt32(hotel3g.Models.EnumOrderPayStatus.支付成功)==1)
               { %>
               <img src="../../images/order-ico/yfkb_03.jpg" />
           <% } if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsSure))
               {%>
               <img src="../../images/order-ico/gwcb_03.jpg" />
           <% } if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPeiSongZhong))
               {%>
               <img src="../../images/order-ico/wuliub_03.jpg" />
           <% } if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsFinish))
               { %>
               <img src="../../images/order-ico/jycgb_03.jpg" />
           <% } if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsCancel)||
                  status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsBossCancel)||
                  status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsOverTime)||
                  status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.JudanTuikuan)||
                  status == 2)
               { %>
               <img src="../../images/order-ico/qxb_03.jpg" />
           <% } %>
		</div>
	</section>
    
	<!--酒店方式-->
	<section class="yu-bgw yu-bmar10 ">
    <% if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsFinish))
       { %>
         <div class="yu-grid yu-alignc yu-tbpad30r yu-lpad40r yu-bor bbor yu-rpad20r">
			<a class="o-d-ico type3 yu-rmar25r" href="#"></a>
			<p class="yu-alignc yu-overflow yu-f30r">送达时间</p>
			<p class="yu-c40 yu-f26r">已送达</p>
		</div>
    <% } %>
    <!----派送中----->
    <% if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPeiSongZhong))
       { %>
        <div class="yu-grid yu-alignc yu-tbpad30r yu-lpad40r yu-bor bbor yu-rpad20r">
			<a class="o-d-ico type3 yu-rmar25r" href="#"></a>
			<p class="yu-alignc yu-overflow yu-f30r">送达时间</p>
			<p class="yu-c40 yu-f26r">预计<%=ViewData["willArriveTime"]%>分钟到达</p>
		</div>
		<div class="yu-h80r yu-grid  yu-bgfa yu-bor bbor yu-f24r">
			<div class="yu-w265r yu-bor rbor yu-grid yu-h80r yu-alignc">
				<p class="yu-c99 yu-lpad20r yu-rmar30r">派送人</p>
				<p><%=ViewData["songcanyuan"]%></p>
			</div>
			<a class="yu-grid yu-h80r yu-alignc" href="tel:<%=ViewData["songcanphone"] %>">
				<p class="yu-c99 yu-lpad20r yu-rmar30r">联系电话</p>
				<p class="yu-rmar20r yu-black"><%=ViewData["songcanphone"] %></p>
				<p class="phone-ico4"></p>
			</a>
		</div>
        <% } %>
		<div class="yu-grid yu-alignc yu-tbpad30r yu-lpad40r">
			<a class="o-d-ico type1 yu-rmar25r" href="#"></a>
			<a class="yu-alignc yu-overflow" href="javascript:;">
				<div class="yu-f36r">
					<p class="yu-black yu-bmar5">
						<span class="yu-f36r"><%=ViewData["linkman"]%></span>
						<span class="yu-f30r yu-f-w100"><%--女士--%></span>
						<span class="yu-f30r yu-f-w100"><%=ViewData["linkphone"]%></span>
					</p>
					<div class="yu-grid yu-alignc">
						<p class="address-type-ico yu-rmar5">酒店</p>
						<p class="yu-c99 yu-f26r text-ell yu-overflow yu-f-w100">
                        <% 
                            string linkman = ViewData["linkman"] + "";
                            string address = ViewData["hotel"] + "" + ViewData["roomNo"];
                            if (tid == Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
                            {
                                if (!string.IsNullOrEmpty(linkman))//外卖才联系人
                                {
                                %>
                                <%=address%>
                                <%
                                }
                                else
                                { 
                                %>
                                <%="桌台号:" + ViewData["tablenumber"]%>
                                <%
                                 }
                                %>
                        <%  }
                            else
                            { 
                            %>
                            <%=ViewData["tablenumber"]%>
                            <%
                            }
                            %>
                       
                        </p>
					</div>
				</div>
			</a>
		</div>
		<div class="colorBorder"></div>
	</section>
	<!--end-->
    <% 
        System.Data.DataTable dt_dish = (System.Data.DataTable)ViewData["dt_dish"];
        string ordertips = ViewData["ordertips"] + "";
         %>
	<section class="yu-bgw yu-bmar20r">
		<div class="yu-h100r yu-lrpad10 yu-l100r yu-bor bbor yu-arr">
            <div class="yu-c99 yu-f30r yu-grid yu-alignc" onclick="javascript:<%=isShare?"":"toIndex()" %>">
				<p class="yu-rmar20r">
                <%=ViewData["storeName"]%></p>
				<a class="phone-ico4" href="tel:<%=ViewData["storePhone"] %>" id="telid"></a>
			</div>
		</div>
        <% if (!string.IsNullOrEmpty(ordertips))
           { %>
        <div class="yu-grid yu-alignc charge-tip yu-lrpad20r yu-f22r yu-c40">
			<span class="iconfont icon-gonggao y-f22r yu-rmar10r"></span>
			<span>提示：<%=ordertips%> <%--提示：如需在酒店大厅或茶皇厅就餐，服务费10%，茶位费另计。--%></span>
		</div>
        <% } %>
		<div class="yu-pad20 yu-bglgrey yu-bor bbor">
			<ul>
            <!---订单菜品---->
            <%
                foreach (System.Data.DataRow row in dt_dish.Rows)
                {
              %>
				<li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p class="yu-f24r"><%=row["dishesName"]%></p>
						</div>
					</div>
                    <p class="yu-c99 yu-f26r yu-w150r"><%=Convert.ToDouble(row["discount"])>0?"会员"+Convert.ToDouble(row["discount"])+"折":"" %></p>
					<p class="yu-grey yu-rmar20 yu-f22r">X<%=row["number"]%></p>
					<p class="yu-f26r">￥<%=row["price"]%></p>
				</li>
                <% } %>

                <!---商家打包费---->
                <% 
                    decimal bagging = (decimal)ViewData["bagging"];
                    if (bagging > 0)
                    {
                 %>
				<li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p class="yu-f24r">打包费</p>
							
						</div>
					</div>
					<p class="yu-f26r">￥<%=bagging%></p>
				</li>
                <% } %>
                
                <!---订单备注---->
                <% if (!string.IsNullOrEmpty(ViewData["remo"] + ""))
                   { %>
				<li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p class="yu-f24r">备注</p>
							
						</div>
					</div>
					<p class="yu-f26r"><%= ViewData["remo"]%></p>
				</li>
                <% } %>
                <li class="yu-grid yu-alignc yu-bmar10">
					<div class="yu-overflow">
						<div class="yu-grid yu-alignc">
							<p class="yu-f24r">用餐时间</p>
							
						</div>
					</div>
					<p class="yu-f26r"><%= ViewData["usetime"]%></p>
				</li>
                <!---操作---->
				
                    <% 
                        //待支付
                        if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.UnPay))
                       { %>
                       <li class="yu-grid yu-alignc yu-bmar10 yu-f40r">
					        <div class="yu-overflow">&nbsp;</div>
					        <div>
						        <a onclick="javascript:TishiKuang('确定取消订单吗？',1)" href="javascript:" class="yu-btn6 type1">取消订单</a>
						        <a onclick="javascript:ToPay()" href="javascript:" class="yu-btn6 type2">去支付</a>
                                </div>
				        </li>
					  <% }
                       //派送中
                        if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPeiSongZhong))
                        { %>
						<li class="yu-grid yu-alignc yu-bmar10 yu-f40r">
					        <div class="yu-overflow">&nbsp;</div>
					        <div>
                                <a onclick="javascript:TishiKuang('确定操作收货吗？',2)" href="javascript:" class="yu-btn6 type2">确认收货</a>
                                </div>
				        </li>
					<% }
			          //取消
                        if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsCancel)||
                            status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsOverTime)||
                            status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.JudanTuikuan)||
                            status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsBossCancel))
                        { 
					  %>
                      <li class="yu-grid yu-alignc yu-bmar10 yu-f40r">
					        <div class="yu-overflow">&nbsp;</div>
					        <div>
                             <% if (!isShare)
                                { %>
                             <a  href="/DishOrderA/DishOrderIndex/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>&tid=<%=tid %>" class="yu-btn6 type2">重新选购</a>
                             <%} %>
                           </div>
				        </li>
                      <% } %>	
			</ul>
		</div>
		<div class="yu-h120r yu-grid yu-lrpad20r yu-alignc ">
				<p class="yu-black yu-rmar20 yu-f30r">总价</p>
				<div class="yu-overflow">
					<p class="yu-c40 yu-f30r">￥<span class="yu-f36r"><%=ViewData["PayAmount"]%></span></p>
					<p class="yu-c99 yu-f22r">
                           <%if(Convert.ToDecimal(ViewData["YouhuiMoney"]) != 0) 
                            {
                            %>
                            会员优惠<%=ViewData["YouhuiMoney"]%>元
                            <%
                            }%>
                            
                            <%if (Convert.ToDecimal(ViewData["CouponMoney"]) != 0) 
                            {
                            %>
                            &nbsp;已扣除红包<%=ViewData["CouponMoney"]%>元
                            <%
                            }%>
                            获得 <%=ViewData["jifen"]%> 积分
                      </p>
                      <p class="yu-c99 yu-f22r">
                      <%=ViewData["manjianremo"]%>
                      </p>
				</div>
		</div>
		
	</section>
	
	<section class="yu-bgw yu-bmar20r yu-lpad20r">
		<div class="yu-h80r yu-bor bbor yu-f30r yu-l80r">订单信息</div>
		<div class="yu-tbpad30r">
			<ul class="yu-f24r yu-c99 yu-l35r">
				<%--<li class="yu-grid">
					<p class="yu-rmar20r">支付方式</p>
					<p>
                      <%= (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.UnPay)) ? "待支付" : (string.IsNullOrEmpty(ViewData["payType"] + "") ? "在线支付" : ViewData["payType"] + "")%>
                    </p>
				</li>--%>
                <li class="yu-grid">
					<p class="yu-rmar20r">订单编号</p>
					<p><%=ViewData["orderCode"]%></p>
				</li>
				<li class="yu-grid">
					<p class="yu-rmar20r">下单时间</p>
					<p><%=ViewData["submitTime"]%></p>
				</li>
                 
                 <!---付款时间----->
                <% if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPay) ||
                       status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsSure) ||
                       status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPeiSongZhong) ||
                       status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsFinish))
                   { %>
				    <li class="yu-grid">
					    <p class="yu-rmar20r">付款时间</p>
					    <p><%=ViewData["payTime"]%></p>
				    </li>
				<% } %>

               <!---确认时间----->
               <% if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsSure) ||
                      status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPeiSongZhong) ||
                       status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsFinish))
                  { %>
				    <li class="yu-grid">
					    <p class="yu-rmar20r">确认时间</p>
					    <p><%=ViewData["sureTime"]%></p>
				    </li>
			   <% } %>	
             <!---送餐时间----->
               <% if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsPeiSongZhong) ||
                       status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsFinish))
                  { %>
				    <li class="yu-grid">
					    <p class="yu-rmar20r">送餐时间</p>
					    <p><%=ViewData["songcantime"]%></p>
				    </li>
			   <% } %>
               <!---交易完成----->
               <% if (status == Convert.ToInt32(hotel3g.Models.EnumOrderStatus.IsFinish))
                  { %>
				    <li class="yu-grid">
					    <p class="yu-rmar20r">成交时间</p>
					    <p><%=ViewData["finishTime"]%></p>
				    </li>
			   <% } %>	
			</ul>
		</div>
	</section>
    <!--end-->
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
<script type="text/javascript">
    sessionStorage.IsDishABack=0;
           $(function () {
                document.getElementById('telid').addEventListener('click', function (e) { e.stopPropagation() }, false);
             })

        $(".mask-close,.mask").click(function () {
	        $(".mask").fadeOut();
	    })
    //去支付
    function ToPay()
        {
            $.post("/DishOrderA/SendOrderToPay/?orderCode=<%=ViewData["orderCode"] %>&fromview=1",
                function(data){
                    if(data.error==1){
//                            window.location.href = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx4231803400779997&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fwxOAuthRedirect.aspx&response_type=code&scope=snsapi_base&state=<%=ViewData["orderCode"] %>#wechat_redirect";

                      window.location.href = '/Recharge/CardPay/<%=Html.ViewData["hId"]%>?key=<%=Html.ViewData["key"] %>&orderNo=<%=ViewData["orderCode"] %>';
                   
                    }else{
                        $("#tishi_msg").html(data.message);
                        $("#tishi_close").html("好的，知道了");
                        $("#tishi_sure").hide();
                        $(".alert").fadeIn();
                        return false;
                    }
                });
        }

   function TishiKuang(msg,type)
   {
       $("#tishi_msg").html(msg);
       $(".alert").fadeIn();
       $("#optype").val(type);

       $("#tishi_sure,#tishi_close").show();
       $("#tishi_close").html("取消");
   }
   $("#tishi_sure").click(function () {
	        var type=$('#optype').val();
            if(type==1)
            {
                CancelOrder();
            }
            if(type==2)
            {
                FinishOrder();
            }
	    });

    //取消订单
    function CancelOrder() {
        $.post("/DishOrderA/CancelOrder/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&orderCode=<%=ViewData["orderCode"] %>&storeId=<%=ViewData["storeId"] %>", 
                function (data) {
                    if(data.error==1)//取消成功跳回点餐首页
                    { 
                    <% if(!isShare){ %>
                      window.location.href= "/DishOrderA/DishOrderIndex/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&tid=<%=tid %>";
                    <% }else{ %>
                     window.location.reload();
                    <%} %>
                    }else{
                        $("#tishi_sure").hide();
                        $("#tishi_msg").html(data.message);
                        $("#tishi_close").html("好的，知道了");
                        $(".alert").fadeIn();
                    }
                });
        }

    //确认收货，订单完成
    function FinishOrder() {
        $.post("/DishOrderA/FinishOrder/?orderCode=<%=ViewData["orderCode"] %>&storeId=<%=ViewData["storeId"] %>", 
            function (data) {
                if(data.error==1)//确认收货成
                { 
                    //window.location.href= "/user/myorders/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>";//订单管理页
                    window.location.reload();
                }else{
                    $("#tishi_sure").hide();
                    $("#tishi_msg").html(data.message);
                    $("#tishi_close").html("好的，知道了");
                    $(".alert").fadeIn();
                }
                $(".mask").hide();
            })
     }

     function toIndex()
     {
        window.location.href='/DishOrderA/DishOrderIndex/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>&tid=<%=tid %>';
     }
</script>
</body>
</html>
