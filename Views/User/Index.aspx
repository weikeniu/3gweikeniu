<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    string id = RouteData.Values["id"].ToString();
    hotel3g.Repository.MemberCard MemberCard = ViewData["MyCard"] as hotel3g.Repository.MemberCard;
    hotel3g.Repository.MemberInfo MemberInfoDeatil = ViewData["Info"] as hotel3g.Repository.MemberInfo;
    hotel3g.Repository.MemberCardIntegralRule IntegralRule = ViewData["IntegralRule"] as hotel3g.Repository.MemberCardIntegralRule;
 
 

    var cardList = ViewData["list"] as List<hotel3g.Models.Home.MemberCardCustom>;
    cardList = cardList.Where(c => c.IncreaseType == 1 || c.IncreaseType == 2).ToList();

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", ViewData["weixinID"]);
    viewDic.Add("hId", ViewData["hId"]);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);


    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
  

%>
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
    <title>会员中心</title>
    <link href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.4" rel="stylesheet"
        type="text/css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/member.css?v=1.2" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
 
<link type="text/css" rel="stylesheet" href="../../css/booklist/font/iconfont.css"/>
<link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css"/>

<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/css/booklist/font/iconfont.js"></script>
<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
 

    <style type="text/css">
.icon {
   width: 1em; height: 1em;
   vertical-align: -0.15em;
   fill: currentColor;
   overflow: hidden;
   background: none;
   margin-top:0;
transform: scale(1);
}
</style>
</head>
<body>
    <%  hotel3g.Common.UserInfo user = ViewData["data"] as hotel3g.Common.UserInfo; %>
    <% if (user != null && MemberCard != null)
       { %>
    <section class="yu-grid mem-top">
    <div class="member-head">
      <div class="img-cirle">
      	<img src="<%=string.IsNullOrEmpty(MemberCard.photo)?"/img/huiyuanok_03.png":MemberCard.photo  %>" />
      </div>
      <div class="member-lv">
      <%=IntegralRule.GradeName %>
      </div>
    </div>
    <div class="yu-overflow mem-txt">
          <p class="yu-f30r yu-bmar20r"><%=user.Name %></p>
     <p class="yu-f30r yu-bmar30r"><%=user.Mobile %></p>
      <p class="yu-f26r">会员卡号：<%=MemberCard.cardno %></p>
    </div>
    <div><a class="yu-arr iconfont icon-youx mem-right-btn yu-white" href="<%=ViewData["MemberCenterUrl"] %>">会员特权</a></div>
 </section>
    <section class="main"><%--
 	<div class="mem-row yu-grid yu-arr iconfont icon-youx">--%>

     <%  string show_cz = "0";
         string rechargeurl = "javascript:void(0)";
         if (Convert.ToInt32(ViewData["rechargeCount"]) > 0)
         {
             rechargeurl = string.Format("/Recharge/RechargeUser/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);
             show_cz = "1";
          
         } 
            %>          
    
 	<div class="mem-row yu-grid  <%=show_cz=="1" ?  "yu-arr iconfont icon-youx" :  "" %>">

		<!-- <div class="ico-part"><div class="ico-bg type5"><span class="mem-ico type5"></span></div></div> -->
    <svg class="icon yu-f50r yu-rmar20r" aria-hidden="true">
        <use xlink:href="#icon-chongzhi2"></use>
      </svg>
   		<p class="yu-overflow">我的储值卡</p> 
       
   		<a  style="display:<%=show_cz=="1" ?  "block" :  "none" %> "   href="<%=rechargeurl %>" class="yu-blue yu-font12 yu-rmar20"  >去充值</a>	
      
 	</div>
 	<div class="mem-row yu-grid mem-num">
 		<div class="yu-overflow yu-textc">
        <a href="<%=rechargeurl%>">
 			<p class="num"><%= user.Balance%></p>
   		<div class="yu-f26r yu-grid yu-alignc yu-j-c">
          <svg class="icon yu-f30r yu-rmar10r" aria-hidden="true">
            <use xlink:href="#icon-chuzhika"></use>
          </svg>
          <span>储值卡</span>
        </div>
            </a>
 		</div>

        
		<div class="yu-overflow yu-textc">
            <a href="/user/MyCouPons/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
 			    <p class="num"><%=user.CouponMoney %><span class="yu-font12"> 元</span></p>
 			    <div class="yu-f26r yu-grid yu-alignc yu-j-c">
            <svg class="icon yu-f30r yu-rmar10r" aria-hidden="true">
              <use xlink:href="#icon-hongbao5"></use>
            </svg>
            <span>红包</span>
          </div>
            </a>
 		</div> 
       


		<div class="yu-overflow yu-textc">
          <a href="/membercard/JiFendetail/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">

 			<p class="num"><%=user.Emoney%></p>
 			<div class="yu-f26r yu-grid yu-alignc yu-j-c">
        <svg class="icon yu-f30r yu-rmar10r" aria-hidden="true">
          <use xlink:href="#icon-jifen"></use>
        </svg>
        <span>积分</span>
      </div>
            </a>
 		</div>  				
 	</div>
 </section>

 <%     bool istravel = WeiXin.Common.NormalCommon.IsLXSDoMain(); %>

 <% if( !istravel) { %>
    <section class="gg">
 
	<a href="/Hotel/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>"><img src="../../images/gg.jpg" /></a>
</section>
<%} %>
    <section class="main">

    <% if( istravel) { %>
       <a style="color:#333" href="/user/Myorders/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>">
         	<div class="mem-row yu-grid yu-arr iconfont icon-youx">
<%--   		<div class="ico-part"><div class="ico-bg type8"><span class="mem-ico type10"></span></div></div>--%>
            <svg class="icon yu-f50r yu-rmar20r" aria-hidden="true">
			  <use xlink:href="#icon-maidan"></use>
			</svg>
   		<p class="yu-overflow">全部订单</p>
   	</div> 
      </a>
     
    <%} %>
    
           <% if (!string.IsNullOrEmpty(MemberCard.cardno) &&  cardList.Count > 0  )
              { %>
      <a style="color:#333" href="/MemberCard/CardList/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>">
         	<div class="mem-row yu-grid yu-arr iconfont icon-youx">
   		<!-- <div class="ico-part"><div class="ico-bg type3"><span class="mem-ico type9"></span></div></div> -->
      <svg class="icon yu-f50r yu-rmar20r" aria-hidden="true">
        <use xlink:href="#icon-chongzhi2"></use>
      </svg>
   		<p class="yu-overflow">购买会员卡</p>
   	</div> 
      </a>
      <%} %>
      
  <%
      bool HasSignFor_hongbao =
      (bool)ViewData["HasSignFor_hongbao"];
      if (HasSignFor_hongbao)
      { %>
                 
  <a style="color:#333" href="/MemberFX/FXIndex/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>">
   	<div class="mem-row yu-grid yu-arr iconfont icon-youx">
   		<!-- <div class="ico-part"><div class="ico-bg type9"><span class="mem-ico type11"></span></div></div> -->
      <svg class="icon yu-f50r yu-rmar20r" aria-hidden="true">
        <use xlink:href="#icon-fenxiaozhongxin"></use>
      </svg>
   		<p class="yu-overflow">分销中心</p>
   	</div>
    </a>
 <%} %>
               	
    <a style="color:#333" href="/User/MyReWard/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>">
<div class="mem-row yu-grid yu-arr iconfont icon-youx">
   		<!-- <div class="ico-part"><div class="ico-bg type3"><span class="mem-ico type3"></span></div></div> -->
      <svg class="icon yu-f50r yu-rmar20r" aria-hidden="true">
        <use xlink:href="#icon-zhongjiang"></use>
      </svg>
   		<p class="yu-overflow">中奖</p>
   	</div>   	</a>

 </section>
    <section class="main">

    <a style="color:#333" href="/User/UserInfo/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>">
   	<div class="mem-row yu-grid yu-arr iconfont icon-youx">
   		<!-- <div class="ico-part"><div class="ico-bg type4"><span class="mem-ico type4"></span></div></div> -->
      <svg class="icon yu-f50r yu-rmar20r" aria-hidden="true">
        <use xlink:href="#icon-zhanghao"></use>
      </svg>
   		<p class="yu-overflow">账号</p>
   	</div> 
    </a>


    <% if (!string.IsNullOrEmpty(MemberCard.cardno))
       { %>
        <a style="color:#333" href="/Recharge/PayPasswordEdit/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>">
       	<div class="mem-row yu-grid yu-arr iconfont icon-youx">
   		<!-- <div class="ico-part"><div class="ico-bg type6"><span class="mem-ico type8"></span></div></div> -->
      <svg class="icon yu-f50r yu-rmar20r" aria-hidden="true">
        <use xlink:href="#icon-zhifumima"></use>
      </svg>
   		<p class="yu-overflow">支付密码</p>
   	</div> 
      </a>

      <%} %>


 
  <a style="color:#333" href="/User/mybuy/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>">
   	<div class="mem-row yu-grid yu-arr iconfont icon-youx">
   		<!-- <div class="ico-part"><div class="ico-bg type1"><span class="mem-ico type1"></span></div></div> -->
      <svg class="icon yu-f50r yu-rmar20r" aria-hidden="true">
        <use xlink:href="#icon-maidan"></use>
      </svg>
   		<p class="yu-overflow">买单</p>
   	</div>
    </a>

     <a style="color:#333" href="/User/MyInvoice/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>">
<div class="mem-row yu-grid yu-arr iconfont icon-youx">
   		<!-- <div class="ico-part"><div class="ico-bg type2"><span class="mem-ico type2"></span></div></div> -->
      <svg class="icon yu-f50r yu-rmar20r" aria-hidden="true">
        <use xlink:href="#icon-fapiao"></use>
      </svg>
   		<p class="yu-overflow">发票</p>
   	</div>   
    
    </a>

       <% if( istravel) { %>
             <a style="color:#333" href="/User/UserCollection/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>">
         	<div class="mem-row yu-grid yu-arr iconfont icon-youx">
<!-- <div class="ico-part"><div class="ico-bg type10"><span class="mem-ico type12"></span></div></div> -->
<svg class="icon yu-f50r yu-rmar20r" aria-hidden="true">
        <use xlink:href="#icon-wodeshoucang"></use>
      </svg>
   		<p class="yu-overflow">我的收藏</p>
   	</div> 
      </a>
      <%} %>

   </section>
    <% if (!string.IsNullOrEmpty(Request.QueryString["money"]))
       { %>
    <div class="mask" style="display: none">
        <div class="hongbaoyubg">
            <div class="hongbao-inner">
                <p class="hb-num">
                    ￥<%=Request.QueryString["money"].ToString()%></p>
                <a href="/User/MyCouPons/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>"
                    class="hb-check"></a>
                <div class="close">
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            setTimeout(function () {
                $(".mask").fadeIn();
            }, 500)
            $(".hongbao-inner .close,.hongbao-inner .hb-check").click(function () {
                $(".mask").fadeOut();
            })
        })
    </script>
    <%} %>
    <% Html.RenderPartial("Footer", viewDic); %>
    <%}
       else
       { 
    %>
    用户异常!
    <%
        } %>
</body>
</html>
