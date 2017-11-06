<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    string id = RouteData.Values["id"].ToString();
    hotel3g.Repository.MemberCard MemberCard = ViewData["MyCard"] as hotel3g.Repository.MemberCard;
    hotel3g.Repository.MemberInfo MemberInfoDeatil = ViewData["Info"] as hotel3g.Repository.MemberInfo;
    hotel3g.Repository.MemberCardIntegralRule IntegralRule = ViewData["IntegralRule"] as hotel3g.Repository.MemberCardIntegralRule;


    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", ViewData["weixinID"]);
    viewDic.Add("hId", ViewData["hId"]);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);

    var cardList = ViewData["list"] as List<hotel3g.Models.Home.MemberCardCustom>;
    cardList = cardList.Where(c => c.IncreaseType == 1 || c.IncreaseType == 2).ToList();


    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
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
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.0" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css?v=1.1" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <script src="<%=ViewData["cssUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=ViewData["cssUrl"] %>/Scripts/fontSize.js"></script>
</head>
<body>
    <%  string show_cz = "0";
        string rechargeurl = "javascript:void(0)";
        if (Convert.ToInt32(ViewData["rechargeCount"]) > 0)
        {
            rechargeurl = string.Format("/RechargeA/RechargeUser/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);
            show_cz = "1";
        } 
    %>
    <!-- <>主体页面 -->
    <article class="full-page">
		<!--导航栏-->
		     <%Html.RenderPartial("HeaderA", viewDic);%>
		<!--//内容区-->

        <%  hotel3g.Common.UserInfo user = ViewData["data"] as hotel3g.Common.UserInfo; %>
        <% if (user != null && user.Id > 0)
           { %>
		<section class="show-body">
			<section class="content2">
				
				<div class="pg__ucenter">
					<!--//用户头像信息-->
					<div class="uc__hdinfo flexbox">
						<div class="uimg">
							<span class="img"><img src="<%=string.IsNullOrEmpty(MemberCard.photo)?"/img/huiyuanok_03.png":MemberCard.photo  %>" /></span>
							<i class="tag"><%=IntegralRule.GradeName %></i>
						</div>
						<div class="info flex1">
							<label class="name"><%=user.Name %></label>
							<label class="tel"><%=user.Mobile %></label>
							<label class="card">会员卡号：<%=MemberCard.cardno %></label>
						</div>
						<a class="lk-memPrivilege" href="/MemberCardA/MemberCenter/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>">会员特权<i class="css3-arr"></i></a>
					</div>
					
					<!--//我的储值卡-->
					<div class="uc__storeValCard">
						<div class="tit clearfix">
							<h2 class="fl"><i class="ico-cicle i1"></i>我的储值卡</h2>
							<a  style="display:<%=show_cz=="1" ?  "block" :  "none" %>" class="lk-recharge fr" href="<%=rechargeurl %>">去充值<i class="css3-arr"></i></a>
						</div>
						<div class="cnt">
							<ul class="clearfix flexbox">
								<li class="flex1">
                                  <a href="<%=rechargeurl%>">
									<em class="num"><%=user.Balance %></em>
									<div class="txt">储值卡</div>
                                    </a>
								</li>
								<li class="flex1">
                                <a href="/UserA/MyCouPons/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
									<em class="num"><%=user.CouponMoney %></em>
									<div class="txt">红包</div>
                                    </a>
								</li>
								<li class="flex1">
                                 <a href="/MemberCardA/JiFendetail/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
									<em class="num"><%=MemberCard.jifen %></em>
									<div class="txt">积分</div>
                                    </a>
								</li>


							</ul>
						</div>
					</div>
					
					<!--//广告图-->
					<p class="ad-img"><a href="/HotelA/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>"><img class="max__img" src="../../images/gg.jpg" /></a></p>
					
					<!--//菜单导航-->
					<div class="uc__navMenu-list">
						<ul class="mt20 clearfix">

                            <% if (!string.IsNullOrEmpty(MemberCard.cardno) && cardList.Count > 0)
                               { %>
                            <li><a href="/MemberCardA/CardList/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>"><i class="ico-cicle i8"></i><span class="fl">购买会员卡</span><label class="fr"><i class="css3-arr"></i></label></a></li>
                            <%} %>

                                   <%
                                bool HasSignFor_hongbao =
                                (bool)ViewData["HasSignFor_hongbao"];
                                if (HasSignFor_hongbao)
                                { %>
                               <li><a href="/MemberFX/FXIndex/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>"><i class="ico-cicle i9"></i><span class="fl">分销中心</span><label class="fr"><i class="css3-arr"></i></label></a></li>
                            <%} %>
						
							<li><a href="/UserA/MyReWard/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>"><i class="ico-cicle i4"></i><span class="fl">中奖</span><label class="fr"><i class="css3-arr"></i></label></a></li>
						</ul>
                        
    
						<ul class="mt20 clearfix">
							<li><a href="/UserA/UserInfo/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>"><i class="ico-cicle i5"></i><span class="fl">账号</span><label class="fr"><i class="css3-arr"></i></label></a></li>

                            <% if (!string.IsNullOrEmpty(MemberCard.cardno))
                          { %>
							<li><a href="/RechargeA/PayPasswordEdit/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>"><i class="ico-cicle i6"></i><span class="fl">支付密码</span><label class="fr">修改支付密码 <i class="css3-arr"></i></label></a></li>
                              <%} %>
                        	<li style="display:none"><a href="/UserA/MyBuy/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>"><i class="ico-cicle i2"></i><span class="fl">买单</span><label class="fr"><i class="css3-arr"></i></label></a></li>
							<li><a href="/UserA/MyInvoice/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>"><i class="ico-cicle i3"></i><span class="fl">发票</span><label class="fr"><i class="css3-arr"></i></label></a></li>

                     

						</ul>
                            
					</div>
				</div>
			</section>
		</section>
           <% if (!string.IsNullOrEmpty(Request.QueryString["money"]))
              { %>
    <div class="mask" style="display: none">
        <div class="hongbaoyubg">
            <div class="hongbao-inner">
                <p class="hb-num">
                    ￥<%=Request.QueryString["money"].ToString()%></p>
                <a href="/UserA/MyCouPons/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>"
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
        	<%} %>
	</article>
</body>
</html>
