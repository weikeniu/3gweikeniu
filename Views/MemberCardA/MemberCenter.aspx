<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%  
    hotel3g.Repository.MemberInfo MemberInfoDeatil = ViewData["Info"] as hotel3g.Repository.MemberInfo;

    hotel3g.Repository.MemberCard MemberCard = ViewData["MyCard"] as hotel3g.Repository.MemberCard;
    hotel3g.Repository.MemberCardIntegralRule IntegralRule = ViewData["IntegralRule"] as hotel3g.Repository.MemberCardIntegralRule;

    hotel3g.Repository.HotelInfoItem HotelInfo = ViewData["HotelInfo"] as hotel3g.Repository.HotelInfoItem;
    if (HotelInfo == null)
    {
        HotelInfo = new hotel3g.Repository.HotelInfoItem() { SubName = "", hotelLog = "../../images/newlogo.png" };
    }

    var cardList = ViewData["list"] as List<hotel3g.Models.Home.MemberCardCustom>;
    string cardno = IntegralRule != null ? IntegralRule.CardNo : "";

    string cardlog = string.Empty;
    if (MemberInfoDeatil != null && !string.IsNullOrEmpty(MemberInfoDeatil.CardLogo))
    {
        cardlog = MemberInfoDeatil.CardLogo;
    }


    string hotelname = ViewData["HotelName"] != null ? ViewData["HotelName"] as string : "";


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
    <title>会员特权</title>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/new-style.css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/mend-reset.css" />
</head>
<body class="yu-bgw">
    <%
        ViewDataDictionary viewDic = new ViewDataDictionary();
        viewDic.Add("weixinID", ViewData["weixinID"]);
        viewDic.Add("hId", ViewData["hId"]);
        viewDic.Add("uwx", ViewData["userWeiXinID"]);
    %>
    <article class="full-page">
           <%Html.RenderPartial("HeaderA", viewDic);%>
    <section class="show-body">
			<section class="content2">
    <section class="hyk-box">
        	
 		<img src="<%=MemberInfoDeatil==null||string.IsNullOrEmpty(MemberInfoDeatil.backgroud)||MemberInfoDeatil.backgroud.IndexOf("#")>-1?"../../images/member/card2.png": MemberInfoDeatil.backgroud.Replace("html/images", "images/cards") %>" />

            <% string zdycard = string.Empty; %>
        <% if (MemberInfoDeatil!=null  && MemberInfoDeatil.backgroud != null && MemberInfoDeatil.backgroud.ToLower().Contains("http"))
           {
               zdycard = "display:none"; %>          
           <%}  %>

              <% if (zdycard == string.Empty && string.IsNullOrEmpty(cardlog))
                 {
                     cardlog = HotelInfo.hotelLog;  %>   
 
            <%} %>   


               
        
        <% if (!string.IsNullOrEmpty(cardlog))
           { %>     

             <div class="logo-pic">  
 			<img src="<%=cardlog%>" />
            	</div>
            <%} %>
                     
 	


 		<div class="txt-top">
 
 			<p class="yu-font32r yu-w440r" style="<%=zdycard%>" ><%=HotelInfo.SubName %></p>      
 		
 			<p class="yu-font26r"><%=IntegralRule != null ? IntegralRule.GradeName : "微信粉丝"%></p>
 		</div>
 		<div class="txt-bottom">
 			<!--激活前则不显示此卡号-->
 			<p class="fl"><%=string.IsNullOrEmpty(cardno) ? "" : cardno%></p>

            <% 
                if (MemberInfoDeatil != null)
                {
                    string rate = "9.9";
                    if (MemberInfoDeatil.vip0rate > 0)
                    {
                        rate = MemberInfoDeatil.vip0rate.ToString();
                    }
                    else
                        if (MemberInfoDeatil.vip1rate > 0)
                        {
                            rate = MemberInfoDeatil.vip1rate.ToString();
                        }
                        else
                            if (MemberInfoDeatil.vip2rate > 0)
                            {
                                rate = MemberInfoDeatil.vip2rate.ToString();
                            }
                            else
                                if (MemberInfoDeatil.vip3rate > 0)
                                {
                                    rate = MemberInfoDeatil.vip3rate.ToString();
                                }
                                else
                                    if (MemberInfoDeatil.vip4rate > 0)
                                    {
                                        rate = MemberInfoDeatil.vip4rate.ToString();
                                    }


                    if (!rate.Equals("10.0") && !rate.Equals("0.0") && !rate.Equals("0.0"))
                    {
                    %>
 
 		 
            <%}

                }  %>

                <%if (IntegralRule != null && IntegralRule.CouponType == 0 && IntegralRule.GradeRate > 0 && IntegralRule.GradeRate != 10)
                  { %>

                <p class="fr"><%=Convert.ToDouble(IntegralRule.GradeRate)%>折<i class="yu-font20r">起</i></p>
                <%}
                  else if (IntegralRule != null && IntegralRule.CouponType == 1 && IntegralRule.Reduce > 0)
                  {  %>

                    <p class="fr">立减￥<%=Convert.ToDouble(IntegralRule.Reduce)%> </p>
                  <%} %>
 		</div>
 	</section>
    <section>

 
    <% if (string.IsNullOrEmpty(cardno))
       { %>

       <%  cardList = cardList.OrderBy(c => c.CardLevel).ToList(); %>
       <% if (cardList.Count > 0 && (cardList[0].IncreaseType == 1 || cardList[0].IncreaseType == 2) && cardList[0].BuyMoney > 0)
          {   %>
           <a class="hyk-btn" href='/MemberCardA/CardList/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"]%>'>购买会员卡</a>
          <%}
          else
          { %>
    <a class="hyk-btn" href="<%=ViewData["MemberRegister"] %>">激活会员卡</a>

    <%} %>
    <%} %>

          <% if (MemberInfoDeatil != null)
             { %>
 		<ul class="yu-bgw yu-bor tbor hy-right ">
 			<li class="yu-bor bbor ">
 				<div class="yu-h90r yu-grid yu-alignc yu-lpad42r show-box">
	 				<p class="ico type1"></p>
	 				<p class="yu-overflow yu-f34r">会员权益</p>
 				</div>
 				<div class="slide-box">

               
 					<table class="hy-right-tb">
                     <% if (cardList.Count == 0)
                   {  %>
 						<tr>
 							<th>&nbsp;</th>
 							<th>普通会员</th>
 							<th>高级会员</th>
 							<th>白金会员</th>
 							<th>黄金会员</th>
 							<th>钻石会员</th>
 						</tr>

                        

 						<tr>
 							<th>订房优惠</th>
 								<td><%=MemberInfoDeatil != null && MemberInfoDeatil.vip0rate > 0 ? MemberInfoDeatil.vip0rate + "折" : "无折扣"%> </td>
							<td><%=MemberInfoDeatil != null && MemberInfoDeatil.vip1rate > 0 ? MemberInfoDeatil.vip1rate + "折" : "无折扣"%></td>
							<td><%=MemberInfoDeatil != null && MemberInfoDeatil.vip2rate > 0 ? MemberInfoDeatil.vip2rate + "折" : "无折扣"%></td>
							<td><%=MemberInfoDeatil != null && MemberInfoDeatil.vip3rate > 0 ? MemberInfoDeatil.vip3rate + "折" : "无折扣"%></td>
							<td><%=MemberInfoDeatil != null && MemberInfoDeatil.vip4rate > 0 ? MemberInfoDeatil.vip4rate + "折" : "无折扣"%></td>
 						</tr>
 						<tr>
 							<th>积分加成</th>
 				<td><%=MemberInfoDeatil != null ? MemberInfoDeatil.vip0plus + " 倍" : "无加成"%></td>
							<td><%=MemberInfoDeatil != null ? MemberInfoDeatil.vip1plus + " 倍" : "无加成"%></td>
							<td><%=MemberInfoDeatil != null ? MemberInfoDeatil.vip2plus + " 倍" : "无加成"%></td>
							<td><%=MemberInfoDeatil != null ? MemberInfoDeatil.vip3plus + " 倍" : "无加成"%></td>
							<td><%=MemberInfoDeatil != null ? MemberInfoDeatil.vip4plus + " 倍" : "无加成"%></td>

 						</tr>
                        <%}
                   else
                   {
                       string strcard = "";
                       string strmeal = "";
                       string strcoupon = "";
                       string strjifen = "";
                       foreach (var item in cardList)
                       {

                           strcard += string.Format("<th>{0}</th>", item.CardName);
                           strcoupon += string.Format("<td>{0}</td>", item.CouponType == 0 ? Convert.ToDouble(item.Discount) + "折" : "立减￥" + Convert.ToDouble( item.Reduce));
                           strmeal += string.Format("<td>{0}</td>", item.MealCouponType == 0 ? Convert.ToDouble(item.MealDiscount) + "折" : "立减￥" + Convert.ToDouble(item.MealReduce));
                           strjifen += string.Format("<td>{0}倍</td>", Convert.ToDouble(item.JiFen));


                       } %>
                        		<tr>
 							<th>&nbsp;</th> 	
                            <%=strcard %>						 
 						</tr>
                        <tr>
 							<th>订房优惠</th>
                            <%=   strcoupon%>
                            </tr>

                              <tr  style="<%= ViewData["canyin"].ToString() == "0" ? "display:none" : "" %>" >
 							<th>订餐优惠</th>
                            <%=   strmeal%>
                            </tr>
                            	<tr>
 							<th>积分加成</th>
                            <%=strjifen %>
                            </tr>

                        <%} %>
 					</table>
 				</div>
 			</li>
 			<li class="yu-bor bbor">
 				<div class="yu-h90r yu-grid yu-alignc yu-lpad42r show-box">
	 				<p class="ico type2"></p>
	 				<p class="yu-overflow yu-f34r">会员说明</p>
 				</div>
 				<div class="slide-box yu-tbpad20r yu-lrpad30r yu-bgef yu-f24r yu-c99">
 					<%=MemberInfoDeatil != null ? MemberInfoDeatil.intro.Replace("\n", "<br />") : ""%>
 				</div>
 			</li>
 			<li class="yu-bor bbor">
 				<div class="yu-h90r yu-grid yu-alignc yu-lpad42r show-box">
 					<p class="ico type3"></p>
 					<p class="yu-overflow yu-f34r">会员等级</p>
 				</div>
 				<div class="slide-box">
 					<table class="hy-right-tb">

                         <% if (cardList.Count == 0)
                            {  %>
 						<tr>
 							<th>等级</th>
 							<th>普通会员</th>
 							<th>高级会员</th>
 							<th>白金会员</th>
 							<th>黄金会员</th>
 							<th>钻石会员</th>
 						</tr>
 						<tr>
 							<th>间夜</th>
 						<td><%=MemberInfoDeatil != null ? MemberInfoDeatil.vip0.ToString() : "无"%> </td>
							<td><%=MemberInfoDeatil != null ? MemberInfoDeatil.vip1.ToString() : "无"%></td>
							<td><%=MemberInfoDeatil != null ? MemberInfoDeatil.vip2.ToString() : "无"%></td>
							<td><%=MemberInfoDeatil != null ? MemberInfoDeatil.vip3.ToString() : "无"%></td>
							<td><%=MemberInfoDeatil != null ? MemberInfoDeatil.vip4.ToString() : "无"%></td>
 						</tr>
                        <%}
                            else
                            {
                                string strcard = "";
                                string strcoupon = "";
                                                              
                                foreach (var item in cardList)
                                {

                                    strcard += string.Format("<th>{0}</th>", item.CardName);


                                    if (item.IncreaseType == 0 || item.IncreaseType == 1)
                                    {
                                        strcoupon += string.Format("<td>{0}</td>", item.IncreaseType == 0 ? item.Rooms + "间" : "￥" + Convert.ToDouble(item.BuyMoney));
                                    }

                                    else
                                    {
                                        strcoupon += string.Format("<td>{0}或{1} </td>", item.Rooms + "间", "￥" + Convert.ToDouble(item.BuyMoney));
                                    } 

                                } %>
                                <tr>
 							<th>等级</th>
                            <%=strcard %>
                            </tr>
                            <tr>
 							<th>间夜</th>
                            <%= strcoupon%>
                            </tr>

                       <%} %>
 					</table>
 				</div>
 			</li>
 		</ul>
           <%}
             else
             { %>
             
             <ul class="yu-bgw yu-bor tbor hy-right ">
 			<li class="yu-bor bbor sp">
 				<div class="yu-h90r yu-grid yu-alignc yu-lpad42r show-box">
	 				<p class="ico type1"></p>
	 				<p class="yu-overflow yu-f34r">会员权益</p>
 				</div>
 			</li>
 			<li class="yu-bor bbor sp">
 				<div class="yu-h90r yu-grid yu-alignc yu-lpad42r show-box">
	 				<p class="ico type2"></p>
	 				<p class="yu-overflow yu-f34r">会员说明</p>
 				</div>
 			</li>
 			<li class="yu-bor bbor sp">
 				<div class="yu-h90r yu-grid yu-alignc yu-lpad42r show-box">
 					<p class="ico type3"></p>
 					<p class="yu-overflow yu-f34r">会员等级</p>
 				</div>
 			</li>
 		</ul>
             <%} %>
 	</section>
    </section>
    </section>
    </article>
    <script>
        $(function () {
            $(".hy-right .show-box").on("click", function () {
                $(this).siblings(".slide-box").slideToggle(200);
                $(this).parent("li").toggleClass("cur");
            })
        })
    </script>
</body>
</html>
